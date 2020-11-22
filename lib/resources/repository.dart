import 'package:httprestimagegrid/models/item_model.dart';
import 'package:httprestimagegrid/resources/provider.dart';

class Repository {
  final albumApiProvider = AlbumApiProvider();

  Future<List<AlbumModel>> fetchAllAlbums() => albumApiProvider.fetchAlbum();
}