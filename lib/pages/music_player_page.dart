import 'dart:ui';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:bottom_sheet_bar/bottom_sheet_bar.dart';
import 'package:flutter/material.dart';
import 'package:music_app/Providers/data_provider.dart';
import 'package:music_app/Providers/navigation_index_provider.dart';
import 'package:music_app/components/song_tile.dart';

class MusicPlayer extends StatefulWidget {
  final DataProvider dataProvider;
  final CurrentIndexProvider currentIndexProvider;
  const MusicPlayer({
    super.key,
    required this.dataProvider,
    required this.currentIndexProvider,
  });

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  final _controller = BottomSheetBarController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final albumArtSize = width * 0.8;
    final topBarPadding = width * 0.04;
    final controlsPadding = width * 0.10;
    final titleFontSize = width * 0.05;
    final artistFontSize = width * 0.035;
    final iconSize = width * 0.09;
    final heartIconSize = width * 0.10;
    final sliderHorizontalPadding = width * 0.03;
    // final sliderLabelFontSize = width * 0.04;
    final verticalSpacing = height * 0.04;

    return BottomSheetBar(
      controller: _controller,
      locked: false,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Top Bar
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: topBarPadding,
                vertical: verticalSpacing * 0.5,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.white,
                    size: iconSize,
                  ),
                  Icon(
                    Icons.more_vert,
                    color: Colors.white,
                    size: iconSize * 0.9,
                  ),
                ],
              ),
            ),

            SizedBox(height: verticalSpacing),

            // Album Art
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                widget.dataProvider.clickedSong!.imageUrl,
                width: albumArtSize,
                height: albumArtSize,
                fit: BoxFit.cover,
              ),
            ),

            SizedBox(height: verticalSpacing),

            // Song Title + Heart
            Padding(
              padding: EdgeInsets.symmetric(horizontal: controlsPadding),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.dataProvider.clickedSong!.name,
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: titleFontSize,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          widget.dataProvider.clickedSong!.artist,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: artistFontSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.dataProvider.toggleLikedsong(
                        widget.dataProvider.clickedSong!,
                      );
                    },
                    child:
                        widget.dataProvider.isSongLiked(
                          widget.dataProvider.clickedSong!.id,
                        )
                        ? Icon(
                            Icons.favorite,
                            color: Colors.green,
                            size: heartIconSize,
                          )
                        : Icon(Icons.favorite_outline, size: heartIconSize),
                  ),
                ],
              ),
            ),

            SizedBox(height: verticalSpacing),

            // Slider
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: sliderHorizontalPadding,
              ),
              child: StreamBuilder<Duration>(
                stream: widget.dataProvider.musicPlayer.positionStream,
                builder: (context, snapshot) {
                  final position = snapshot.data ?? Duration.zero;
                  final duration =
                      widget.dataProvider.musicPlayer.duration ?? Duration.zero;
                  final buffered =
                      widget.dataProvider.musicPlayer.bufferedPosition;

                  return ProgressBar(
                    thumbRadius: 5,
                    timeLabelType: TimeLabelType.remainingTime,
                    timeLabelLocation: TimeLabelLocation.none,
                    progress: position,
                    buffered: buffered,
                    total: duration,
                    onSeek: (newPosition) {
                      widget.dataProvider.musicPlayer.seek(newPosition);
                    },
                  );
                },
              ),
            ),

            SizedBox(height: verticalSpacing),

            // Controls
            Padding(
              padding: EdgeInsets.symmetric(horizontal: controlsPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.shuffle,
                    color: Colors.white,
                    size: iconSize * 0.8,
                  ),
                  GestureDetector(
                    onTap: widget.dataProvider.playPrevious,
                    child: Icon(
                      Icons.skip_previous_rounded,
                      color: Colors.white,
                      size: iconSize * 1.2,
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.dataProvider.togglePlayPause,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFF1DB954),
                        shape: BoxShape.circle,
                      ),
                      padding: EdgeInsets.all(iconSize * 0.33),
                      child: widget.dataProvider.musicPlayer.playing
                          ? Icon(
                              Icons.pause,
                              color: Colors.white,
                              size: iconSize * 1.2,
                            )
                          : Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: iconSize * 1.2,
                            ),
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.dataProvider.playNext,
                    child: Icon(
                      Icons.skip_next_rounded,
                      color: Colors.white,
                      size: iconSize * 1.2,
                    ),
                  ),
                  Icon(Icons.repeat, color: Colors.white, size: iconSize * 0.8),
                ],
              ),
            ),
          ],
        ),
      ),
      collapsed: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          color: Colors.grey.shade900,
        ),
        child: const Center(
          child: Text(
            "Next Songs",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              // fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      expandedBuilder: (ScrollController p1) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 50.0, sigmaY: 50.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(25),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(
                    'Next Songs',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: ListView.separated(
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      controller: p1,
                      itemCount: widget.dataProvider.songQueue.length,
                      itemBuilder: (context, index) {
                        final song = widget.dataProvider.songQueue[index];
                        return SongTile(
                          song: song,
                          currentIndexProvider: widget.currentIndexProvider,
                          dataProvider: widget.dataProvider,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
