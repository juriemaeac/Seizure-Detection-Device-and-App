import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:seizure_app/boxes/boxData.dart';
import 'package:seizure_app/boxes/boxInfo.dart';
import 'package:seizure_app/pages/intro_screen_page.dart';

import 'model/personal_info.dart';
import 'model/sensed_data.dart';

late Box boxData;
late Box boxInfo;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(SensedDataAdapter());
  Hive.registerAdapter(PersonalInfoAdapter());
  await Hive.openBox<SensedData>(HiveBoxesData.data);
  await Hive.openBox<PersonalInfo>(HiveBoxesInfo.info);
  runApp(const MyApp());
  RenderErrorBox.backgroundColor = Colors.transparent;
  RenderErrorBox.textStyle = ui.TextStyle(color: Colors.transparent);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seizure App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: const IntroScreenPage(),
    );
  }
}
