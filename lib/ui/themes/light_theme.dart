import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.blue,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 20,
    ),
  ),
  textTheme: const TextTheme(
      // bodyText1: TextStyle(color: Colors.black),
      // bodyText2: TextStyle(color: Colors.black87),
      // headline1: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
  buttonTheme: const ButtonThemeData(
    buttonColor: Colors.blue,
    textTheme: ButtonTextTheme.primary,
  ),
  // Add more theme customizations as needed
);
