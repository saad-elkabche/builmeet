import 'package:builmeet/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme=ThemeData(
  scaffoldBackgroundColor: AppColors.scaffoldColor,
  textSelectionTheme: const TextSelectionThemeData(
    selectionColor: AppColors.primaryColor,
    selectionHandleColor: AppColors.primaryColor,
    cursorColor: AppColors.primaryColor
  ),
  datePickerTheme: DatePickerThemeData(
    backgroundColor: Colors.white,
    dayBackgroundColor:MaterialStateProperty.resolveWith((states){
      if(states.contains(MaterialState.selected)){
        return AppColors.primaryColor;
      }
    }),
    dayStyle: GoogleFonts.acme(),
    headerHeadlineStyle: GoogleFonts.acme(),
    headerHelpStyle: GoogleFonts.acme(),
    rangePickerHeaderHeadlineStyle: GoogleFonts.acme(),
    rangePickerHeaderHelpStyle: GoogleFonts.acme(),
    yearBackgroundColor: MaterialStateProperty.resolveWith((states){
      if(states.contains(MaterialState.selected)){
        return AppColors.primaryColor;
      }
    }),
    yearForegroundColor:  MaterialStateProperty.resolveWith((states){
      return Colors.black;
    }),
    yearStyle: GoogleFonts.acme(),
    headerBackgroundColor: AppColors.scaffoldColor,
    headerForegroundColor: Colors.black,
    todayForegroundColor:MaterialStateProperty.resolveWith((states) => Colors.white),
    todayBackgroundColor: MaterialStateProperty.resolveWith((states){
      return AppColors.scaffoldColor;
    }),
    weekdayStyle: GoogleFonts.acme(),
  ),
  textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: AppColors.primaryColor)
  ),

);