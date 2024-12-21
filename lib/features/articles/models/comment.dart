// To parse this JSON data, do
//
//     final comment = commentFromJson(jsonString);

import 'dart:convert';

List<Comment> commentFromJson(String str) => List<Comment>.from(json.decode(str).map((x) => Comment.fromJson(x)));

String commentToJson(List<Comment> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Comment {
    String id;
    String author;
    String content;
    DateTime time;
    bool hasEdited;
    int likeCount;
    bool isLike;
    bool canEdit;

    Comment({
        required this.id,
        required this.author,
        required this.content,
        required this.time,
        required this.hasEdited,
        required this.likeCount,
        required this.isLike,
        required this.canEdit,
    });

    factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json["id"],
        author: json["author"],
        content: json["content"],
        time: DateTime.parse(json["time"]),
        hasEdited: json["has_edited"],
        likeCount: json["like_count"],
        isLike: json["is_like"],
        canEdit: json["can_edit"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "author": author,
        "content": content,
        "time": time.toIso8601String(),
        "has_edited": hasEdited,
        "like_count": likeCount,
        "is_like": isLike,
        "can_edit": canEdit,
    };
}
