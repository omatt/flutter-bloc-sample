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