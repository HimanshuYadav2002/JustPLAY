import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_app/Providers/auth_provider.dart';
import 'package:music_app/Providers/data_provider.dart';
import 'package:music_app/Providers/navigation_index_provider.dart';
import 'package:music_app/components/mini_player.dart';
import 'package:music_app/pages/playlist_page.dart';
import 'package:provider/provider.dart';
import 'pages/search_page.dart';
import 'pages/library_page.dart';
import 'pages/music_player_page.dart';
import 'package:flutter/services.dart';

class JustPlay extends StatelessWidget {
  const JustPlay({super.key});

  @override
  Widget build(BuildContext context) {
    final currentIndexProvider = Provider.of<CurrentIndexProvider>(context);
    final dataProvider = Provider.of<DataProvider>(context);
    final auth = Provider.of<AuthProvider>(context);
    dataProvider.loadSongsFromDB();
    dataProvider.loadPlaylistfromDb();

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
      MusicPlayer(
        dataProvider: dataProvider,
        currentIndexProvider: currentIndexProvider,
      ),
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
      home: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (!didPop) {
            // Send app to background (instead of killing)
            try {
              await MethodChannel("app.minimizer").invokeMethod("minimizeApp");
            } on PlatformException catch (e) {
              if (kDebugMode) {
                print("Failed to minimize app: ${e.message}");
              }
            }
          }
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: AlignmentGeometry.directional(0, 0.1),
              colors: [
                Colors.blue, // Spotify green
                Colors.black,
              ],
            ),
          ),
          child: Scaffold(
            drawer: Drawer(
              backgroundColor: Colors.transparent,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                child: Container(
                  padding: EdgeInsets.all(8),
                  color: Colors.black.withAlpha(25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          ListTile(
                            leading: Image.network(auth.localUser!.photoUrl!),
                            title: Text(auth.localUser!.name!),
                            subtitle: Text(
                              auth.localUser!.email!,
                              style: TextStyle(fontSize: 10),
                            ),
                          ),

                          SizedBox(height: 5),
                          ListTile(
                            title: Text("Plan Expire on"),
                            subtitle: Text(
                              "${auth.localUser!.subscriptionEnd!.day}/${auth.localUser!.subscriptionEnd!.month}/${auth.localUser!.subscriptionEnd!.year}",
                            ),
                          ),
                        ],
                      ),

                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade400,
                          ),
                          onPressed: () async {
                            // sign out
                            await auth.signOutAndClearLocal();
                          },
                          child: const Text(
                            'Logout',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: pages[currentIndexProvider.navigationCurrentIndex],
                ),
                (dataProvider.clickedSong != null &&
                        currentIndexProvider.navigationCurrentIndex != 3)
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
                  dataProvider.setClickedPlaylistToDownloads();
                }
                currentIndexProvider.setCurrentIndex(index);
                currentIndexProvider.setNavigationIndex(index);
              },
              selectedItemColor: Colors.blue,
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
      ),
    );
  }
}
