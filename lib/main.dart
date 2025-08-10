import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:just_audio/just_audio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'JustPLAY',
    home: const HomePage(),
    debugShowCheckedModeBanner: false,
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final yt = YoutubeExplode();
  final player = AudioPlayer();
  final searchController = TextEditingController();
  List<Video> results = [];
  bool isLoading = false;
  String? currentlyPlayingId;

  @override
  void dispose() {
    yt.close();
    player.dispose();
    super.dispose();
  }

  Future<void> searchVideos(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        results.clear();
      });
      return;
    }
    setState(() {
      isLoading = true;
    });

    final searchList = await yt.search.search(query);

    setState(() {
      results = searchList.toList();
      isLoading = false;
    });
  }

  Future<void> playAudio(Video video) async {
    try {
      setState(() {
        currentlyPlayingId = video.id.value;
      });
      final manifest = await yt.videos.streamsClient.getManifest(video.id);
      final audioInfo = manifest.audioOnly.withHighestBitrate();
      await player.setUrl(audioInfo.url.toString());
      await player.play();
    } catch (e) {
      debugPrint("Error playing audio: $e");
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.grey.shade400,
    appBar: AppBar(
      backgroundColor: Colors.black,
      title: const Text(
        'JustPLAY',
        style: TextStyle(
          color: Colors.lightGreenAccent,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
          fontStyle: FontStyle.italic,
          fontSize: 40,
        ),
      ),
      centerTitle: true,
    ),
    body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            controller: searchController,
            onSubmitted: searchVideos,
            decoration: InputDecoration(
              labelText: 'Search YouTube',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () => searchVideos(searchController.text),
              ),
            ),
          ),
        ),
        if (isLoading) const LinearProgressIndicator(),
        Expanded(
          child: ListView.builder(
            itemCount: results.length,
            itemBuilder: (_, i) {
              final video = results[i];
              final thumbUrl = video.thumbnails.highResUrl;
              final isPlaying = video.id.value == currentlyPlayingId;

              return ListTile(
                leading: Image.network(
                  thumbUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
                title: Text(
                  video.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(video.author),
                trailing: Icon(
                  isPlaying ? Icons.pause_circle : Icons.play_circle,
                  color: Colors.blue,
                  size: 32,
                ),
                onTap: () => playAudio(video),
              );
            },
          ),
        ),
      ],
    ),
  );
}
