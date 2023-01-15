import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppStyle {
  static Color mainColor = const Color(0xff000633);
  static Color secondColor = const Color(0xff0065ff);
  static Color bgColor = const Color(0xffe2e2ff);

  static List<Color> cardsColors = [
    Colors.white,
    Colors.red.shade100,
    Colors.pink.shade100,
    Colors.yellow.shade100,
    Colors.green.shade100,
    Colors.orange.shade100,
    Colors.blueGrey.shade100,
    Colors.blue.shade100,
  ];

  static TextStyle mainTitle = GoogleFonts.roboto(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: mainColor,
  );
  static TextStyle mainContent = GoogleFonts.livvic(
    color: mainColor,
  );
  static TextStyle dateTitle = GoogleFonts.roboto(
    fontSize: 19,
    color: mainColor,
    fontWeight: FontWeight.w500,
  );
}
