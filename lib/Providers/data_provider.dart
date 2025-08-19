import 'package:flutter/material.dart';
import 'package:music_app/models/playlist_model.dart';
import 'package:music_app/models/song_model.dart';

class DataProvider with ChangeNotifier {
  final Playlist _downloads = Playlist(
    name: "Downloads",
    imageUrl:
        "https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=400&q=60",
    songIndices: [2],
  );

  Playlist get downloads => _downloads;

  Playlist? _clickedPlaylist;
  Song? _clickedSong;

  Playlist? get clickedPlaylist => _clickedPlaylist;
  Song? get clickedSong => _clickedSong;

  void setClickedPlaylist(Playlist? playlist) {
    _clickedPlaylist = playlist;
    notifyListeners();
  }

  void setClickedSong(Song? song) {
    _clickedSong = song;
    notifyListeners();
  }

  final List<Song> _songsList = [
    Song(
      id: "123",
      name: "tennu le",
      artist: "himanshu",
      imageUrl:
          "https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=400&q=60",
    ),
    Song(
      id: "456",
      name: "courtside",
      artist: "karan Aujla",
      imageUrl:
          "https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=400&q=60",
    ),
    Song(
      id: "789",
      name: "wavy",
      artist: "artist",
      imageUrl:
          "https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=400&q=60",
    ),
  ];

  final List<Playlist> _playlists = [
    Playlist(
      name: "Liked Songs",
      imageUrl:
          "https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=400&q=60",
      songIndices: [0],
    ),

    Playlist(
      name: "customPlaylist",
      imageUrl:
          "https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=400&q=60",
      songIndices: [1],
    ),
  ];

  List<Song> get songsList => _songsList;
  List<Playlist> get playlists => _playlists;

  void addToPlaylist(Playlist playlist, Song song) {
    int songIndex = _songsList.indexWhere((s) => s.id == song.id);
    if (songIndex == -1) {
      _songsList.add(song);
      songIndex = _songsList.length - 1;
    }

    playlist.songIndices.add(songIndex);

    notifyListeners();
  }

  void removeFromPlaylist(Playlist playlist, Song song) {
    int songIndex = _songsList.indexWhere((s) => s.id == song.id);

    playlist.songIndices.remove(songIndex);

    notifyListeners();
  }
}
