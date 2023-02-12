import 'package:flutter/material.dart';

//? Tema dell'app
ThemeData appTheme = ThemeData(
  inputDecorationTheme: const InputDecorationTheme(
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        width: 2,
        color: Color(0xFFD6D6D6),
      ),
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        width: 2,
        color: Color(0xFF757575),
      ),
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
    hintStyle: TextStyle(
      color: Color(0xFF9E9E9E),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
    fillColor: Color(0xFFEEEEEE),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 2, color: Color.fromARGB(255, 255, 15, 15)),
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
    errorBorder: OutlineInputBorder(
      borderSide:
          BorderSide(width: 2, color: Color.fromARGB(255, 255, 110, 110)),
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
    errorStyle: TextStyle(
      color: Color.fromARGB(255, 255, 73, 73),
      fontWeight: FontWeight.w600,
    ),
  ),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: Color(0xFF757575),
  ),
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
        fontSize: 40, fontWeight: FontWeight.w600, color: Colors.black),
    headlineMedium: TextStyle(
        fontSize: 30, fontWeight: FontWeight.w600, color: Colors.black),
    labelLarge: TextStyle(
        fontSize: 25, fontWeight: FontWeight.w600, color: Colors.black),
    labelMedium: TextStyle(
        fontSize: 19, fontWeight: FontWeight.w600, color: Colors.black),
    labelSmall: TextStyle(
        fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black),
  ),
  primarySwatch: Colors.blue,
  primaryColor: const Color(0xFF5DB075),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFFEEEEEE),
    selectedIconTheme: IconThemeData(
      color: Color(0xFF5DB075),
    ),
    showSelectedLabels: false,
    showUnselectedLabels: false,
  ),
  errorColor: const Color.fromARGB(255, 255, 73, 73),
);
