import 'package:flutter/material.dart';
import 'package:music_app/components/mini_player.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Search',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // search field look
            TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Song , Artist , Album",
                hintStyle: TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.white10,
                suffixIcon: Icon(Icons.search, color: Colors.white70, size: 30),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Center(
                child: Text(
                  'Search results will appear here',
                  style: TextStyle(color: Colors.white54),
                ),
              ),
            ),
            MiniPlayer(
              title: "Kwaku the Traveller",
              artist: "Black Sherif",
              imageUrl:
                  "https://images.unsplash.com/photo-1507874457470-272b3c8d8ee2?auto=format&fit=crop&w=400&q=60",
              isLiked: true,
              progress: 0.3,
            ),
          ],
        ),
      ),
    );
  }
}
