import 'package:flutter/material.dart';

class ArticleMain extends StatefulWidget {
  const ArticleMain({super.key});

  @override
  State<ArticleMain> createState() => _ArticleMain();
}

class _ArticleMain extends State<ArticleMain> {  
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
            const Center(child: Text('Hello World')),
            const SizedBox(height: 16.0),
            Row(
              children: [
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Search Articles',
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
                      ),
                    ),
                    child: const Text('Search'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_drop_down),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
