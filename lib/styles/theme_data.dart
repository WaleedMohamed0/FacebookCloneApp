import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import '../components/constants.dart';

ThemeData darkMode = ThemeData(
  scaffoldBackgroundColor: HexColor('242527'),
  backgroundColor: Colors.black,
  // default Color for Whole the App
  primarySwatch: defaultColor,

  appBarTheme: AppBarTheme(
      // titleSpacing: 20.0,
      backgroundColor: HexColor('242527'),
      elevation: 0,
      foregroundColor: Colors.white,
      titleTextStyle: const TextStyle(
          color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
      iconTheme: IconThemeData(color: Colors.white)),
  textTheme: TextTheme(
    // For Panel's Text
    subtitle1: const TextStyle(
      fontSize: 13,
      color: Colors.white,
    ),
    // time
    subtitle2: TextStyle(
      fontSize: 13,
      color: Colors.grey[400],
    ),
    // For Headers
    headline1: TextStyle(
      fontSize: 26.0,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    // name of user in profile screen
    headline2: const TextStyle(
        fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),
    headline3: const TextStyle(
        fontSize: 25,
        height: 1.2,
        color: Colors.white,
        overflow: TextOverflow.ellipsis),
    headline4: const TextStyle(
        fontSize: 25, color: Colors.white, letterSpacing: 2.5, height: 1),
    // comments
    headline5: const TextStyle(
      fontSize: 15,
      color: Colors.white,
    ),
    // name of user in home screen
    bodyText1: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    // Post Text
    bodyText2: TextStyle(
      fontSize: 16,
      color: Colors.white,
    ),
  ),
  iconTheme: IconThemeData(color: Colors.white),
);

ThemeData lightMode = ThemeData(
  // Messenger background color
  backgroundColor: Colors.white,
  primarySwatch: defaultColor,
  scaffoldBackgroundColor: Colors.white,
  iconTheme: const IconThemeData(color: Colors.black),
  appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: TextStyle(
          color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
      foregroundColor: Colors.black,
      iconTheme: IconThemeData(color: Colors.black)),
  textTheme: TextTheme(
    // For Headers
    headline1: const TextStyle(
      fontSize: 26.0,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    // name of user in profile screen
    headline2: const TextStyle(
        fontSize: 28, color: Colors.black, fontWeight: FontWeight.bold),
    headline4: const TextStyle(
        fontSize: 25.0, color: Colors.black, letterSpacing: 2.5, height: 1),
    // Normal Text
    subtitle1: const TextStyle(
      fontSize: 13,
      color: Colors.black,
    ),
    // time
    subtitle2: TextStyle(
      fontSize: 13,
      color: Colors.grey[600],
    ),
    // name of user in home screen
    bodyText1: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    // Post Text
    bodyText2: TextStyle(
      fontSize: 16,
      color: Colors.black,
    ),
    headline3: TextStyle(
      fontSize: 25,
      color: Colors.black,
    ),
    // comments
    headline5: TextStyle(
      fontSize: 15,
      color: Colors.black,
    ),
  ),
);
