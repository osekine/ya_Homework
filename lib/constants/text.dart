import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextTheme textTheme = TextTheme(
    titleLarge: GoogleFonts.roboto(
        textStyle: const TextStyle(
            fontSize: 32, fontWeight: FontWeight.w500, height: 38 / 32)),
    titleMedium: GoogleFonts.roboto(
        textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            height: 32 / 20,
            letterSpacing: 0.5)),
    labelLarge: GoogleFonts.roboto(
        textStyle: const TextStyle(
      fontSize: 14,
      height: 24 / 14,
      letterSpacing: 0.16,
      fontWeight: FontWeight.w500,
    )),
    bodyLarge: GoogleFonts.roboto(
        textStyle: const TextStyle(
            fontSize: 16, height: 20 / 16, fontWeight: FontWeight.w400)),
    bodySmall: GoogleFonts.roboto(
        textStyle: const TextStyle(
            fontSize: 16, height: 20 / 16, fontWeight: FontWeight.w400)),
    titleSmall: GoogleFonts.roboto(
      textStyle: const TextStyle(
          fontSize: 14, height: 20 / 14, fontWeight: FontWeight.w400),
    ));

enum TextStyles { title, subtitle, body, button, subhead }

class TextOption {
  static TextStyle getCustomStyle(
      {required TextStyles style,
      required Color color,
      TextDecoration decoration = TextDecoration.none}) {
    switch (style) {
      case TextStyles.title:
        return GoogleFonts.roboto(
            textStyle: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w500,
                height: 38 / 32,
                decoration: decoration,
                color: color));
      case TextStyles.subtitle:
        return GoogleFonts.roboto(
            textStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                height: 32 / 20,
                color: color,
                decoration: decoration,
                letterSpacing: 0.5));
      case TextStyles.body:
        return GoogleFonts.roboto(
            textStyle: TextStyle(
          fontSize: 16,
          height: 20 / 16,
          fontWeight: FontWeight.w400,
          color: color,
          decoration: decoration,
        ));
      case TextStyles.button:
        return GoogleFonts.roboto(
            textStyle: TextStyle(
          fontSize: 14,
          height: 24 / 14,
          letterSpacing: 0.16,
          fontWeight: FontWeight.w500,
          color: color,
          decoration: decoration,
        ));
      case TextStyles.subhead:
        return GoogleFonts.roboto(
            textStyle: TextStyle(
          fontSize: 14,
          height: 20 / 14,
          fontWeight: FontWeight.w400,
          color: color,
          decoration: decoration,
        ));
    }
  }
}
