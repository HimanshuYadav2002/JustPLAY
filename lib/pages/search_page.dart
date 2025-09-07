import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:music_app/Providers/data_provider.dart';
import 'package:music_app/Providers/navigation_index_provider.dart';
import 'package:music_app/components/add_song_to_custom_playlist_tile.dart';
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
  bool addToCustomPlaylistButtonClicked = false;

  void toggleAddToCustomPlaylistButtonClicked() {
    setState(() {
      addToCustomPlaylistButtonClicked = !addToCustomPlaylistButtonClicked;
    });
  }

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
          imageUrl: track.thumbnails.last.url, // use first thumbnail
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
        child: Stack(
          children: [
            Column(
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
                    suffixIcon: Icon(
                      Icons.search,
                      color: Colors.white70,
                      size: 30,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                if (isLoading)
                  Expanded(
                    child: Center(child: const CircularProgressIndicator()),
                  ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: ListView.separated(
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemCount: songList.length,
                      itemBuilder: (context, i) {
                        Song song = songList[i];
                        if (widget.dataProvider
                            .getplaylistsbyName("Downloads")
                            .songKeySet
                            .contains(song.id)) {
                          song = widget.dataProvider.getSongById(song.id)!;
                        }

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
                ),
              ],
            ),
            (addToCustomPlaylistButtonClicked
                ? BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 50.0, sigmaY: 50.0),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(25),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            'Add to Playlist',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Expanded(
                          child: ListView.separated(
                            itemBuilder: (context, index) {
                              final playlist = widget.dataProvider
                                  .playlistsExcludingLikedAndDownloads()[index];
                              return AddToPlaylistTile(
                                song: widget
                                    .dataProvider
                                    .selctedSongtoAddToPlaylist!,
                                playlist: playlist,
                                currentIndexProvider:
                                    widget.currentIndexProvider,
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
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                : SizedBox()),
          ],
        ),
      ),
    );
  }
}
