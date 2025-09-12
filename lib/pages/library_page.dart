import 'package:flutter/material.dart';
import 'package:music_app/Providers/data_provider.dart';
import 'package:music_app/Providers/navigation_index_provider.dart';
import 'package:music_app/components/playlist_tile.dart';

class LibraryPage extends StatelessWidget {
  final CurrentIndexProvider currentIndexProvider;
  final DataProvider dataProvider;

  const LibraryPage({
    super.key,
    required this.currentIndexProvider,
    required this.dataProvider,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 10, top: 20, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Scaffold.of(context).openDrawer();
                      },
                      child: Icon(Icons.menu, size: 50),
                    ),
                    Text(
                      " Library",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                GestureDetector(onTap: () {}, child: Icon(Icons.add, size: 50)),
              ],
            ),
            SizedBox(height: 10),
            // pills row
            Row(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: _pill('Playlists')),
                Expanded(child: _pill('Albums')),
                Expanded(child: _pill('Artists')),
              ],
            ),

            const SizedBox(height: 20),
            // list of playlists
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    final playlist = dataProvider
                        .playlistsExcludingDownloads()[index];
                    return PlaylistTile(
                      playlist: playlist,
                      currentIndexProvider: currentIndexProvider,
                      dataProvider: dataProvider,
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemCount: dataProvider.playlistsExcludingDownloads().length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.withAlpha(50),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
