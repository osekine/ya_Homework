import 'package:flutter/material.dart';
import 'package:to_do_app/core/constants/text.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.blue,
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: Color.fromRGBO(0, 122, 255, 1),
    onPrimary: Colors.black,
    secondary: Colors.white,
    onSecondary: Color(0x99000000),
    error: Color(0XFFFF3B30),
    onError: Colors.black,
    background: Color(0xFFF7F6F2),
    onBackground: Colors.black,
    surface: Colors.white,
    onSurface: Color(0x55000000),
    shadow: Color(0xFF000000),
  ),
  dividerColor: const Color(0x33000000),
  canvasColor: const Color(0x0F000000),
  useMaterial3: true,
  textTheme: textTheme,
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.blue,
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF0A84FF),
    onPrimary: Colors.white,
    secondary: Color(0x00252528),
    onSecondary: Color(0x99FFFFFF),
    error: Color(0XFFFF453A),
    onError: Colors.white,
    background: Color(0xFF161618),
    onBackground: Colors.white,
    surface: Color(0xFF252528),
    onSurface: Color(0x99FFFFFF),
    shadow: Color(0xFF3C3C3F),
  ),
  dividerColor: const Color(0x33FFFFFF),
  canvasColor: const Color(0x52000000),
  useMaterial3: true,
  textTheme: textTheme,
);
