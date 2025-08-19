import 'package:flutter/material.dart';
import 'package:music_app/models/playlist_model.dart';
import 'package:music_app/models/song_model.dart';

class DataProvider with ChangeNotifier {
  final List<Song> _songsList = [];
  List<Song> get songsList => _songsList;

  final Playlist _likedSongs = Playlist(
    name: "Liked Songs",
    imageUrl:
        "https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=400&q=60",
    songIndices: [],
  );
  final Playlist _downloads = Playlist(
    name: "Downloads",
    imageUrl:
        "https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=400&q=60",
    songIndices: [],
  );

  Playlist get downloads => _downloads;
  Playlist get likedSongs => _likedSongs;

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

  final Map<String, Playlist> _customPlaylists = {
    "": Playlist(
      name: "Gym Playlist",
      imageUrl:
          "https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=400&q=60",
      songIndices: [],
    ),
  };
  Iterable<Playlist> get customPlaylists => _customPlaylists.values;

  List<Playlist> allPlaylists() {
    return [_likedSongs, ..._customPlaylists.values];
  }

  void addToPlaylist(Playlist playlist, Song song) {
    int songIndex = _songsList.indexWhere((s) => s.id == song.id);
    if (songIndex == -1) {
      _songsList.add(song);
      songIndex = _songsList.length - 1;
      playlist.songIndices.add(songIndex);
      notifyListeners();
    } else if (!playlist.songIndices.contains(songIndex)) {
      playlist.songIndices.add(songIndex);
      notifyListeners();
    }
  }

  void removeFromPlaylist(Playlist playlist, Song song) {
    int songIndex = _songsList.indexWhere((s) => s.id == song.id);

    playlist.songIndices.remove(songIndex);

    notifyListeners();
  }
}
