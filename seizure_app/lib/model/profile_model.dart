import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class Profile extends HiveObject {
  @HiveField(0)
  String? id;
  @HiveField(1)
  late int firstName;
  @HiveField(2)
  late String middleName;
  @HiveField(3)
  late String lastName;
  @HiveField(4)
  late String guardianName;
  @HiveField(5)
  late double contactNumber;
  @HiveField(6)
  late String address;
  Profile(
      {required this.firstName,
      required this.middleName,
      required this.lastName,
      required this.guardianName,
      required this.contactNumber,
      required this.address});
}
