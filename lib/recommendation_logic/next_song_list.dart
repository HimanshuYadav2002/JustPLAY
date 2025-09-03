import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:music_app/models/song_model.dart';

Future<Map<String, Song>> getRecomendedSongs({String? songId}) async {
  final url = Uri.parse(
    'https://music.youtube.com/youtubei/v1/next?alt=json&key=AIzaSyC9XL3ZjWddXya6X74dJoCTL-WEYFDNX30',
  );

  final headers = {
    'Content-Type': 'application/json',
    'User-Agent': 'Mozilla/5.0',
    'Origin': 'https://music.youtube.com',
    'Referer': 'https://music.youtube.com',
  };

  final body = {
    "context": {
      "client": {
        "clientName": "WEB_REMIX",
        "clientVersion": "1.20230620.01.00",
      },
    },
    "videoId": songId,
    "playlistId": "RDAMVM$songId",
    "enablePersistentPlaylistPanel": true,
    "isAudioOnly": true,
    "tunerSettingValue": "AUTOMIX_SETTING_NORMAL",
  };

  final response = await http.post(
    url,
    headers: headers,
    body: jsonEncode(body),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to fetch next songs: ${response.statusCode}');
  }

  final data = jsonDecode(response.body);

  final contents =
      data['contents']?['singleColumnMusicWatchNextResultsRenderer']?['tabbedRenderer']?['watchNextTabbedResultsRenderer']?['tabs']?[0]?['tabRenderer']?['content']?['musicQueueRenderer']?['content']?['playlistPanelRenderer']?['contents'];

  if (contents == null) return {};

  final Map<String, Song> results = {};

  // 🔹 Start at index 1 to skip current song
  // 🔹 Only take the next 20 songs
  final limit = (contents.length > 20) ? 20 : contents.length;

  for (var i = 0; i < limit; i++) {
    final item = contents[i];
    final video = item['playlistPanelVideoRenderer'];
    if (video == null) continue;

    final videoId = video['videoId'] ?? '';
    if (videoId.isEmpty) continue;

    final title = video['title']?['runs']?[0]?['text'] ?? '';
    final artist = video['longBylineText']?['runs']?[0]?['text'] ?? '';
    final thumbList = video['thumbnail']?['thumbnails'];
    final thumbnailUrl = (thumbList != null && thumbList.isNotEmpty)
        ? thumbList.last['url']
        : '';

    results[videoId] = Song(
      id: videoId,
      name: title,
      artist: artist,
      imageUrl: thumbnailUrl,
    );
  }

  return results;
}
