import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData lightTheme({bool useGoogleFonts = true}) {
    final textTheme = useGoogleFonts
        ? GoogleFonts.interTextTheme(
            const TextTheme(
              bodyLarge: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF333333),
              ),
              bodyMedium: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              bodySmall: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w300,
                color: Color(0xFF5B625E),
              ),
              titleLarge: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
              ),
            ),
          )
        : const TextTheme();

    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        tertiary: const Color(0xFFFF914D),
        primary: const Color(0xFF68B684),
        secondary: const Color(0xFFDE6418),
        seedColor: const Color(0xFFFDFCF9),
      ),
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      useMaterial3: true,
      textTheme: textTheme,
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide.none,
        ),
        focusColor: Color(0xFF7C837F),
        filled: true,
        fillColor: Color(0xFFDDDDDD),
      ),
    );
  }
}
