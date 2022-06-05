import 'dart:ffi';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:seizure_app/constant.dart';
import 'package:seizure_app/default_widget.dart';
import 'package:seizure_app/widgets/calendar.dart';
import 'package:seizure_app/widgets/calendar_item.dart';
import 'package:seizure_app/widgets/graph.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
              padding: const EdgeInsets.only(top:10, left: 20, right: 20),
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
                      // Text(
                      //   'See All',
                      //   style: Theme.of(context).textTheme.headline6!.copyWith(
                      //         color: Colors.grey,
                      //       ),
                      // ),
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
                margin: const EdgeInsets.only(
                  top: 10,
                  bottom: 10
                ),
              child: Column(
                children: [
                  Container(
                width: double.infinity,
                height: 130,
                decoration: BoxDecoration(
                    color: darkBlue,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                    ),
                    boxShadow: const [
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
                      child: LineChart(activityData()),
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
                decoration: BoxDecoration(
                    color: darkBlue,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                    boxShadow: const [
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
                    Text(
                        "Show full activity",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.white),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),))),
                      onPressed: () {},
                      child: Padding(
                        padding: const EdgeInsets.only(left: 7, right:7),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const <Widget>[
                            Icon(
                              Icons.notes_rounded,
                              color:darkBlue,
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
          // sliverList(
          //   child: Container(
          //     // padding: const EdgeInsets.symmetric(
          //     //   horizontal: 20,
          //     //   vertical: 20,
          //     // ),
          //     margin: const EdgeInsets.only(
          //       top: 10,
          //       left: 20,
          //       right: 20,
          //       bottom: 10,
          //     ),
          //     height: 300,
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.start,
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Text(
          //           "Analytics",
          //           style: TextStyle(
          //                   fontSize: 18, fontWeight: FontWeight.bold),
          //                   textAlign: TextAlign.left,
          //           ),
          //         SizedBox(height: 10,),
          //         Row(
          //           crossAxisAlignment: CrossAxisAlignment.center,
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             Column(
          //               children: [
          //                 Container(
          //                   width: (MediaQuery.of(context).size.width * 0.85)/2,
          //                   height: 120,
          //                   decoration: BoxDecoration(
          //                       color: thirdColor,
          //                       borderRadius: BorderRadius.circular(20),
          //                       boxShadow: const [
          //                         BoxShadow(
          //                           color: Colors.black12,
          //                           blurRadius: 10,
          //                           spreadRadius: 3,
          //                           offset: Offset(0, 10),
          //                         ),
          //                       ],
          //                   ),
          //                   child: Column(
          //                     mainAxisAlignment: MainAxisAlignment.center,
          //                     crossAxisAlignment: CrossAxisAlignment.center,
          //                     children: [
          //                       Row(
          //                         mainAxisAlignment: MainAxisAlignment.center,
          //                         crossAxisAlignment: CrossAxisAlignment.center,
          //                         children: [
          //                           Column(
          //                             children: [
          //                               Icon(
          //                                 Icons.favorite_border_rounded,
          //                                 color: Colors.white,
          //                                 size: 40,
          //                               ),
          //                             ],
          //                           ),
          //                           SizedBox(
          //                             width: 10,
          //                           ),
          //                           Column(
          //                             children: [
          //                               Row(
          //                                 children: [
          //                                   Text(
          //                                     "82",
          //                                     style: TextStyle(
          //                                       fontSize: 30,
          //                                       fontWeight: FontWeight.w400,
          //                                       color: Colors.white,
          //                                     ),
          //                                   ),
          //                                   SizedBox(
          //                                     width: 5,
          //                                   ),
          //                                   Column(
          //                                     children: [
          //                                       SizedBox(height: 13,),
          //                                       Text(
          //                                         "bpm",
          //                                         style: TextStyle(
          //                                           fontSize: 12,
          //                                           fontWeight: FontWeight.w400,
          //                                           color: Colors.white,
          //                                         ),
          //                                       ),
          //                                     ],
          //                                   ),
          //                                 ],
          //                               ),
          //                             ],
          //                           ),
          //                         ],
          //                       ),
          //                       const Text(
          //                             "Heart Rate",
          //                             style: TextStyle(
          //                               fontSize: 15,
          //                               fontWeight: FontWeight.w400,
          //                               color: Colors.white,
          //                             ),
          //                           ),
          //                     ]),
          //                 )
          //               ],
          //             ),
          //             Column(
          //               children: [
          //                 Container(
          //                   width: (MediaQuery.of(context).size.width * 0.85)/2,
          //                   height: 120,
          //                   decoration: BoxDecoration(
          //                       color: thirdColor,
          //                       borderRadius: BorderRadius.circular(20),
          //                       boxShadow: const [
          //                         BoxShadow(
          //                           color: Colors.black12,
          //                           blurRadius: 10,
          //                           spreadRadius: 3,
          //                           offset: Offset(0, 10),
          //                         ),
                                  
          //                       ],
          //                   ),
          //                   child: Column(
          //                     mainAxisAlignment: MainAxisAlignment.center,
          //                     crossAxisAlignment: CrossAxisAlignment.center,
          //                     children: [
          //                       Row(
          //                         mainAxisAlignment: MainAxisAlignment.center,
          //                         crossAxisAlignment: CrossAxisAlignment.center,
          //                         children: [
          //                           Column(
          //                             children: [
          //                               Icon(
          //                                 Icons.device_hub_rounded,
          //                                 color: Colors.white,
          //                                 size: 40,
          //                               ),
          //                             ],
          //                           ),
          //                           SizedBox(
          //                             width: 10,
          //                           ),
          //                           Column(
          //                             children: [
          //                               Row(
          //                                 children: [
          //                                   Text(
          //                                     "3.5",
          //                                     style: TextStyle(
          //                                       fontSize: 30,
          //                                       fontWeight: FontWeight.w400,
          //                                       color: Colors.white,
          //                                     ),
          //                                   ),
          //                                   SizedBox(
          //                                     width: 5,
          //                                   ),
          //                                   Column(
          //                                     children: [
          //                                       SizedBox(height: 13,),
          //                                       Text(
          //                                         "Hz",
          //                                         style: TextStyle(
          //                                           fontSize: 12,
          //                                           fontWeight: FontWeight.w400,
          //                                           color: Colors.white,
          //                                         ),
          //                                       ),
          //                                     ],
          //                                   ),
          //                                 ],
          //                               ),
          //                             ],
          //                           ),
          //                         ],
          //                       ),
          //                       const Text(
          //                             "Accelerometry",
          //                             style: TextStyle(
          //                               fontSize: 15,
          //                               fontWeight: FontWeight.w400,
          //                               color: Colors.white,
          //                             ),
          //                           ),
          //                     ]),
          //                 )
          //               ],
          //             ),
          //           ],
          //         ),
          //         const SizedBox(height: 20),
          //         Row(
          //           crossAxisAlignment: CrossAxisAlignment.center,
          //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             Column(
          //               children: [
          //                 Container(
          //                   width: (MediaQuery.of(context).size.width * 0.85)/2,
          //                   height: 120,
          //                   decoration: BoxDecoration(
          //                       color: thirdColor,
          //                       borderRadius: BorderRadius.circular(20),
          //                       boxShadow: const [
          //                         BoxShadow(
          //                           color: Colors.black12,
          //                           blurRadius: 10,
          //                           spreadRadius: 3,
          //                           offset: Offset(0, 10),
          //                         ),
          //                       ],
          //                   ),
          //                   child: Column(
          //                     mainAxisAlignment: MainAxisAlignment.center,
          //                     crossAxisAlignment: CrossAxisAlignment.center,
          //                     children: [
          //                       Row(
          //                         mainAxisAlignment: MainAxisAlignment.center,
          //                         crossAxisAlignment: CrossAxisAlignment.center,
          //                         children: [
          //                           Column(
          //                             children: [
          //                               Icon(
          //                                 Icons.back_hand,
          //                                 color: Colors.white,
          //                                 size: 40,
          //                               ),
          //                             ],
          //                           ),
          //                           SizedBox(
          //                             width: 10,
          //                           ),
          //                           Column(
          //                             children: [
          //                               Row(
          //                                 children: [
          //                                   Text(
          //                                     "2.0",
          //                                     style: TextStyle(
          //                                       fontSize: 30,
          //                                       fontWeight: FontWeight.w400,
          //                                       color: Colors.white,
          //                                     ),
          //                                   ),
          //                                   SizedBox(
          //                                     width: 5,
          //                                   ),
          //                                   Column(
          //                                     children: [
          //                                       SizedBox(height: 13,),
          //                                       Text(
          //                                         "μS",
          //                                         style: TextStyle(
          //                                           fontSize: 12,
          //                                           fontWeight: FontWeight.w400,
          //                                           color: Colors.white,
          //                                         ),
          //                                       ),
          //                                     ],
          //                                   ),
          //                                 ],
          //                               ),
          //                             ],
          //                           ),
          //                         ],
          //                       ),
          //                       const Text(
          //                         "Electrodermal",
          //                         style: TextStyle(
          //                           fontSize: 15,
          //                           fontWeight: FontWeight.w400,
          //                           color: Colors.white,
          //                         ),
          //                       ),
          //                     ]),
          //                 )
          //               ],
          //             ),
          //             Column(
          //               children: [
          //                 Container(
          //                   width: (MediaQuery.of(context).size.width * 0.85)/2,
          //                   height: 120,
          //                   decoration: BoxDecoration(
          //                       color: thirdColor,
          //                       borderRadius: BorderRadius.circular(20),
          //                       boxShadow: const [
          //                         BoxShadow(
          //                           color: Colors.black12,
          //                           blurRadius: 10,
          //                           spreadRadius: 3,
          //                           offset: Offset(0, 10),
          //                         ),
          //                       ],
          //                   ),
          //                   child: Column(
          //                     mainAxisAlignment: MainAxisAlignment.center,
          //                     crossAxisAlignment: CrossAxisAlignment.center,
          //                     children: [
          //                       Row(
          //                         mainAxisAlignment: MainAxisAlignment.center,
          //                         crossAxisAlignment: CrossAxisAlignment.center,
          //                         children: [
          //                           Column(
          //                             children: [
          //                               Icon(
          //                                 Icons.analytics,
          //                                 color: Colors.white,
          //                                 size: 40,
          //                               ),
          //                             ],
          //                           ),
          //                           SizedBox(
          //                             width: 10,
          //                           ),
          //                           Column(
          //                             children: [
          //                               Text(
          //                                 "Normal",
          //                                 style: TextStyle(
          //                                   fontSize: 20,
          //                                   fontWeight: FontWeight.w400,
          //                                   color: Colors.white,
          //                                 ),
          //                               ),
          //                             ],
          //                           ),
          //                         ],
          //                       ),
          //                       const Text(
          //                         "Device Sensitivity",
          //                         style: TextStyle(
          //                           fontSize: 15,
          //                           fontWeight: FontWeight.w400,
          //                           color: Colors.white,
          //                         ),
          //                       ),
          //                     ]),
          //                 )
          //               ],
          //             ),
          //           ],
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          
          sliverList(
            child: Container(
              padding: const EdgeInsets.only(top:10, left: 20, right: 20),
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
                  padding: const EdgeInsets.only(top:15, bottom:15, left:20, right:20),
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
                  child:Column(
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
                          SizedBox(width: 5,),
                          Column(
                            children: const[
                              SizedBox(height: 35,
                              ),
                              Text(
                                "bpm",
                                style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: darkGrey
                            ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20,),
                      Container(
                        padding: const EdgeInsets.only(left:10, right: 10, top:3, bottom:3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey[200],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.favorite_rounded,
                              color: Color.fromARGB(255, 244, 86, 74),
                            ),
                            SizedBox(width: 10,),
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
                  margin: const EdgeInsets.only(top:20, bottom:20, right:20),
                  padding: const EdgeInsets.only(top:15, bottom:15, left:20, right:20),
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
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5,),
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
                          Text(
                            "movement",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: darkGrey
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 28,),
                      Container(
                        padding: const EdgeInsets.only(left:10, right: 10, top:3, bottom:3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey[200],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.device_hub_rounded,
                              color: Colors.green,
                            ),
                            SizedBox(width: 10,),
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
                Container(
                  width: 230,
                  margin: const EdgeInsets.only(top:20, bottom:20, right:20),
                  padding: const EdgeInsets.only(top:15, bottom:15, left:20, right:20),
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
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5,),
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
                          Text(
                            "activity",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: darkGrey
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 28,),
                      Container(
                        padding: const EdgeInsets.only(left:10, right: 10, top:3, bottom:3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey[200],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.back_hand,
                              color: Colors.amber,
                            ),
                            SizedBox(width: 10,),
                            Text(
                              "Electrodermal Activity",
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
                // GridOption(
                //   image: 'images/vet.png',
                //   title: 'Vet',
                //   isSelected: true,
                //   onTap: () {},
                // ),
                // GridOption(
                //   image: 'images/Grooming.png',
                //   title: 'Grooming',
                //   isSelected: false,
                //   onTap: () {},
                // ),
                // GridOption(
                //   image: 'images/food.png',
                //   title: 'Food',
                //   isSelected: false,
                //   onTap: () {},
                // ),
                // GridOption(
                //   image: 'images/playing.png',
                //   title: 'Playing',
                //   isSelected: false,
                //   onTap: () {},
                // ),
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
                        'Recent Activities',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      Text(
                        'See All',
                        style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
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
            padding: const EdgeInsets.all(0),
            children: const [
              DrListContainer(),
              DrListContainer(),
              DrListContainer(),
              DrListContainer(),
              DrListContainer(),
            ],
          ))
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: darkBlue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          print('selected index $index');
        },
      ),
    );
  }
}

class DrListContainer extends StatelessWidget {
  const DrListContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: darkBlue,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            spreadRadius: 1,
            // offset: const Offset(
            //   0,
            //   10,
            // ),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: darkBlue,
              borderRadius: BorderRadius.circular(20),
              image: const DecorationImage(
                image: AssetImage('images/dr.png'), // change in future
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'drh. Ariyo Hartono',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'General Veterinary',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$125.000',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      Text(
                        '2.1 KM',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 40,
            child: Container(
              decoration: const BoxDecoration(
                color: darkBlue,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.chevron_right,
                  color: Colors.white,
                ),
                onPressed: () {
                  print('on click');
                },
              ),
            ),
          ),
        ],
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
