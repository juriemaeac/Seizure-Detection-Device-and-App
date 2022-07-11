import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:seizure_app/boxes/boxData.dart';
import 'package:seizure_app/model/sensed_data.dart';
import 'package:intl/intl.dart';

class AlertPage extends StatefulWidget {
  const AlertPage({Key? key}) : super(key: key);

  @override
  State<AlertPage> createState() => _AlertPageState();
}

class _AlertPageState extends State<AlertPage> {
  void addData() {
    DateTime now = DateTime.now();
    String formattedTime = DateFormat.Hm().format(now);
    String recordDate = DateFormat("MMMM dd, yyyy").format(DateTime.now());

    Box<SensedData> dataBox = Hive.box<SensedData>(HiveBoxesData.data);
    dataBox.add(SensedData(
      date: recordDate,
      time: formattedTime,
      isHeightened: 'False',
      bpm: 'Erratic',
      gsr: 'Erratic',
      accelerometer: 'Erratic',
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 70,
          ),
          Container(
            padding: EdgeInsets.all(20),
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 2.6,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            margin: EdgeInsets.all(40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.white,
                  size: 55,
                ),
                Text(
                  "Warning",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 80,
                ),
                Text(
                  "Possible Seizure",
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
                Text(
                  "Episode Detected",
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 80,
                ),
                ElevatedButton(
                  onPressed: () {
                    addData();
                    Navigator.of(context).pop();
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
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "False Alarm?",
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ),
                //SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
//     return Container(
//         padding: EdgeInsets.only(top: 15),
//         height: MediaQuery.of(context).size.height / 3,
//         width: MediaQuery.of(context).size.width,
//         decoration: ,
//         child: Column(
//           //mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: <Widget>[
//             Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Icon(
//                   Icons.warning_amber_rounded,
//                   color: Colors.white,
//                   size: 65,
//                 ),
//                 Text(
//                   "Warning",
//                   style: TextStyle(
//                       fontSize: 30,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white),
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 Text(
//                   "Possible Seizure",
//                   style: TextStyle(fontSize: 15, color: Colors.white),
//                 ),
//                 Text(
//                   "Episode Detected",
//                   style: TextStyle(fontSize: 15, color: Colors.white),
//                 ),
//                 SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: () {
//                     addData();
//                     Navigator.of(context).pop();
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 20.0, right: 20.0),
//                     child: Text(
//                       "Confirm",
//                       style: TextStyle(fontSize: 15, color: Colors.red),
//                     ),
//                   ),
//                   style: ButtonStyle(
//                     backgroundColor: MaterialStateProperty.all(Colors.white),
//                     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                       RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20.0),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: Text(
//                     "False Alarm?",
//                     style: TextStyle(fontSize: 15, color: Colors.white),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//               ],
//             )
//           ],
//         ),
//       );
  }
}
