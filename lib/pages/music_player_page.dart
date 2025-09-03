import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:music_app/Providers/data_provider.dart';

class MusicPlayer extends StatefulWidget {
  final DataProvider dataProvider;
  const MusicPlayer({super.key, required this.dataProvider});

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {

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

    return SafeArea(
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

          // Song Title + Heart (aligned with album art and controls)
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

          SizedBox(height: verticalSpacing * 0.5),

          // Slider
          Padding(
            padding: EdgeInsets.symmetric(horizontal: sliderHorizontalPadding),
            child: Column(
              children: [
                StreamBuilder<Duration>(
                  stream: widget.dataProvider.musicPlayer.positionStream,
                  builder: (context, snapshot) {
                    final position = snapshot.data ?? Duration.zero;
                    final duration =
                        widget.dataProvider.musicPlayer.duration ??
                        Duration.zero;
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

                // Slider(
                //   value: 40,
                //   min: 0,
                //   max: 266,
                //   activeColor: const Color(0xFF1DB954), // Spotify green
                //   inactiveColor: Colors.white24,
                //   onChanged: (value) {},
                // ),
                // Padding(
                //   padding: EdgeInsets.symmetric(
                //     horizontal: sliderHorizontalPadding * 2,
                //   ),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Text(
                //         "0:12",
                //         style: TextStyle(
                //           color: Colors.white70,
                //           fontSize: sliderLabelFontSize,
                //         ),
                //       ),
                //       Text(
                //         "4:26",
                //         style: TextStyle(
                //           color: Colors.white70,
                //           fontSize: sliderLabelFontSize,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),

          SizedBox(height: verticalSpacing * 0.5),

          // Controls
          Padding(
            padding: EdgeInsets.symmetric(horizontal: controlsPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.shuffle, color: Colors.white, size: iconSize * 0.8),
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
                    decoration: BoxDecoration(
                      color: const Color(0xFF1DB954),
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
    );
  }
}
