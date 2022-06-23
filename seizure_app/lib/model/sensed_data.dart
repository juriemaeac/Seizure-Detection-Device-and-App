import 'package:hive/hive.dart';
part 'sensed_data.g.dart';

@HiveType(typeId: 1)
class SensedData extends HiveObject {
  @HiveField(0)
  String? id;
  @HiveField(1)
  late String date;
  @HiveField(2)
  late String time;
  @HiveField(3)
  late var isHeistend;
  @HiveField(4)
  late String bpm;
  @HiveField(5)
  late String gsr;
  @HiveField(6)
  late String accelerometer;
  SensedData(
      {required this.date,
      required this.time,
      required this.isHeistend,
      required this.bpm,
      required this.gsr,
      required this.accelerometer});
}
