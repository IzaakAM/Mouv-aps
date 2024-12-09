import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class TopBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;

  const TopBar({super.key, required this.title});

  @override
  State<TopBar> createState() => _TopBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _TopBarState extends State<TopBar> {
  int points = 10;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        widget.title,
        style: GoogleFonts.oswald(
          textStyle: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 35,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      actions: <Widget>[
        Text(
          '$points pts',
          style: GoogleFonts.oswald(
            textStyle: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 25,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 15),
          child: Icon(
            FontAwesomeIcons.solidCircleUser,
            size: 35,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
