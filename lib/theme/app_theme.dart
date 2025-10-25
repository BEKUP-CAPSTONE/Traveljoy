import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Colors.white;
  static const Color secondaryColor = Color(0xFF006989);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: primaryColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: secondaryColor,
      primary: secondaryColor,
      secondary: secondaryColor,
      surface: Colors.white,
      brightness: Brightness.light,
    ),

    // AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: secondaryColor,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: secondaryColor,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),

    // ElevatedButton
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: secondaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),

    // TextButton
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: secondaryColor,
        textStyle: const TextStyle(fontWeight: FontWeight.w500),
      ),
    ),

    // Floating Action Button
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: secondaryColor,
      foregroundColor: Colors.white,
    ),

    // TextField, InputDecoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade50,
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: secondaryColor, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      labelStyle: const TextStyle(color: secondaryColor),
      hintStyle: TextStyle(color: Colors.grey.shade500),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    ),

    // Cursor dan teks
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: secondaryColor,
      selectionColor: Color(0x33006989),
      selectionHandleColor: secondaryColor,
    ),

    // Icon
    iconTheme: const IconThemeData(color: secondaryColor),

    // Checkbox, Radio, Switch
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.all(secondaryColor),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.all(secondaryColor),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all(secondaryColor),
      trackColor: WidgetStateProperty.all(secondaryColor.withOpacity(0.4)),
    ),
  );
}
