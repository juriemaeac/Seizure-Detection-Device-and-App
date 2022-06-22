import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:seizure_app/device/sensor.dart';
import 'package:seizure_app/pages/intro_screen_page.dart';
import 'package:seizure_app/pages/profile_page.dart';
import 'package:seizure_app/pages/records_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  runApp(const MyApp());
  // RenderErrorBox.backgroundColor = Colors.transparent;
  // RenderErrorBox.textStyle = ui.TextStyle(color: Colors.transparent);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Seizure App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          //primarySwatch: Colors.indigo,
          textTheme: GoogleFonts.poppinsTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        home: const IntroScreenPage(),
        routes: <String, WidgetBuilder>{
          "Home": (BuildContext context) => SensorPage(),
          "Records": (BuildContext context) => RecordPage(),
          "Profile": (BuildContext context) => ProfilePage(),
        });
  }
}
