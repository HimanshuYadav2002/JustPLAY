import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/Database/database.dart';
import 'package:music_app/Streaming_Logic/youtube_audio_source.dart';
import 'package:music_app/models/playlist_model.dart';
import 'package:music_app/models/song_model.dart';
import 'dart:io';
import 'package:music_app/Streaming_Logic/core_streaming_functions.dart';
import 'package:music_app/recommendation_logic/next_song_list.dart';
import 'package:path/path.dart' as path;
import 'dart:math';

/// Generates a random index different from [currentIndex].
int getRandomSongIndex(int currentIndex, int queueLength) {
  if (queueLength <= 1) {
    throw ArgumentError("Queue must contain at least 2 songs.");
  }

  final random = Random();
  int newIndex;

  do {
    newIndex = random.nextInt(queueLength); // generates 0..queueLength-1
  } while (newIndex == currentIndex);

  return newIndex;
}

class DataProvider with ChangeNotifier {
  DataProvider() {
    _musicPlayer.playerStateStream.listen((state) async {
      if (state.processingState != ProcessingState.completed) return;

      if (_shuffleMode) {
        final nextIndex = getRandomSongIndex(
          _currentPlayingIndex,
          _songQueue.length,
        );
        await _playSongAtIndex(nextIndex);
      } else if (_repeatMode) {
        await _musicPlayer.seek(Duration.zero);
        await _musicPlayer.play();
      } else {
        await playNext();
      }
    });
  }

  final _musicPlayer = AudioPlayer();
  AudioPlayer get musicPlayer => _musicPlayer;

  Map<String, Song> _songQueue = {};
  List<Song> get songQueue => _songQueue.values.toList();
  int _currentPlayingIndex = 0;

  void setSongQueue(Map<String, Song> queue) {
    _songQueue = queue;
    notifyListeners();
  }

  void setCurrentPlayingIndex(int value) {
    _currentPlayingIndex = value;
    notifyListeners();
  }

  /// ✅ Centralized function to play a song at given index
  Future<void> _playSongAtIndex(int index) async {
    final queueList = _songQueue.values.toList();
    if (index < 0 || index >= queueList.length) return;

    setCurrentPlayingIndex(index);
    setClickedSong(queueList[index]);

    final song = queueList[index];
    if (song.downloadPath == null || song.downloadPath!.isEmpty) {
      await _musicPlayer.setAudioSource(YoutubeAudioSource(videoId: song.id));
    } else {
      await _musicPlayer.setAudioSource(
        AudioSource.uri(Uri.file(song.downloadPath!)),
      );
    }
    await _musicPlayer.play();
  }

  /// ✅ Unified play next
  Future<void> playNext() async {
    if (_currentPlayingIndex < _songQueue.length - 1) {
      await _playSongAtIndex(_currentPlayingIndex + 1);
    }
  }

  /// ✅ Unified play previous
  Future<void> playPrevious() async {
    if (_currentPlayingIndex > 0) {
      await _playSongAtIndex(_currentPlayingIndex - 1);
    }
  }

  /// ✅ Play selected song (used in navigation: home, playlist, recommendations)
  Future<void> playAudio(Song song, int navigationIndex) async {
    if (_musicPlayer.playing) await _musicPlayer.pause();

    if (navigationIndex != 3) {
      setSongQueue({});
      setCurrentPlayingIndex(0);
    }

    if (navigationIndex == 3) {
      // play from existing queue
      final index = _songQueue.keys.toList().indexOf(song.id);
      await _playSongAtIndex(index);
      return;
    }

    if (navigationIndex == 1) {
      // play from recommendations
      setClickedSong(null);
      setLoadingSongId(song.id);
      Map<String, Song> queue = await getRecomendedSongs(songId: song.id);
      setSongQueue(queue);
      setLoadingSongId("");
      await _playSongAtIndex(0);
      return;
    }

    if (navigationIndex == 2) {
      // play from playlist
      Map<String, Song> playlistSongqueue = {};
      for (String key
          in _playlists[_clickedPlaylist]!.songKeys.toList().sublist(
            _playlists[_clickedPlaylist]!.songKeys.toList().indexOf(song.id),
          )) {
        playlistSongqueue[key] = _songsList[key]!;
      }
      setSongQueue(playlistSongqueue);
      await _playSongAtIndex(0);
      return;
    }

    // fallback direct play
    await _playSongAtIndex(0);
  }

  // ================================
  // SONGS & PLAYLIST MANAGEMENT
  // ================================
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

  Song? getSongById(String id) => _songsList[id];

  bool isSongLiked(String songID) =>
      _playlists["Liked Songs"]!.songKeySet.contains(songID);

  bool isSongDownloaded(String songID) =>
      _playlists["Downloads"]!.songKeySet.contains(songID);

  void toggleLikedsong(Song song) {
    if (_playlists["Liked Songs"]!.songKeySet.contains(song.id)) {
      _playlists["Liked Songs"]!.songKeys.remove(song.id);
      _playlists["Liked Songs"]!.songKeySet.remove(song.id);
      Database.updateDbPlaylist(_playlists["Liked Songs"]!);
    } else {
      if (_songsList.containsKey(song.id)) {
        _playlists["Liked Songs"]!.songKeys.add(song.id);
        _playlists["Liked Songs"]!.songKeySet.add(song.id);
        Database.updateDbPlaylist(_playlists["Liked Songs"]!);
      } else {
        _songsList[song.id] = song;
        _playlists["Liked Songs"]!.songKeys.add(song.id);
        _playlists["Liked Songs"]!.songKeySet.add(song.id);
        Database.addSongtoDb(song);
        Database.updateDbPlaylist(_playlists["Liked Songs"]!);
      }
    }
    notifyListeners();
  }

  String? _clickedPlaylist;
  Song? _clickedSong;
  String _loadingSongId = "";

  String? get clickedPlaylist => _clickedPlaylist;
  Song? get clickedSong => _clickedSong;
  String get loadingSongId => _loadingSongId;

  void setClickedPlaylist(String playlist) {
    _clickedPlaylist = playlist;
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

  void setLoadingSongId(String id) {
    _loadingSongId = id;
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

  Playlist getplaylistsbyName(String name) => _playlists[name]!;

  void loadPlaylistfromDb() async {
    Isar db = await Database.instance;
    final allPlaylists = await db.playlists.where().findAll();
    if (allPlaylists.isEmpty) {
      db.writeTxn(() async {
        await db.playlists.putAll(_playlists.values.toList());
      });
    } else {
      _playlists.clear();
      for (var playlist in allPlaylists) {
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

  void addToPlaylist(Playlist playlist, Song song) {
    if (!_songsList.containsKey(song.id)) {
      _songsList[song.id] = song;
      playlist.songKeys.add(song.id);
      playlist.songKeySet.add(song.id);
      Database.addSongtoDb(song);
      Database.updateDbPlaylist(playlist);
    } else if (!playlist.songKeySet.contains(song.id)) {
      playlist.songKeys.add(song.id);
      playlist.songKeySet.add(song.id);
      Database.updateDbPlaylist(playlist);
    }
    notifyListeners();
  }

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

      final dir = Directory('/storage/emulated/0/Download/JustPlay');
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      final filePath = path.join(dir.path, '${song.id}.m4a');
      final file = File(filePath);

      var fileStream = file.openWrite();
      await stream.pipe(fileStream);
      await fileStream.flush();
      await fileStream.close();

      addToPlaylist(getplaylistsbyName("Downloads"), song);
      Song currentSong = getSongById(song.id)!;
      currentSong.downloadPath = filePath;
      Database.addSongtoDb(currentSong);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }

  // ================================
  // PLAYER STATE
  // ================================
  bool _shuffleMode = false;
  bool _repeatMode = false;
  bool get shuffleMode => _shuffleMode;
  bool get repeatMode => _repeatMode;

  void toggleShuffleMode() {
    _shuffleMode = !_shuffleMode;
    if (_repeatMode) _repeatMode = false;
    notifyListeners();
  }

  void toggleRepeatMode() {
    _repeatMode = !_repeatMode;
    if (_shuffleMode) _shuffleMode = false;
    notifyListeners();
  }

  void togglePlayPause() {
    _musicPlayer.playing ? _musicPlayer.pause() : _musicPlayer.play();
    notifyListeners();
  }

  // ================================
  // MISC
  // ================================
  Song? _selctedSongtoAddToPlaylist;
  Song? get selctedSongtoAddToPlaylist => _selctedSongtoAddToPlaylist;

  void setSelctedSongtoAddToPlaylist(Song song) {
    _selctedSongtoAddToPlaylist = song;
    notifyListeners();
  }
}
