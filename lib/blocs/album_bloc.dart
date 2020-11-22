
import 'dart:async';

import 'package:httprestimagegrid/models/item_model.dart';
import 'package:httprestimagegrid/resources/repository.dart';

class AlbumsBloc {
  final _repository = Repository();
  final _albumFetcher = StreamController<List<AlbumModel>>();

  Stream<List<AlbumModel>> get allAlbums => _albumFetcher.stream;

  fetchAlbum() async {
    List<AlbumModel> listAlbums = await _repository.fetchAllAlbums();
    _albumFetcher.sink.add(listAlbums);
  }

  dispose() {
    _albumFetcher.close();
  }
}

final bloc = AlbumsBloc();