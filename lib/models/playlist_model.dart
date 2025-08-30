import 'package:isar/isar.dart';

part 'playlist_model.g.dart';

/// PLAYLIST MODEL
@collection
class Playlist {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true) // indexed playlist name
  late String name;

  late String imageUrl;

  // store songs as a list of ids
  final List<String> songKeys = [];

  @ignore // not persisted, derived in memory
  Set<String> get songKeySet => {...songKeys};

  Playlist({
    required this.name,
    required this.imageUrl,
    required List<String> songKeys,
  }) {
    {
      this.songKeys.addAll(songKeys);
    }
  }
}
