// To parse this JSON data, do
//
//     final commentModel = commentModelFromJson(jsonString);

import 'dart:convert';

List<CommentModel> commentModelFromJson(String str) => List<CommentModel>.from(
  json.decode(str).map((x) => CommentModel.fromJson(x)),
);

String commentModelToJson(List<CommentModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CommentModel {
  String id;
  String video;
  String user;
  String userName;
  String? userAvatar;
  String text;
  DateTime createdAt;

  CommentModel({
    required this.id,
    required this.video,
    required this.user,
    required this.userName,
    required this.userAvatar,
    required this.text,
    required this.createdAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
    id: json["id"],
    video: json["video"],
    user: json["user"],
    userName: json["user_name"],
    userAvatar: json["user_avatar"],
    text: json["text"],
    createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "video": video,
    "user": user,
    "user_name": userName,
    "user_avatar": userAvatar,
    "text": text,
    "created_at": createdAt.toIso8601String(),
  };
}
