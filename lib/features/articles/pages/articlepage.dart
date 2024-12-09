import 'package:flutter/material.dart';

class ArticlePage extends StatelessWidget {
  const ArticlePage({super.key});

  @override
  Widget build(BuildContext context) {
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
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'BP Batam Dukung Penuh Pengembangan Investasi Sektor Inovasi Teknologi di Indonesia',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Posted by: Rhuuzi Wiranata',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Color(0xFF555555),
                      ),
                    ),
                    Text(
                      'Created at: Aug. 14, 2024, 3:04 P.M.',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Color(0xFF555555),
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        text: 'Source: ',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Color(0xFF555555),
                        ),
                        children: [
                          TextSpan(
                            text: 'Source',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Color(0xFF01AAE8),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      children: [
                        Icon(Icons.thumb_up, color: Color(0xFFC8C8C8)),
                        SizedBox(width: 8.0),
                        Text('0'),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      children: [
                        Icon(Icons.comment, color: Color(0xFFC8C8C8)),
                        SizedBox(width: 8.0),
                        Text('0'),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Batam, Batamnews - BP Batam berpartisipasi dalam kegiatan Indonesia Internet Expo & Summit (IIXS) 2024 yang keenam di Jakarta International Expo, Senin, 12 Agustus 2024.\n\n'
                      'Partisipasi BP Batam ini bertujuan untuk mempromosikan Batam sebagai salah satu kawasan ramah investasi, khususnya dalam mendukung kemajuan ekosistem digital di Indonesia.\n\n'
                      'Kepala Biro Humas Promosi dan Protokol, Ariastuty Sirait mengatakan, keikutsertaan BP Batam pada kegiatan tersebut sekaligus momentum untuk memperkenalkan potensi pengembangan Data Center yang menjadi keunggulan Batam dalam investasi sektor inovasi teknologi.\n\n'
                      'Tuty juga mengapresiasi penyelenggaraan IIXS 2024 yang mendapat dukungan penuh dari Kementerian Komunikasi dan Informatika (Kemkominfo) Republik Indonesia.\n\n'
                      'Turut hadir dalam kegiatan IIXS 2024 Wakil Menteri Kominfo, Nezar Patria serta Ketua Umum Asosiasi Penyelenggara Jasa Internet (APJII), Muhammad Arif.',
                      style: TextStyle(
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
                  TextField(
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Write a comment...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
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
                      child: const Text('Post'),
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
                    _buildOtherArticle(
                      title: 'Teknologi QR Code Permudah Pendaftaran Subsidi BBM di Kepri',
                      author: 'Rengga Yuliandra',
                      date: 'Sept. 8, 2024, 6:05 P.M.',
                      context: context,
                    ),
                    _buildOtherArticle(
                      title:
                          'Diskominfo Batam Ajak Generasi Muda Cakap Digital Lewat Pemanfaatan Teknologi Informasi',
                      author: 'MEDIACENTER',
                      date: 'Oct. 27, 2024, midnight',
                      context: context,
                    ),
                    _buildOtherArticle(
                      title: 'Telkom Desain Ulang Pusat Data di Batam supaya Bisa Pakai AI',
                      author: 'Amelia Yesidora',
                      date: 'Oct. 30, 2024, 4:11 P.M.',
                      context: context,
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

  Widget _buildOtherArticle({
    required String title,
    required String author,
    required String date,
    required BuildContext context,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
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
            title,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            'Posted by: $author',
            style: const TextStyle(
              fontSize: 14.0,
              color: Colors.grey,
            ),
          ),
          Text(
            'Created at: $date',
            style: const TextStyle(
              fontSize: 14.0,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
