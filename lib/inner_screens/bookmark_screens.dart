import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news/widgets/empty_screen.dart';

import '../services/utils.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).getColor;
    // Size size = Utils(context).getScreenSize;
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: color),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            'Bookmarks',
            style: GoogleFonts.lobster(
              textStyle: const TextStyle(fontSize: 20),
              letterSpacing: 0.6,
              color: color,
            ),
          ),
        ),
        body: const EmptyNewsWidget(
            text: 'You didn\'t add anything yet to your bookmark',
            imagePath: 'assets/images/bookmark.png')
        //  ListView.builder(
        //   itemCount: 3,
        //   itemBuilder: (context, index) {
        //     return const ArticlesWidget();
        //   },
        // )
        );
  }
}
