import 'dart:ffi';

import 'package:fl_chart/fl_chart.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:seizure_app/constant.dart';
import 'package:seizure_app/default_widget.dart';
import 'package:seizure_app/pages/profile.dart';
import 'package:seizure_app/pages/records.dart';
import 'package:seizure_app/widgets/barchart.dart';
import 'package:seizure_app/widgets/calendar.dart';
import 'package:seizure_app/widgets/recent_high.dart';
import 'package:seizure_app/widgets/recent_normal.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      body: CustomScrollView(
        slivers: [
          sliverList(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 10,
              ),
              margin: const EdgeInsets.only(
                top: 50,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(
                    Icons.dashboard_rounded,
                    size: 30,
                    color: grey,
                  ),
                  Icon(
                    Icons.person_rounded,
                    size: 30,
                    color: grey,
                  ),
                ],
              ),
            ),
          ),
          sliverList(
            child: Container(
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
                children: const [
                  Text(
                    'Hi User',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Good Morning!',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
          sliverList(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                //vertical: 20,
              ),
              margin: const EdgeInsets.only(
                top: 20,
              ),
              child: Column(
                children: const [
                  CalendarSection(),
                ],
              ),
            ),
          ),
          sliverList(
            child: Container(
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
          ),
          sliverList(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                //vertical: 20,
              ),
              margin: const EdgeInsets.only(top: 10, bottom: 10),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 150,
                    decoration: const BoxDecoration(
                      color: darkBlue,
                      borderRadius: BorderRadius.only(
                        topRight: const Radius.circular(20),
                        topLeft: const Radius.circular(20),
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
                        // Padding(
                        //   padding: const EdgeInsets.all(15),
                        //   child: Text(
                        //     "Seizure Activity",
                        //     style: TextStyle(
                        //         fontSize: 12, fontWeight: FontWeight.bold),
                        //   ),
                        // )
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
                          "Show full activity",
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RecordPage(),
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
                                  Icons.notes_rounded,
                                  color: darkBlue,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Show',
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
          ),
          sliverList(
            child: Container(
              padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Analytics',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.sensors_rounded,
                            color: Colors.grey,
                            size: 20,
                          ),
                          SizedBox(width: 5),
                          const Text(
                            'Update',
                            style: const TextStyle(
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
          ),
          sliverList(
              child: Container(
            height: 200,
            width: MediaQuery.of(context).size.width,
            //margin: const EdgeInsets.only(left: 20, right: 20, bottom:20),
            //padding: const EdgeInsets.all(20),
            child: ListView(
              shrinkWrap: true,
              primary: false,
              // physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.all(0),
              scrollDirection: Axis.horizontal,
              children: [
                Container(
                  width: 230,
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
                            "104",
                            style: TextStyle(
                              fontSize: 50,
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
                              color: const Color.fromARGB(255, 244, 86, 74),
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
                  width: 230,
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
                            "Nominal",
                            style: TextStyle(
                              fontSize: 30,
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
                          children: [
                            const Icon(
                              Icons.device_hub_rounded,
                              color: Colors.green,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
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
                Container(
                  width: 230,
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
                            "Erratic",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: darkGrey,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                            ),
                          ),
                          const Text(
                            "activity",
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
                          children: [
                            const Icon(
                              Icons.back_hand,
                              color: Colors.amber,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              "Electrodermal Activity",
                              style: const TextStyle(
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
          )),
          sliverList(
            child: Container(
              padding: const EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: 5,
              ),
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Activity',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      Row(
                        children: const [
                          Icon(
                            Icons.monitor_heart_outlined,
                            color: Colors.grey,
                            size: 20,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'See All',
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
          ),
          sliverList(
              child: ListView(
            shrinkWrap: true,
            primary: false,
            padding: const EdgeInsets.only(bottom: 60),
            children: const [
              RecentActivitiesAlert(),
            ],
          ))
        ],
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
}

class GridOption extends StatelessWidget {
  const GridOption({
    Key? key,
    required this.image,
    required this.title,
    this.isSelected = false,
    required this.onTap,
  }) : super(key: key);

  final String image;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(left: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 4.3,
              height: 85,
              decoration: BoxDecoration(
                color: isSelected ? darkBlue : lightBlue,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Image.asset(
                image,
                // fit: BoxFit.scaleDown,
                height: 50,
              ),
            ),
            Flexible(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
