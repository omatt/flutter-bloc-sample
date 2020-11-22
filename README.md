# httprestimagegrid

HTTP REST Image GridView sample for Flutter using BLoC pattern.

## Getting Started

This sample app demonstrates the displaying of network images on a GridView using [BLoC pattern][].

BLoC stands for Business Logic Components. The pattern utilizes a [Stream][] where widgets can listen for changes in events using [StreamBuilder][].

Flutter BLoC pattern consists of the UI screen, the BLoC, Repository, and Network Provider. Using this approach, the class containing the UI screen will be clean from methods for implementing Business Logic. API Requests can also be easily reused on other screens. The Repository can also help on keeping track of API Providers set.

### Network Provider

This handles network requests and parses the response data into the Models/Objects set. The sample fetches data from `https://jsonplaceholder.typicode.com/photos`, and the response is a list of albums.

```
[
  {
    "albumId": 1,
    "id": 1,
    "title": "accusamus beatae ad facilis cum similique qui sunt",
    "url": "https://via.placeholder.com/600/92c952",
    "thumbnailUrl": "https://via.placeholder.com/150/92c952"
  },
  {
    "albumId": 1,
    "id": 2,
    "title": "reprehenderit est deserunt velit ipsam",
    "url": "https://via.placeholder.com/600/771796",
    "thumbnailUrl": "https://via.placeholder.com/150/771796"
  },
  {
    "albumId": 1,
    "id": 3,
    "title": "officia porro iure quia iusto qui ipsa ut modi",
    "url": "https://via.placeholder.com/600/24f355",
    "thumbnailUrl": "https://via.placeholder.com/150/24f355"
  },
  ...
 ]
 ```

Define a Model to handle needed data from the network request.

#### Model

```dart
class AlbumModel {
  final int albumId;
  final int id;
  final String title;
  final String albumImageUrl;
  final String albumThumbUrl;

  AlbumModel(
      {this.albumId,
        this.id,
        this.title,
        this.albumImageUrl,
        this.albumThumbUrl});

  factory AlbumModel.fromJson(Map<String, dynamic> json) {
    return AlbumModel(
      albumId: json['albumId'],
      id: json['id'],
      title: json['title'],
      albumImageUrl: json['url'],
      albumThumbUrl: json['thumbnailUrl'],
    );
  }
}
```

#### Provider

This handles the network requests and returns a List of AlbumModel. 

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class AlbumApiProvider {
  Future<List<AlbumModel>> fetchAlbum() async {
    print('fetchAlbum()');
    final response =
    await http.get('https://jsonplaceholder.typicode.com/photos');

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Iterable iterableAlbum = json.decode(response.body);
      var albumList = List<AlbumModel>();
      List<Map<String, dynamic>>.from(iterableAlbum).map((Map model) {
        // Add Album mapped from json to List<Album>
        albumList.add(AlbumModel.fromJson(model));
      }).toList();
      return albumList;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}
```

### Repository

This contains Providers that will be called through BLoC.

```dart
class Repository {
  final albumApiProvider = AlbumApiProvider();

  Future<List<AlbumModel>> fetchAllAlbums() => albumApiProvider.fetchAlbum();
}
```

### BLoC

The BLoC contains the `Stream` that will be called for the UI screen. Setup a method that can add `Future<List<Model>>` in the Stream and a method to close the Stream once it isn't needed anymore.

```dart
import 'dart:async';

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
```

### User Interface Screen

Initialize the BLoC for the screen. This can be done in `initState()` for example.

```dart
@override
void initState() {
  super.initState();
  bloc.fetchAlbum();
}
```

Set the `Stream` in `StreamBuilder`.

```dart
@override
Widget build(BuildContext context) {
  return StreamBuilder(
    stream: bloc.allAlbums,
    builder: (BuildContext context, AsyncSnapshot<List<AlbumModel>> snapshot) {
      return Widget(); 
    },
  );
}
```

## Demo

Running the demo

[![Demo][1]][1]

  [1]: https://i.stack.imgur.com/Jj33q.gif
  [BLoC pattern]: https://flutter.dev/docs/development/data-and-backend/state-mgmt/options#bloc--rx
  [Stream]: https://api.flutter.dev/flutter/dart-async/Stream-class.html
  [StreamBuilder]: https://api.flutter.dev/flutter/widgets/StreamBuilder-class.html
