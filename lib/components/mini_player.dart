import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:music_app/Providers/data_provider.dart';
import 'package:music_app/Providers/navigation_index_provider.dart';
import 'package:music_app/models/song_model.dart';

class MiniPlayer extends StatelessWidget {
  final Song song;
  final CurrentIndexProvider currentIndexProvider;
  final DataProvider dataProvider;

  const MiniPlayer({
    super.key,
    required this.song,
    required this.currentIndexProvider,
    required this.dataProvider,
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

              // Heart icon
              IconButton(
                onPressed: () {
                  dataProvider.toggleLikedsong(song);
                },
                icon: dataProvider.likedSongs.songKeySet.contains(song.id)
                    ? Icon(Icons.favorite, color: Colors.green, size: 30)
                    : Icon(Icons.favorite_outline, size: 30),
              ),

              IconButton(
                onPressed: () {
                  dataProvider.togglePlayPause();
                },
                icon: dataProvider.musicPlayer.playing
                    ? Icon(Icons.pause, color: Colors.white, size: 28)
                    : Icon(Icons.play_arrow, color: Colors.white, size: 28),
              ),

              // Play icon
            ],
          ),

          const SizedBox(height: 8),

          StreamBuilder<Duration>(
            stream: dataProvider.musicPlayer.positionStream,
            builder: (context, snapshot) {
              final position = snapshot.data ?? Duration.zero;
              final duration =
                  dataProvider.musicPlayer.duration ?? Duration.zero;
              final buffered =
                  dataProvider.musicPlayer.bufferedPosition;

              return ProgressBar(
                thumbRadius: 5,
                timeLabelType: TimeLabelType.remainingTime,
                timeLabelLocation: TimeLabelLocation.none,
                progress: position,
                buffered: buffered,
                total: duration,
                onSeek: (newPosition) {
                  dataProvider.musicPlayer.seek(newPosition);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
