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
    secondary: Color(0xFFb6e0ff),
    onSecondary: Color(0xFF4779a2),
    error: Colors.redAccent,
    onError: Colors.white,
    surface: Colors.white,
    surfaceTint: Color(0xFFf3faff),
    onSurface: Color(0xFF4A4A4A),
    brightness: Brightness.light,
  );

  static const ColorScheme darkColorScheme = ColorScheme(
    primary: Color(0xFF4779a2),
    onPrimary: Colors.black45,
    secondary: Color(0xFF4779a2),
    onSecondary: Color(0xff90d0ff),
    error: Colors.redAccent,
    onError: Colors.white,
    surface: Colors.black54,
    surfaceTint: Color(0xFF303030),
    onSurface: Colors.white60,
    brightness: Brightness.dark,
  );

  static const _lightFocusColor = Color(0xFFeaf6ff);
  static const _darkFocusColor = Color(0xFF1a1a1a);
}

