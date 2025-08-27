import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_app/Providers/data_provider.dart';
import 'package:music_app/Providers/navigation_index_provider.dart';
import 'package:music_app/components/mini_player.dart';
import 'package:music_app/pages/playlist_page.dart';
import 'package:provider/provider.dart';
import 'pages/search_page.dart';
import 'pages/library_page.dart';
import 'pages/music_player_page.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => CurrentIndexProvider(),
      child: ChangeNotifierProvider(
        create: (_) => DataProvider(),
        child: JustPLAY(),
      ),
    ),
  );
}

class JustPLAY extends StatelessWidget {
  const JustPLAY({super.key});

  @override
  Widget build(BuildContext context) {
    final currentIndexProvider = Provider.of<CurrentIndexProvider>(context);
    final dataProvider = Provider.of<DataProvider>(context);
    final pages = [
      LibraryPage(
        currentIndexProvider: currentIndexProvider,
        dataProvider: dataProvider,
      ),
      SearchPage(
        currentIndexProvider: currentIndexProvider,
        dataProvider: dataProvider,
      ),
      PlaylistPage(
        currentIndexProvider: currentIndexProvider,
        dataProvider: dataProvider,
      ),
      MusicPlayer(),
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'JustPLAY',

      theme: ThemeData(
        scaffoldBackgroundColor: Colors.transparent,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.transparent,
        ),
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        brightness: Brightness.dark,
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme.apply(bodyColor: Colors.white),
        ),
      ),

      home: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: AlignmentGeometry.directional(0, 0.1),
            colors: [
              Colors.green.shade900, // Spotify green
              Colors.black,
            ],
          ),
        ),
        child: Scaffold(
          body: Column(
            
            children: [
              Expanded(
                child: pages[currentIndexProvider.navigationCurrentIndex],
              ),
              (dataProvider.clickedSong != null)
                  ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MiniPlayer(
                        song: dataProvider.clickedSong!,
                        currentIndexProvider: currentIndexProvider,
                        dataProvider: dataProvider,
                      ),
                  )
                  : SizedBox(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            onTap: (index) {
              if (index == 2) {
                dataProvider.setClickedPlaylist(dataProvider.downloads);
              }
              currentIndexProvider.setCurrentIndex(index);
              currentIndexProvider.setNavigationIndex(index);
            },
            selectedItemColor: const Color(0xFF00D074),
            unselectedItemColor: Colors.white70,
            showUnselectedLabels: false,
            showSelectedLabels: false,
            iconSize: 30,
            currentIndex: currentIndexProvider.currentIndex,
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
