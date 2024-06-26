// import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:seizure_app/constant.dart';
// import 'package:seizure_app/default_widget.dart';
// import 'package:seizure_app/device/blu_connection.dart';
// import 'package:seizure_app/device/sensor.dart';
// import 'package:seizure_app/device/widget.dart';
// import 'package:seizure_app/pages/profile_page.dart';
// import 'package:seizure_app/pages/records_page.dart';
// import 'package:seizure_app/widgets/barchart.dart';
// import 'package:seizure_app/widgets/calendar.dart';
// import 'package:seizure_app/widgets/recent_high.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   int pageIndex = 0;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       extendBody: true,
//       body: CustomScrollView(
//         slivers: [
//           sliverList(
//             child: Container(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 15,
//                 vertical: 10,
//               ),
//               margin: const EdgeInsets.only(
//                 top: 50,
//               ),
//             ),
//           ),
//           sliverList(
//             child: Container(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 20,
//                 //vertical: 20,
//               ),
//               //   margin: const EdgeInsets.only(
//               //     top: 60,
//               //   ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text(
//                         'Hi User',
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(10), // Image border
//                         child: SizedBox.fromSize(
//                           size: const Size.fromRadius(20), // Image radius
//                           child: Image.asset('images/samplePic.jpg', fit: BoxFit.cover)
//                         ),
//                       ),
//                     ],
//                   ),
//                   const Text(
//                     'Good Morning!',
//                     style: TextStyle(
//                       fontSize: 18,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           sliverList(
//             child: Container(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 20,
//                 //vertical: 20,
//               ),
//               margin: const EdgeInsets.only(
//                 top: 20,
//               ),
//               child: Column(
//                 children: const [
//                   CalendarSection(),
//                 ],
//               ),
//             ),
//           ),
//           sliverList(
//             child: Container(
//               padding: const EdgeInsets.only(left: 20, right: 20),
//               width: MediaQuery.of(context).size.width,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'Seizure Activity',
//                         style: Theme.of(context).textTheme.headline6,
//                       ),
//                     ],
//                   ), 
//                 ],
//               ),
//             ),
//           ),
//           sliverList(
//             child: Container(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 20,
//                 //vertical: 20,
//               ),
//               margin: const EdgeInsets.only(top: 10, bottom: 10),
//               child: Column(
//                 children: [
//                   Container(
//                     width: double.infinity,
//                     height: 170,
//                     decoration: const BoxDecoration(
//                       color: darkBlue,
//                       borderRadius: BorderRadius.only(
//                         topRight: Radius.circular(20),
//                         topLeft: Radius.circular(20),
//                       ),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black12,
//                           blurRadius: 15,
//                           spreadRadius: 2,
//                         ),
//                       ],
//                     ),
//                     child: Stack(
//                       children: [
//                         Container(
//                           width: double.infinity,
//                           padding: const EdgeInsets.only(
//                             top: 10,
//                           ),
//                           // padding: const EdgeInsets.only(
//                           //   left: 20,
//                           //   right: 20,
//                           //),
//                           //child: LineChart(activityData()),
//                           child: const BarChartSample1(),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     width: double.infinity,
//                     height: 50,
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     decoration: const BoxDecoration(
//                       color: darkBlue,
//                       borderRadius: BorderRadius.only(
//                         bottomRight: Radius.circular(20),
//                         bottomLeft: Radius.circular(20),
//                       ),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black12,
//                           blurRadius: 10,
//                           spreadRadius: 3,
//                           offset: Offset(0, 10),
//                         ),
//                       ],
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text(
//                           "Record a Seizure activity",
//                           style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white),
//                         ),
//                         ElevatedButton(
//                           style: ButtonStyle(
//                               backgroundColor:
//                                   MaterialStateProperty.all(Colors.white),
//                               shape: MaterialStateProperty.all<
//                                       RoundedRectangleBorder>(
//                                   RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(20.0),
//                               ))),
//                           onPressed: () {
//                             //check ata dito kung may connected sa device o wala, kapag wala
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => const SensorPage(),
//                               ),
//                             );
//                           },
//                           child: Padding(
//                             padding: const EdgeInsets.only(left: 7, right: 7),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: const <Widget>[
//                                 Icon(
//                                   Icons.record_voice_over_rounded,
//                                   color: darkBlue,
//                                 ),
//                                 SizedBox(
//                                   width: 10,
//                                 ),
//                                 Text(
//                                   'Record',
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w400,
//                                     color: darkBlue,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           sliverList(
//             child: Container(
//               padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
//               width: MediaQuery.of(context).size.width,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'Analytics',
//                         style: Theme.of(context).textTheme.headline6,
//                       ),
//                       Row(
//                         children: const[
//                            Icon(
//                             Icons.sensors_rounded,
//                             color: Colors.grey,
//                             size: 20,
//                           ),
//                           SizedBox(width: 5),
//                           Text(
//                             'Update',
//                             style: TextStyle(
//                               color: Colors.grey,
//                               fontSize: 14,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           sliverList(
//             child: SizedBox(
//             height: 200,
//             width: MediaQuery.of(context).size.width,
//             //margin: const EdgeInsets.only(left: 20, right: 20, bottom:20),
//             //padding: const EdgeInsets.all(20),
//             child: ListView(
//               shrinkWrap: true,
//               primary: false,
//               // physics: const ClampingScrollPhysics(),
//               padding: const EdgeInsets.all(0),
//               scrollDirection: Axis.horizontal,
//               children: [
//                 Container(
//                   width: 230,
//                   margin: const EdgeInsets.all(20),
//                   padding: const EdgeInsets.only(
//                       top: 15, bottom: 15, left: 20, right: 20),
//                   //height: 200,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(20),
//                     boxShadow: const [
//                       BoxShadow(
//                         color: Colors.black12,
//                         blurRadius: 15,
//                         spreadRadius: 2,
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "104",
//                             style: TextStyle(
//                               fontSize: 50,
//                               fontWeight: FontWeight.bold,
//                               color: darkGrey,
//                               fontFamily: GoogleFonts.poppins().fontFamily,
//                             ),
//                           ),
//                           const SizedBox(
//                             width: 5,
//                           ),
//                           Column(
//                             children: const [
//                               SizedBox(
//                                 height: 35,
//                               ),
//                               Text(
//                                 "bpm",
//                                 style: TextStyle(
//                                     fontSize: 15,
//                                     fontWeight: FontWeight.w400,
//                                     color: darkGrey),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                       const SizedBox(
//                         height: 20,
//                       ),
//                       Container(
//                         padding: const EdgeInsets.only(
//                             left: 10, right: 10, top: 3, bottom: 3),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(8),
//                           color: Colors.grey[200],
//                         ),
//                         child: Row(
//                           children: const [
//                             Icon(
//                               Icons.favorite_rounded,
//                               color: Color.fromARGB(255, 244, 86, 74),
//                             ),
//                             SizedBox(
//                               width: 10,
//                             ),
//                             Text(
//                               "Heart Rate",
//                               style: TextStyle(
//                                 color: Colors.grey,
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//                 Container(
//                   width: 230,
//                   margin: const EdgeInsets.only(top: 20, bottom: 20, right: 20),
//                   padding: const EdgeInsets.only(
//                       top: 15, bottom: 15, left: 20, right: 20),
//                   //height: 200,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(20),
//                     boxShadow: const [
//                       BoxShadow(
//                         color: Colors.black12,
//                         blurRadius: 15,
//                         spreadRadius: 2,
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const SizedBox(
//                         height: 5,
//                       ),
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Nominal",
//                             style: TextStyle(
//                               fontSize: 30,
//                               fontWeight: FontWeight.bold,
//                               color: darkGrey,
//                               fontFamily: GoogleFonts.poppins().fontFamily,
//                             ),
//                           ),
//                           const Text(
//                             "movement",
//                             style: TextStyle(
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w400,
//                                 color: darkGrey),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(
//                         height: 28,
//                       ),
//                       Container(
//                         padding: const EdgeInsets.only(
//                             left: 10, right: 10, top: 3, bottom: 3),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(8),
//                           color: Colors.grey[200],
//                         ),
//                         child: Row(
//                           children: const [
//                              Icon(
//                               Icons.device_hub_rounded,
//                               color: Colors.green,
//                             ),
//                             SizedBox(
//                               width: 10,
//                             ),
//                             Text(
//                               "Accelerometer",
//                               style: TextStyle(
//                                 color: Colors.grey,
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//                 Container(
//                   width: 230,
//                   margin: const EdgeInsets.only(top: 20, bottom: 20, right: 20),
//                   padding: const EdgeInsets.only(
//                       top: 15, bottom: 15, left: 20, right: 20),
//                   //height: 200,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(20),
//                     boxShadow: const [
//                       BoxShadow(
//                         color: Colors.black12,
//                         blurRadius: 15,
//                         spreadRadius: 2,
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const SizedBox(
//                         height: 5,
//                       ),
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Erratic",
//                             style: TextStyle(
//                               fontSize: 30,
//                               fontWeight: FontWeight.bold,
//                               color: darkGrey,
//                               fontFamily: GoogleFonts.poppins().fontFamily,
//                             ),
//                           ),
//                           const Text(
//                             "activity",
//                             style: TextStyle(
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w400,
//                                 color: darkGrey),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(
//                         height: 28,
//                       ),
//                       Container(
//                         padding: const EdgeInsets.only(
//                             left: 10, right: 10, top: 3, bottom: 3),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(8),
//                           color: Colors.grey[200],
//                         ),
//                         child: Row(
//                           children: const [
//                             Icon(
//                               Icons.back_hand,
//                               color: Colors.amber,
//                             ),
//                             SizedBox(
//                               width: 10,
//                             ),
//                             Text(
//                               "Electrodermal Activity",
//                               style: TextStyle(
//                                 color: Colors.grey,
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           ),
//           sliverList(
//             child: Container(
//               padding: const EdgeInsets.only(
//                 //top: 20,
//                 left: 20,
//                 right: 20,
//                 bottom: 5,
//               ),
//               width: MediaQuery.of(context).size.width,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'Recent Activity',
//                         style: Theme.of(context).textTheme.headline6,
//                       ),
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => const RecordPage(),
//                             ),
//                           );
//                         },
//                         child: Row(
//                           children: const [
//                             Icon(
//                               Icons.monitor_heart_outlined,
//                               color: Colors.grey,
//                               size: 20,
//                             ),
//                             SizedBox(width: 5),
//                             Text(
//                               'See All',
//                               style: TextStyle(
//                                 color: Colors.grey,
//                                 fontSize: 14,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           sliverList(
//               child: ListView(
//             shrinkWrap: true,
//             primary: false,
//             padding: const EdgeInsets.only(bottom: 60),
//             children: const [
//               RecentActivitiesAlert(),
//             ],
//           ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: FloatingNavbar(
//         onTap: (int val) => setState(() {
//           pageIndex = val;
//           //print('selected index $val');
//           if (pageIndex == 0) {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => const HomePage(),
//               ),
//             );
//           } else if (pageIndex == 1) {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => const RecordPage(),
//               ),
//             );
//           } else if (pageIndex == 2) {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => const ProfilePage(),
//               ),
//             );
//           } else {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => const HomePage(),
//               ),
//             );
//           }
//         }),
//         currentIndex: pageIndex,
//         items: [
//           FloatingNavbarItem(icon: Icons.home),
//           FloatingNavbarItem(icon: Icons.bar_chart),
//           FloatingNavbarItem(icon: Icons.person),
//         ],
//         selectedItemColor: lightBlue,
//         unselectedItemColor: Colors.white,
//         backgroundColor: darkBlue,
//         itemBorderRadius: 15,
//         borderRadius: 20,
//         iconSize: 20,
//       ),
//     );
//   }
// }


