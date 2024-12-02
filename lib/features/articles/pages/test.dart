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
        title: const Text('Hello World'),
      ),
      body: const Center(
        child: Text('Hello World'),
      ),
    );
  }
}
