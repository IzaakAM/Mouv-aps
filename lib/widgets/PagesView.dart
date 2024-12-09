import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mouv_aps/screens/ChatPage.dart';
import 'package:mouv_aps/screens/CookingPage.dart';
import 'package:mouv_aps/screens/EducationalPage.dart';
import 'package:mouv_aps/screens/HomePage.dart';
import 'package:mouv_aps/screens/TrainingPage.dart';
import 'package:mouv_aps/widgets/topbar.dart';

class PagesView extends StatefulWidget {
  const PagesView({super.key});

  @override
  State<PagesView> createState() => _PagesViewState();
}

class _PagesViewState extends State<PagesView> {
  int currentPageIndex = 0;
  PageController pageController = PageController(initialPage: 0);

  final List<Widget> pages = [
    const HomePage(),
    const TrainingPage(),
    const CookingPage(),
    const EducationalPage(),
    const ChatPage()
  ];

  final List<String> pageTitles = [
    'Accueil',
    'Exercices',
    'Nutrition',
    'Éducation',
    'Chat',
  ];

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
      body: PageView(
        controller: pageController,
        children: pages,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: TopBar(title: pageTitles[currentPageIndex]),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceTint,
        shadowColor: Theme.of(context).colorScheme.primary,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
            pageController.jumpToPage(index);
          });
        },
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(FontAwesomeIcons.house),
            label: 'Accueil',
          ),
          NavigationDestination(
            icon: Icon(FontAwesomeIcons.dumbbell),
            label: 'Exercices',
          ),
          NavigationDestination(
            icon: Icon(FontAwesomeIcons.utensils),
            label: 'Nutrition',
          ),
          NavigationDestination(
            icon: Icon(FontAwesomeIcons.handHoldingHeart),
            label: 'Éducation',
          ),
          NavigationDestination(
            icon: Icon(FontAwesomeIcons.solidComment),
            label: 'Chat',
          ),
        ],
      ),
    );
  }
}
