//PAGE KUNG SAN UNG READING NG SENSOR

import 'dart:async';
import 'dart:convert' show utf8;

import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oscilloscope/oscilloscope.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:seizure_app/constant.dart';
import 'package:seizure_app/pages/home_page.dart';
import 'package:seizure_app/pages/profile_page.dart';
import 'package:seizure_app/pages/records_page.dart';
import 'package:seizure_app/widgets/barchart.dart';
import 'package:seizure_app/widgets/calendar.dart';
import 'package:seizure_app/widgets/recent_high.dart';

class SensorPage extends StatefulWidget {
  const SensorPage({ Key? key, this.device}) : super(key: key);
  final BluetoothDevice? device; //remove ? if may mga errors

  @override
  _SensorPageState createState() => _SensorPageState();
}

class _SensorPageState extends State<SensorPage> {
  int pageIndex = 0;

  final String SERVICE_UUID = "4fafc201-1fb5-459e-8fcc-c5c9c331914b";
  final String CHARACTERISTIC_UUID = "beb5483e-36e1-4688-b7f5-ea07361b26a8";
  late bool isReady;
  late Stream<List<int>> stream;
  List<double> traceDust = [];
  final String noData = "0,0,0,0,0"; 
  var currentValue = "no reading";
  @override
  void initState() {
    super.initState();
    isReady = false;
    connectToDevice();
  }

  connectToDevice() async {
    if (widget.device == null) {
      _Pop();
      return;
    }

    Timer(const Duration(seconds: 15), () {
      if (!isReady) {
        disconnectFromDevice();
        _Pop();
      }
    });

    await widget.device!.connect();
    discoverServices();
  }

  disconnectFromDevice() {
    if (widget.device == null) {
      _Pop();
      return;
    }

    widget.device!.disconnect();
  }

  discoverServices() async {
    if (widget.device == null) {
      _Pop();
      return;
    }

    List<BluetoothService> services = await widget.device!.discoverServices();
    services.forEach((service) {
      if (service.uuid.toString() == SERVICE_UUID) {
        service.characteristics.forEach((characteristic) {
          if (characteristic.uuid.toString() == CHARACTERISTIC_UUID) {
            characteristic.setNotifyValue(!characteristic.isNotifying);
            stream = characteristic.value;

            setState(() {
              isReady = true;
            });
          }
        });
      }
    });

    if (!isReady) {
      _Pop();
    }
  }

  Future<bool> _onWillPop() async{
    bool willPop = false;
    await showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: const Text('Are you sure?'),
              content: Text('Do you want to disconnect device and go back?'),
              actions: <Widget>[
                FlatButton(
                    onPressed: (){
                      Navigator.of(context).pop(false); 
                      willPop = false;},
                    child: Text('No')),
                FlatButton(
                    onPressed: () {
                      disconnectFromDevice();
                      willPop = true;
                      Navigator.of(context).pop(true);
                    },
                    child: const Text('Yes')),
              ],
            ));
     return willPop;
  }

  _Pop() {
    Navigator.of(context).pop(true);
  }

  String _dataParser(List<int> dataFromDevice) {
    return utf8.decode(dataFromDevice);
  }

  @override
  Widget build(BuildContext context) {
    // Oscilloscope oscilloscope = Oscilloscope(
    //   showYAxis: true,
    //   padding: 0.0,
    //   backgroundColor: Colors.pink,
    //   traceColor: Colors.white,
    //   yAxisMax: 3000.0,
    //   yAxisMin: 0.0,
    //   dataSet: traceDust,
    // );

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        // appBar: AppBar(
        //   title: Text('Records Page'),
        // ),
        body: Container(
          padding: const EdgeInsets.symmetric(
              //horizontal: 15,
              vertical: 10,
            ),
            margin: const EdgeInsets.only(
              top: 50,
            ),
            child: !isReady
                ? Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black,),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProfilePage(),
                              ),
                            );
                          },
                        ),
                        const Text(
                          'Records',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(
                          width: 40,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4,
                    ),
                    Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                        color: darkBlue,
                        size: 50,
                      ),
                    ),
                  ],
                )
                : Container(
                    child: StreamBuilder<List<int>>(
                      stream: stream,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<int>> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.active) {
                          if (snapshot.data != null){
                            currentValue = _dataParser(snapshot.data!);
                          } else{
                            currentValue = noData;
                          }
                          //traceDust.add(double.tryParse(currentValue) ?? 0);

                          // HOME PAGE
                          return Scaffold(
                            body: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              // Container(
                              //   padding: const EdgeInsets.symmetric(
                              //     horizontal: 15,
                              //     vertical: 10,
                              //   ),
                              //   margin: const EdgeInsets.only(
                              //     top: 50,
                              //   ),
                              // ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  //vertical: 20,
                                ),
                                //   margin: const EdgeInsets.only(
                                //     top: 60,
                                //   ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Hi User',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10), // Image border
                                          child: SizedBox.fromSize(
                                            size: const Size.fromRadius(20), // Image radius
                                            child: Image.asset('images/samplePic.jpg', fit: BoxFit.cover)
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  //vertical: 20,
                                ),
                                // margin: const EdgeInsets.only(
                                //   top: 20,
                                // ),
                                child: Column(
                                  children: const [
                                    CalendarSection(),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(left: 20, right: 20),
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Seizure Activity',
                                          style: Theme.of(context).textTheme.headline6,
                                        ),
                                      ],
                                    ), 
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  //vertical: 20,
                                ),
                                margin: const EdgeInsets.only(top: 10, bottom: 10),
                                child: Column(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: 170,
                                      decoration: const BoxDecoration(
                                        color: darkBlue,
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(20),
                                          topLeft: Radius.circular(20),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 15,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                      child: Stack(
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.only(
                                              top: 10,
                                            ),
                                            // padding: const EdgeInsets.only(
                                            //   left: 20,
                                            //   right: 20,
                                            //),
                                            //child: LineChart(activityData()),
                                            child: const BarChartSample1(),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      height: 50,
                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                      decoration: const BoxDecoration(
                                        color: darkBlue,
                                        borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(20),
                                          bottomLeft: Radius.circular(20),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 10,
                                            spreadRadius: 3,
                                            offset: Offset(0, 10),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            "Record a Seizure activity",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                          ElevatedButton(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(Colors.white),
                                                shape: MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(20.0),
                                                ))),
                                            onPressed: () {
                                              //check ata dito kung may connected sa device o wala, kapag wala
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => const SensorPage(),
                                                ),
                                              );
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 7, right: 7),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: const <Widget>[
                                                  Icon(
                                                    Icons.record_voice_over_rounded,
                                                    color: darkBlue,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    'Record',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w400,
                                                      color: darkBlue,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Real-time Analytics',
                                          style: Theme.of(context).textTheme.headline6,
                                        ),
                                        Row(
                                          children: const[
                                            Icon(
                                              Icons.sensors_rounded,
                                              color: Colors.grey,
                                              size: 20,
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              'Update',
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                //height: 250,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: 180,
                                          margin: const EdgeInsets.all(20),
                                          padding: const EdgeInsets.only(
                                              top: 15, bottom: 15, left: 20, right: 20),
                                          //height: 200,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(20),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.black12,
                                                blurRadius: 15,
                                                spreadRadius: 2,
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${currentValue}",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold,
                                                      color: darkGrey,
                                                      fontFamily: GoogleFonts.poppins().fontFamily,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Column(
                                                    children: const [
                                                      SizedBox(
                                                        height: 35,
                                                      ),
                                                      Text(
                                                        "bpm",
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight: FontWeight.w400,
                                                            color: darkGrey),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              Container(
                                                padding: const EdgeInsets.only(
                                                    left: 10, right: 10, top: 3, bottom: 3),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(8),
                                                  color: Colors.grey[200],
                                                ),
                                                child: Row(
                                                  children: const [
                                                    Icon(
                                                      Icons.favorite_rounded,
                                                      color: Color.fromARGB(255, 244, 86, 74),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      "Heart Rate",
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: 180,
                                          margin: const EdgeInsets.only(top: 20, bottom: 20, right: 20),
                                          padding: const EdgeInsets.only(
                                              top: 15, bottom: 15, left: 20, right: 20),
                                          //height: 200,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(20),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.black12,
                                                blurRadius: 15,
                                                spreadRadius: 2,
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${currentValue}",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold,
                                                      color: darkGrey,
                                                      fontFamily: GoogleFonts.poppins().fontFamily,
                                                    ),
                                                  ),
                                                  const Text(
                                                    "movement",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w400,
                                                        color: darkGrey),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 28,
                                              ),
                                              Container(
                                                padding: const EdgeInsets.only(
                                                    left: 10, right: 10, top: 3, bottom: 3),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(8),
                                                  color: Colors.grey[200],
                                                ),
                                                child: Row(
                                                  children: const [
                                                    Icon(
                                                      Icons.device_hub_rounded,
                                                      color: Colors.green,
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      "Accelerometer",
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: 180,
                                          margin: const EdgeInsets.only(left:20, right:20),
                                          padding: const EdgeInsets.only(
                                              top: 15, bottom: 15, left: 20, right: 20),
                                          //height: 200,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(20),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.black12,
                                                blurRadius: 15,
                                                spreadRadius: 2,
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${currentValue}",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold,
                                                      color: darkGrey,
                                                      fontFamily: GoogleFonts.poppins().fontFamily,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Column(
                                                    children: const [
                                                      SizedBox(
                                                        height: 35,
                                                      ),
                                                      Text(
                                                        "activity",
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight: FontWeight.w400,
                                                            color: darkGrey),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              Container(
                                                padding: const EdgeInsets.only(
                                                    left: 10, right: 10, top: 3, bottom: 3),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(8),
                                                  color: Colors.grey[200],
                                                ),
                                                child: Row(
                                                  children: const [
                                                    Icon(
                                                      Icons.back_hand,
                                                      color: Colors.amber,
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      "Heart Rate",
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: 180,
                                          margin: const EdgeInsets.only(right: 20),
                                          padding: const EdgeInsets.only(
                                              top: 15, bottom: 15, left: 20, right: 20),
                                          //height: 200,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(20),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.black12,
                                                blurRadius: 15,
                                                spreadRadius: 2,
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Connected",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold,
                                                      color: darkGrey,
                                                      fontFamily: GoogleFonts.poppins().fontFamily,
                                                    ),
                                                  ),
                                                  const Text(
                                                    "Status",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w400,
                                                        color: darkGrey),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 28,
                                              ),
                                              Container(
                                                padding: const EdgeInsets.only(
                                                    left: 10, right: 10, top: 3, bottom: 3),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(8),
                                                  color: Colors.grey[200],
                                                ),
                                                child: Row(
                                                  children: const [
                                                    Icon(
                                                      Icons.bluetooth,
                                                      color: Colors.blue,
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      "Bluetooth",
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // Container(
                              //   color: Colors.pink,
                              //   height: 200,
                              //   width: MediaQuery.of(context).size.width,
                              //   //margin: const EdgeInsets.only(left: 20, right: 20, bottom:20),
                              //   //padding: const EdgeInsets.all(20),
                              //   child: ListView(
                              //     shrinkWrap: true,
                              //     primary: false,
                              //     // physics: const ClampingScrollPhysics(),
                              //     padding: const EdgeInsets.all(0),
                              //     scrollDirection: Axis.horizontal,
                              //     children: [
                                    
                                    
                              //     ],
                              //   ),
                              // ),
                              
                              // Column(
                              //     mainAxisAlignment: MainAxisAlignment.center,
                              //     children: <Widget>[
                              //       const Text('Current value from Sensor',
                              //           style: TextStyle(fontSize: 14)),
                              //       Text('${currentValue} reading',
                              //           style: const TextStyle(
                              //               fontWeight: FontWeight.bold,
                              //               fontSize: 24))
                              //     ]),
                              // Expanded(
                              //   flex: 1,
                              //   child: oscilloscope,
                              // )
                            ],
                          ));
                        } else {
                          return Text('Check the stream');
                        }
                      },
                    ),
                  ),
                  ),
                  bottomNavigationBar: FloatingNavbar(
        onTap: (int val) => setState(() {
          pageIndex = val;
          //print('selected index $val');
          if (pageIndex == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SensorPage(),
              ),
            );
          } else if (pageIndex == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RecordPage(),
              ),
            );
          } else if (pageIndex == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfilePage(),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SensorPage(),
              ),
            );
          }
        }),
        currentIndex: pageIndex,
        items: [
          FloatingNavbarItem(icon: Icons.home),
          FloatingNavbarItem(icon: Icons.bar_chart),
          FloatingNavbarItem(icon: Icons.person),
        ],
        selectedItemColor: lightBlue,
        unselectedItemColor: Colors.white,
        backgroundColor: darkBlue,
        itemBorderRadius: 15,
        borderRadius: 20,
        iconSize: 20,
      ),
      ),
    );
  }
}