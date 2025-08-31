import 'package:isar/isar.dart';

part 'song_model.g.dart';

/// SONG MODEL
@collection
class Song {
  Id isarId = Isar.autoIncrement; // internal Isar id

  @Index(unique: true) // indexed song id for fast lookup
  late String id;
  late String name;
  late String artist;
  late String imageUrl;
  String? downloadPath = "";

  Song({
    required this.id,
    required this.name,
    required this.artist,
    required this.imageUrl,
  });
}
