//=========================================================================================//
//Accelerometer SetUp
#include <Adafruit_MPU6050.h>
#include <Adafruit_Sensor.h>
#include <Wire.h>

//=========================================================================================//

//=========================================================================================//
//Pulse Sensor SetUp
#define USE_ARDUINO_INTERRUPTS false
#include <PulseSensorPlayground.h>

const int OUTPUT_TYPE = SERIAL_PLOTTER;

const int PULSE_INPUT = 36;
const int PULSE_BLINK = LED_BUILTIN;    // Pin 13 is the on-board LED
const int PULSE_FADE = 5;
const int THRESHOLD = 1600;   // orig 700Adjust this number to avoid noise when idle

int Signal = 0;

byte samplesUntilReport;
const byte SAMPLES_PER_SERIAL_SAMPLE = 10;

PulseSensorPlayground pulseSensor;
//=========================================================================================//

//=========================================================================================//
//BLE Setup
#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>

BLEServer* pServer = NULL;
BLECharacteristic* pCharacteristic = NULL;
bool deviceConnected = false;
bool oldDeviceConnected = false;
uint32_t value = 0;

#define SERVICE_UUID        "4fafc201-1fb5-459e-8fcc-c5c9c331914b"
#define CHARACTERISTIC_UUID "beb5483e-36e1-4688-b7f5-ea07361b26a8"

class MyServerCallbacks: public BLEServerCallbacks {
    void onConnect(BLEServer* pServer) {
      deviceConnected = true;
      BLEDevice::startAdvertising();
    };

    void onDisconnect(BLEServer* pServer) {
      deviceConnected = false;
    }
};
//=========================================================================================//


//=========================================================================================//

//Variable Assignments

const unsigned long eventInterval = 30000; //check vitals every 1min
unsigned long previousTime = 0; //time since last read

int alertState = 0;
int isSensingHeightened = 0;
int hasResponded = 0;
int delayTime = 10500; //delay for seizure confirmation 10secs

//Pinout for GSR Sensor
const int GSR = 34;
int sensorValue = 0;
//int gsr_average = 0;

//Pinout for Accelerometer
float accBaseX = 5.0;
float accBaseY = 5.0;
float accBaseZ = 5.0;
int curAcceleration = 0;
Adafruit_MPU6050 mpu;

//Vitals Threshold
int bpmBase = 60;
int gsrBase = 1800;

// Dynamic Variables for Vitals
//int curBPM;
int curMotion = 0;
int curGSR = 0;
int bpmNow = -1; 

//=========================================================================================//
//Function to check Pulse and returns beats per minute.
int checkBPM() {
  int readBPM = 0;
  int bpm = bpmNow;
  int bpmHigh = bpmBase + 15;
  int bpmLow = bpmBase - 15;
  
  if(bpm > 50){
    if(bpm > bpmHigh || bpm < bpmLow){
      readBPM = 1;
    } else{
      readBPM = 0;
      }
  } else{
    Serial.println("BPM Reading Error.");
  }

  return readBPM;
}

//=========================================================================================//


//=========================================================================================//
//Function to check Motion and returns array(x,y,z).
/*int checkMotion() {
  int readMotion = 0;

  if (mpu.getMotionInterruptStatus()) {
    // Get new sensor events with the readings 
    sensors_event_t a, g, temp;
    mpu.getEvent(&a, &g, &temp);
    Serial.println("Motion Activity is Erratic!");
    readMotion = 1;
  }
  curMotion = readMotion;
  return readMotion;
}
*/
int checkAcceleration(){
  int readAcceleration = 0;
  float aX = 0.0;
  float aY = 0.0;
  float aZ = 0.0;

  int checkX = 0;
  int checkY = 0;
  int checkZ = 0;
  
  float accXHigh = (accBaseX + 10);
  float accXLow = (accBaseX - 10);
  
  float accYHigh = (accBaseY + 10);
  float accYLow = (accBaseY - 10);
  
  float accZHigh = (accBaseZ + 10);
  float accZLow = (accBaseZ - 10);

  sensors_event_t a, g, temp;
  mpu.getEvent(&a, &g, &temp);

  aX = a.acceleration.x;
  aY = a.acceleration.y;
  aZ = a.acceleration.z;
 
  if(aX >= accXHigh || aX <= accXLow){
    checkX = 1;
  } 
  if(aY >= accYHigh || aY <= accYLow){
    checkY = 1;
  } 
  if(aZ >= accZHigh || aZ <= accZLow){
    checkZ = 1;
  } 

  if (checkX == 1 || checkY == 1 || checkZ == 1){
    readAcceleration = 1;
    curAcceleration = readAcceleration;
    Serial.println("Motion is Erratic!");
  } else{
    Serial.println("Motion is Nominal");
  }
 /* Print out the values */
  Serial.print("Acceleration X: ");
  Serial.print(a.acceleration.x);
  Serial.print(", Y: ");
  Serial.print(a.acceleration.y);
  Serial.print(", Z: ");
  Serial.print(a.acceleration.z);
  Serial.println(" m/s^2");
  delay(100);

  return readAcceleration;
}

//=========================================================================================//



//=========================================================================================//
//Function to check Electrodermal Activity and returns skin resistance.
int checkGSR() {
  int readGSR = 0;
  long sum = 0;
  int readNow = 0;
  int gsrHigh = (gsrBase+150);
  int gsrLow = (gsrBase-150);
  for (int i = 0; i < 10; i++)    //Average the 10 measurements to remove the glitch
  {
    sensorValue = analogRead(GSR);
    sum += sensorValue;
    delay(25);
  }
  int gsr_average = (sum / 10);
  Serial.print("GSR Reading: ");
  Serial.println(gsr_average);
  if (gsr_average < 4095) {
    readNow = gsr_average;
    
    if (readNow <= gsrLow || readNow >= gsrHigh) {
      Serial.println("Electrodermal Activity is Erratic!");
      readGSR = 1;

    } else {
      //Serial.print("GSR Average: ");
      //Serial.println(gsr_average);
      readGSR = 0;
    }
  } else {
    Serial.println("GSR Sensor Reading Error");
  }

  curGSR = readGSR;
  return readGSR;
}

//=========================================================================================//



//=========================================================================================//

void getBPMnow(){
  int counter = 0;
  while(counter < 1){
    Signal = analogRead(PULSE_INPUT);

    Serial.println("Looking for BPM");

    if (pulseSensor.sawNewSample()) {
      if (--samplesUntilReport == (byte) 0) {
        samplesUntilReport = SAMPLES_PER_SERIAL_SAMPLE;
        pulseSensor.outputSample();
        if (pulseSensor.sawStartOfBeat()) { 
          int myBPM = (pulseSensor.getBeatsPerMinute() - 130);
          pulseSensor.outputBeat();
          Serial.print("BPM: ");                        // Print phrase "BPM: " 
          Serial.println(myBPM);
          bpmNow = myBPM;
          counter += 1;
        }
      }
      
    }delay(100);
  }

  Serial.print("BPM Found");
  return;
}

//=========================================================================================//


//=========================================================================================//
bool checkVitals() {
  int i = 0;
  int gsrSumHigh = 0;
  int motionSumHigh = 0;
  int bpmSumHigh = 0;
  int samplingRate = 0;
  if(isSensingHeightened == 1){
    gsrSumHigh = 3;
    motionSumHigh = 3;
    bpmSumHigh = 3; 
    samplingRate = 5;
  } else {
    gsrSumHigh = 7;
    motionSumHigh = 7;
    bpmSumHigh = 7; 
    samplingRate = 10;
  }
  
  Serial.println("=========================================");
  Serial.println("Checking Vitals");
  Serial.println("Getting BPM");
  getBPMnow();
  Serial.print("Using current BPM: ");
  Serial.println(bpmNow);
  bool isSeizureDetected = false;

  int sumBPM = 0;
  int sumGSR = 0;
  int sumMotion = 0;

  for (i; i < samplingRate; i++) {
    int motionNow = checkAcceleration();
    int gsrNow = checkGSR();
    Serial.print("Checking Now: ");
    Serial.println(i);
    
 
    int bpmCurrent = checkBPM();
    if(bpmCurrent == 1){
      sumBPM += 1;
      Serial.println("BPM is Erratic!");
    } else{
      Serial.println("BPM is Nominal!");
    }

    if (motionNow == 1) {
      sumMotion += 1;
      Serial.println("Motion is Erratic!");
    } else{
      Serial.println("Motion is Nominal!");
    }

    if (gsrNow == 1) {
      sumGSR += 1;
      Serial.println("GSR is Erratic!");
    } else{
      Serial.println("GSR is Nominal!");
    }

    //delay(5);
  }
  Serial.print("SumBPM: ");
  Serial.println(sumBPM);
  
  Serial.print("SumGSR: ");
  Serial.println(sumGSR);

  Serial.print("SumMotion: ");
  Serial.println(sumMotion);
  
  Serial.println("=========================================");
  if (sumBPM >= bpmSumHigh && sumGSR >= gsrSumHigh && sumMotion >= motionSumHigh) {
    isSeizureDetected = true;
    Serial.println("Seizure Episode Confirmed!");
  } else {
    isSeizureDetected = false;
    Serial.println("Vitals are Nominal");
  }
  Serial.println("=========================================");

  return isSeizureDetected;
}
//=========================================================================================//


//=========================================================================================//

void calibrateACC(){
  int sampling = 20;
  int counter = 0;
   float accSumX = 0.0;
   float accSumY = 0.0;
   float accSumZ = 0.0;
  
  float calibratedACCX = 0.0;
  float calibratedACCY = 0.0;
  float calibratedACCZ = 0.0;
  
  Serial.println("=== Calibrating Accelerometer ====");
  Serial.print("Current Accelerometer Baseline: X:");
  Serial.print(accBaseX);
  Serial.print(", Y: ");
  Serial.print(accBaseY);
  Serial.print(", Z: ");
  Serial.println(accBaseZ);
  for(counter; counter< sampling; counter++){
    Serial.print("Sampling Iteration: ");
    Serial.println(counter);
    
    sensors_event_t a, g, temp;
    mpu.getEvent(&a, &g, &temp);
  
    /* Print out the values */
    Serial.print("Acceleration X: ");
    Serial.print(a.acceleration.x);
    accSumX += a.acceleration.x;
    Serial.print(", Y: ");
    Serial.print(a.acceleration.y);
    accSumY += a.acceleration.y;
    Serial.print(", Z: ");
    Serial.print(a.acceleration.z);
    accSumZ += a.acceleration.z;
    Serial.println(" m/s^2");
  
    Serial.println("");

    delay(100);
    }

  calibratedACCX = (accSumX/sampling);
  calibratedACCY = (accSumY/sampling);
  calibratedACCZ = (accSumZ/sampling);

  accBaseX = calibratedACCX;
  accBaseY = calibratedACCY;
  accBaseZ = calibratedACCZ;
  Serial.print("Updated Baseline Acceleration: X: ");
  Serial.print(accBaseX);
  Serial.print(", Y: ");
  Serial.print(accBaseY);
  Serial.print(", Z: ");
  Serial.print(accBaseZ);
  Serial.println(" m/s^2");
  delay(100);
  return;
}
//=========================================================================================//


//=========================================================================================//

void calibrateGSR(){
  int sampling = 50;
  int counter = 0;
  unsigned long gsrSum = 0;
  int calibratedGSR = 0;
  Serial.println("=== Calibrating GSR ====");
  Serial.print("Current GSR Baseline: ");
  Serial.println(gsrBase);
  for(counter; counter< sampling; counter++){
    Serial.print("Sampling Iteration: ");
    Serial.println(counter);
    long sum=0;
    for(int i=0;i<10;i++)           //Average the 10 measurements to remove the glitch
        {
        int sensorVal = analogRead(GSR);
        sum += sensorVal;
        delay(50);
        }
     int gsr_average = (sum/10);
     Serial.print("GSR: ");
     Serial.println(gsr_average);
     gsrSum += gsr_average;  
     delay(100);
    }

  calibratedGSR = (gsrSum/sampling);
  Serial.print("Baseline GSR: ");
  Serial.println(calibratedGSR);
  gsrBase = calibratedGSR;
  Serial.print("Updated Baseline GSR: ");
  Serial.println(gsrBase);
  return;
}

//=========================================================================================//


//=========================================================================================//
void calibrateBPM(){
  int sampling = 5;
  int count = 0;
  int counter = 0;
  unsigned long bpmSum = 0;
  int calibratedBPM = 0;

  Serial.println("=== Calibrating BPM ====");
 
  while(counter < sampling){
     Signal = analogRead(PULSE_INPUT);

    Serial.print("Sampling Iteration: ");
    Serial.println(counter);
    if (pulseSensor.sawNewSample()) {
      if (--samplesUntilReport == (byte) 0) {
        samplesUntilReport = SAMPLES_PER_SERIAL_SAMPLE;
        pulseSensor.outputSample();
        if (pulseSensor.sawStartOfBeat()) { 
          Serial.print("Signal: "); 
          Serial.println(Signal);
          int myBPM = (pulseSensor.getBeatsPerMinute() - 130);
          pulseSensor.outputBeat();
          Serial.print("BPM: ");                        // Print phrase "BPM: " 
          Serial.println(myBPM);
          if(myBPM >= 40){
            bpmSum += myBPM;
            counter += 1;
          } else {
            Serial.println("Error. BPM too low!");
          }
          
        }
      }
      
    }delay(100);
  }
  
  Serial.print("Current BPM Baseline: ");
  Serial.println(bpmBase);
  
  calibratedBPM = (bpmSum/sampling);
  Serial.print("Baseline BPM: ");
  Serial.println(calibratedBPM);
  
  
  bpmBase = calibratedBPM;
  Serial.print("Updated Baseline BPM: ");
  Serial.println(bpmBase);
  
  return;
}
//=========================================================================================//

void initialStream(){
  int counter = 0;
  String str = "";
  str += alertState;
  str += ",";
  str += isSensingHeightened;
  str += ",";
  str += bpmNow;
  str += ",";
  str += curGSR;
  str += ",";
  str += curAcceleration;
  
  while(counter < 20){
    Serial.println("Looking for Seize Companion App");
    if (deviceConnected) {
      delay(50);
      Serial.println("Device is Connected! Sending Initial Data Now");
      pCharacteristic->setValue((char*)str.c_str());
      pCharacteristic->notify();
      value++;
      delay(10); // bluetooth stack will go into congestion, if too many packets are sent, in 6 hours test i was able to go as low as 3ms
      counter += 1;
    }
    delay(50);
  }
  return;
  
}

//=========================================================================================//
void setup() {
  Serial.begin(115200);
  //=========================================================================================//
  //Bluetooth SetUp
  // Create the BLE Device
  BLEDevice::init("ESP32 Seize Device");

  // Create the BLE Server
  pServer = BLEDevice::createServer();
  pServer->setCallbacks(new MyServerCallbacks());

  // Create the BLE Service
  BLEService *pService = pServer->createService(SERVICE_UUID);

  // Create a BLE Characteristic
  pCharacteristic = pService->createCharacteristic(
                      CHARACTERISTIC_UUID,
                      BLECharacteristic::PROPERTY_READ   |
                      BLECharacteristic::PROPERTY_WRITE  |
                      BLECharacteristic::PROPERTY_NOTIFY |
                      BLECharacteristic::PROPERTY_INDICATE
                    );
  // Create a BLE Descriptor
  pCharacteristic->addDescriptor(new BLE2902());

  // Start the service
  pService->start();

  // Start advertising
  BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  pAdvertising->setScanResponse(false);
  pAdvertising->setMinPreferred(0x0);  // set value to 0x00 to not advertise this parameter
  BLEDevice::startAdvertising();
  Serial.println("=========================================");
  Serial.println("Bluetooth Connection Setting Up");
  Serial.println("Waiting a client connection to notify...");
  Serial.println("=========================================");
  initialStream(); //initialize bluetooth stream
  //=========================================================================================//
  //Setup Accelerometer
  if (!mpu.begin()) {
    Serial.println("Failed to find MPU6050 chip");
    while (1) {
      delay(10);
    }
  }
  pinMode(LED_BUILTIN, OUTPUT);
  digitalWrite(LED_BUILTIN, LOW);
  /* For Motion
  mpu.setHighPassFilter(MPU6050_HIGHPASS_0_63_HZ);
  mpu.setMotionDetectionThreshold(1);
  mpu.setMotionDetectionDuration(15);
  mpu.setInterruptPinLatch(true);  // Keep it latched.  Will turn off when reinitialized.
  mpu.setInterruptPinPolarity(true);
  mpu.setMotionInterrupt(true);
  */
  mpu.setAccelerometerRange(MPU6050_RANGE_8_G);
  mpu.setGyroRange(MPU6050_RANGE_500_DEG);
  mpu.setFilterBandwidth(MPU6050_BAND_21_HZ);

  
  //=========================================================================================//
  //SetUp Pulse Sensor
  
  // Configure the PulseSensor manager.
  pulseSensor.analogInput(PULSE_INPUT);
  pulseSensor.blinkOnPulse(PULSE_BLINK);
  pulseSensor.fadeOnPulse(PULSE_FADE);

  pulseSensor.setSerial(Serial);
  pulseSensor.setOutputType(OUTPUT_TYPE);
  pulseSensor.setThreshold(THRESHOLD);

  samplesUntilReport = SAMPLES_PER_SERIAL_SAMPLE;

  if (!pulseSensor.begin()) {
    for(;;) {
      // Flash the led to show things didn't work.
      digitalWrite(PULSE_BLINK, LOW);
      delay(50);
      digitalWrite(PULSE_BLINK, HIGH);
      delay(50);
    }
  }

  //=========================================================================================//
  //SetUp GSR, Pulse Sensor and Accelerometer

  calibrateBPM(); //run bpm baseline calibration
  calibrateGSR(); //run gsr baseline calibration
  calibrateACC(); //run accelerometer baseline calibration

}


//=========================================================================================//

//LED behaviours 
void startLED() {
  digitalWrite(LED_BUILTIN, HIGH);
  delay(350);
  digitalWrite(LED_BUILTIN, LOW);
  delay(350);
}

void okayLED() {
  digitalWrite(LED_BUILTIN, HIGH);
  delay(250);
  digitalWrite(LED_BUILTIN, LOW);
  delay(250);
  digitalWrite(LED_BUILTIN, HIGH);
  delay(250);
  digitalWrite(LED_BUILTIN, LOW);
  delay(250);
}

//SEND DATA TO BLE DEVICE APP
void sendData() {
  
    String str = "";
    str += alertState;
    str += ",";
    str += isSensingHeightened;
    str += ",";
    str += bpmNow;
    str += ",";
    str += curGSR;
    str += ",";
    str += curAcceleration;
    Serial.println("========== DATA =========");
    Serial.print("Data: [");
    Serial.print(str);
    Serial.println("]");
    Serial.println("=========================");
    
  if (deviceConnected) {
    Serial.println("Device is Connected! Sending Data Now");
    pCharacteristic->setValue((char*)str.c_str());
    pCharacteristic->notify();
    value++;
    delay(10); // bluetooth stack will go into congestion, if too many packets are sent, in 6 hours test i was able to go as low as 3ms
  }
  // disconnecting
  if (!deviceConnected && oldDeviceConnected) {
    delay(500); // give the bluetooth stack the chance to get things ready
    pServer->startAdvertising(); // restart advertising
    Serial.println("Start Advertising");
    oldDeviceConnected = deviceConnected;
  }
  // connecting
  if (deviceConnected && !oldDeviceConnected) {
    // do stuff here on connecting
    oldDeviceConnected = deviceConnected;
  }

}

//=========================================================================================//


//=========================================================================================//
void loop() {
  //dont start until all sensors return useable data
  //run function for sensor check
  
  unsigned long currentTime = millis();
  startLED();

  if (alertState == 1) {
      //sendNotification to App
      //wait app response
  
      while (true) {
        Serial.println("Warning! Seizure Episode is Detected!");
        digitalWrite(LED_BUILTIN, HIGH);
        delay(100);
        digitalWrite(LED_BUILTIN, LOW);
        delay(100);
      }
  
    }
    


  if (currentTime - previousTime >= eventInterval) {
    Serial.println(" ");
    bool isSeizure = checkVitals();
    if (isSeizure == true) {
      alertState = 1;

    } else {
      alertState = 0;
      okayLED();
    }
    sendData();
    previousTime = currentTime;
  }

}

//=========================================================================================//
