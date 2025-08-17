import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_app/Providers/navigation_index_provider.dart';
import 'package:music_app/pages/playlist_page.dart';
import 'package:provider/provider.dart';
import 'pages/search_page.dart';
import 'pages/library_page.dart';
import 'pages/downloads_page.dart';
import 'pages/music_player.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CurrentIndexProvider(),
      child: const JustPLAY(),
    ),
  );
}

class JustPLAY extends StatefulWidget {
  const JustPLAY({super.key});

  @override
  State<JustPLAY> createState() => _JustPLAYState();
}

class _JustPLAYState extends State<JustPLAY> {

  final pages = [
    const LibraryPage(),
    const SearchPage(),
    const DownloadsPage(),
    const MusicPlayer(),
    PlaylistPage(playlistName: "Liked songs"),
  ];

  @override
  Widget build(BuildContext context) {
    final currentIndexProvider = Provider.of<CurrentIndexProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'JustPLAY',
      theme: ThemeData(
        brightness: Brightness.dark,
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme.apply(bodyColor: Colors.white),
        ),
      ),
      home: Scaffold(
        // Keep the same dark background
        backgroundColor: Colors.black,
        body: pages[currentIndexProvider.currentIndex],
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            splashFactory: NoSplash.splashFactory,
            highlightColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.black,
            iconSize: 30,
            currentIndex: currentIndexProvider.navigationCurrentIndex,
            onTap: (i) =>
                setState(() => currentIndexProvider.setCurrentIndex(i)),
            selectedItemColor: const Color(0xFF00D074),
            unselectedItemColor: Colors.white70,
            showUnselectedLabels: false,
            showSelectedLabels: false,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.library_music),
                label: 'Library',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search, size: 35),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.cloud_download),
                label: 'Downloads',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
