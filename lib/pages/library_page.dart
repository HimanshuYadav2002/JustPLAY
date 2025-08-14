import 'package:flutter/material.dart';
import 'package:music_app/Providers/navigation_index_provider.dart';
import 'package:music_app/components/mini_player.dart';
import 'package:provider/provider.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  final List<Map<String, String>> items = const [
    {
      'title': 'Liked Songs',
      'subtitle': '483 Songs',
      'image':
          'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=400&q=60',
    },
    {
      'title': 'New Episodes',
      'subtitle': 'Updated 2 days ago',
      'image':
          'https://images.unsplash.com/photo-1519681393784-d120267933ba?auto=format&fit=crop&w=400&q=60',
    },
    {
      'title': 'My life is a movie',
      'subtitle': 'Playlist · Liam Carter',
      'image':
          'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?auto=format&fit=crop&w=400&q=60',
    },
    {
      'title': 'Your Top Songs 2022',
      'subtitle': 'Playlist',
      'image':
          'https://images.unsplash.com/photo-1500917293891-ef795e70e1f6?auto=format&fit=crop&w=400&q=60',
    },
    {
      'title': 'Acoustic Chill',
      'subtitle': 'Playlist',
      'image':
          'https://images.unsplash.com/photo-1497032628192-86f99bcd76bc?auto=format&fit=crop&w=400&q=60',
    },
    {
      'title': 'Amour de lycee',
      'subtitle': 'Playlist · Ethan Dubois',
      'image':
          'https://images.unsplash.com/photo-1507878866276-a947ef722fee?auto=format&fit=crop&w=400&q=60',
    },
    {
      'title': 'Liked Songs',
      'subtitle': '483 Songs',
      'image':
          'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=400&q=60',
    },
    {
      'title': 'New Episodes',
      'subtitle': 'Updated 2 days ago',
      'image':
          'https://images.unsplash.com/photo-1519681393784-d120267933ba?auto=format&fit=crop&w=400&q=60',
    },
    {
      'title': 'My life is a movie',
      'subtitle': 'Playlist · Liam Carter',
      'image':
          'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?auto=format&fit=crop&w=400&q=60',
    },
    {
      'title': 'Your Top Songs 2022',
      'subtitle': 'Playlist',
      'image':
          'https://images.unsplash.com/photo-1500917293891-ef795e70e1f6?auto=format&fit=crop&w=400&q=60',
    },
    {
      'title': 'Acoustic Chill',
      'subtitle': 'Playlist',
      'image':
          'https://images.unsplash.com/photo-1497032628192-86f99bcd76bc?auto=format&fit=crop&w=400&q=60',
    },
    {
      'title': 'Amour de lycee',
      'subtitle': 'Playlist · Ethan Dubois',
      'image':
          'https://images.unsplash.com/photo-1507878866276-a947ef722fee?auto=format&fit=crop&w=400&q=60',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final currentIndexProvider = Provider.of<CurrentIndexProvider>(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 10, top: 20, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Center(
              child: Text(
                'Your Library',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // pills row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [_pill('Playlists'), _pill('Albums'), _pill('Artists')],
            ),

            const SizedBox(height: 20),
            // list of playlists
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    final it = items[index];
                    return _libraryTile(
                      it['image']!,
                      it['title']!,
                      it['subtitle']!,
                      currentIndexProvider.setCurrentIndex,
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemCount: items.length,
                ),
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

  Widget _pill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white70, fontSize: 15),
      ),
    );
  }

  Widget _libraryTile(
    String image,
    String title,
    String subtitle,
    void Function(int newIndex) setCurrentIndex,
  ) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => setCurrentIndex(4),
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
        ),
        const Icon(Icons.more_vert, color: Colors.white54),
      ],
    );
  }
}
