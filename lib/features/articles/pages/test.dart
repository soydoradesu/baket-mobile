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
            const SizedBox(height: 16.0),
            Center(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "BP Batam Dukung Penuh Pengembangan Investasi Sektor Inovasi Teknologi di Indonesia",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4.0),
                    Text("Posted by: Rhuuzi Wiranata"),
                    SizedBox(height: 8.0),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 4.0),
                          child: Icon(Icons.thumb_up,),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 16.0),
                          child: Text("0"),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 4.0),
                          child: Icon(Icons.comment,),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 0.0),
                          child: Text("0"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Center(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "King Koil Batam Hadirkan Teknologi Terbaru di Kasur yang Bikin Tidur Makin Lelap",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4.0),
                    Text("Posted by: Aminudin"),
                    SizedBox(height: 8.0),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 4.0),
                          child: Icon(Icons.thumb_up,),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 16.0),
                          child: Text("0"),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 4.0),
                          child: Icon(Icons.comment,),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 0.0),
                          child: Text("0"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Center(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Viral Pabrik Perusahaan Termahal di Dunia Nvidia Ada di Batam, Ini Faktanya",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4.0),
                    Text("Posted by: Kamila Meilina"),
                    SizedBox(height: 8.0),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 4.0),
                          child: Icon(Icons.thumb_up,),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 16.0),
                          child: Text("0"),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 4.0),
                          child: Icon(Icons.comment,),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 0.0),
                          child: Text("0"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Center(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Telkom Desain Ulang Pusat Data di Batam supaya Bisa Pakai AI",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4.0),
                    Text("Posted by: Amelia Yesidora"),
                    SizedBox(height: 8.0),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 4.0),
                          child: Icon(Icons.thumb_up,),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 16.0),
                          child: Text("0"),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 4.0),
                          child: Icon(Icons.comment,),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 0.0),
                          child: Text("0"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Center(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Diskominfo Batam Dorong Generasi Muda Melek Digital melalui Pemanfaatan Teknologi Informasi",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4.0),
                    Text("Posted by: Abdul Aziz Maulana"),
                    SizedBox(height: 8.0),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 4.0),
                          child: Icon(Icons.thumb_up,),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 16.0),
                          child: Text("0"),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 4.0),
                          child: Icon(Icons.comment,),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 0.0),
                          child: Text("0"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // const SizedBox(height: 16.0),
            // Center(
            //   child: Container(
            //     padding: const EdgeInsets.all(16.0),
            //     decoration: BoxDecoration(
            //       border: Border.all(color: Colors.black),
            //       borderRadius: BorderRadius.circular(8.0),
            //     ),
            //     child: const Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text(
            //           "Diskominfo Batam Dorong Generasi Muda Melek Digital melalui Pemanfaatan Teknologi Informasi",
            //           style: TextStyle(fontWeight: FontWeight.bold),
            //         ),
            //         SizedBox(height: 4.0),
            //         Text("Posted by: Ahmadi Sultan"),
            //         SizedBox(height: 8.0),
            //         Row(
            //           children: [
            //             Padding(
            //               padding: EdgeInsets.only(right: 4.0),
            //               child: Icon(Icons.thumb_up,),
            //             ),
            //             Padding(
            //               padding: EdgeInsets.only(right: 16.0),
            //               child: Text("0"),
            //             ),
            //             Padding(
            //               padding: EdgeInsets.only(right: 4.0),
            //               child: Icon(Icons.comment,),
            //             ),
            //             Padding(
            //               padding: EdgeInsets.only(right: 0.0),
            //               child: Text("0"),
            //             ),
            //           ],
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
