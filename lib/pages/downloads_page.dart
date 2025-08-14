import 'package:flutter/material.dart';
import 'package:music_app/Providers/navigation_index_provider.dart';
import 'package:music_app/components/mini_player.dart';
import 'package:provider/provider.dart';

class DownloadsPage extends StatelessWidget {
  const DownloadsPage({super.key});

  final List<Map<String, String>> songs = const [
    {
      'title': 'Midnight Serenade',
      'artist': 'The Night Owls',
      'image':
          'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=400&q=60',
    },
    {
      'title': 'Ocean Breeze',
      'artist': 'Liam Carter',
      'image':
          'https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0?auto=format&fit=crop&w=400&q=60',
    },
    {
      'title': 'Sunset Drive',
      'artist': 'Ethan Dubois',
      'image':
          'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?auto=format&fit=crop&w=400&q=60',
    },
    {
      'title': 'Acoustic Vibes',
      'artist': 'Ava Summers',
      'image':
          'https://images.unsplash.com/photo-1507874457470-272b3c8d8ee2?auto=format&fit=crop&w=400&q=60',
    },
    {
      'title': 'Rainy Day Jazz',
      'artist': 'Oliver Miles',
      'image':
          'https://images.unsplash.com/photo-1507878866276-a947ef722fee?auto=format&fit=crop&w=400&q=60',
    },
    {
      'title': 'Midnight Serenade',
      'artist': 'The Night Owls',
      'image':
          'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=400&q=60',
    },
    {
      'title': 'Ocean Breeze',
      'artist': 'Liam Carter',
      'image':
          'https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0?auto=format&fit=crop&w=400&q=60',
    },
    {
      'title': 'Sunset Drive',
      'artist': 'Ethan Dubois',
      'image':
          'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?auto=format&fit=crop&w=400&q=60',
    },
    {
      'title': 'Acoustic Vibes',
      'artist': 'Ava Summers',
      'image':
          'https://images.unsplash.com/photo-1507874457470-272b3c8d8ee2?auto=format&fit=crop&w=400&q=60',
    },
    {
      'title': 'Rainy Day Jazz',
      'artist': 'Oliver Miles',
      'image':
          'https://images.unsplash.com/photo-1507878866276-a947ef722fee?auto=format&fit=crop&w=400&q=60',
    },
    {
      'title': 'Midnight Serenade',
      'artist': 'The Night Owls',
      'image':
          'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=400&q=60',
    },
    {
      'title': 'Ocean Breeze',
      'artist': 'Liam Carter',
      'image':
          'https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0?auto=format&fit=crop&w=400&q=60',
    },
    {
      'title': 'Sunset Drive',
      'artist': 'Ethan Dubois',
      'image':
          'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?auto=format&fit=crop&w=400&q=60',
    },
    {
      'title': 'Acoustic Vibes',
      'artist': 'Ava Summers',
      'image':
          'https://images.unsplash.com/photo-1507874457470-272b3c8d8ee2?auto=format&fit=crop&w=400&q=60',
    },
    {
      'title': 'Rainy Day Jazz',
      'artist': 'Oliver Miles',
      'image':
          'https://images.unsplash.com/photo-1507878866276-a947ef722fee?auto=format&fit=crop&w=400&q=60',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final currentIndexProvider = Provider.of<CurrentIndexProvider>(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Center(
              child: Text(
                'Downloads',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Songs list
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left:8),
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    final song = songs[index];
                    return _songTile(
                      song['image']!,
                      song['title']!,
                      song['artist']!,
                      currentIndexProvider.setCurrentIndex,
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemCount: songs.length,
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

  Widget _songTile(
    String image,
    String title,
    String artist,
    void Function(int newIndex) setCurrentIndex,
  ) {
    return Row(
      children: [
        // Song thumbnail
        GestureDetector(
          onTap: () {
            setCurrentIndex(3);
          },
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
        // Song title and artist
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
                artist,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
        ),
        // Heart icon
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.favorite_border),
          color: Colors.white70,
        ),
        // Delete icon
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.delete_outline),
          color: Colors.white70,
        ),
      ],
    );
  }
}
