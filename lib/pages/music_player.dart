import 'package:flutter/material.dart';

class MusicPlayer extends StatelessWidget {
  const MusicPlayer({super.key});

  @override
  Widget build(BuildContext context) {
      return SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.white,
                    size: 28,
                  ),

                  Icon(Icons.more_vert, color: Colors.white),
                ],
              ),
            ),

            const SizedBox(height: 60),

            // Album Art
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                "https://upload.wikimedia.org/wikipedia/en/f/fd/Coldplay_-_Parachutes.png",
                width: 280,
                height: 280,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 60),

            // Song Title + Heart
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Yellow",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Coldplay",
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.favorite_border_rounded,
                    color: Colors.white,
                    size: 35,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Slider
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
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
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "0:12",
                          style: TextStyle(color: Colors.white70, fontSize: 15),
                        ),
                        Text(
                          "4:26",
                          style: TextStyle(color: Colors.white70, fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Controls
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.shuffle, color: Colors.white),
                  const Icon(
                    Icons.skip_previous_rounded,
                    color: Colors.white,
                    size: 36,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1DB954),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(12),
                    child: const Icon(
                      Icons.pause_rounded,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                  const Icon(
                    Icons.skip_next_rounded,
                    color: Colors.white,
                    size: 36,
                  ),
                  Icon(Icons.repeat, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      );
  }
}
