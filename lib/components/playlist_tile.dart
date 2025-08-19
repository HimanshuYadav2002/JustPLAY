import 'package:flutter/material.dart';
import 'package:music_app/Providers/navigation_index_provider.dart';
import 'package:music_app/models/playlist_model.dart';
import 'package:provider/provider.dart';
import 'package:music_app/Providers/data_provider.dart';

class PlaylistTile extends StatelessWidget {
  final Playlist playlist;
  final CurrentIndexProvider currentIndexProvider;

  const PlaylistTile({
    super.key,
    required this.playlist,
    required this.currentIndexProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            currentIndexProvider.setNavigationIndex(2);
            final dataProvider = Provider.of<DataProvider>(
              context,
              listen: false,
            );
            dataProvider.setClickedPlaylist(playlist);
          },
          child: Container(
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
                '${playlist.songIndices.length} songs',
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
        ),
        const Icon(Icons.more_vert, color: Colors.white54),
      ],
    );
  }
}
