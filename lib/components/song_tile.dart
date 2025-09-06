import 'dart:io';

import 'package:flutter/material.dart';
import 'package:music_app/Database/database.dart';
import 'package:music_app/Providers/navigation_index_provider.dart';
import 'package:music_app/models/song_model.dart';
import 'package:music_app/Providers/data_provider.dart';

class SongTile extends StatefulWidget {
  final Song? song;
  final VoidCallback? toggleAddToCustomPlaylistButtonClicked;
  final CurrentIndexProvider currentIndexProvider;
  final DataProvider dataProvider;

  const SongTile({
    super.key,
    this.toggleAddToCustomPlaylistButtonClicked,
    required this.song,
    required this.currentIndexProvider,
    required this.dataProvider,
  });

  @override
  State<SongTile> createState() => _SongTileState();
}

class _SongTileState extends State<SongTile> {
  var isdownloading = false;

  List<Widget> rightIcons(BuildContext context) {
    if (widget.dataProvider.clickedPlaylist?.toLowerCase() ==
            "liked songs" ||
        widget.currentIndexProvider.navigationCurrentIndex == 3) {
      return [
        IconButton(
          onPressed: () {
            widget.dataProvider.toggleLikedsong(widget.song!);
          },
          icon: widget.dataProvider.isSongLiked(widget.song!.id)
              ? Icon(Icons.favorite, color: Colors.green, size: 30)
              : Icon(Icons.favorite_outline, color: Colors.white, size: 30),
        ),

        IconButton(
          onPressed: () async {
            setState(() {
              isdownloading = true;
            });
            await widget.dataProvider.downloadSong(widget.song!);
            setState(() {
              isdownloading = false;
            });
          },
          icon: isdownloading
              ? Icon(Icons.downloading, color: Colors.green, size: 30)
              : !widget.dataProvider
                    .getplaylistsbyName("Downloads")
                    .songKeySet
                    .contains(widget.song!.id)
              ? Icon(Icons.downloading, color: Colors.white, size: 30)
              : Icon(
                  Icons.download_done_rounded,
                  color: Colors.green,
                  size: 30,
                ),
        ),
      ];
    }
    else if (widget.currentIndexProvider.currentIndex == 1) {
      return [
        IconButton(
          onPressed: () {
            widget.dataProvider.toggleLikedsong(widget.song!);
          },
          icon: widget.dataProvider.isSongLiked(widget.song!.id)
              ? Icon(Icons.favorite, color: Colors.green, size: 30)
              : Icon(Icons.favorite_outline, color: Colors.white, size: 30),
        ),

        IconButton(
          onPressed: () async {
            if (!widget.dataProvider
                .getplaylistsbyName("Downloads")
                .songKeySet
                .contains(widget.song!.id)) {
              setState(() {
                isdownloading = true;
              });
              await widget.dataProvider.downloadSong(widget.song!);
              setState(() {
                isdownloading = false;
              });
            }
          },
          icon: isdownloading
              ? Icon(Icons.downloading, color: Colors.green, size: 30)
              : !widget.dataProvider
                    .getplaylistsbyName("Downloads")
                    .songKeySet
                    .contains(widget.song!.id)
              ? Icon(Icons.downloading, color: Colors.white, size: 30)
              : Icon(
                  Icons.download_done_rounded,
                  color: Colors.green,
                  size: 30,
                ),
        ),

        IconButton(
          onPressed: () {
            widget.toggleAddToCustomPlaylistButtonClicked!();
            widget.dataProvider.setSelctedSongtoAddToPlaylist(widget.song!);
          },
          icon: Icon(Icons.add, color: Colors.white, size: 30),
        ),
      ];
    } else if (widget.dataProvider.clickedPlaylist?.toLowerCase() ==
        "downloads") {
      return [
        IconButton(
          onPressed: () {
            widget.dataProvider.toggleLikedsong(widget.song!);
          },
          icon: widget.dataProvider.isSongLiked(widget.song!.id)
              ? Icon(Icons.favorite, color: Colors.green, size: 30)
              : Icon(Icons.favorite_outline, color: Colors.white, size: 30),
          color: Colors.white70,
        ),
        // Delete icon
        IconButton(
          onPressed: () async {
            widget.dataProvider.removeFromPlaylist(
              widget.dataProvider.getplaylistsbyName("Downloads"),
              widget.dataProvider.getSongById(widget.song!.id)!,
            );
            Song? song = widget.dataProvider.getSongById(widget.song!.id);
            await File(song!.downloadPath.toString()).delete();
            song.downloadPath = "";
            Database.addSongtoDb(song);
          },
          icon: const Icon(Icons.delete_outline, color: Colors.red, size: 30),
          color: Colors.white70,
        ),
      ];
    } else {
      return [
        IconButton(
          onPressed: () {
            widget.dataProvider.toggleLikedsong(widget.song!);
          },
          icon: widget.dataProvider.isSongLiked(widget.song!.id)
              ? Icon(Icons.favorite, color: Colors.green, size: 30)
              : Icon(Icons.favorite_outline, color: Colors.white, size: 30),
        ),

        IconButton(
          onPressed: () async {
            setState(() {
              isdownloading = true;
            });
            await widget.dataProvider.downloadSong(widget.song!);
            setState(() {
              isdownloading = false;
            });
          },
          icon: isdownloading
              ? Icon(Icons.downloading, color: Colors.green, size: 30)
              : !widget.dataProvider
                    .getplaylistsbyName("Downloads")
                    .songKeySet
                    .contains(widget.song!.id)
              ? Icon(Icons.downloading, color: Colors.white, size: 30)
              : Icon(
                  Icons.download_done_rounded,
                  color: Colors.green,
                  size: 30,
                ),
        ),

        IconButton(
          onPressed: () {
            widget.dataProvider.removeFromPlaylist(
              widget.dataProvider.getplaylistsbyName(
                widget.dataProvider.clickedPlaylist!,
              ),
              widget.song!,
            );
          },
          icon: Icon(Icons.close, color: Colors.red, size: 30),
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.dataProvider.playAudio(
          widget.song!,widget.currentIndexProvider.navigationCurrentIndex
        );
      },
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(widget.song!.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  overflow: TextOverflow.ellipsis,
                  widget.song!.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  overflow: TextOverflow.ellipsis,
                  widget.song!.artist,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: rightIcons(context),
          ),
        ],
      ),
    );
  }
}
