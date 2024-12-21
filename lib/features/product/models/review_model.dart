// To parse this JSON data, do
//
//     final review = reviewFromJson(jsonString);

import 'dart:convert';

List<Review> reviewFromJson(String str) =>
    List<Review>.from(json.decode(str).map((x) => Review.fromJson(x)));

String reviewToJson(List<Review> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Review {
  int id;
  int user;
  bool isUserReview;
  bool isLiked;
  String username;
  String product;
  int rating;
  String comment;
  DateTime createdAt;
  int likeReviewCount;

  Review({
    required this.id,
    required this.user,
    required this.isUserReview,
    required this.isLiked,
    required this.username,
    required this.product,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.likeReviewCount,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json["id"],
        user: json["user"],
        isUserReview: json['is_user_review'],
        isLiked: json['isLiked'],
        username: json["username"],
        product: json["product"],
        rating: json["rating"],
        comment: json["comment"],
        createdAt: DateTime.parse(json["created_at"]),
        likeReviewCount: json["likeReview_count"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "username": username,
        "isLiked": isLiked,
        "rating": rating,
        "comment": comment,
        "created_at": createdAt.toIso8601String(),
        "likeReview_count": likeReviewCount,
      };
}
