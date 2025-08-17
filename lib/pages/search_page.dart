import 'package:flutter/material.dart';
import 'package:music_app/components/mini_player.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:just_audio/just_audio.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
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
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Search',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // search field look
            TextField(
              controller: searchController,
              onSubmitted: searchVideos,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Song , Artist , Album",
                hintStyle: TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.white10,
                suffixIcon: Icon(Icons.search, color: Colors.white70, size: 30),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            if (isLoading) const LinearProgressIndicator(),
            const SizedBox(height: 20),
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
            MiniPlayer(
              title: "Kwaku the Traveller",
              artist: "Black Sherif",
              imageUrl:
                  "https://images.unsplash.com/photo-1507874457470-272b3c8d8ee2?auto=format&fit=crop&w=400&q=60",
              isLiked: true,
              progress: 0.3,
            ),
          ],
        ),
      ),
    );
  }
}
