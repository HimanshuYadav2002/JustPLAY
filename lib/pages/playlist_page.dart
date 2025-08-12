import 'package:flutter/material.dart';

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
    return SafeArea(
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {},
                ),
                Expanded(
                  child: Text(
                    playlistName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 48), // to balance back button space
              ],
            ),
          ),

          // Search & Sort Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Row(
              children: [
                Expanded(
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
                SizedBox(width: 20),
                GestureDetector(
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
              ],
            ),
          ),

          // Songs List
          Expanded(
            child: ListView.builder(
              itemCount: songs.length,
              itemBuilder: (context, index) {
                final song = songs[index];
                return ListTile(
                  leading: Image.network(
                    song['image'],
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(
                    song['title'],
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    song['artist'],
                    style: TextStyle(color: Colors.white70),
                  ),
                  trailing: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: playlistName.toLowerCase() == "liked songs"
                        ? [
                            Icon(Icons.favorite, color: Colors.green,size: 30,),
                            SizedBox(width: 20),
                            Icon(
                              Icons.cloud_download_outlined,
                              color: Colors.white,
                              size: 30,
                            ),
                          ]
                        : [],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
