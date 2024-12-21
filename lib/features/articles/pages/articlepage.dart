import 'dart:convert';

import 'package:baket_mobile/core/constants/_constants.dart';
import 'package:baket_mobile/features/articles/models/articlep.dart';
import 'package:baket_mobile/features/articles/widgets/articlecard.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ArticlePage extends StatelessWidget {
  final String id;
  const ArticlePage({super.key, required this.id});
  static const String baseUrl = Endpoints.baseUrl;

  Future<ArticleP> fetchData(CookieRequest request) async {
    final url = '$baseUrl/articles/json/flutter/article/$id/';
    final response = await request.get(url);
    return ArticleP.fromJson(response);
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return FutureBuilder(
      future: fetchData(request),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Column(
            children: [
              Text(
                "Terjadi kesalahan",
                style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
              ),
              SizedBox(height: 8),
            ],
          );
        }
        else {
          return Scaffold(
            appBar: AppBar(
            title: const Text('Article Page'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
            backgroundColor: const Color(0xFFFBFBF9),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Main Article
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6.0,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            snapshot.data!.article.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF333333),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Text(
                            'Posted by: ${snapshot.data!.article.postedBy}',
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Color(0xFF555555),
                            ),
                          ),
                          Text(
                            'Created at: ${snapshot.data!.article.createdAt}',
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Color(0xFF555555),
                            ),
                          ),
                          Text.rich(
                            TextSpan(
                              text: 'Source: ',
                              style: const TextStyle(
                                fontSize: 14.0,
                                color: Color(0xFF555555),
                              ),
                              children: [
                                TextSpan(
                                  text: snapshot.data!.article.source,
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    color: Color(0xFF01AAE8),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Row(
                            children: [
                              const Icon(Icons.thumb_up, color: Color(0xFFC8C8C8)),
                              const SizedBox(width: 8.0),
                              Text('${snapshot.data!.article.likeCount}'),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          Row(
                            children: [
                              const Icon(Icons.comment, color: Color(0xFFC8C8C8)),
                              const SizedBox(width: 8.0),
                              Text('${snapshot.data!.article.commentCount}'),
                            ],
                          ),
                          const SizedBox(height: 16.0),
                          Text(
                            snapshot.data!.article.content,
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: Color(0xFF333333),
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    // Comments Section
                    CommentSection(articleId: id),
                    const SizedBox(height: 32.0),
                    // Other Articles Section
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0E0E0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Other Articles',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF555555),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.other.length,
                            itemBuilder: (context, index) {
                              Other o = snapshot.data!.other[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: ArticleCard(
                                  id: o.id,
                                  title: o.title,
                                  postedBy: o.postedBy,
                                  likeCount: o.likeCount,
                                  commentCount: o.commentCount,
                                  hasLike: o.isLike,
                                  hasComment: o.isComment,
                                  mainPage: false,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      }
    );
  }
}

class CommentSection extends StatefulWidget {
  final String articleId;

  const CommentSection({
    super.key,
    required this.articleId,
  });

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final _formKey = GlobalKey<FormState>();
  static const String baseUrl = Endpoints.baseUrl;
  final TextEditingController _postController = TextEditingController();
  String _post = '';

  Future<void> postComment(CookieRequest request) async {
    if (_formKey.currentState!.validate()) {
      final url = "$baseUrl/article/add_comment/${widget.articleId}/";
      final response = await request.postJson(
        url,
        jsonEncode(<String, String>{
          "content": _post,
        }),
      );
      if (context.mounted) {
        if (response.ok) {
          ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(
            content: Text("Komentar berhasil dipost"),
          ));
        }
        else {
          ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(
            content: Text("Terjadi kesalahan"),
          ));
        }
      }
      _post = '';
      _postController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
      return Column(
        children: [
          const Text(
            'Comments',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF555555),
            ),
          ),
          const SizedBox(height: 8.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                key: _formKey,
                child: TextFormField(
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Write a comment...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _post = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Write a comment...";
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 8.0),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF01AAE8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    'Post',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          const Text(
            'No comments yet',
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          CommentWidget(
            commentId: "b7e5ac4d-78b4-4e66-b643-0891e91e03b0",
            username: "Undefined",
            comment: "Tes",
            timestamp: "20-12-2024",
            likes: 0,
          ),
        ],
      );
  }
}

class CommentWidget extends StatefulWidget {
  final String commentId;
  final String username;
  final String comment;
  final String timestamp;
  final int likes;
  final bool isLike;

  const CommentWidget({
    super.key, 
    required this.commentId,
    required this.username,
    required this.comment,
    required this.timestamp,
    required this.likes,
    this.isLike = false,
  });

  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  bool _isEditing = false;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _commentController.text = widget.comment;
  }

  @override
  Widget build(BuildContext context) {
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
            ],
          ),
          _isEditing
              ? TextField(
                  controller: _commentController,
                  style: const TextStyle(
                    overflow: TextOverflow.visible, // equivalent to break-words
                    leadingDistribution: TextLeadingDistribution.even, // equivalent to leading-7
                  ),
                )
              : Text(
                  widget.comment,
                  style: const TextStyle(
                    overflow: TextOverflow.visible, // equivalent to break-words
                    leadingDistribution: TextLeadingDistribution.even, // equivalent to leading-7
                  ),
                ),
          Row(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      // Add your like button tap handler here
                      // For example:
                      // await _toggleLike();
                      // setState(() {
                      //   _isLiked = !_isLiked;
                      // });
                    },
                    child: Icon(
                      Icons.thumb_up,
                      color: widget.isLike ? Colors.blue : Colors.grey[400], // equivalent to #c8c8c8
                      size: 18,
                    ),
                  ),
                  Text('${widget.likes}'), // like count
                ],
              ),
              const SizedBox(width: 10), // equivalent to ml-5
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isEditing = !_isEditing;
                  });
                },
                child: const Icon(
                  Icons.edit,
                  color: Colors.blue, // equivalent to #01aae8
                  size: 18,
                ),
              ),
              const SizedBox(width: 5), // equivalent to m-1
              GestureDetector(
                onTap: () {
                  // Add your delete button tap handler here
                  // For example:
                  // _deleteComment();
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
    );
  }

  // Example of an asynchronous function to toggle like
  Future<void> _toggleLike() async {
    // Simulate a network request
    await Future.delayed(Duration(milliseconds: 500));
    // Update the likes count
    // For example:
    // widget.likes++;
  }

  // Example of an asynchronous function to delete comment
  Future<void> _deleteComment() async {
    // Simulate a network request
    await Future.delayed(Duration(milliseconds: 500));
    // Remove the comment from the list
    // For example:
    // Navigator.pop(context);
  }
}