// To parse this JSON data, do
//
//     final videoModel = videoModelFromJson(jsonString);

import 'dart:convert';

List<VideoModel> videoModelFromJson(String str) =>
    List<VideoModel>.from(json.decode(str).map((x) => VideoModel.fromJson(x)));

String videoModelToJson(List<VideoModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VideoModel {
  String id;
  String title;
  String description;
  String video;
  String preview;
  int commentsCount;
  DateTime createdAt;

  VideoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.video,
    required this.preview,
    required this.commentsCount,
    required this.createdAt,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) => VideoModel(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    video: json["video"],
    preview: json["preview"],
    commentsCount: json["comments_count"],
    createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "video": video,
    "preview": preview,
    "comments_count": commentsCount,
    "created_at": createdAt.toIso8601String(),
  };
}
