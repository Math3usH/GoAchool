import 'package:flutter/material.dart';

class AppTheme {
  static const Color yellow = Color(0xFFFFD000);
  static const Color yellowDark = Color(0xFFB89300);
  static const Color yellowLight = Color(0xFFFFF7CC);
  static const Color navy = Color(0xFF0D1B2A);
  static const Color navyMid = Color(0xFF1A2E45);
  static const Color navyLight = Color(0xFF2A4060);
  static const Color green = Color(0xFF22C55E);
  static const Color greenLight = Color(0xFFDCFCE7);
  static const Color red = Color(0xFFEF4444);
  static const Color redLight = Color(0xFFFEE2E2);
  static const Color orange = Color(0xFFF97316);
  static const Color orangeLight = Color(0xFFFFF0E6);
  static const Color blue = Color(0xFF3B82F6);
  static const Color blueLight = Color(0xFFEFF6FF);
  static const Color gray100 = Color(0xFFF5F6FA);
  static const Color gray200 = Color(0xFFE8EAF0);
  static const Color gray300 = Color(0xFFC8CDD8);
  static const Color gray400 = Color(0xFF8A92A3);
  static const Color gray600 = Color(0xFF525A6B);

  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        fontFamily: 'Nunito',
        colorScheme: ColorScheme.fromSeed(
          seedColor: yellow,
          primary: yellow,
          onPrimary: navy,
          secondary: navy,
          onSecondary: Colors.white,
          background: gray100,
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: gray100,
        appBarTheme: const AppBarTheme(
          backgroundColor: navy,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: yellow,
            foregroundColor: navy,
            textStyle: const TextStyle(
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w800,
              fontSize: 15,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: gray200),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: gray200, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: yellowDark, width: 1.5),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shadowColor: Colors.black12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: Colors.white,
        ),
      );
}
