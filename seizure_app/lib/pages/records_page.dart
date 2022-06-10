import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:seizure_app/constant.dart';
import 'package:seizure_app/pages/home_page.dart';
import 'package:seizure_app/pages/profile_page.dart';
import 'package:seizure_app/widgets/barchart.dart';
import 'package:seizure_app/widgets/recent_normal.dart';
import 'package:seizure_app/widgets/stat_card.dart';

class RecordPage extends StatefulWidget {
  const RecordPage({Key? key}) : super(key: key);

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  int pageIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,

      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(
              top: 60,
              left: 20,
              right: 20,
            ),
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Icon(
                      Icons.bar_chart_rounded,
                      color: darkBlue,
                      size: 28,
                    ),
                    Text(
                      'Records',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: darkBlue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            margin: const EdgeInsets.only(top: 10, bottom: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: double.infinity,
                  height: 220,
                  decoration: BoxDecoration(
                    color: darkBlue,
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
                      ProjectStatisticsCard(
                        name: 'Seizures Detected',
                        descriptions: 'Database Analytics',
                        count: 4,
                        // progress: 1,
                        // progressString: '4',
                        color: darkBlue,
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(
                          bottom: 5,
                        ),
                        height: 160,
                        child: const BarChartSample1(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height - 390,
            child: ListView.builder(
                itemCount: 10,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                primary: false,
                padding: const EdgeInsets.only(bottom: 0),
                itemBuilder: (BuildContext context, int index) {
                  return const RecentActivitiesNormal();
                }
                // children: const [
                //   RecentActivitiesNormal(),
                //   RecentActivitiesAlert(),
                //   RecentActivitiesAlert(),
                //   RecentActivitiesAlert(),
                //   RecentActivitiesAlert(),
                //   RecentActivitiesAlert(),
                // ],
                ),
          ),
        ],
      ),
      bottomNavigationBar: FloatingNavbar(
        onTap: (int val) => setState(() {
          pageIndex = val;
          //print('selected index $val');
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
