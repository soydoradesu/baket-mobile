// Reply Model for Forum

import 'package:baket_mobile/features/forum/domain/models/user_model.dart';

class ReplyModel {
  String id;
  UserModel user;
  String postId;
  String content;
  int likeCount;
  DateTime createdAt;
  bool isLiked;

  ReplyModel({
    required this.id,
    required this.user,
    required this.postId,
    required this.content,
    required this.likeCount,
    required this.createdAt,
    required this.isLiked,
  });

  factory ReplyModel.fromJson(Map<String, dynamic> json) => ReplyModel(
        id: json["id"],
        user: UserModel.fromJson(json["user"]),
        postId: json["post_id"],
        content: json["content"],
        likeCount: json["like_count"],
        createdAt: DateTime.parse(json["created_at"]),
        isLiked: json["is_liked"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user.toJson(),
        "post_id": postId,
        "content": content,
        "like_count": likeCount,
        "created_at": createdAt.toIso8601String(),
        "is_liked": isLiked,
      };

  ReplyModel copyWith({
    String? id,
    UserModel? user,
    String? postId,
    String? content,
    int? likeCount,
    DateTime? createdAt,
    bool? isLiked,
  }) {
    return ReplyModel(
      id: id ?? this.id,
      user: user ?? this.user,
      postId: postId ?? this.postId,
      content: content ?? this.content,
      likeCount: likeCount ?? this.likeCount,
      createdAt: createdAt ?? this.createdAt,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}
