import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/Providers/navigation_index_provider.dart';
import 'package:music_app/models/song_model.dart';
import 'package:music_app/Providers/data_provider.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class SongTile extends StatelessWidget {
  final Song? song;
  final int songIndex;
  final CurrentIndexProvider currentIndexProvider;
  final DataProvider dataProvider;
  SongTile({
    super.key,
    required this.songIndex,
    required this.song,
    required this.currentIndexProvider,
    required this.dataProvider,
  });

  final yt = YoutubeExplode();
  final player = AudioPlayer();

  Future<void> playAudio(Song video) async {
    final manifest = await yt.videos.streamsClient.getManifest(video.id);
    final audioInfo = manifest.audioOnly.withHighestBitrate();
    await player.setUrl(audioInfo.url.toString());
    await player.play();
  }

  List<Widget> rightIcons(BuildContext context) {
    if (currentIndexProvider.currentIndex == 1) {
      return [
        IconButton(
          onPressed: () {
            dataProvider.addToPlaylist(dataProvider.likedSongs, song!);
          },
          icon: dataProvider.likedSongs.songIndices.contains(songIndex)
              ? Icon(Icons.favorite, color: Colors.green, size: 30)
              : Icon(Icons.favorite_outline, size: 30),
        ),

        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.cloud_download_outlined,
            color: Colors.white,
            size: 30,
          ),
        ),

        IconButton(
          onPressed: () {},
          icon: Icon(Icons.add, color: Colors.white, size: 30),
        ),
      ];
    } else if (dataProvider.clickedPlaylist?.name.toLowerCase() ==
        "downloads") {
      return [
        IconButton(
          onPressed: () {
            print("clicked");
            print(song!.name);
            dataProvider.addToPlaylist(dataProvider.likedSongs, song!);
          },
          icon: dataProvider.likedSongs.songIndices.contains(songIndex)
              ? Icon(Icons.favorite, color: Colors.green, size: 30)
              : Icon(Icons.favorite_outline, size: 30),
          color: Colors.white70,
        ),
        // Delete icon
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.delete_outline, color: Colors.red, size: 30),
          color: Colors.white70,
        ),
      ];
    } else if (dataProvider.clickedPlaylist?.name.toLowerCase() ==
        "liked songs") {
      return [
        IconButton(
          onPressed: () {
            dataProvider.addToPlaylist(dataProvider.likedSongs, song!);
          },
          icon: dataProvider.likedSongs.songIndices.contains(songIndex)
              ? Icon(Icons.favorite, color: Colors.green, size: 30)
              : Icon(Icons.favorite_outline, size: 30),
        ),

        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.cloud_download_outlined,
            color: Colors.white,
            size: 30,
          ),
        ),
      ];
    } else {
      return [
        IconButton(
          onPressed: () {
            dataProvider.addToPlaylist(dataProvider.likedSongs, song!);
          },
          icon: dataProvider.likedSongs.songIndices.contains(songIndex)
              ? Icon(Icons.favorite, color: Colors.green, size: 30)
              : Icon(Icons.favorite_outline, size: 30),
        ),

        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.cloud_download_outlined,
            color: Colors.white,
            size: 30,
          ),
        ),

        IconButton(
          onPressed: () {},
          icon: Icon(Icons.close, color: Colors.red, size: 30),
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        playAudio(song!);
        dataProvider.setClickedSong(song);
      },
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(song!.imageUrl),
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
                  overflow: TextOverflow.ellipsis,
                  song!.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  overflow: TextOverflow.ellipsis,
                  song!.artist,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: rightIcons(context),
          ),
        ],
      ),
    );
  }
}
