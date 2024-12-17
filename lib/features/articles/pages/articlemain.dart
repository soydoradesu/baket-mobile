import 'package:baket_mobile/core/constants/_constants.dart';
import 'package:flutter/material.dart';
import 'package:baket_mobile/features/articles/pages/articlepage.dart';
import 'package:baket_mobile/features/articles/models/article.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ArticleMain extends StatefulWidget {
  const ArticleMain({super.key});

  @override
  State<ArticleMain> createState() => _ArticleMain();
}

class _ArticleMain extends State<ArticleMain> {  
  static const String baseUrl = Endpoints.baseUrl;

  Future<List<ArticleCard>> fetchArticles(CookieRequest request) async {
    final response = await request.get('$baseUrl/articles/json/flutter/main/');

    var data = response;
    Article? article;

    List<ArticleCard> lst = [];
    for (var d in data) {
      if (d != null) {
        article = Article.fromJson(d);
        lst.add(ArticleCard(
          key: Key(article.pk), 
          title: article.fields.title, 
          postedBy: article.fields.postedBy, 
          likeCount: article.fields.likeCount, 
          commentCount: article.fields.commentCount
        ));
      }
    }

    return lst;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Article'),
      ),
      body: FutureBuilder(
        future: fetchArticles(request),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          }
          else {
            if (!snapshot.hasData) {
              return const Column(
                children: [
                  Text(
                    "Tidak ada produk",
                    style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
                  ),
                  SizedBox(height: 8),
                ],
              );
            }
            else {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16.0),
                    Row(
                      children: [
                        const Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'Search Articles',
                              enabledBorder: OutlineInputBorder(),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 48,
                          child: TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.horizontal(
                                  right: Radius.circular(20),
                                ),
                                side: BorderSide(
                                  width: 1,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            child: const Text('Search'),
                          ),
                        ),
                        SizedBox(
                          height: 48,
                          child: PopupMenuButton<String>(
                            onSelected: (value) {
                              // BELUM HEHE
                            },
                            itemBuilder: (context) {
                              return <String>['Like Terbanyak', 'Terlama', 'Terbaru'].map((e) {
                                return PopupMenuItem<String>(
                                  value: e,
                                  child: Text(e),
                                );
                              }).toList();
                            },
                            child: const Row(
                              children: [
                                Text('Sort by'),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_drop_down),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: snapshot.data![index],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
          }
        }
      ),
    );
  }
}


class ArticleCard extends StatelessWidget {
  final String title;
  final String postedBy;
  final int likeCount;
  final int commentCount;

  const ArticleCard({
    super.key,
    required this.title,
    required this.postedBy,
    required this.likeCount,
    required this.commentCount,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ArticlePage()),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4.0),
              Text("Posted by: $postedBy"),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 4.0),
                    child: Icon(Icons.thumb_up),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Text(likeCount.toString()),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 4.0),
                    child: Icon(Icons.comment),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 0.0),
                    child: Text(commentCount.toString()),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}