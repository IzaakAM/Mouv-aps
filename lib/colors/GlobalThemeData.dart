import 'package:flutter/material.dart';

class GlobalThemeData {
  static ThemeData lightThemeData = ThemeData(
    colorScheme: lightColorScheme,
    focusColor: _lightFocusColor,
  );

  static ThemeData darkThemeData = ThemeData(
    colorScheme: darkColorScheme,
    focusColor: _darkFocusColor,
  );

  static const ColorScheme lightColorScheme = ColorScheme(
    primary: Color(0xFF4779a2),
    onPrimary: Colors.black45,
    secondary: Color(0xFF4779a2),
    onSecondary: Colors.black38,
    error: Colors.redAccent,
    onError: Colors.white,
    surface: Colors.white,
    onSurface: Colors.black,
    brightness: Brightness.light,
  );

  static const ColorScheme darkColorScheme = ColorScheme(
    primary: Color(0xFF4779a2),
    onPrimary: Colors.black45,
    secondary: Color(0xFF4779a2),
    onSecondary: Colors.black38,
    error: Colors.redAccent,
    onError: Colors.white,
    surface: Colors.black54,
    onSurface: Colors.white,
    brightness: Brightness.light,
  );

  static const _lightFocusColor = Color(0xFFeaf6ff);
  static const _darkFocusColor = Color(0xFF1a1a1a);
}

