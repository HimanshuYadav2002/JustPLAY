import 'package:flutter/material.dart';
import 'package:music_app/Providers/data_provider.dart';
import 'package:music_app/Providers/navigation_index_provider.dart';
import 'package:music_app/components/mini_player.dart';
import 'package:music_app/components/song_tile.dart';
import 'package:music_app/models/song_model.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:just_audio/just_audio.dart';
import 'package:dart_ytmusic_api/yt_music.dart';

class SearchPage extends StatefulWidget {
  final CurrentIndexProvider currentIndexProvider;
  final DataProvider dataProvider;
  const SearchPage({
    super.key,
    required this.currentIndexProvider,
    required this.dataProvider,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final ytmusicapi = YTMusic();

  final yt = YoutubeExplode();
  final player = AudioPlayer();
  final searchController = TextEditingController();
  List<Video> results = [];
  List<Song> songList = [];
  bool isLoading = false;
  String? currentlyPlayingId;

  @override
  void initState() {
    super.initState();
    initYTMusic();
  }

  Future<void> initYTMusic() async {
    await ytmusicapi.initialize(); // this loads the API key & configs
  }

  Future<void> searchSongs(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        songList.clear();
      });
      return;
    }

    setState(() {
      isLoading = true;
      songList.clear();
    });

    // 🔹 Fetch songs (audio tracks only) from YouTube Music
    final searchResults = await ytmusicapi.searchSongs(query);

    setState(() {
      songList = searchResults.take(10).map((track) {
        return Song(
          id: track.videoId, // YT Music song/video ID
          name: track.name,
          artist: track.artist.name,
          imageUrl: track.thumbnails.first.url, // use first thumbnail
        );
      }).toList();
      isLoading = false;
    });
  }

  

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
              controller: searchController,
              onSubmitted: searchSongs,
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
            if (isLoading)
              Expanded(child: Center(child: const CircularProgressIndicator())),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: ListView.separated(
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemCount: songList.length,
                  itemBuilder: (context, i) {
                    final song = songList[i];

                    return SongTile(
                      song: song,
                      currentIndexProvider: widget.currentIndexProvider,
                      dataProvider: widget.dataProvider,
                    );
                  },
                ),
              ),
            ),
            (widget.dataProvider.clickedSong != null)
                ? MiniPlayer(
                    song: widget.dataProvider.clickedSong!,
                    currentIndexProvider: widget.currentIndexProvider,
                    dataProvider: widget.dataProvider,
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
