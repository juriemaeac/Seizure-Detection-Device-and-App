import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:seizure_app/boxes/boxData.dart';
import 'package:seizure_app/constant.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seizure_app/pages/profile_page.dart';

import '../boxes/boxInfo.dart';
import '../model/personal_info.dart';
import '../model/sensed_data.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({
    Key? key,
  }) : super(key: key);
  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    Hive.openBox<PersonalInfo>(HiveBoxesInfo.info);
  }

  late String nickname;
  late String firstName;
  late String middleName;
  late String lastName;
  late String guardianName;
  late String email;
  late String address;
  late int number;

  late PickedFile _imageFile;
  static ImagePicker _picker = ImagePicker();
  var imagePath;

  validated() {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      _onFormSubmit();
    } else {
      return;
    }
  }

  @override
  Widget _buildSheet() {
    return Container(
      height: 120.0,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: Colors.white,
        // borderRadius: BorderRadius.only( topRight: Radius.circular(20),
        // topLeft: Radius.circular(20)),
      ),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 15),
          const Text("Choose Profile Image",
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: darkGrey)),
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: lightGrey,
            ),
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextButton.icon(
                    icon: const Icon(Icons.camera_alt_rounded, color: darkBlue),
                    onPressed: () {
                      takePhoto(ImageSource.camera);
                    },
                    label: const Text('Camera',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w100,
                            color: darkBlue)),
                  ),
                  const SizedBox(width: 30),
                  const VerticalDivider(
                    color: Color.fromARGB(255, 240, 240, 240),
                    thickness: 2,
                  ),
                  const SizedBox(width: 30),
                  TextButton.icon(
                    icon: const Icon(Icons.image_rounded, color: darkBlue),
                    onPressed: () {
                      takePhoto(ImageSource.gallery);
                    },
                    label: const Text('Gallery',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w100,
                            color: darkBlue)),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(source: source);
    setState(() {
      _imageFile = pickedFile!;
      imagePath = _imageFile.path;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(
                    top: 20,
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new_rounded),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          const Text(
                            'Edit Profile',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(
                            width: 40,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Container(
                        width: (MediaQuery.of(context).size.width),
                        //padding: EdgeInsets.all(20.0),
                        margin: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: Stack(
                                    children: <Widget>[
                                      Positioned(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: darkBlue,
                                            //shape: BoxShape.circle,
                                            border: Border.all(
                                              width: 8,
                                              color: darkBlue,
                                            ),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                20), // Image border
                                            child: SizedBox.fromSize(
                                              size: const Size.fromRadius(
                                                  100), // Image radius
                                              child: imagePath == null
                                                  ? Image.asset(
                                                      'images/samplePic.jpg',
                                                      fit: BoxFit.cover)
                                                  : Image.asset(
                                                      'images/pet.png',
                                                      fit: BoxFit
                                                          .cover), //FileImage(File(imagePath)),
                                            ),
                                          ),
                                          // CircleAvatar(
                                          //   radius: 60.0,
                                          //   backgroundImage: imagePath == null
                                          //       ? const AssetImage('images/samplePic.jpg')
                                          //       : null,//FileImage(File(imagePath)),
                                          // ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 15,
                                        right: 15,
                                        child: Container(
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                              //shape: BoxShape.circle,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: darkBlue.withOpacity(.5),
                                            ),
                                            child: InkWell(
                                              onTap: () {
                                                showModalBottomSheet(
                                                  context: context,
                                                  builder: ((builder) =>
                                                      _buildSheet()),
                                                );
                                              },
                                              child: const Icon(
                                                Icons.edit,
                                                color: Colors.white,
                                              ),
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20.0),
                            const SizedBox(height: 20),
                            Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    blurRadius: 15,
                                    spreadRadius: 3,
                                  ),
                                ],
                              ),
                              child: TextFormField(
                                  style: const TextStyle(
                                      color: darkGrey, fontSize: 16),
                                  cursorColor: darkGrey,
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    border: InputBorder.none,
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
                                      borderSide: BorderSide(
                                          color: Colors.transparent, width: 2),
                                    ),
                                    labelText: 'NickName',
                                    labelStyle: TextStyle(
                                      color: darkGrey,
                                      fontSize: 14,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.person,
                                      color: darkGrey,
                                    ),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      nickname = value;
                                    });
                                  }),
                            ),
                            const SizedBox(height: 15),
                            Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    blurRadius: 15,
                                    spreadRadius: 3,
                                  ),
                                ],
                              ),
                              child: TextFormField(
                                  style: const TextStyle(
                                      color: darkGrey, fontSize: 16),
                                  cursorColor: darkGrey,
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    border: InputBorder.none,
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
                                      borderSide: BorderSide(
                                          color: Colors.transparent, width: 2),
                                    ),
                                    labelText: 'First Name',
                                    labelStyle: TextStyle(
                                      color: darkGrey,
                                      fontSize: 14,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.person,
                                      color: darkGrey,
                                    ),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      firstName = value;
                                    });
                                  }),
                            ),
                            const SizedBox(height: 15),
                            Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    blurRadius: 15,
                                    spreadRadius: 3,
                                  ),
                                ],
                              ),
                              child: TextFormField(
                                  style: const TextStyle(
                                      color: darkGrey, fontSize: 16),
                                  cursorColor: darkGrey,
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    border: InputBorder.none,
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
                                      borderSide: BorderSide(
                                          color: Colors.transparent, width: 2),
                                    ),
                                    labelText: 'Middle Name',
                                    labelStyle: TextStyle(
                                      color: darkGrey,
                                      fontSize: 14,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.person,
                                      color: darkGrey,
                                    ),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      middleName = value;
                                    });
                                  }),
                            ),
                            const SizedBox(height: 15),
                            Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    blurRadius: 15,
                                    spreadRadius: 3,
                                  ),
                                ],
                              ),
                              child: TextFormField(
                                  style: const TextStyle(
                                      color: darkGrey, fontSize: 16),
                                  cursorColor: darkGrey,
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    border: InputBorder.none,
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
                                      borderSide: BorderSide(
                                          color: Colors.transparent, width: 2),
                                    ),
                                    labelText: 'Last Name',
                                    labelStyle: TextStyle(
                                      color: darkGrey,
                                      fontSize: 14,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.person,
                                      color: darkGrey,
                                    ),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      lastName = value;
                                    });
                                  }),
                            ),
                            const SizedBox(height: 15),
                            Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    blurRadius: 15,
                                    spreadRadius: 3,
                                  ),
                                ],
                              ),
                              child: TextFormField(
                                  style: const TextStyle(
                                      color: darkGrey, fontSize: 16),
                                  cursorColor: darkGrey,
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    border: InputBorder.none,
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
                                      borderSide: BorderSide(
                                          color: Colors.transparent, width: 2),
                                    ),
                                    labelText: 'Guardian Name',
                                    labelStyle: TextStyle(
                                      color: darkGrey,
                                      fontSize: 14,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.person,
                                      color: darkGrey,
                                    ),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      guardianName = value;
                                    });
                                  }),
                            ),
                            const SizedBox(height: 15),
                            Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    blurRadius: 15,
                                    spreadRadius: 3,
                                  ),
                                ],
                              ),
                              child: TextFormField(
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  style: const TextStyle(
                                      color: darkGrey, fontSize: 16),
                                  cursorColor: darkGrey,
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    border: InputBorder.none,
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
                                      borderSide: BorderSide(
                                          color: Colors.transparent, width: 2),
                                    ),
                                    labelText: 'Email Address',
                                    labelStyle: TextStyle(
                                      color: darkGrey,
                                      fontSize: 14,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.email,
                                      color: darkGrey,
                                    ),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      email = value;
                                    });
                                  }),
                            ),
                            const SizedBox(height: 15),
                            Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    blurRadius: 15,
                                    spreadRadius: 3,
                                  ),
                                ],
                              ),
                              child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(
                                      color: darkGrey, fontSize: 16),
                                  cursorColor: darkGrey,
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    border: InputBorder.none,
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
                                      borderSide: BorderSide(
                                          color: Colors.transparent, width: 2),
                                    ),
                                    labelText: 'Phone Number',
                                    labelStyle: TextStyle(
                                      color: darkGrey,
                                      fontSize: 14,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.phone,
                                      color: darkGrey,
                                    ),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      number = int.parse(value);
                                    });
                                  }),
                            ),
                            const SizedBox(height: 15),
                            Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    blurRadius: 15,
                                    spreadRadius: 3,
                                  ),
                                ],
                              ),
                              child: TextFormField(
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  style: const TextStyle(
                                      color: darkGrey, fontSize: 16),
                                  cursorColor: darkGrey,
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    border: InputBorder.none,
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
                                      borderSide: BorderSide(
                                          color: Colors.transparent, width: 2),
                                    ),
                                    labelText: 'Home Address',
                                    labelStyle: TextStyle(
                                      color: darkGrey,
                                      fontSize: 14,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.home,
                                      color: darkGrey,
                                    ),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      address = value;
                                    });
                                  }),
                            ),
                            const SizedBox(height: 15),
                          ],
                        )),
                    Container(
                      padding: const EdgeInsets.only(
                        bottom: 20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(darkBlue),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ))),
                            onPressed: () {
                              validated();
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 85, right: 85, top: 10, bottom: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const <Widget>[
                                  Text(
                                    'Save',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.white),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ))),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 15, right: 15, top: 10, bottom: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const <Widget>[
                                  Text(
                                    'Cancel',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: darkBlue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onFormSubmit() {
    Box<PersonalInfo> infoBox = Hive.box<PersonalInfo>(HiveBoxesInfo.info);
    print("Creating User!");
    var newUser = infoBox.add(PersonalInfo(
        nickname: nickname,
        firstName: firstName,
        middleName: middleName,
        lastName: lastName,
        guardianName: guardianName,
        contactNumber: number,
        address: address,
        email: email));
    print(newUser);
    var infolength = Hive.box<PersonalInfo>(HiveBoxesInfo.info).length;
    print("User profile count: ${infolength}");
    Navigator.pop(context);
  }
}
