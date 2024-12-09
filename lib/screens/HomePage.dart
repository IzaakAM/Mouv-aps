import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mouv_aps/widgets/navbar.dart';
import 'package:mouv_aps/widgets/topbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Theme
            .of(context)
            .colorScheme
            .surfaceTint,
        systemNavigationBarIconBrightness: Brightness.light,
      ));
    }
    return Scaffold(
      appBar: TopBar(title: 'Accueil'),
      backgroundColor: Theme.of(context).colorScheme.surface,
      bottomNavigationBar: const MainNavigationBar(),
    );
  }
}