import 'package:flutter/material.dart';
import 'package:to_do_app/constants/text.dart';

ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
    useMaterial3: true,
    textTheme: textTheme);

ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.blue,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFF0A84FF),
      onPrimary: Colors.white,
      secondary: Color(0x00252528),
      onSecondary: Color(0x99FFFFFF),
      error: Colors.red,
      onError: Colors.white,
      background: Color(0xFF161618),
      onBackground: Colors.white,
      surface: Color(0xFF252528),
      onSurface: Color(0x99FFFFFF),
      shadow: Color(0xFF3C3C3F),
    ),
    dividerColor: const Color(0x33FFFFFF),
    canvasColor: Colors.amber,
    useMaterial3: true,
    textTheme: textTheme);
