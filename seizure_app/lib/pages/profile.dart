import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:seizure_app/constant.dart';
import 'package:seizure_app/pages/edit_profile.dart';
import 'package:seizure_app/pages/home_page.dart';
import 'package:seizure_app/pages/records.dart';
import 'package:flutter/cupertino.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int pageIndex = 2;
  bool normalStatus = true;
  bool sensitiveStatus = false;
  TimeOfDay selectedTimeStart = TimeOfDay.now();
  TimeOfDay selectedTimeEnd = TimeOfDay.now() ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: const EdgeInsets.only(
                  top: 70,
                  left: 20,
                  right: 20,
                ),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    width: MediaQuery.of(context).size.width/2-20,
                    height: MediaQuery.of(context).size.height/3.5,
                    decoration: BoxDecoration(
                      color: lightGrey,
                      borderRadius: BorderRadius.all(Radius.circular(20),
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
                          borderRadius: BorderRadius.circular(20), // Image border
                          child: SizedBox.fromSize(
                            size: Size.fromRadius(80), // Image radius
                            child: Image.asset('images/samplePic.jpg', fit: BoxFit.cover),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const FittedBox(
                          fit: BoxFit.fitWidth, 
                          child: Text(
                            'Nickname',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: darkBlue,
                            ),
                          ),
                        ),
                        
                        SizedBox(
                          height: 10,
                        ),
                      ]
                    ),
                  ),
                  SizedBox(width: 10,),
                  Container(
                    color: Colors.transparent,
                    width: MediaQuery.of(context).size.width/2-30,
                    height: MediaQuery.of(context).size.height/3.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                  
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Profile',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.black87,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const EditProfilePage(),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex:3,
                          child: Scrollbar(
                            isAlwaysShown: true,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const[
                                  Text(
                                    'Full Name',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: darkBlue,
                                    ),
                                  ),
                                  Text(
                                    'Full Name',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Guardian Full Name',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: darkBlue,
                                    ),
                                  ),
                                  Text(
                                    'Guardian Name',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    '09876543121',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: darkBlue,
                                    ),
                                  ),
                                  Text(
                                    'Contact Number',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Full Address',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: darkBlue,
                                    ),
                                  ),
                                  Text(
                                    'Address',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.black,
                                    ),
                                  ),
                                  
                                ],
                              ),
                            ),
                          ),
                        ),
                        
                      ]
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 115,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
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
                      decoration: BoxDecoration(
                        color: darkBlue,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                      ),
                      child: Icon(
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width-155,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text('Device Connectivity',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: darkGrey,
                                  ),
                                ),
                                Text('Phone Name',
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
                                        MaterialStateProperty.all(lightGrey),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ))),
                                onPressed: () { },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 7, right: 7),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: const <Widget>[
                                      Icon(
                                        Icons.bluetooth_rounded,
                                        color: darkBlue,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'Connected', //or connect
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
                )
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                //height: 170,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
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
                  top: 10,
                  left: 20,
                  right: 20,
                  bottom: 10,
                ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
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
                          Divider(
                            color: Color.fromARGB(255, 240, 240, 240),
                            thickness: 1,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.motion_photos_on_rounded,
                                    color: Colors.green,
                                    size: 40,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
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
                                inactiveColor:lightBlue,
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
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.contactless_rounded,
                                    color: red,
                                    size: 40,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
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
                                inactiveColor:lightBlue,
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
                                      sensitiveStatus = val;
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
                    Divider(
                            color: Color.fromARGB(255, 217, 217, 217),
                            thickness: 1,
                          ),
                    Container(
                      padding: const EdgeInsets.only(top:10, bottom: 10, left: 20, right: 20),
                        //height: 120,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                        Icon(
                                          Icons.access_time_rounded,
                                          color: darkGrey,
                                          size: 28,
                                        ),
                                        SizedBox(width: 10,),
                                          Text(
                                            'Set Schedule',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: darkGrey
                                              ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(lightGrey),
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20.0),
                                            ))),
                                        onPressed: () { },
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 50, right: 50),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: const <Widget>[
                                              Text(
                                                'Save', //or connect
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
                                  VerticalDivider(
                                    color: Color.fromARGB(255, 240, 240, 240),
                                    thickness: 1,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 115,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'From: ',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: darkGrey,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () { _selectTimeStart(context); },
                                              child: Container(
                                                padding: const EdgeInsets.only(top:3, bottom: 3, left: 15, right: 15),
                                                decoration: BoxDecoration(
                                                  color: lightGrey,
                                                  borderRadius: BorderRadius.circular(10),),
                                                child: Text(
                                                  '${selectedTimeStart.hour}:${selectedTimeStart.minute}',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: darkGrey,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        width: 115,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Until: ',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: darkGrey,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () { _selectTimeEnd(context); },
                                              child: Container(
                                                padding: const EdgeInsets.only(top:3, bottom: 3, left: 15, right: 15),
                                                decoration: BoxDecoration(
                                                  color: lightGrey,
                                                  borderRadius: BorderRadius.circular(10),),
                                                child: Text(
                                                  '${selectedTimeEnd.hour}:${selectedTimeEnd.minute}',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: darkGrey,
                                                  ),
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
      ),
      bottomNavigationBar: FloatingNavbar(
        onTap: (int val) => setState(() {
          pageIndex = val;
          print('selected index $val');
          if (pageIndex == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
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
                builder: (context) => const HomePage(),
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
    );
  }
  _selectTimeStart(BuildContext context) async {
      final TimeOfDay? timeOfDay = await showTimePicker(
        context: context,
        initialTime: selectedTimeStart,
        
        initialEntryMode: TimePickerEntryMode.dial,

      );
      if(timeOfDay != null && timeOfDay != selectedTimeStart)
        {
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
      if(timeOfDay != null && timeOfDay != selectedTimeEnd)
        {
          setState(() {
            selectedTimeEnd = timeOfDay;
          });
        }
  }
}
