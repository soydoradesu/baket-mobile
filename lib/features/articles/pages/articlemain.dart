import 'package:baket_mobile/core/constants/_constants.dart';
import 'package:flutter/material.dart';
import 'package:baket_mobile/features/articles/pages/articlepage.dart';
import 'package:baket_mobile/features/articles/models/articlem.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ArticleMain extends StatefulWidget {
  const ArticleMain({super.key});

  @override
  State<ArticleMain> createState() => _ArticleMain();
}

class _ArticleMain extends State<ArticleMain> {  
  static const String baseUrl = Endpoints.baseUrl;
  final TextEditingController _searchController = TextEditingController();
  String _search = '';
  String _sort = '';
  static const sortOptions = {
    'most_like': 'Like Terbanyak',
    'oldest': 'Terlama',
    'most_recent': 'Terbaru',
  };

  Future<List<ArticleCard>> fetchArticles(CookieRequest request, {String? search, String? sort}) async {
    final url = '$baseUrl/articles/json/flutter/main/?search=${search ?? ''}&sort=${sort ?? ''}';
    final response = await request.get(url);

    var data = response;
    ArticleM? article;

    List<ArticleCard> lst = [];
    for (var d in data) {
      if (d != null) {
        article = ArticleM.fromJson(d);
        lst.add(ArticleCard(
          key: Key(article.id), 
          title: article.title, 
          postedBy: article.postedBy, 
          likeCount: article.likeCount, 
          commentCount: article.commentCount,
          hasLike: article.isLike,
          hasComment: article.isComment,
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
        future: fetchArticles(request, search: _search, sort: _sort),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          }
          else {
            if (!snapshot.hasData) {
              return const Column(
                children: [
                  Text(
                    "Tidak ada artikel",
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
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: const InputDecoration(
                              labelText: 'Search Articles',
                              enabledBorder: OutlineInputBorder(),
                              border: OutlineInputBorder(),
                            ),
                            // onChanged: (value) {
                            //   setState(() {
                            //     _search = value;
                            //   });
                            // },
                          ),
                        ),
                        SizedBox(
                          height: 48,
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                _search = _searchController.text;
                              });
                            },
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
                              setState(() {
                                _sort = value;
                              });
                            },
                            itemBuilder: (context) {
                              return sortOptions.entries.map((e) {
                                return PopupMenuItem<String>(
                                  value: e.key,
                                  child: Text(e.value),
                                );
                              }).toList();
                            },
                            child: Row(
                              children: [
                                Text(sortOptions[_sort] ?? 'Sort by'),
                                const SizedBox(width: 8),
                                const Icon(Icons.arrow_drop_down),
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
  final bool hasLike;
  final bool hasComment;

  const ArticleCard({
    super.key,
    required this.title,
    required this.postedBy,
    required this.likeCount,
    required this.commentCount,
    this.hasLike = false,
    this.hasComment = false,
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
                  IconCard(icon: const Icon(Icons.thumb_up), padding: const EdgeInsets.only(right: 4.0), has: hasLike),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Text(likeCount.toString()),
                  ),
                  IconCard(icon: const Icon(Icons.comment), padding: const EdgeInsets.only(right: 4.0), has: hasComment),
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

class IconCard extends StatelessWidget {
  final Icon icon;
  final EdgeInsets padding;
  final bool has;

  const IconCard({
    super.key,
    required this.icon,
    this.padding = EdgeInsets.zero,
    this.has = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Icon(
        icon.icon,
        color: has ? Colors.blue : icon.color,
      ),
    );
  }
}