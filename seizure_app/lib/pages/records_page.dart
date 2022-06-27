import 'package:flutter/material.dart';
//import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:seizure_app/constant.dart';
import 'package:seizure_app/widgets/stat_card.dart';

import '../boxes/boxData.dart';
import '../model/sensed_data.dart';

class RecordPage extends StatefulWidget {
  const RecordPage({Key? key}) : super(key: key);

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  int pageIndex = 1;
  int count = 0;
  @override
  void initState() {
    super.initState();
    Hive.openBox<SensedData>(HiveBoxesData.data);
  }

  var recordsCount = Hive.box<SensedData>(HiveBoxesData.data).length;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(
              top: 50,
              // left: 20,
              // right: 20,
            ),
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20),
                  child: Row(
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
                  height: 210,
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
                        count: recordsCount,
                        // progress: 1,
                        // progressString: '4',
                        color: darkBlue,
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
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
                        width: double.infinity,
                        height: 140,
                        child: Image.asset(
                          'images/records.png',
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ValueListenableBuilder(
              valueListenable:
                  Hive.box<SensedData>(HiveBoxesData.data).listenable(),
              builder: (context, Box<SensedData> box, _) {
                if (box.values.isEmpty) {
                  return Center(
                    child: Container(
                        padding: const EdgeInsets.only(top: 120),
                        child: const Text("Records list is empty")),
                  );
                }
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height - 390,
                    child: ListView.builder(
                        itemCount: box.values.length,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        primary: false,
                        padding: const EdgeInsets.only(bottom: 0),
                        itemBuilder: (BuildContext context, int index) {
                          int reverseIndex = box.length - 1 - index;
                          final SensedData? res = box.getAt(reverseIndex);
                          //return const RecentActivitiesNormal();
                          return ListTile(
                            title: Container(
                              margin: const EdgeInsets.symmetric(
                                //horizontal: 10,
                                vertical: 10,
                              ),
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 15,
                                    spreadRadius: 3,
                                    // offset: const Offset(
                                    //   0,
                                    //   10,
                                    // ),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: const Icon(
                                          Icons.warning_amber_rounded,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Seizure Episode',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            '${res!.date} - ${res.time}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 9,
                                          ),
                                          Container(
                                            height: 2,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                140,
                                            decoration: const BoxDecoration(
                                              color: Colors.transparent,
                                              border: Border(
                                                top: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 240, 240, 240),
                                                  width: 1,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 9,
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.favorite_rounded,
                                                color: Color.fromARGB(
                                                    255, 244, 86, 74),
                                                size: 20,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                "${res.bpm} bpm",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Icon(
                                                Icons.device_hub_rounded,
                                                color: Colors.green,
                                                size: 20,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                "Erratic",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Icon(
                                                Icons.back_hand,
                                                color: Colors.amber,
                                                size: 20,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                "Erratic",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
