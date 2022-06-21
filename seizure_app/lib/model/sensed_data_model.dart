import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class PersonalInfo extends HiveObject {
  @HiveField(0)
  String? id;
  @HiveField(1)
  late String date;
  @HiveField(2)
  late String time;
  @HiveField(3)
  late bool isHeistend;
  @HiveField(4)
  late String bpm;
  @HiveField(5)
  late String gsr;
  @HiveField(6)
  late String accelerometer;
  PersonalInfo(
      {required this.date,
      required this.time,
      required this.isHeistend,
      required this.bpm,
      required this.gsr,
      required this.accelerometer});
}
