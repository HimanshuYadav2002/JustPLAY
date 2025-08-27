import 'package:flutter/material.dart';
import 'package:music_app/Providers/data_provider.dart';
import 'package:music_app/Providers/navigation_index_provider.dart';
import 'package:music_app/components/mini_player.dart';
import 'package:music_app/components/song_tile.dart';

class PlaylistPage extends StatelessWidget {
  final CurrentIndexProvider currentIndexProvider;
  final DataProvider dataProvider;
  const PlaylistPage({
    super.key,
    required this.currentIndexProvider,
    required this.dataProvider,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
        child: Column(
          children: [
            Center(
              child: Text(
                dataProvider.clickedPlaylist!.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20),
            // Search & Sort Row
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText:
                          "Find in ${dataProvider.clickedPlaylist?.name.toLowerCase() ?? ''}",
                      hintStyle: TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.white10,
                      prefixIcon: Icon(Icons.search, color: Colors.white70),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      alignment: Alignment.center,
                      width: 60,
                      height: 55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white10,
                      ),
                      child: Text(
                        "Sort",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Songs List
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: ListView.separated(
                  itemCount: dataProvider.clickedPlaylist?.songKeys.length ?? 0,
                  itemBuilder: (context, index) {
                    final song =
                        dataProvider.songsList[dataProvider
                            .clickedPlaylist
                            ?.songKeys[index]];
                    if (song == null) return SizedBox.shrink();
                    return SongTile(
                      currentIndexProvider: currentIndexProvider,
                      dataProvider: dataProvider,
                      song: song,
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
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
}
