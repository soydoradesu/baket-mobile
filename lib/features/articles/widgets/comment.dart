import 'dart:convert';

import 'package:baket_mobile/core/constants/_constants.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class CommentWidget extends StatefulWidget {
  final String commentId;
  final String username;
  final String comment;
  final String timestamp;
  final int likes;
  final bool hasEdit;
  final bool isLike;
  final bool isUser;
  final VoidCallback? onDelete;

  const CommentWidget({
    super.key, 
    required this.commentId,
    required this.username,
    required this.comment,
    required this.timestamp,
    required this.likes,
    this.hasEdit = false,
    this.isLike = false,
    this.isUser = false,
    required this.onDelete,
  });

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  static const String baseUrl = Endpoints.baseUrl;
  int _likes = 0;
  bool _isLike = false;

  @override
  void initState() {
    super.initState();
    _likes = widget.likes;
    _isLike = widget.isLike;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Container(
      margin: const EdgeInsets.only(top: 16), // equivalent to mt-4
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                widget.username,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text(' - '),
              Text(
                widget.timestamp,
                style: TextStyle(color: Colors.grey[500]),
              ),
              if (widget.hasEdit)
                const Text(" (edited)"),
            ],
          ),
          Text(
            widget.comment,
            style: const TextStyle(
              overflow: TextOverflow.visible, // equivalent to break-words
              leadingDistribution: TextLeadingDistribution.even, // equivalent to leading-7
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      final url = "$baseUrl/articles/likeComment/${widget.commentId}/";
                      await request.get(url);
                      setState(() {
                        _isLike = !_isLike;
                        _likes = _isLike ? _likes + 1 : _likes - 1;
                      });
                    },
                    child: Icon(
                      Icons.thumb_up,
                      color: _isLike ? Colors.blue : Colors.grey[400], // equivalent to #c8c8c8
                      size: 18,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left:4.0),
                    child: Text('${_likes}'), // like count
                  ),
                ],
              ),
              if (widget.isUser)
                Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final url = "$baseUrl/articles/delete_comment/${widget.commentId}/";
                        final response = await request.get(
                          url
                        );
                        if (context.mounted) {
                          if (response["status"] == "success") {
                            ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                              content: Text("Komentar berhasil dihapus"),
                            ));
                            widget.onDelete?.call();
                          }
                          else {
                            ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                              content: Text("Terjadi kesalahan"),
                            ));
                          }
                        }
                      },
                      child: const Icon(
                        Icons.delete,
                        color: Colors.red, // equivalent to #ff0000
                        size: 18,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}