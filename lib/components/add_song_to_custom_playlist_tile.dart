import 'package:flutter/material.dart';
import 'package:music_app/Providers/navigation_index_provider.dart';
import 'package:music_app/models/playlist_model.dart';
import 'package:music_app/Providers/data_provider.dart';
import 'package:music_app/models/song_model.dart';

class AddToPlaylistTile extends StatelessWidget {
  final Song song;
  final Playlist playlist;
  final DataProvider dataProvider;
  final CurrentIndexProvider currentIndexProvider;
  final VoidCallback toggleAddToCustomPlaylistButtonClicked;

  const AddToPlaylistTile({
    super.key,
    required this.song,
    required this.playlist,
    required this.dataProvider,
    required this.currentIndexProvider,
    required this.toggleAddToCustomPlaylistButtonClicked,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        dataProvider.addToPlaylist(playlist, song);
        toggleAddToCustomPlaylistButtonClicked();
      },
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(playlist.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  playlist.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  // Example: show number of songs as subtitle
                  '${playlist.songKeys.length} songs',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
          playlist.songKeySet.contains(song.id)
              ? Icon(Icons.download_done_rounded, color: Colors.blue, size: 30)
              : SizedBox(),
        ],
      ),
    );
  }
}
