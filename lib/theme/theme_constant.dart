
// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

const PRIMARY_COLOR = Colors.deepOrangeAccent;

ThemeData lightModeTheme = ThemeData(
  brightness: Brightness.light,
  elevatedButtonTheme: ElevatedButtonThemeData(style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(PRIMARY_COLOR))),
  appBarTheme: const AppBarTheme(backgroundColor: PRIMARY_COLOR),
  floatingActionButtonTheme:const FloatingActionButtonThemeData(backgroundColor:  PRIMARY_COLOR),
  
);

ThemeData darkModeTheme = ThemeData(
  brightness: Brightness.dark,
  dialogTheme: const DialogTheme(backgroundColor: Colors.black),
  appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
  // popupMenuTheme: PopupMenuThemeData(color: W),
  elevatedButtonTheme: ElevatedButtonThemeData(style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.greenAccent))),
);