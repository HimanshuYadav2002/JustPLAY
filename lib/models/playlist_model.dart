class Playlist {
  final String name;
  final String imageUrl;

  final List<String> songKeys;
  final Set<String> songKeySet;

  Playlist({
    required this.name,
    required this.imageUrl,
    List<String>? songKeys, // optional input
  }) : songKeys = songKeys ?? [], // default empty list
       songKeySet = {...?songKeys}; // build set from list
}
