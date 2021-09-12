import 'package:flutter/material.dart';
import 'package:httprestimagegrid/blocs/album_bloc.dart';

import 'models/item_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _scrollController = ScrollController();
  int gridColumnCount = 3;
  int gridRowCount = 7;

  // GridView has 3 columns set
  // Succeeding pages should display in rows of 3 for uniformity
  loadMoreImages(bool increment) {
    setState(() {
      firstLoad = false;
      if (!increment)
        _imageGridCursorEnd = gridRowCount * gridColumnCount;
      else
        _imageGridCursorEnd += gridRowCount * gridColumnCount;
    });
  }

  // Call to fetch images
  // if refresh set to true, it will trigger setState() to reset the GridView
  loadImages(bool refresh) {
    bloc.fetchAlbum();
    if (refresh) loadMoreImages(!refresh); // refresh whole GridView
  }

  @override
  void initState() {
    super.initState();
    bloc.fetchAlbum();
    // Set initial cursor end
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels == 0)
          print('Grid scroll at top');
        else {
          print('Grid scroll at bottom');
          try {
            loadMoreImages(true);
          } catch (e) {
            debugPrint('Error: $e');
          }
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
  }

  var _imageGridCursorStart = 0, _imageGridCursorEnd = 0;
  var firstLoad = true;

  @override
  Widget build(BuildContext context) {
    var deviceData = MediaQuery.of(context);
    var deviceHeight = deviceData.size.height;
    var deviceWidth = deviceData.size.width;
    // Estimated size of thumbnails is 150px,
    // divided by the device's width to determine
    // the number of columns needed
    gridColumnCount = (deviceWidth / 150).round();
    gridRowCount = (deviceHeight / 100).round();
    // Check the first instance of loading the grid.
    // This helps update the number of initial
    // to be displayed on the grid.
    if (firstLoad)
      _imageGridCursorEnd = gridRowCount * gridColumnCount;
    debugPrint(
        'Width: $deviceWidth $gridColumnCount Height: $gridRowCount');
    return StreamBuilder(
      stream: bloc.allAlbums,
      builder:
          (BuildContext context, AsyncSnapshot<List<AlbumModel>> snapshot) {
        if (snapshot.hasData) {
          // This ensures that the cursor won't exceed List<Album> length
          if (_imageGridCursorEnd > snapshot.data!.length)
            _imageGridCursorEnd = snapshot.data!.length;
          debugPrint(
              'Stream snapshot contains ${snapshot.data!.length} item/s');
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.title!),
          ),
          body: Center(
            child: RefreshIndicator(
              // onRefresh is a RefreshCallback
              // RefreshCallback is a Future Function().
              onRefresh: () async => loadImages(true),
              child: snapshot.hasData
                  ? Scrollbar(
                controller: _scrollController,
                      child: GridView.count(
                        physics: AlwaysScrollableScrollPhysics(),
                        controller: _scrollController,
                        primary: false,
                        padding: const EdgeInsets.all(20),
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        crossAxisCount: gridColumnCount,
                        children: getListImg(snapshot.data!
                            .getRange(
                                _imageGridCursorStart, _imageGridCursorEnd)
                            .toList()),
                      ),
                    )
                  : Text('Waiting...'),
            ),
          ),
        );
      },
    );
  }

  getListImg(List<AlbumModel> listAlbum) {
    final List<Widget> listImages = [];
    for (var album in listAlbum) {
      listImages.add(
        Container(
          padding: const EdgeInsets.all(8),
          child: Image.network(album.albumThumbUrl!, fit: BoxFit.cover),
          // child: Thumbnail(image: imagePath, size: Size(100, 100)),
        ),
      );
    }
    return listImages;
  }
}
