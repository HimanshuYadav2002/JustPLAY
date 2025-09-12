import 'package:isar/isar.dart';
import 'package:music_app/models/playlist_model.dart';
import 'package:music_app/models/song_model.dart';
import 'package:music_app/models/user_model.dart';
import 'package:path_provider/path_provider.dart';

class Database {
  static Isar? _isar;

  static Future<Isar> get instance async {
    _isar ??= await Isar.open([
      SongSchema,
      PlaylistSchema,
      UserSchema,
    ], directory: (await getApplicationDocumentsDirectory()).path);
    return _isar!;
  }

  static Future<void> addSongtoDb(Song song) async {
    final isar = await instance;
    await isar.writeTxn(() async {
      await isar.songs.put(song);
    });
  }

  static Future<void> updateDbPlaylist(Playlist playlist) async {
    final isar = await instance;
    await isar.writeTxn(() async {
      await isar.playlists.put(playlist);
    });
  }

  // ---------- User related helpers ----------
  static Future<void> upsertUser(User user) async {
    final isar = await instance;
    await isar.writeTxn(() async {
      final existing = await isar.users
          .filter()
          .uidEqualTo(user.uid)
          .findFirst();
      if (existing != null) {
        user.isarId = existing.isarId; // keep same primary key
      }
      await isar.users.put(user); // update or insert
    });
  }

  static Future<User?> getUserByUid(String uid) async {
    final isar = await instance;
    final q = await isar.users.filter().uidEqualTo(uid).findFirst();
    return q;
  }

  static Future<User?> getAnyUser() async {
    final isar = await instance;
    final users = await isar.users.where().findAll();
    if (users.isEmpty) return null;
    return users.first;
  }

  static Future<void> deleteUserByUid(String uid) async {
    final isar = await instance;
    await isar.writeTxn(() async {
      final u = await isar.users.filter().uidEqualTo(uid).findFirst();
      if (u != null) await isar.users.delete(u.isarId);
    });
  }

  /// Clears all local app data: songs, playlists, user.
  static Future<void> clearAllLocalData() async {
    final isar = await instance;
    await isar.writeTxn(() async {
      await isar.songs.clear();
      await isar.playlists.clear();
      await isar.users.clear();
    });
  }
}
