import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: const Color(0xFFFEFEFE),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF2691ED),
    foregroundColor: Colors.black,
    elevation: 0,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 24,
    ),
    iconTheme: IconThemeData(color: Colors.white),
  ),
  cardColor: const Color(0xFFF7F2FA),
  textTheme: const TextTheme(
    titleLarge: TextStyle(color: Colors.black),
    headlineMedium: TextStyle(color: Color(0xFF1D1B20)),
    headlineLarge: TextStyle(
      color: Colors.black,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ), // Header Text
    bodyLarge: TextStyle(color: Color(0xFF49454F)), // Small Text
  ),
  colorScheme: const ColorScheme.light(
    onSurface: Color(0xFFFEFEFE),
    primary: Color(0xFF00BCD4), // Header
    secondary: Color(0xFFFFC107), // Star Color
    surface: Color(0xFFF7F2FA), // Card Background
  ),
  cardTheme: const CardThemeData(
    color: Color(0xFFF7F2FA),
    surfaceTintColor: Color(0xFFFEF7FF), // Card Small Background
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFDAD9DA), // Button color
      foregroundColor: Color(0xFF737074),
      textStyle: TextStyle(
        color: Color(0xFF737074),
        fontSize: 20,
        fontWeight: FontWeight.w300,
      ),
      fixedSize: Size(480, 40),
    ),
  ),
  iconTheme: IconThemeData(color: Colors.black),
);
//Color(0xFFDAD9DA)
