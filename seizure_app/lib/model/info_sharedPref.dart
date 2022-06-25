var imagePath;
String? textNickname;
String? textFirstName;
String? textMiddleName;
String? textLastName;
String? textGuardianName;
String? textEmail;
String? textNumber;
String? textAddress;

class InfoPref {
  var imagePath;
  String userNickname;
  String userFirstName;
  String userMiddleName;
  String userLastName;
  String userGuardianName;
  String userEmail;
  String userNumber;
  String userAddress;

  InfoPref(
      {this.imagePath,
      required this.userNickname,
      required this.userFirstName,
      required this.userMiddleName,
      required this.userLastName,
      required this.userGuardianName,
      required this.userEmail,
      required this.userNumber,
      required this.userAddress});

  Map<String, dynamic> toJson() {
    return {
      'imagePath': imagePath,
      'userNickname': userNickname,
      'userFirstname': userFirstName,
      'userMiddleName': userMiddleName,
      'userLastName': userLastName,
      'userGuadianName': userGuardianName,
      'userEmail': userEmail,
      'userNumber': userNumber,
      'userAddress': userAddress,
    };
  }

  InfoPref.fromJson(Map<String, dynamic> json)
      : imagePath = json['imagePath'],
        userNickname = json['userNickname'],
        userFirstName = json['userFirstName'],
        userMiddleName = json['userMiddleName'],
        userLastName = json['userLastName'],
        userGuardianName = json['userGuardianName'],
        userEmail = json['userEmail'],
        userNumber = json['userNumber'],
        userAddress = json['userAddress'];
}
