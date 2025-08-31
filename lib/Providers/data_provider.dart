import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/Database/database.dart';
import 'package:music_app/Streaming_Logic/youtube_audio_source.dart';
import 'package:music_app/models/playlist_model.dart';
import 'package:music_app/models/song_model.dart';
import 'dart:io';
import 'package:music_app/Streaming_Logic/core_streaming_functions.dart';
import 'package:path/path.dart' as path;

class DataProvider with ChangeNotifier {
  final Map<String, Song> _songsList = {};

  void loadSongsFromDB() async {
    Isar db = await Database.instance;
    final allDbSongs = await db.songs.where().findAll();
    _songsList.clear();
    if (allDbSongs.isNotEmpty) {
      for (var song in allDbSongs) {
        _songsList[song.id] = song;
      }
      notifyListeners();
    }
  }

  Song? getSongById(String id) {
    return _songsList[id];
  }

  bool isSongLiked(String songID) {
    return _playlists["Liked Songs"]!.songKeySet.contains(songID);
  }

  bool isSongDownloaded(String songID) {
    return _playlists["Downloads"]!.songKeySet.contains(songID);
  }

  void toggleLikedsong(Song song) {
    if (_playlists["Liked Songs"]!.songKeySet.contains(song.id)) {
      _playlists["Liked Songs"]!.songKeys.remove(song.id);
      _playlists["Liked Songs"]!.songKeySet.remove(song.id);
      Database.updateDbPlaylist(_playlists["Liked Songs"]!);
      notifyListeners();
    } else {
      if (_songsList.containsKey(song.id)) {
        _playlists["Liked Songs"]!.songKeys.add(song.id);
        _playlists["Liked Songs"]!.songKeySet.add(song.id);
        Database.updateDbPlaylist(_playlists["Liked Songs"]!);
        notifyListeners();
      } else {
        _songsList[song.id] = song;
        _playlists["Liked Songs"]!.songKeys.add(song.id);
        _playlists["Liked Songs"]!.songKeySet.add(song.id);
        Database.addSongtoDb(song);
        Database.updateDbPlaylist(_playlists["Liked Songs"]!);
        notifyListeners();
      }
    }
  }

  String? _clickedPlaylist;
  Song? _clickedSong;

  String? get clickedPlaylist => _clickedPlaylist;
  Song? get clickedSong => _clickedSong;

  void setClickedPlaylist(Playlist? playlist) {
    _clickedPlaylist = playlist?.name;
    notifyListeners();
  }

  void setClickedPlaylistToDownloads() {
    _clickedPlaylist = "Downloads";
    notifyListeners();
  }

  void setClickedSong(Song? song) {
    _clickedSong = song;
    notifyListeners();
  }

  final Map<String, Playlist> _playlists = {
    "Liked Songs": Playlist(
      name: "Liked Songs",
      imageUrl:
          "https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=400&q=60",
      songKeys: [],
    ),
    "Downloads": Playlist(
      name: "Downloads",
      imageUrl:
          "https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=400&q=60",
      songKeys: [],
    ),
    "Gym Playlist": Playlist(
      name: "Gym Playlist",
      imageUrl:
          "https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=400&q=60",
      songKeys: [],
    ),
  };

  Playlist getplaylistsbyName(String name) {
    return _playlists[name]!;
  }

  void loadPlaylistfromDb() async {
    Isar db = await Database.instance;
    final allPlaylists = await db.playlists.where().findAll();
    if (allPlaylists.isEmpty) {
      db.writeTxn(() async {
        await db.playlists.putAll(_playlists.values.toList());
      });
    } else {
      final allDbPlaylists = await db.playlists.where().findAll();
      _playlists.clear();
      for (var playlist in allDbPlaylists) {
        _playlists[playlist.name] = playlist;
      }
      notifyListeners();
    }
  }

  List<Playlist> playlistsExcludingDownloads() {
    final playlistsCopy = Map.of(_playlists);
    playlistsCopy.remove("Downloads");
    return playlistsCopy.values.toList();
  }

  List<Playlist> playlistsExcludingLikedAndDownloads() {
    final playlistsCopy = Map.of(_playlists);
    playlistsCopy.remove("Liked Songs");
    playlistsCopy.remove("Downloads");
    return playlistsCopy.values.toList();
  }

  // this function is mainly used to add songs to custom playlist
  void addToPlaylist(Playlist playlist, Song song) {
    if (!_songsList.containsKey(song.id)) {
      _songsList[song.id] = song;
      playlist.songKeys.add(song.id);
      playlist.songKeySet.add(song.id);
      Database.addSongtoDb(song);
      Database.updateDbPlaylist(playlist);
      notifyListeners();
    } else if (!playlist.songKeySet.contains(song.id)) {
      playlist.songKeys.add(song.id);
      playlist.songKeySet.add(song.id);
      Database.updateDbPlaylist(playlist);
      notifyListeners();
    }
  }

  // this function is mainly used to remove songs to custom playlist
  void removeFromPlaylist(Playlist playlist, Song song) {
    playlist.songKeys.remove(song.id);
    playlist.songKeySet.remove(song.id);
    Database.updateDbPlaylist(playlist);
    notifyListeners();
  }

  Future<void> downloadSong(Song song) async {
    final CoreStreamingFunctions streamingFunctions = CoreStreamingFunctions();
    try {
      final streamInfo = await streamingFunctions.getStreamInfo(song.id);

      int start = 0;
      int end = streamInfo.size.totalBytes;

      Stream<List<int>> stream = streamingFunctions.getStream(
        streamInfo,
        start: start,
        end: end,
      );

      // Prepare save path
      final dir = Directory('/storage/emulated/0/Download/JustPlay');
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      // Save file with .m4a extension
      final filePath = path.join(dir.path, '${song.id}.m4a');
      final file = File(filePath);

      // Open write stream
      var fileStream = file.openWrite();

      // Pipe youtube stream → file
      await stream.pipe(fileStream);

      await fileStream.flush();
      await fileStream.close();

      addToPlaylist(getplaylistsbyName("Downloads"), song);
      Song currentsong = getSongById(song.id)!;
      currentsong.downloadPath = filePath;
      Database.addSongtoDb(currentsong);
      notifyListeners();
    } catch (e) {}
  }

  final _musicPlayer = AudioPlayer();
  AudioPlayer get musicPlayer => _musicPlayer;

  Future<void> playAudio(Song song) async {
    _musicPlayer.stop();
    _musicPlayer.clearAudioSources();
    if (song.downloadPath == "") {
      final audioSource = YoutubeAudioSource(videoId: song.id);
      await _musicPlayer.setAudioSource(audioSource);
    } else {
      _musicPlayer.setFilePath(getSongById(song.id)!.downloadPath ?? "");
      for (var i = 0; i < 10; i++) {
        print("playing by file ");
      }
    }
    togglePlayPause();
    _musicPlayer.play();
  }

  void togglePlayPause() {
    _musicPlayer.playing ? _musicPlayer.pause() : _musicPlayer.play();
    notifyListeners();
  }

  Song? _selctedSongtoAddToPlaylist;
  Song? get selctedSongtoAddToPlaylist => _selctedSongtoAddToPlaylist;

  void setSelctedSongtoAddToPlaylist(Song song) {
    _selctedSongtoAddToPlaylist = song;
    notifyListeners();
  }
}
