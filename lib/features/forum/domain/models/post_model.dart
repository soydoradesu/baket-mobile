// Post Model for Forum

import 'package:baket_mobile/features/forum/domain/models/user_model.dart';

class PostModel {
  String id;
  UserModel user;
  String content;
  int likeCount;
  int replyCount;
  DateTime createdAt;
  DateTime updatedAt;
  bool isLiked;

  PostModel({
    required this.id,
    required this.user,
    required this.content,
    required this.likeCount,
    required this.replyCount,
    required this.createdAt,
    required this.updatedAt,
    required this.isLiked,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
        id: json["id"],
        user: UserModel.fromJson(json["user"]),
        content: json["content"],
        likeCount: json["like_count"],
        replyCount: json["reply_count"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        isLiked: json["is_liked"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user.toJson(),
        "content": content,
        "like_count": likeCount,
        "reply_count": replyCount,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "is_liked": isLiked,
      };

  PostModel copyWith({
    String? id,
    UserModel? user,
    String? content,
    int? likeCount,
    int? replyCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isLiked,
  }) {
    return PostModel(
      id: id ?? this.id,
      user: user ?? this.user,
      content: content ?? this.content,
      likeCount: likeCount ?? this.likeCount,
      replyCount: replyCount ?? this.replyCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  @override
  String toString() {
    return 'PostModel $id \n ${user.toString()} \n'
        'content: $content \n'
        'likeCount: $likeCount \n'
        'replyCount: $replyCount \n'
        'createdAt: $createdAt \n'
        'updatedAt: $updatedAt \n'
        'isLiked: $isLiked \n';
  }
}
