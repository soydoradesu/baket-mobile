// To parse this JSON data, do
//
//     final articleM = articleMFromJson(jsonString);

import 'dart:convert';

List<ArticleM> articleMFromJson(String str) => List<ArticleM>.from(json.decode(str).map((x) => ArticleM.fromJson(x)));

String articleMToJson(List<ArticleM> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ArticleM {
    String id;
    String title;
    String postedBy;
    int likeCount;
    int commentCount;
    bool isLike;
    bool isComment;

    ArticleM({
        required this.id,
        required this.title,
        required this.postedBy,
        required this.likeCount,
        required this.commentCount,
        required this.isLike,
        required this.isComment,
    });

    factory ArticleM.fromJson(Map<String, dynamic> json) => ArticleM(
        id: json["id"],
        title: json["title"],
        postedBy: json["posted_by"],
        likeCount: json["like_count"],
        commentCount: json["comment_count"],
        isLike: json["is_like"],
        isComment: json["is_comment"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "posted_by": postedBy,
        "like_count": likeCount,
        "comment_count": commentCount,
        "is_like": isLike,
        "is_comment": isComment,
    };
}
