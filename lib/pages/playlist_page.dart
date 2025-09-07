import 'package:flutter/material.dart';
import 'package:music_app/Providers/data_provider.dart';
import 'package:music_app/Providers/navigation_index_provider.dart';
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
                dataProvider.clickedPlaylist!,
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
                          "Find in ${dataProvider.clickedPlaylist?.toLowerCase() ?? ''}",
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
                padding: const EdgeInsets.only(right: 7 , left :10),
                child: ListView.separated(
                  itemCount: dataProvider
                      .getplaylistsbyName(dataProvider.clickedPlaylist!)
                      .songKeys
                      .length,
                  itemBuilder: (context, index) {
                    final song = dataProvider.getSongById(
                      dataProvider
                          .getplaylistsbyName(dataProvider.clickedPlaylist!)
                          .songKeys[index],
                    );
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
          ],
        ),
      ),
    );
  }
}
