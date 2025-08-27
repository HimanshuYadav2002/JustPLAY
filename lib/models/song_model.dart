class Song {
  String id;
  String name;
  String artist;
  String imageUrl;
  String? downloadPath;

  Song({
    required this.id,
    required this.name,
    required this.artist,
    required this.imageUrl,
    this.downloadPath,
  });
}
