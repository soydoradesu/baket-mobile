// To parse this JSON data, do
//
//     final article = articleFromJson(jsonString);

import 'dart:convert';

List<Article> articleFromJson(String str) => List<Article>.from(json.decode(str).map((x) => Article.fromJson(x)));

String articleToJson(List<Article> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Article {
    Model model;
    String pk;
    Fields fields;

    Article({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Article.fromJson(Map<String, dynamic> json) => Article(
        model: modelValues.map[json["model"]]!,
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": modelValues.reverse[model],
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    String title;
    String postedBy;
    String content;
    DateTime createdAt;
    String source;
    int likeCount;
    int commentCount;

    Fields({
        required this.title,
        required this.postedBy,
        required this.content,
        required this.createdAt,
        required this.source,
        required this.likeCount,
        required this.commentCount,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        title: json["title"],
        postedBy: json["posted_by"],
        content: json["content"],
        createdAt: DateTime.parse(json["created_at"]),
        source: json["source"],
        likeCount: json["like_count"],
        commentCount: json["comment_count"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "posted_by": postedBy,
        "content": content,
        "created_at": createdAt.toIso8601String(),
        "source": source,
        "like_count": likeCount,
        "comment_count": commentCount,
    };
}

enum Model {
    ARTICLES_ARTICLE
}

final modelValues = EnumValues({
    "articles.article": Model.ARTICLES_ARTICLE
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}
