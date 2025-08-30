import 'package:isar/isar.dart';
import 'package:music_app/models/playlist_model.dart';
import 'package:music_app/models/song_model.dart';
import 'package:path_provider/path_provider.dart';

class Database {
  static Isar? _isar;

  static Future<Isar> get instance async {
    _isar ??= await Isar.open([
      SongSchema,
      PlaylistSchema,
    ], directory: (await getApplicationDocumentsDirectory()).path);
    return _isar!;
  }

  static void addSongtoDb(Song song) async {
    await _isar?.writeTxn(() async {
      await _isar?.songs.put(song);
    });
  }

  static void addSongtoDbPlaylist(Playlist playlist, Song song) async {
    final targetPlaylist = await _isar?.playlists.getByName(playlist.name);
    targetPlaylist!.songKeys.add(song.id);
    await _isar?.writeTxn(() async {
      await _isar?.playlists.put(targetPlaylist);
    });
  }
}
