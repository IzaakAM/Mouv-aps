import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainNavigationBar extends StatefulWidget {
  const MainNavigationBar({super.key});

  @override
  State<MainNavigationBar> createState() => _MainNavigationBarState();
}

class _MainNavigationBarState extends State<MainNavigationBar> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      backgroundColor: Theme.of(context).colorScheme.surfaceTint,
      shadowColor: Theme.of(context).colorScheme.primary,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      selectedIndex: currentPageIndex,
      onDestinationSelected: (int index) {
        setState(() {
          currentPageIndex = index;
        });
      },
      destinations: const <Widget>[
        NavigationDestination(
            icon: Icon(FontAwesomeIcons.house), label: 'Accueil'),
        NavigationDestination(
            icon: Icon(FontAwesomeIcons.dumbbell), label: 'Exercices'),
        NavigationDestination(
            icon: Icon(FontAwesomeIcons.utensils),
            label: 'Nutrition'),
        NavigationDestination(
            icon: Icon(FontAwesomeIcons.handHoldingHeart), label: 'Education'),
        NavigationDestination(
            icon: Icon(FontAwesomeIcons.comment), label: 'Chat'),
      ],
    );
  }
}
