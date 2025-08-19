import 'package:flutter/material.dart';
import 'package:music_app/Providers/data_provider.dart';
import 'package:music_app/Providers/navigation_index_provider.dart';
import 'package:music_app/models/song_model.dart';

class MiniPlayer extends StatelessWidget {
  final Song song;
  final CurrentIndexProvider currentIndexProvider;
  final DataProvider dataProvider;
  final double progress; // 0.0 to 1.0

  const MiniPlayer({
    super.key,
    required this.song,
    required this.currentIndexProvider,
    required this.dataProvider,
    this.progress = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2A2422),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Main row
          Row(
            children: [
              // Album art
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                  song.imageUrl,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 8),

              // Song details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      song.artist,
                      style: const TextStyle(color: Colors.white70),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Heart icon
              Icon(
                Icons.favorite,
                color: dataProvider.clickedPlaylist!.name.toLowerCase() =="liked songs" ? Colors.green : Colors.white70,
              ),
              const SizedBox(width: 12),

              // Play icon
              const Icon(Icons.play_arrow, color: Colors.white, size: 28),
            ],
          ),

          const SizedBox(height: 8),

          // Progress bar
          LinearProgressIndicator(
            value: progress,
            minHeight: 3,
            backgroundColor: Colors.white24,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ],
      ),
    );
  }
}
