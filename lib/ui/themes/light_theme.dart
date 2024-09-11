
import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.blue,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 20,
    ),
  ),
  textTheme: TextTheme(
    // bodyText1: TextStyle(color: Colors.black),
    // bodyText2: TextStyle(color: Colors.black87),
    // headline1: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.blue,
    textTheme: ButtonTextTheme.primary,
  ),
  // Add more theme customizations as needed
);
