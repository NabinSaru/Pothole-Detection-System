import 'package:flutter/material.dart';
import 'package:new_project/Directory/connection.dart';
import 'package:new_project/Directory/signin.dart';
import 'package:new_project/Directory/PasswordStrengthGUI.dart';
import 'package:new_project/Directory/welcome.dart';
import 'package:new_project/Pages/home.dart';
import 'package:new_project/GlobalVar.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pothole Detection System',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Color(0xFFE8716D),
        primaryColor: Color(0xFF2E3E52),
        buttonColor: Color(0xFF6ADCC8),
        primaryColorDark: Color(0xFF7C8BA6)
//        primarySwatch: Colors.blue,
      ),
      home: Welcome(),
      // home: FlutterPasswordStrength(),
    );
  }
}

