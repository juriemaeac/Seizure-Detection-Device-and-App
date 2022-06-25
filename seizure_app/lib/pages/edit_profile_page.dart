import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:seizure_app/constant.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seizure_app/model/info_sharedPref.dart';
import 'package:seizure_app/pages/profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    loadData();
    super.initState();
  }

  loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? json = prefs.getString('TestUser_Key');
    print("load info $json");

    if (json == null) {
      print('no data');
    } else {
      Map<String, dynamic> map = jsonDecode(json);
      print('map $map');

      final user1 = InfoPref.fromJson(map);
      print(
          'Name: ${user1.userFirstName} ${user1.userMiddleName} ${user1.userLastName}');
      print('Email: ${user1.userEmail}');
      print('Guardian: ${user1.userGuardianName}');
      print('Number: ${user1.userNumber}');
    }
  }

  late PickedFile _imageFile;
  static ImagePicker _picker = ImagePicker();
  static final TextEditingController textNicknameController =
      TextEditingController(text: "");
  static final TextEditingController textFirstNameController =
      TextEditingController(text: "");
  static final TextEditingController textMiddleNameController =
      TextEditingController(text: "");
  static final TextEditingController textLastNameController =
      TextEditingController(text: "");
  static final TextEditingController textGuardianNameController =
      TextEditingController(text: "");
  static final TextEditingController textEmailController =
      TextEditingController(text: "");
  static final TextEditingController textNumberController =
      TextEditingController(text: "");
  static final TextEditingController textAddressController =
      TextEditingController(text: "");

  //var imagePath;

  saveData() async {
    //String textName = '${user.displayName}';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final testUser = InfoPref(
      userNickname: '$textNickname',
      userFirstName: '$textFirstName',
      userMiddleName: '$textMiddleName',
      userLastName: '$textLastName',
      userGuardianName: '$textGuardianName',
      userEmail: '$textEmail',
      userNumber: '$textNumber',
      userAddress: '$textAddress',
    );

    String json = jsonEncode(testUser);
    print("save info $json");
    prefs.setString('TestUser_Key', json);
  }

  cleardata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    print("Data cleared");
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
                                          child: Column(
                                            children: [
                                              if (imagePath != null) ...[
                                                CircleAvatar(
                                                  radius: 70.0,
                                                  backgroundImage: FileImage(
                                                      File(imagePath)),
                                                ),
                                              ] else ...[
                                                CircleAvatar(
                                                    radius: 70.0,
                                                    backgroundImage: AssetImage(
                                                        'images/samplePic.jpg')),
                                              ],
                                            ],
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
                            Row(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width / 2 -
                                      25,
                                  //margin: const EdgeInsets.only(bottom: 10),
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
                                    controller: textNicknameController,
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
                                            color: Colors.transparent,
                                            width: 2),
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
                                        textNickname = value;
                                      });
                                    },
                                    validator: (String? value) {
                                      if (value!.isEmpty) {
                                        return 'Enter Nickname';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width / 2 -
                                      25,
                                  //margin: const EdgeInsets.only(bottom: 10),
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
                                      controller: textFirstNameController,
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
                                              color: Colors.transparent,
                                              width: 2),
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
                                          textFirstName = value;
                                        });
                                      },
                                      validator: (String? value) {
                                        if (value!.isEmpty) {
                                          return 'Enter First Name';
                                        }
                                        return null;
                                      }),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Container(
                              //margin: const EdgeInsets.only(bottom: 10),
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
                                  controller: textMiddleNameController,
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
                                      textMiddleName = value;
                                    });
                                  },
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'Enter Middle Name';
                                    }
                                    return null;
                                  }),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              //margin: const EdgeInsets.only(bottom: 10),
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
                                  controller: textLastNameController,
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
                                      textLastName = value;
                                    });
                                  },
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'Enter Last Name';
                                    }
                                    return null;
                                  }),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              //margin: const EdgeInsets.only(bottom: 10),
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
                                  controller: textGuardianNameController,
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
                                      textGuardianName = value;
                                    });
                                  },
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'Enter Guardian Name';
                                    }
                                    return null;
                                  }),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              //margin: const EdgeInsets.only(bottom: 10),
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
                                  controller: textEmailController,
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
                                      textEmail = value;
                                    });
                                  },
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'Enter Email Address';
                                    }
                                    return null;
                                  }),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              //margin: const EdgeInsets.only(bottom: 10),
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
                                  controller: textNumberController,
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
                                      textNumber = value;
                                    });
                                  },
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'Enter Phone Number';
                                    }
                                    return null;
                                  }),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              //margin: const EdgeInsets.only(bottom: 10),
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
                                  controller: textAddressController,
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
                                      textAddress = value;
                                    });
                                  },
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'Enter Home Address';
                                    }
                                    return null;
                                  }),
                            ),
                            const SizedBox(height: 20),
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
                              if (!_formKey.currentState!.validate()) {
                                return;
                              }
                              _formKey.currentState!.save();
                              saveData();
                              print("Profile Saved");
                              loadData();
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 85, right: 85, top: 15, bottom: 15),
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
                                  left: 15, right: 15, top: 15, bottom: 15),
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
}
