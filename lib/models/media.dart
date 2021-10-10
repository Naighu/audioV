class Media {
  final String title, id, channelName, uploadDate, thumbnailUrl, duartion;
  final int viewCount;
  Media(
      {required this.title,
      required this.viewCount,
      required this.id,
      required this.channelName,
      required this.uploadDate,
      required this.thumbnailUrl,
      required this.duartion});

  factory Media.fromJson(Map json) => Media(
      title: json["title"],
      viewCount: json["engagement"],
      id: json["id"],
      channelName: json["author"],
      uploadDate: json["uploadDate"],
      thumbnailUrl: json["thumbnails"],
      duartion: json["duartion"]);
}
