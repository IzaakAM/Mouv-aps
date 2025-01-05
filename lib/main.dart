import 'package:flutter/material.dart';
import 'package:accueil/screens/login.dart';  // Assurez-vous que l'importation est correcte

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login(),  
    );
  }
}
