import 'package:flutter/material.dart';

class MusicPlayer extends StatelessWidget {
  const MusicPlayer({super.key});

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
    final sliderLabelFontSize = width * 0.04;
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
              "https://upload.wikimedia.org/wikipedia/en/f/fd/Coldplay_-_Parachutes.png",
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
                        "Yellow",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: titleFontSize,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Coldplay",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: artistFontSize,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.favorite_border_rounded,
                  color: Colors.white,
                  size: heartIconSize,
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
                Slider(
                  value: 40,
                  min: 0,
                  max: 266,
                  activeColor: const Color(0xFF1DB954), // Spotify green
                  inactiveColor: Colors.white24,
                  onChanged: (value) {},
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: sliderHorizontalPadding * 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "0:12",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: sliderLabelFontSize,
                        ),
                      ),
                      Text(
                        "4:26",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: sliderLabelFontSize,
                        ),
                      ),
                    ],
                  ),
                ),
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
                Icon(
                  Icons.skip_previous_rounded,
                  color: Colors.white,
                  size: iconSize * 1.2,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1DB954),
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(iconSize * 0.33),
                  child: Icon(
                    Icons.pause_rounded,
                    color: Colors.white,
                    size: iconSize * 1.2,
                  ),
                ),
                Icon(
                  Icons.skip_next_rounded,
                  color: Colors.white,
                  size: iconSize * 1.2,
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
