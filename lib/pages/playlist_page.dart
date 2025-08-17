import 'package:flutter/material.dart';
import 'package:music_app/Providers/navigation_index_provider.dart';
import 'package:provider/provider.dart';

class PlaylistPage extends StatelessWidget {
  final String playlistName;

  PlaylistPage({required this.playlistName});

  final List<Map<String, dynamic>> songs = [
    {
      'title': '7 Minutes',
      'artist': 'Dean Lewis',
      'image':
          'https://images.unsplash.com/photo-1500917293891-ef795e70e1f6?auto=format&fit=crop&w=400&q=60',
      'lyrics': true,
      'explicit': false,
    },
    {
      'title': 'Song 2',
      'artist': 'Artist 2',
      'image':
          'https://images.unsplash.com/photo-1507878866276-a947ef722fee?auto=format&fit=crop&w=400&q=60',
      'lyrics': true,
      'explicit': true,
    },
    {
      'title': 'Song 3',
      'artist': 'Artist 3',
      'image':
          'https://images.unsplash.com/photo-1497032628192-86f99bcd76bc?auto=format&fit=crop&w=400&q=60',
      'lyrics': false,
      'explicit': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final currentIndexProvider = Provider.of<CurrentIndexProvider>(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
        child: Column(
          children: [
            Center(
              child: Text(
                playlistName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20),

            // Search & Sort Row
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Find in ${playlistName.toLowerCase()}",
                      hintStyle: TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.white10,
                      prefixIcon: Icon(Icons.search, color: Colors.white70),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      alignment: Alignment.center,
                      width: 60,
                      height: 55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white10,
                      ),
                      child: Text(
                        "Sort",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Songs List
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ListView.separated(
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemCount: songs.length,
                  itemBuilder: (context, index) {
                    final song = songs[index];
                    return _songTile(
                      song['image'],
                      song['title'],
                      song['artist'],
                      currentIndexProvider.setCurrentIndex,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _songTile(
    String image,
    String title,
    String subtitle,
    void Function(int newIndex) setCurrentIndex,
  ) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => setCurrentIndex(4),
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(image),
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
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: playlistName.toLowerCase() == "liked songs"
              ? [
                  Icon(Icons.favorite, color: Colors.green, size: 30),
                  SizedBox(width: 20),
                  Icon(
                    Icons.cloud_download_outlined,
                    color: Colors.white,
                    size: 30,
                  ),
                ]
              : [
                  Icon(Icons.favorite, color: Colors.green, size: 30),
                  SizedBox(width: 20),
                  Icon(
                    Icons.cloud_download_outlined,
                    color: Colors.white,
                    size: 30,
                  ),
                  SizedBox(width: 20),
                  Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 30,
                  ),
                ],
        ),
      ],
    );
  }
}
