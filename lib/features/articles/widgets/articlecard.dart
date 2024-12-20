import 'package:baket_mobile/features/articles/pages/articlepage.dart';
import 'package:flutter/material.dart';

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