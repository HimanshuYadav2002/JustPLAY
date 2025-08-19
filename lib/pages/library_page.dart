import 'package:flutter/material.dart';
import 'package:music_app/Providers/data_provider.dart';
import 'package:music_app/Providers/navigation_index_provider.dart';
import 'package:music_app/components/mini_player.dart';
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
            // Header
            Center(
              child: Text(
                'Your Library',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 20),
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
                    final playlist = dataProvider.playlists[index];
                    return PlaylistTile(
                      playlist: playlist,
                      currentIndexProvider: currentIndexProvider,
                      dataProvider: dataProvider,
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemCount: dataProvider.playlists.length,
                ),
              ),
            ),
            (dataProvider.clickedSong != null)
                ? MiniPlayer(
                    song: dataProvider.clickedSong!,
                    currentIndexProvider: currentIndexProvider,
                    dataProvider: dataProvider,
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget _pill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.withAlpha(50),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(color: Colors.white70, fontSize: 15),
        ),
      ),
    );
  }
}
