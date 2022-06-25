//HOME PAGE

import 'dart:async';
import 'dart:convert' show utf8;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:seizure_app/boxes/boxData.dart';
import 'package:seizure_app/constant.dart';
import 'package:seizure_app/model/sensed_data.dart';
import 'package:seizure_app/pages/profile_page.dart';
import 'package:seizure_app/pages/records_page.dart';
import 'package:seizure_app/widgets/barchart.dart';
import 'package:seizure_app/widgets/calendar.dart';
import 'package:seizure_app/widgets/notification_widget.dart';
import 'package:oscilloscope/oscilloscope.dart';

class SensorPage extends StatefulWidget {
  const SensorPage({Key? key, this.device}) : super(key: key);
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
  final List noReading = [];
  List<double> traceData = [];

  late String date;
  late String time;
  late String isHeightened = 'False';
  late String bpm = 'Erratic';
  late String gsr = 'Erratic';
  late String accelerometer = 'Erratic';
  var sense = "";

  @override
  void initState() {
    super.initState();
    isReady = false;
    connectToDevice();
    Hive.openBox<SensedData>(HiveBoxesData.data);
    NotificationWidget.init();
  }

  parseData(String dataVal) {
    var split = dataVal.split(',');
    final Map<int, String> values = {
      for (int i = 0; i < split.length; i++) i: split[i]
    };
    return values;
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

  // Future<bool> _onWillPop() async{
  //   bool willPop = false;
  //   await showDialog(
  //       context: context,
  //       builder: (context) =>
  //           AlertDialog(
  //             title: const Text('Are you sure?'),
  //             content: Text('Do you want to disconnect device and go back?'),
  //             actions: <Widget>[
  //               FlatButton(
  //                   onPressed: (){
  //                     Navigator.of(context).pop(false);
  //                     willPop = false;},
  //                   child: Text('No')),
  //               FlatButton(
  //                   onPressed: () {
  //                     disconnectFromDevice();
  //                     willPop = true;
  //                     Navigator.of(context).pop(true);
  //                   },
  //                   child: const Text('Yes')),
  //             ],
  //           ));
  //    return willPop;
  // }

  _Pop() {
    Navigator.of(context).pop(true);
  }

  String _dataParser(List<int> dataFromDevice) {
    return utf8.decode(dataFromDevice);
  }

  @override
  Widget build(BuildContext context) {
    Oscilloscope oscilloscope = Oscilloscope(
      showYAxis: true,
      padding: 0.0,
      backgroundColor: Colors.white,
      traceColor: darkBlue,
      yAxisMax: 200.0,
      yAxisMin: 0.0,
      dataSet: traceData,
      strokeWidth: 5,
      yAxisColor: lightGrey,
    );
    sense = deviceSensitivity.getString();
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(
          //horizontal: 15,
          vertical: 10,
        ),
        margin: const EdgeInsets.only(
          top: 50,
        ),
        child: !isReady
            ? Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: darkBlue,
                  size: 50,
                ),
              )
            : Container(
                child: StreamBuilder<List<int>>(
                  stream: stream,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<int>> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                        child: LoadingAnimationWidget.staggeredDotsWave(
                          color: darkBlue,
                          size: 50,
                        ),
                      );
                    } else if (snapshot.connectionState ==
                            ConnectionState.active &&
                        snapshot.data != []) {
                      print("Ito yung snapshotData ${snapshot.data}");
                      var currentValue = _dataParser(snapshot.data!);
                      print("Current Value: $currentValue");
                      var dataArray = parseData(currentValue);
                      print("Data Array: $dataArray");

                      print("Parsed Data");
                      print("IsSeizure: ${dataArray[0]}");
                      print("IsHeightened: ${dataArray[1]}");
                      print("BPM: ${dataArray[2]}");
                      print("GSR: ${dataArray[3]}");
                      print("ACC: ${dataArray[4]}");

                      traceData.add(double.tryParse(dataArray[2]) ?? 0);
                      sense = deviceSensitivity.getString();
                      bpm = "${dataArray[2]}";
                      var seizureStat = dataArray[0];
                      if (seizureStat == '1') {
                        NotificationWidget.showNotification(
                            title: "Warning",
                            body: "Possible Seizure Episode Detected");
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) =>
                              _buildPopupDialogAlert(context, bpm),
                        );
                      }
                      // HOME PAGE
                      return Scaffold(
                        body: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Hi User',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const ProfilePage(),
                                            ),
                                          );
                                        },
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              10), // Image border
                                          child: SizedBox.fromSize(
                                              size: const Size.fromRadius(
                                                  20), // Image radius
                                              child: Image.asset(
                                                  'images/samplePic.jpg',
                                                  fit: BoxFit.cover)),
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
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Seizure Activity',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
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
                              margin:
                                  const EdgeInsets.only(top: 10, bottom: 10),
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
                                          margin: EdgeInsets.all(10),
                                          padding: const EdgeInsets.all(
                                            10,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          // padding: const EdgeInsets.only(
                                          //   left: 20,
                                          //   right: 20,
                                          //),
                                          //child: LineChart(activityData()),
                                          child:
                                              oscilloscope, //const BarChartSample1(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: 50,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                                  MaterialStateProperty.all(
                                                      Colors.white),
                                              shape: MaterialStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ))),
                                          onPressed: () {
                                            showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  _buildPopupDialog(context),
                                            );
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 7, right: 7),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: const <Widget>[
                                                Icon(
                                                  Icons
                                                      .record_voice_over_rounded,
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
                              padding: const EdgeInsets.only(
                                  top: 10, left: 20, right: 20),
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Real-time Analytics',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.sensors_rounded,
                                            color: Colors.grey,
                                            size: 20,
                                          ),
                                          SizedBox(width: 5),
                                          GestureDetector(
                                            onTap: () {
                                              NotificationWidget.showNotification(
                                                  title: "Warning",
                                                  body:
                                                      "Possible Seizure Episode Detected");
                                              showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        _buildPopupDialogAlert(
                                                            context, bpm),
                                              );
                                            },
                                            child: Text(
                                              'Update',
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 14,
                                              ),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 180,
                                        margin: const EdgeInsets.only(
                                            top: 20, bottom: 20, left: 20),
                                        padding: const EdgeInsets.only(
                                            top: 15,
                                            bottom: 15,
                                            left: 20,
                                            right: 20),
                                        //height: 200,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 15,
                                              spreadRadius: 2,
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                if (dataArray[2] == null) ...[
                                                  Text(
                                                    "null",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: darkGrey,
                                                      fontFamily:
                                                          GoogleFonts.poppins()
                                                              .fontFamily,
                                                    ),
                                                  ),
                                                  const Text(
                                                    "bpm",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: darkGrey),
                                                  ),
                                                ] else if (int.parse(
                                                        dataArray[2]) <
                                                    0) ...[
                                                  Text(
                                                    "Error",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: darkGrey,
                                                      fontFamily:
                                                          GoogleFonts.poppins()
                                                              .fontFamily,
                                                    ),
                                                  ),
                                                  const Text(
                                                    "bpm",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: darkGrey),
                                                  ),
                                                ] else if (int.parse(
                                                        dataArray[2]) >
                                                    0) ...[
                                                  Text(
                                                    "${dataArray[2]}",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: darkGrey,
                                                      fontFamily:
                                                          GoogleFonts.poppins()
                                                              .fontFamily,
                                                    ),
                                                  ),
                                                  const Text(
                                                    "bpm",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: darkGrey),
                                                  ),
                                                ]
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 28,
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                  top: 3,
                                                  bottom: 3),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: Colors.grey[200],
                                              ),
                                              child: Row(
                                                children: const [
                                                  Icon(
                                                    Icons.favorite_rounded,
                                                    color: Colors.red,
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
                                        margin: const EdgeInsets.only(
                                            top: 20, bottom: 20, right: 20),
                                        padding: const EdgeInsets.only(
                                            top: 15,
                                            bottom: 15,
                                            left: 20,
                                            right: 20),
                                        //height: 200,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 15,
                                              spreadRadius: 2,
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                if (dataArray[4] == null) ...[
                                                  Text(
                                                    "null",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: darkGrey,
                                                      fontFamily:
                                                          GoogleFonts.poppins()
                                                              .fontFamily,
                                                    ),
                                                  ),
                                                  const Text(
                                                    "movement",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: darkGrey),
                                                  ),
                                                ] else if (int.parse(
                                                        dataArray[4]) ==
                                                    0) ...[
                                                  Text(
                                                    "Nominal",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: darkGrey,
                                                      fontFamily:
                                                          GoogleFonts.poppins()
                                                              .fontFamily,
                                                    ),
                                                  ),
                                                  const Text(
                                                    "movement",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: darkGrey),
                                                  ),
                                                ] else if (int.parse(
                                                        dataArray[4]) ==
                                                    1) ...[
                                                  Text(
                                                    "Erratic",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: darkGrey,
                                                      fontFamily:
                                                          GoogleFonts.poppins()
                                                              .fontFamily,
                                                    ),
                                                  ),
                                                  const Text(
                                                    "movement",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: darkGrey),
                                                  ),
                                                ],
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 28,
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                  top: 3,
                                                  bottom: 3),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 180,
                                        margin: const EdgeInsets.only(left: 20),
                                        padding: const EdgeInsets.only(
                                            top: 15,
                                            bottom: 15,
                                            left: 20,
                                            right: 20),
                                        //height: 200,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 15,
                                              spreadRadius: 2,
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                if (dataArray[3] == null) ...[
                                                  Text(
                                                    "null",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: darkGrey,
                                                      fontFamily:
                                                          GoogleFonts.poppins()
                                                              .fontFamily,
                                                    ),
                                                  ),
                                                  const Text(
                                                    "Resistance",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: darkGrey),
                                                  ),
                                                ] else if (int.parse(
                                                        dataArray[3]) ==
                                                    0) ...[
                                                  Text(
                                                    "Nominal",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: darkGrey,
                                                      fontFamily:
                                                          GoogleFonts.poppins()
                                                              .fontFamily,
                                                    ),
                                                  ),
                                                  const Text(
                                                    "Resistance",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: darkGrey),
                                                  ),
                                                ] else if (int.parse(
                                                        dataArray[3]) ==
                                                    1) ...[
                                                  Text(
                                                    "Erratic",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: darkGrey,
                                                      fontFamily:
                                                          GoogleFonts.poppins()
                                                              .fontFamily,
                                                    ),
                                                  ),
                                                  const Text(
                                                    "Resistance",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: darkGrey),
                                                  ),
                                                ],
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 28,
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                  top: 3,
                                                  bottom: 3),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: Colors.grey[200],
                                              ),
                                              child: Row(
                                                children: const [
                                                  Icon(
                                                    Icons.back_hand_rounded,
                                                    color: Colors.amber,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    "Electrodermal",
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
                                        margin:
                                            const EdgeInsets.only(right: 20),
                                        padding: const EdgeInsets.only(
                                            top: 15,
                                            bottom: 15,
                                            left: 20,
                                            right: 20),
                                        //height: 200,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 15,
                                              spreadRadius: 2,
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                if (int.parse(dataArray[1]) ==
                                                    0) ...[
                                                  Text(
                                                    "${sense}",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: darkGrey,
                                                      fontFamily:
                                                          GoogleFonts.poppins()
                                                              .fontFamily,
                                                    ),
                                                  ),
                                                  const Text(
                                                    "Sensing",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: darkGrey),
                                                  ),
                                                ] else if (int.parse(
                                                        dataArray[1]) ==
                                                    1) ...[
                                                  Text(
                                                    "Sensitive",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: darkGrey,
                                                      fontFamily:
                                                          GoogleFonts.poppins()
                                                              .fontFamily,
                                                    ),
                                                  ),
                                                  const Text(
                                                    "Sensing",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: darkGrey),
                                                  ),
                                                ],
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 28,
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                  top: 3,
                                                  bottom: 3),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: Colors.grey[200],
                                              ),
                                              child: Row(
                                                children: const [
                                                  Icon(
                                                    Icons.speed_rounded,
                                                    color: Colors.blue,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    "Parameter",
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
                            Container(
                              height: 50,
                              margin: EdgeInsets.only(
                                  top: 20, bottom: 7, left: 20, right: 20),
                              //width: MediaQuery.of(context).size.width * 0.7,
                              padding: const EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20)),
                                color: darkBlue,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.7 /
                                        2.6,
                                    padding: const EdgeInsets.all(5),
                                    decoration: const BoxDecoration(
                                      //shape: BoxShape.circle,
                                      color: Colors.white,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(15)),
                                    ),
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      icon: const Icon(Icons.home_rounded,
                                          size: 20, color: darkBlue),
                                      onPressed: () {
                                        //Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.7 /
                                        2.6,
                                    padding: const EdgeInsets.all(5),
                                    decoration: const BoxDecoration(
                                      //shape: BoxShape.circle,
                                      //color: Colors.white,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(15)),
                                    ),
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      icon: const Icon(Icons.bar_chart,
                                          size: 20, color: Colors.white),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const RecordPage(),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.7 /
                                        2.6,
                                    padding: const EdgeInsets.all(5),
                                    decoration: const BoxDecoration(
                                      //shape: BoxShape.circle,
                                      //color: Colors.white,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(15)),
                                    ),
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      icon: const Icon(Icons.person,
                                          size: 20, color: Colors.white),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const ProfilePage(),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Center(
                          child: Container(
                        margin: const EdgeInsets.only(top: 8.0),
                        child: const Text('Check the stream'),
                      ));
                    }
                  },
                ),
              ),
      ),
    );
  }

  void addData(String bpmNow) {
    DateTime now = DateTime.now();
    String formattedTime = DateFormat.Hm().format(now);
    String recordDate = DateFormat("MMMM dd, yyyy").format(DateTime.now());

    Box<SensedData> dataBox = Hive.box<SensedData>(HiveBoxesData.data);
    dataBox.add(SensedData(
      date: recordDate,
      time: formattedTime,
      isHeightened: 'False',
      bpm: bpmNow,
      gsr: 'Erratic',
      accelerometer: 'Erratic',
    ));
  }

  Widget _buildPopupDialog(BuildContext context) {
    return new AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      contentPadding: EdgeInsets.only(top: 10.0),
      content: Container(
        padding: EdgeInsets.only(top: 15),
        height: MediaQuery.of(context).size.height / 3,
        width: MediaQuery.of(context).size.width,
        child: Column(
          //mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 30, top: 20),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.red,
                    size: 40,
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Record",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Seizure Episode Detected",
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
                Text(
                  "Manual Record",
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    String setBPM = 'Erratic';
                    addData(setBPM);
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Text(
                      "Confirm",
                      style: TextStyle(fontSize: 15, color: Colors.red),
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPopupDialogAlert(BuildContext context, String bpmString) {
    return new AlertDialog(
      backgroundColor: Colors.red,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      contentPadding: EdgeInsets.only(top: 10.0),
      content: Container(
        padding: EdgeInsets.only(top: 15),
        height: MediaQuery.of(context).size.height / 3,
        width: MediaQuery.of(context).size.width,
        child: Column(
          //mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.white,
                  size: 65,
                ),
                Text(
                  "Warning",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Possible Seizure",
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
                Text(
                  "Episode Detected",
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    addData(bpmString);
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Text(
                      "Confirm",
                      style: TextStyle(fontSize: 15, color: Colors.red),
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "False Alarm?",
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ),
                SizedBox(height: 20),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class deviceSensitivity {
  static String sensitivity = "Normal";
  static void setString(String newValue) {
    sensitivity = newValue;
  }

  static String getString() {
    return sensitivity;
  }
}
