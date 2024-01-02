// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news/inner_screens/bookmark_screens.dart';
import 'package:news/providers/theme_providers.dart';

import 'package:news/widgets/vertical_spacing.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    themeProvider.getDarkTheme ? Colors.white : Colors.black;
    return Drawer(
      child: Material(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Column(
                children: [
                  Flexible(
                    child: Image.asset(
                      'assets/images/newspaper.png',
                      height: 60,
                      width: 60,
                    ),
                  ),
                  const VerticalSpacing(20),
                  Flexible(
                    child: Text(
                      'News App',
                      style: GoogleFonts.lobster(
                        textStyle: const TextStyle(fontSize: 20),
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const VerticalSpacing(20),
            ListTiles(
              label: 'Home',
              callback: () {},
              icon: const Icon(Icons.home),
            ),
            ListTiles(
              label: 'Bookmark',
              callback: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: const BookmarkScreen(),
                    inheritTheme: true,
                    ctx: context,
                  ),
                );
              },
              icon: const Icon(Icons.bookmark_outline),
            ),
            const Divider(),
            SwitchListTile(
              title: Text(
                themeProvider.getDarkTheme ? 'Dark' : 'Light',
                style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).textSelectionTheme.selectionColor),
              ),
              secondary: Icon(
                themeProvider.getDarkTheme ? Icons.dark_mode : Icons.light_mode,
                color: Theme.of(context).colorScheme.secondary,
              ),
              value: themeProvider.getDarkTheme,
              onChanged: (value) {
                setState(() {
                  themeProvider.setDarkTheme = value;
                });
              },
            )
          ],
        ),
      ),
    );
  }
}

class ListTiles extends StatelessWidget {
  final String label;
  final Function callback;
  final Icon icon;
  const ListTiles({
    Key? key,
    required this.label,
    required this.callback,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon,
      title: Text(
        label,
        style: TextStyle(
          fontSize: 20,
          color: Theme.of(context).textSelectionTheme.selectionColor,
        ),
      ),
      onTap: () {
        callback();
      },
    );
  }
}
