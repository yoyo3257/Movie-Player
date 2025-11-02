import 'package:flutter/material.dart';

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF121212),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF2C2A30),
    foregroundColor: Colors.white,
    elevation: 0,
    titleTextStyle: TextStyle(
      color: Color(0xFF00BCD4),
      fontWeight: FontWeight.bold,
      fontSize: 24,
    ),
    iconTheme: IconThemeData(color: Color(0xFF00BCD4)),
  ),
  cardColor: const Color(0xFF1D1B20),
  textTheme: const TextTheme(
    titleLarge: TextStyle(color: Color(0xFFFFFFFF)),
    headlineMedium: TextStyle(color: Color(0xFFFFFFFF)),
    headlineLarge: TextStyle(
      color: Color(0xFFFFFFFF),
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ), // Header Text
    bodyLarge: TextStyle(color: Color(0xFFCAC4D0)), // Small Text
  ),
  colorScheme: const ColorScheme.dark(
    onSurface: Color(0xFF121212), // background
    primary: Color(0xFF00BCD4), // Header
    secondary: Color(0xFFFFC107), // Star Color
    surface: Color(0xFF1D1B20), // Card Background
  ),
  cardTheme: const CardThemeData(
    color: Color(0xFF1D1B20),
    surfaceTintColor: Color(0xFF141218), // Card Small Background
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF2C2B2C), // Button color
      foregroundColor: Color(0xFF737074),
      textStyle: TextStyle(
        color: Color(0xFF737074),
        fontSize: 20,
        fontWeight: FontWeight.w300,
      ),
      fixedSize: Size(480, 40),
    ),
  ),
  iconTheme: IconThemeData(color: Color(0xFFFFFFFF)),
);
