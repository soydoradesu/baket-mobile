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
  final VoidCallback? refresh;

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
    required this.refresh,
  });

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  static const String baseUrl = Endpoints.baseUrl;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Container(
      margin: const EdgeInsets.only(top: 16),
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
              overflow: TextOverflow.visible,
              leadingDistribution: TextLeadingDistribution.even,
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
                        widget.refresh?.call();
                      });
                    },
                    child: Icon(
                      Icons.thumb_up,
                      color: widget.isLike ? Colors.blue : Colors.grey[400],
                      size: 18,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:4.0),
                    child: Text('${widget.likes}'),
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
                            widget.refresh?.call();
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
                        color: Colors.red,
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