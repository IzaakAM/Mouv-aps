import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mouv_aps/providers/recipe_provider.dart';
import 'package:provider/provider.dart';

import 'package:mouv_aps/providers/session_provider.dart';
import 'package:mouv_aps/colors/GlobalThemeData.dart';
import 'package:mouv_aps/screens/AuthPage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<SessionProvider>(
          create: (_) => SessionProvider(),
        ),
        ChangeNotifierProvider<RecipeProvider>(
          create: (_) => RecipeProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
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
      home: const AuthPage(),
    );
  }
}