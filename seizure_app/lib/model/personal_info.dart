import 'package:hive/hive.dart';
part 'personal_info.g.dart';

@HiveType(typeId: 0)
class PersonalInfo extends HiveObject {
  @HiveField(0)
  String? id;
  @HiveField(1)
  late String nickname;
  @HiveField(2)
  late String firstName;
  @HiveField(3)
  late String middleName;
  @HiveField(4)
  late String lastName;
  @HiveField(5)
  late String guardianName;
  @HiveField(6)
  late String email;
  @HiveField(7)
  late int contactNumber;
  @HiveField(8)
  late String address;
  PersonalInfo(
      {required this.nickname,
      required this.firstName,
      required this.middleName,
      required this.lastName,
      required this.guardianName,
      required this.email,
      required this.contactNumber,
      required this.address});
}
