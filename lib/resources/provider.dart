import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:httprestimagegrid/models/item_model.dart';
class AlbumApiProvider {
  Future<List<AlbumModel>> fetchAlbum() async {
    print('fetchAlbum()');
    final response =
    await http.get(Uri.https('jsonplaceholder.typicode.com', 'photos'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Iterable iterableAlbum = json.decode(response.body);
      List<AlbumModel> albumList = [];
      List<Map<String, dynamic>>.from(iterableAlbum).map((Map model) {
        // Add Album mapped from json to List<Album>
        albumList.add(AlbumModel.fromJson(model as Map<String, dynamic>));
      }).toList();
      return albumList;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}