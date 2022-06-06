import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:seizure_app/constant.dart';

DateTime now = DateTime.now();
String formattedDate = DateFormat('EEE d MMM kk:mm:ss').format(now);

class RecentActivitiesAlert extends StatelessWidget {
  const RecentActivitiesAlert({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
        boxShadow: const[
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
                  color: red,
                  borderRadius: BorderRadius.circular(15),
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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   const Text(
                          'High Alert',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                      formattedDate,
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 9,),
                  Container(height: 2,
                    width: MediaQuery.of(context).size.width - 140,
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                      border: Border(
                        top: BorderSide(
                          color: Color.fromARGB(255, 240, 240, 240),
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 9,),
          Row(
            children: const[
              Icon(
                Icons.favorite_rounded,
                color: Color.fromARGB(255, 244, 86, 74),
                size: 20,
              ),
              SizedBox(width: 10,),
              Text(
                "104 bpm",
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
              SizedBox(width: 10,),
              Text(
                "Nominal",
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
              SizedBox(width: 10,),
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
    );
  }
}