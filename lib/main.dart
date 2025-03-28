import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:mouv_aps/screens/HomePage.dart';
import 'package:mouv_aps/colors/GlobalThemeData.dart';
import 'package:mouv_aps/widgets/PagesView.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // App root
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mouv\'APS',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: GlobalThemeData.lightThemeData,
      darkTheme: GlobalThemeData.darkThemeData,
      home: const PagesView()
    );
  }
}