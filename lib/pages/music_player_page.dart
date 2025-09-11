import 'dart:ui';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:music_app/Providers/data_provider.dart';
import 'package:music_app/Providers/navigation_index_provider.dart';
import 'package:music_app/components/add_song_to_custom_playlist_tile.dart';
import 'package:music_app/components/song_tile.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

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
  var isdownloading = false;
  bool addToCustomPlaylistButtonClicked = false;
  void toggleAddToCustomPlaylistButtonClicked() {
    setState(() {
      addToCustomPlaylistButtonClicked = !addToCustomPlaylistButtonClicked;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final albumArtSize = width * 0.8;
    // final topBarPadding = width * 0.04;
    final controlsPadding = width * 0.10;
    final titleFontSize = width * 0.05;
    final artistFontSize = width * 0.035;
    final iconSize = width * 0.09;
    final heartIconSize = width * 0.10;
    final sliderHorizontalPadding = width * 0.1;
    // final sliderLabelFontSize = width * 0.04;
    final verticalSpacing = height * 0.04;

    return SlidingUpPanel(
      parallaxEnabled: true,
      color: Colors.black.withAlpha(100),
      minHeight: 40,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Top Bar
            // Padding(
            //   padding: EdgeInsets.symmetric(
            //     horizontal: topBarPadding,
            //     vertical: verticalSpacing * 0.5,
            //   ),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Icon(
            //         Icons.keyboard_arrow_down_rounded,
            //         color: Colors.white,
            //         size: iconSize,
            //       ),
            //       Icon(
            //         Icons.more_vert,
            //         color: Colors.white,
            //         size: iconSize * 0.9,
            //       ),
            //     ],
            //   ),
            // ),
            SizedBox(height: verticalSpacing * 2),

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

            SizedBox(height: verticalSpacing * 1.5),

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
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: artistFontSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          setState(() {
                            isdownloading = true;
                          });
                          await widget.dataProvider.downloadSong(
                            widget.dataProvider.clickedSong!,
                          );
                          setState(() {
                            isdownloading = false;
                          });
                        },
                        child: isdownloading
                            ? Icon(
                                Icons.downloading,
                                color: Colors.blue,
                                size: heartIconSize * 0.75,
                              )
                            : !widget.dataProvider
                                  .getplaylistsbyName("Downloads")
                                  .songKeySet
                                  .contains(widget.dataProvider.clickedSong!.id)
                            ? Icon(
                                Icons.downloading,
                                color: Colors.white,
                                size: heartIconSize * 0.75,
                              )
                            : Icon(
                                Icons.download_done_rounded,
                                color: Colors.blue,
                                size: heartIconSize * 0.75,
                              ),
                      ),
                      SizedBox(width: 10),
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
                                color: Colors.blue,
                                size: heartIconSize * 0.75,
                              )
                            : Icon(
                                Icons.favorite_outline,
                                size: heartIconSize * 0.75,
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: verticalSpacing * 0.5),

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
                    progressBarColor: Colors.blue,
                    thumbColor: Colors.blue,
                    bufferedBarColor: Colors.white.withAlpha(25),
                    baseBarColor: Colors.white.withAlpha(30),
                    thumbRadius: 5,
                    thumbCanPaintOutsideBar: false,
                    timeLabelType: TimeLabelType.remainingTime,
                    timeLabelLocation: TimeLabelLocation.sides,
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

            SizedBox(height: verticalSpacing * 0.5),

            // Controls
            Padding(
              padding: EdgeInsets.symmetric(horizontal: controlsPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: widget.dataProvider.toggleShuffleMode,
                    child: Icon(
                      Icons.shuffle,
                      color: widget.dataProvider.shuffleMode
                          ? Colors.blue
                          : Colors.white,
                      size: iconSize * 0.8,
                    ),
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
                      decoration: BoxDecoration(
                        color: Colors.blue.shade700,
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
                  GestureDetector(
                    onTap: widget.dataProvider.toggleRepeatMode,
                    child: Icon(
                      Icons.repeat,
                      color: widget.dataProvider.repeatMode
                          ? Colors.blue
                          : Colors.white,
                      size: iconSize * 0.8,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      padding: EdgeInsets.all(0),
      panel: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(20),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.only(right: 7, left: 10),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 10.0),
                  child: Container(
                    height: 5,
                    width: 70,
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    addToCustomPlaylistButtonClicked
                        ? 'Add to Playlist'
                        : "Next songs",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: addToCustomPlaylistButtonClicked
                      ? ListView.separated(
                          padding: EdgeInsets.only(top: 20),
                          itemBuilder: (context, index) {
                            final playlist = widget.dataProvider
                                .playlistsExcludingLikedAndDownloads()[index];
                            return AddToPlaylistTile(
                              song: widget
                                  .dataProvider
                                  .selctedSongtoAddToPlaylist!,
                              playlist: playlist,
                              currentIndexProvider: widget.currentIndexProvider,
                              dataProvider: widget.dataProvider,
                              toggleAddToCustomPlaylistButtonClicked:
                                  toggleAddToCustomPlaylistButtonClicked,
                            );
                          },
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 12),
                          itemCount: widget.dataProvider
                              .playlistsExcludingLikedAndDownloads()
                              .length,
                        )
                      : ListView.separated(
                          padding: EdgeInsets.only(top: 10),
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 12),
                          itemCount: widget.dataProvider.songQueue.length,
                          itemBuilder: (context, index) {
                            final song = widget.dataProvider.songQueue[index];
                            return SongTile(
                              song: song,
                              currentIndexProvider: widget.currentIndexProvider,
                              dataProvider: widget.dataProvider,
                              toggleAddToCustomPlaylistButtonClicked:
                                  toggleAddToCustomPlaylistButtonClicked,
                            );
                          },
                        ),
                ),
                if (addToCustomPlaylistButtonClicked)
                  GestureDetector(
                    onTap: toggleAddToCustomPlaylistButtonClicked,
                    child: Text(
                      "Close",
                      style: TextStyle(color: Colors.red, fontSize: 20),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
