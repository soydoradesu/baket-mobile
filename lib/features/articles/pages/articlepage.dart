import 'dart:convert';

import 'package:baket_mobile/core/constants/_constants.dart';
import 'package:baket_mobile/features/articles/models/articlep.dart';
import 'package:baket_mobile/features/articles/models/comment.dart';
import 'package:baket_mobile/features/articles/widgets/articlecard.dart';
import 'package:baket_mobile/features/articles/widgets/comment.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ArticlePage extends StatefulWidget {
  final String id;
  final VoidCallback refresh;
  const ArticlePage({super.key, required this.id, required this.refresh});

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  static const String baseUrl = Endpoints.baseUrl;

  Future<ArticleP> fetchData(CookieRequest request) async {
    final url = '$baseUrl/articles/json/flutter/article/${widget.id}/';
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
          return const Center(
              child: Column(
              children: [
                Text(
                  "Terjadi kesalahan",
                  style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
                ),
                SizedBox(height: 8),
              ],
            ),
          );
        }
        else {
          return Scaffold(
            appBar: AppBar(
            title: const Text('Article Page'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                widget.refresh.call();
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
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 6.0,
                            offset: Offset(0, 4),
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
                              GestureDetector(
                                onTap: () async {
                                  final url = "$baseUrl/articles/likeArticle/${widget.id}/";
                                  await request.get(url);
                                  setState(() {});
                                },
                                child: Icon(Icons.thumb_up, color: snapshot.data!.article.isLike ? Colors.blue : const Color(0xFFC8C8C8)),
                              ),
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
                    CommentSection(articleId: widget.id),
                    const SizedBox(height: 32.0),
                    // Other Articles Section
                    OtherArticlesList(otherArticles: snapshot.data!.other, refresh: widget.refresh,),
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

  void _refresh() {
    setState(() {});
  }

  Future<List<CommentWidget>> fetchComments(CookieRequest request) async {
    final url = "$baseUrl/articles/json/comment/${widget.articleId}/";
    final response = await request.get(url);

    var data = response;
    Comment? c;
    List<CommentWidget> res = [];
    for (var d in data) {
      if (d != null) {
        c = Comment.fromJson(d);
        res.add(CommentWidget(
          commentId: c.id,
          username: c.author,
          comment: c.content,
          timestamp: c.time.toString(),
          likes: c.likeCount,
          hasEdit: c.hasEdited,
          isLike: c.isLike,
          isUser: c.canEdit,
          refresh: _refresh,
        ));
      }
    }

    return res;
  }

  @override
  Widget build(BuildContext context) {
      final request = context.watch<CookieRequest>();
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
                  controller: _postController,
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
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final url = "$baseUrl/articles/add_comment/${widget.articleId}/";
                      final response = await request.postJson(
                        url,
                        jsonEncode(<String, String>{
                          "content": _post,
                        }),
                      );
                      if (context.mounted) {
                        if (response["status"] == 'success') {
                          ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(
                            content: Text("Komentar berhasil dipost"),
                          ));
                          _postController.clear();
                        }
                        else {
                          ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(
                            content: Text("Terjadi kesalahan"),
                          ));
                        }
                      }
                      setState(() {
                        _post = '';
                      });
                    }
                  },
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
          FutureBuilder(
            future: fetchComments(request),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return const Center(child: CircularProgressIndicator());
              }
              else if (!snapshot.hasData || snapshot.data!.length == 0) {
                return const Text(
                  'No comments yet',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                );        
              }
              else {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return snapshot.data![index];
                  },
                );
              }
            }
          ),
        ],
      );
  }
}

class OtherArticlesList extends StatelessWidget {
  final List<Other> otherArticles;
  final VoidCallback refresh;

  const OtherArticlesList({super.key, required this.otherArticles, required this.refresh});

  @override
  Widget build(BuildContext context) {
    return Container(
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
            itemCount: otherArticles.length,
            itemBuilder: (context, index) {
              final article = otherArticles[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ArticleCard(
                  id: article.id,
                  title: article.title,
                  postedBy: article.postedBy,
                  likeCount: article.likeCount,
                  commentCount: article.commentCount,
                  hasLike: article.isLike,
                  hasComment: article.isComment,
                  mainPage: false,
                  refresh: refresh,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}