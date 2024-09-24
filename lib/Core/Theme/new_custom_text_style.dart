import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_note_app_hive/Core/app_export.dart';

class CustomPoppinsTextStyles {
  static final TextStyle signInText = GoogleFonts.poppins(
    fontSize: 18.fSize,
    color: appTheme.gray500,
    fontWeight: FontWeight.w400,
  );
  static final TextStyle signInHead = GoogleFonts.poppins(
      // fontFamily: marine,
      color: appTheme.red700,
      fontWeight: FontWeight.bold,
      fontSize: 40.fSize);
  static final TextStyle bodyText = GoogleFonts.poppins(
      // fontFamily: marine,
      color: appTheme.black900,
      fontWeight: FontWeight.w400,
      fontSize: 18.fSize);
  static final TextStyle bodyText1 = GoogleFonts.poppins(
      // fontFamily: marine,
      color: appTheme.black900,
      fontWeight: FontWeight.w500,
      fontSize: 20.fSize);
  static final TextStyle bodyText1White = GoogleFonts.poppins(
      // fontFamily: marine,
      color: appTheme.mainWhite,
      fontWeight: FontWeight.w500,
      fontSize: 20.fSize);
  static final TextStyle bodyText2 = GoogleFonts.poppins(
      // fontFamily: marine,
      color: appTheme.black900,
      fontWeight: FontWeight.w600,
      fontSize: 23.fSize);
  static final TextStyle buttonText = GoogleFonts.poppins(
      // fontFamily: marine,
      color: appTheme.whiteA700,
      fontWeight: FontWeight.w500,
      fontSize: 18.fSize);
  static final TextStyle buttonTextRed = GoogleFonts.poppins(
      // fontFamily: marine,
      color: appTheme.red700,
      fontWeight: FontWeight.w500,
      fontSize: 18.fSize);
  static final TextStyle buttonTextSmall = GoogleFonts.poppins(
      // fontFamily: marine,
      color: appTheme.whiteA700,
      fontWeight: FontWeight.w500,
      fontSize: 15.fSize);

  static final TextStyle bodyMedium = GoogleFonts.poppins(
      color: appTheme.black900,
      fontWeight: FontWeight.w500,
      fontSize: 14.fSize);
  static final TextStyle bodyMediumRed = GoogleFonts.poppins(
      color: appTheme.red700, fontWeight: FontWeight.w500, fontSize: 14.fSize);
  static get titleSmallRed700SemiBold_1 => GoogleFonts.poppins(
        fontSize: 18.fSize,
        color: appTheme.red700,
        fontWeight: FontWeight.w600,
      );
  static get titleSmallGreenSemiBold_1 => GoogleFonts.poppins(
        fontSize: 18.fSize,
        color: appTheme.mainGreen,
        fontWeight: FontWeight.w600,
      );
  static get titleSmallWhiteA700SemiBold_1 => GoogleFonts.poppins(
        fontSize: 18.fSize,
        color: appTheme.whiteA700,
        fontWeight: FontWeight.w600,
      );
  static get titleSmallBlackA700SemiBold_1 => GoogleFonts.poppins(
        fontSize: 18.fSize,
        color: appTheme.black900,
        fontWeight: FontWeight.w600,
      );
}
