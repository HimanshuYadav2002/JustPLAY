import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/Streaming_Logic/yt_audio_stream.dart';
import 'package:music_app/models/playlist_model.dart';
import 'package:music_app/models/song_model.dart';

class DataProvider with ChangeNotifier {
  final Map<String, Song> _songsList = {};

  Song? getSongById(String? id) {
    return _songsList[id];
  }

  final Playlist _likedSongs = Playlist(
    name: "Liked Songs",
    imageUrl:
        "https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=400&q=60",
    songKeys: [],
  );
  final Playlist _downloads = Playlist(
    name: "Downloads",
    imageUrl:
        "https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=400&q=60",
    songKeys: [],
  );

  bool isSongLiked(String songID) {
    return _likedSongs.songKeySet.contains(songID);
  }

  bool isSongDownloaded(String songID) {
    return _downloads.songKeySet.contains(songID);
  }

  void toggleLikedsong(Song song) {
    if (_likedSongs.songKeySet.contains(song.id)) {
      _likedSongs.songKeys.remove(song.id);
      _likedSongs.songKeySet.remove(song.id);
      notifyListeners();
    } else {
      if (_songsList.containsKey(song.id)) {
        _likedSongs.songKeys.add(song.id);
        _likedSongs.songKeySet.add(song.id);
        notifyListeners();
      } else {
        _songsList[song.id] = song;
        _likedSongs.songKeys.add(song.id);
        _likedSongs.songKeySet.add(song.id);
        notifyListeners();
      }
    }
  }

  Playlist? _clickedPlaylist;
  Song? _clickedSong;

  Playlist? get clickedPlaylist => _clickedPlaylist;
  Song? get clickedSong => _clickedSong;

  void setClickedPlaylist(Playlist? playlist) {
    _clickedPlaylist = playlist;
    notifyListeners();
  }

  void setClickedPlaylistToDownloads() {
    _clickedPlaylist = _downloads;
    notifyListeners();
  }

  void setClickedSong(Song? song) {
    _clickedSong = song;
    notifyListeners();
  }

  final Map<String, Playlist> _customPlaylists = {
    "Gym Playlist": Playlist(
      name: "Gym Playlist",
      imageUrl:
          "https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=400&q=60",
      songKeys: [],
    ),
  };
  Map<String, Playlist> get customPlaylists => _customPlaylists;

  List<Playlist> allPlaylists() {
    return [_likedSongs, ..._customPlaylists.values];
  }

  // this function is mainly used to add songs to custom playlist
  void addToPlaylist(Playlist playlist, Song song) {
    if (!_songsList.containsKey(song.id)) {
      _songsList[song.id] = song;
      playlist.songKeys.add(song.id);
      playlist.songKeySet.add(song.id);
      notifyListeners();
    } else if (!playlist.songKeySet.contains(song.id)) {
      playlist.songKeys.add(song.id);
      playlist.songKeySet.add(song.id);
      notifyListeners();
    }
  }

  // this function is mainly used to remove songs to custom playlist
  void removeFromPlaylist(Playlist playlist, Song song) {
    playlist.songKeys.remove(song.id);
    playlist.songKeySet.remove(song.id);
    notifyListeners();
  }

  final _musicPlayer = AudioPlayer();
  AudioPlayer get musicPlayer => _musicPlayer;

  Future<void> playAudio(Song song) async {
    _musicPlayer.stop();
    _musicPlayer.clearAudioSources();
    final audioSource = YouTubeAudioSource(videoId: song.id);
    await _musicPlayer.setAudioSource(audioSource);
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
