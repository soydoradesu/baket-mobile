// To parse this JSON data, do
//
//     final articleP = articlePFromJson(jsonString);

import 'dart:convert';

ArticleP articlePFromJson(String str) => ArticleP.fromJson(json.decode(str));

String articlePToJson(ArticleP data) => json.encode(data.toJson());

class ArticleP {
    Article article;
    List<Other> other;

    ArticleP({
        required this.article,
        required this.other,
    });

    factory ArticleP.fromJson(Map<String, dynamic> json) => ArticleP(
        article: Article.fromJson(json["article"]),
        other: List<Other>.from(json["other"].map((x) => Other.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "article": article.toJson(),
        "other": List<dynamic>.from(other.map((x) => x.toJson())),
    };
}

class Article {
    String title;
    String postedBy;
    String content;
    DateTime createdAt;
    String source;
    int likeCount;
    int commentCount;
    bool isLike;
    bool isComment;

    Article({
        required this.title,
        required this.postedBy,
        required this.content,
        required this.createdAt,
        required this.source,
        required this.likeCount,
        required this.commentCount,
        required this.isLike,
        required this.isComment,
    });

    factory Article.fromJson(Map<String, dynamic> json) => Article(
        title: json["title"],
        postedBy: json["posted_by"],
        content: json["content"],
        createdAt: DateTime.parse(json["created_at"]),
        source: json["source"],
        likeCount: json["like_count"],
        commentCount: json["comment_count"],
        isLike: json["is_like"],
        isComment: json["is_comment"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "posted_by": postedBy,
        "content": content,
        "created_at": createdAt.toIso8601String(),
        "source": source,
        "like_count": likeCount,
        "comment_count": commentCount,
        "is_like": isLike,
        "is_comment": isComment,
    };
}

class Other {
    String id;
    String title;
    String postedBy;
    int likeCount;
    int commentCount;
    bool isLike;
    bool isComment;

    Other({
        required this.id,
        required this.title,
        required this.postedBy,
        required this.likeCount,
        required this.commentCount,
        required this.isLike,
        required this.isComment,
    });

    factory Other.fromJson(Map<String, dynamic> json) => Other(
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
