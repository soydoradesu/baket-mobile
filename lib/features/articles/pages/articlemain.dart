import 'package:flutter/material.dart';
import 'package:baket_mobile/features/articles/pages/articlepage.dart';

class ArticleMain extends StatefulWidget {
  const ArticleMain({super.key});

  @override
  State<ArticleMain> createState() => _ArticleMain();
}

class _ArticleMain extends State<ArticleMain> {  
  final List<ArticleCard> items = [
    const ArticleCard(title: "BP Batam Dukung Penuh Pengembangan Investasi Sektor Inovasi Teknologi di Indonesia", postedBy: "Rhuuzi Wiranata", likeCount: 0, commentCount: 0),
    const ArticleCard(title: "King Koil Batam Hadirkan Teknologi Terbaru di Kasur yang Bikin Tidur Makin Lelap", postedBy: "Aminudin", likeCount: 0, commentCount: 0),
    const ArticleCard(title: "Viral Pabrik Perusahaan Termahal di Dunia Nvidia Ada di Batam, Ini Faktanya", postedBy: "Kamila Meilina", likeCount: 0, commentCount: 0),
    const ArticleCard(title: "Telkom Desain Ulang Pusat Data di Batam supaya Bisa Pakai AI", postedBy: "Amelia Yesidora", likeCount: 0, commentCount: 0),
    const ArticleCard(title: "Diskominfo Batam Dorong Generasi Muda Melek Digital melalui Pemanfaatan Teknologi Informasi", postedBy: "Abdul Aziz Maulana", likeCount: 0, commentCount: 0),
    const ArticleCard(title: "Diskominfo Batam Dorong Generasi Muda Melek Digital melalui Pemanfaatan Teknologi Informasi", postedBy: "Abdul Aziz Maulana", likeCount: 0, commentCount: 0),
    const ArticleCard(title: "Diskominfo Batam Dorong Generasi Muda Melek Digital melalui Pemanfaatan Teknologi Informasi", postedBy: "Abdul Aziz Maulana", likeCount: 0, commentCount: 0),
    const ArticleCard(title: "Diskominfo Batam Dorong Generasi Muda Melek Digital melalui Pemanfaatan Teknologi Informasi", postedBy: "Abdul Aziz Maulana", likeCount: 0, commentCount: 0),
    const ArticleCard(title: "Diskominfo Batam Dorong Generasi Muda Melek Digital melalui Pemanfaatan Teknologi Informasi", postedBy: "Abdul Aziz Maulana", likeCount: 0, commentCount: 0),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Article'),
      ),
      body: Padding(
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
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: items[index],
                  );
                },
              ),
            ),
          ],
        ),
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