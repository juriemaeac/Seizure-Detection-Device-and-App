import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:hive/hive.dart';
import 'package:seizure_app/constant.dart';
import 'package:seizure_app/device/widget.dart';
import 'package:seizure_app/pages/edit_profile_page.dart';
import 'package:seizure_app/device/sensor.dart';
import '../boxes/boxData.dart';
import '../boxes/boxInfo.dart';
import '../model/personal_info.dart';
import '../model/sensed_data.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int pageIndex = 2;
  bool normalStatus = true;
  bool isConnected = false;
  bool sensitiveStatus = false;
  TimeOfDay selectedTimeStart = TimeOfDay.now();
  TimeOfDay selectedTimeEnd = TimeOfDay.now();

  late String nickname = 'Nickname';
  late String firstName = 'First Name';
  late String middleName = 'Middle Name';
  late String lastName = 'Last Name';
  late String fullname = 'Full Name';
  late String guardianName = 'Guardian Name';
  late String address = 'Complete Address';
  late String email = '';
  late int number = 0;

  void isSensitive() {
    var checkSense = deviceSensitivity.getString();
    if (checkSense == "Normal") {
      normalStatus = true;
      sensitiveStatus = false;
    } else if (checkSense == "Sensitive") {
      normalStatus = false;
      sensitiveStatus = true;
    }
  }

  void checkUserInfo() {
    var infolength = Hive.box<PersonalInfo>(HiveBoxesInfo.info).length;
    var infoBox = Hive.box<PersonalInfo>(HiveBoxesInfo.info);
    isSensitive();
    if (infolength != 0) {
      print("Profile Found!");
      PersonalInfo? data = infoBox.getAt(infolength - 1);
      nickname = data?.nickname.toString() ?? "Nick Name";
      fullname = "${data?.firstName} ${data?.middleName} ${data?.lastName}";
      guardianName = data?.guardianName ?? "Guardian Name";
      address = data?.address ?? "Complete Address";
      number = data?.contactNumber ?? 0912345678;
    } else {
      print("No Profile Found!");
    }
  }

  @override
  void initState() {
    super.initState();
    Hive.openBox<PersonalInfo>(HiveBoxesInfo.info);
  }

  @override
  Widget build(BuildContext context) {
    checkUserInfo();
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: const EdgeInsets.only(
            top: 50,
          ),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.chevron_left_rounded,
                        size: 25,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Back",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                            top: 20,
                            left: 20,
                            right: 20,
                            bottom: 10,
                          ),
                          width: MediaQuery.of(context).size.width / 2 - 20,
                          height: MediaQuery.of(context).size.height / 3.5,
                          decoration: BoxDecoration(
                            color: lightGrey,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 15,
                                spreadRadius: 3,
                              ),
                            ],
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(20), // Image border
                                  child: SizedBox.fromSize(
                                    size: const Size.fromRadius(
                                        80), // Image radius
                                    child: Image.asset('images/samplePic.jpg',
                                        fit: BoxFit.cover),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(
                                    nickname,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: darkGrey,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ]),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          color: Colors.transparent,
                          width: MediaQuery.of(context).size.width / 2 - 30,
                          height: MediaQuery.of(context).size.height / 3.5,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: const [
                                              Icon(
                                                Icons.person,
                                                color: darkBlue,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                'Profile',
                                                style: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w600,
                                                  color: darkBlue,
                                                ),
                                              ),
                                            ],
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.edit,
                                              color: darkBlue,
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditProfilePage(),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Scrollbar(
                                    isAlwaysShown: true,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            fullname,
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: darkGrey,
                                            ),
                                          ),
                                          Text(
                                            'Full Name',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: lightBlue,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            guardianName,
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: darkGrey,
                                            ),
                                          ),
                                          Text(
                                            'Guardian Name',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: lightBlue,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            number.toString(),
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: darkGrey,
                                            ),
                                          ),
                                          Text(
                                            'Contact Number',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: lightBlue,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            address,
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: darkGrey,
                                            ),
                                          ),
                                          Text(
                                            'Address',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: lightBlue,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                        height: 115,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 13,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 115,
                              padding: const EdgeInsets.only(
                                top: 10,
                                bottom: 10,
                              ),
                              decoration: const BoxDecoration(
                                color: darkBlue,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                ),
                              ),
                              child: const Icon(
                                Icons.phone_android_rounded,
                                color: Colors.white, //or red
                                size: 85,
                              ),
                            ),
                            Container(
                              height: 115,
                              padding: const EdgeInsets.only(
                                top: 10,
                                left: 10,
                                right: 20,
                                bottom: 10,
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width - 155,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Device Connectivity',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: darkGrey,
                                          ),
                                        ),
                                        Text(
                                          "Phone Model",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: darkGrey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    lightGrey),
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ))),
                                        onPressed: () {
                                          int count = 0;
                                          Navigator.popUntil(context, (route) {
                                            return count++ == 2;
                                          });
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
                                                Icons.bluetooth_rounded,
                                                color: darkBlue,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                'CONNECT', //or connect
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
                                ],
                              ),
                            ),
                          ],
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      //height: 170,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 13,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      width: MediaQuery.of(context).size.width,

                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(
                              top: 20,
                              left: 20,
                              right: 20,
                              bottom: 20,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.speed_rounded,
                                      color: darkGrey,
                                      size: 28,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Sensing Parameters',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: darkGrey,
                                      ),
                                    )
                                  ],
                                ),
                                const Divider(
                                  color: Color.fromARGB(255, 240, 240, 240),
                                  thickness: 1,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.motion_photos_on_rounded,
                                          color: Colors.green,
                                          size: 40,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: const [
                                            Text(
                                              'Normal State',
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: darkBlue,
                                              ),
                                            ),
                                            Text(
                                              'Subtitle',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: lightBlue,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    FlutterSwitch(
                                      width: 90,
                                      height: 30,
                                      activeColor: darkBlue,
                                      inactiveColor: lightBlue,
                                      activeTextColor: Colors.white70,
                                      inactiveTextColor: Colors.white70,
                                      toggleColor: Colors.white,
                                      valueFontSize: 12,
                                      toggleSize: 25,
                                      value: normalStatus,
                                      borderRadius: 20,
                                      padding: 5,
                                      showOnOff: false,
                                      onToggle: (val) {
                                        setState(() {
                                          var sensitivity = "Normal";
                                          deviceSensitivity
                                              .setString(sensitivity);
                                          var newVal =
                                              deviceSensitivity.getString();
                                          print("Sensitivity: ${newVal}");
                                          normalStatus = val;
                                          sensitiveStatus = false;
                                          if (normalStatus == false) {
                                            sensitiveStatus = true;
                                          }
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.contactless_rounded,
                                          color: red,
                                          size: 40,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: const [
                                            Text(
                                              'Sensitive State',
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: darkBlue,
                                              ),
                                            ),
                                            Text(
                                              'Subtitle',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: lightBlue,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    FlutterSwitch(
                                      width: 90,
                                      height: 30,
                                      activeColor: darkBlue,
                                      inactiveColor: lightBlue,
                                      activeTextColor: Colors.white70,
                                      inactiveTextColor: Colors.white70,
                                      toggleColor: Colors.white,
                                      valueFontSize: 12,
                                      toggleSize: 25,
                                      value: sensitiveStatus,
                                      borderRadius: 20,
                                      padding: 5,
                                      showOnOff: false,
                                      onToggle: (val) {
                                        setState(() {
                                          var sensitivity = "Sensitive";
                                          deviceSensitivity
                                              .setString(sensitivity);
                                          sensitiveStatus = val;
                                          var newVal =
                                              deviceSensitivity.getString();
                                          print("Sensitivity: ${newVal}");
                                          normalStatus = false;
                                          if (sensitiveStatus == false) {
                                            normalStatus = true;
                                          }
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            color: Color.fromARGB(255, 217, 217, 217),
                            thickness: 1,
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                                top: 20, bottom: 20, left: 20, right: 20),
                            //height: 120,
                            width: MediaQuery.of(context).size.width,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                IntrinsicHeight(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: const [
                                              Icon(
                                                Icons.access_time_rounded,
                                                color: darkGrey,
                                                size: 28,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                'Set Schedule',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: darkGrey),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          ElevatedButton(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        lightGrey),
                                                shape: MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                ))),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext
                                                        context) =>
                                                    _buildPopupDialog(context),
                                              );
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 50, right: 50),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: const <Widget>[
                                                  Text(
                                                    'Set', //or connect
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: darkBlue,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const VerticalDivider(
                                        color:
                                            Color.fromARGB(255, 240, 240, 240),
                                        thickness: 1,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 130,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(
                                                  width: 50,
                                                  child: Text(
                                                    'From: ',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: darkGrey,
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    _selectTimeStart(context);
                                                  },
                                                  child: Container(
                                                    width: 80,
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 3,
                                                            bottom: 3,
                                                            left: 15,
                                                            right: 15),
                                                    decoration: BoxDecoration(
                                                      color: lightGrey,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Text(
                                                      '${selectedTimeStart.hour}:${selectedTimeStart.minute}',
                                                      style: const TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: darkGrey,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          SizedBox(
                                            width: 130,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(
                                                  width: 50,
                                                  child: Text(
                                                    'Until: ',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: darkGrey,
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    _selectTimeEnd(context);
                                                  },
                                                  child: Container(
                                                    width: 80,
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 3,
                                                            bottom: 3,
                                                            left: 15,
                                                            right: 15),
                                                    decoration: BoxDecoration(
                                                      color: lightGrey,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Text(
                                                      '${selectedTimeEnd.hour}:${selectedTimeEnd.minute}',
                                                      style: const TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: darkGrey,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPopupDialog(BuildContext context) {
    return new AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      contentPadding: EdgeInsets.only(top: 10.0),
      content: Container(
        padding: EdgeInsets.all(15),
        height: MediaQuery.of(context).size.height / 3,
        width: MediaQuery.of(context).size.width,
        child: Column(
          //mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 20, top: 20),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.alarm_on_rounded,
                    color: Colors.amber,
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
                  "Schedule",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 4.2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Set From: ",
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                          Text(
                            "${selectedTimeStart.hour}:${selectedTimeStart.minute}",
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Until: ",
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                          Text(
                            "${selectedTimeEnd.hour}:${selectedTimeEnd.minute}",
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Text(
                      "Close",
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.amber),
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

  _selectTimeStart(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTimeStart,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != selectedTimeStart) {
      setState(() {
        selectedTimeStart = timeOfDay;
      });
    }
  }

  _selectTimeEnd(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTimeEnd,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != selectedTimeEnd) {
      setState(() {
        selectedTimeEnd = timeOfDay;
      });
    }
  }
}
