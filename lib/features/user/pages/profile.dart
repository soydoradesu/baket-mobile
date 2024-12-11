import 'package:baket_mobile/features/auth/pages/login.dart';
import 'package:baket_mobile/features/user/models/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const ProfileApp());
}

class ProfileApp extends StatelessWidget {
  const ProfileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile Page',
      theme: ThemeData(
        fontFamily: GoogleFonts.raleway().fontFamily,
        primarySwatch: Colors.blue,
      ),
      home: const ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<UserProfile> fetchUserProfile(CookieRequest request) async {
    final response = await request.get('http://127.0.0.1:8000/user/json/');

    return UserProfile.fromJson(response);
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color(0xFF01AAE8),
      ),
      body: FutureBuilder<UserProfile>(
        future: fetchUserProfile(request),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final user = snapshot.data!;
            return buildProfilePage(context, user, request);
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
  
  Widget buildProfilePage(BuildContext context, UserProfile user, CookieRequest request) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    'http://127.0.0.1:8000${user.profilePicture}',
                  ),
                  radius: 50,
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${user.firstName} ${user.lastName}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF01AAE8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        user.isSuperuser
                        ? 'Superuser'
                        : user.isStaff
                            ? 'Staff'
                            : 'Member',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Wishlist Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.favorite, color: Colors.black),
                      SizedBox(width: 8),
                      Text(
                        '9 item dalam wishlist',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigate to wishlist page
                    },
                    child: const Text(
                      'beli sekarang!',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF01AAE8),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            const Divider(
              thickness: 1, 
              height: 32
            ), // Horizontal line above

            const Text(
              'Biodata Diri',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF01AAE8),
              ),
            ),
            const SizedBox(height: 8),
            BiodataItem(
              label: 'Username',
              value: user.username,
              onTap: () {
                // Navigate to username edit
              },
            ),
            BiodataItem(
              label: 'Tanggal Lahir',
              value: DateFormat('dd-MM-yyyy').format(user.birthDate),
              onTap: () {
                // Navigate to birthdate edit
              },
            ),
            BiodataItem(
              label: 'Jenis Kelamin',
              value: user.gender,
              onTap: () {
                // Navigate to gender edit
              },
            ),

            const Divider(
              thickness: 1, 
              height: 32
            ), // Horizontal line above
            
            const Text(
              'Kontak User',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF01AAE8),
              ),
            ),
            const SizedBox(height: 8),
            BiodataItem(
              label: 'Email',
              value: user.email ?? '-',
              onTap: () {
                // Navigate to email edit
              },
            ),
            BiodataItem(
              label: 'Nomor Hp',
              value: user.phoneNumber ?? '-',
              onTap: () {
                // Navigate to phone number edit
              },
            ),
            const SizedBox(height: 32),
            // Logout Button
            Center(
              child: ElevatedButton.icon(
                onPressed: () async {
                  // Handle logout
                  final response = await request.logout(
                  "http://127.0.0.1:8000/auth/logout/");
                  String message = response["message"];

                  if (context.mounted) {
                    if (response["status"]) {
                      String uname = response["username"];
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("$message Sampai jumpa, $uname."),
                      ));
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(message),
                        ),
                      );
                    }
                  }
                },
                icon: const Icon(Icons.logout, color: Colors.black54),
                label: const Text(
                  'Keluar Akun',
                  style: TextStyle(color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[100],
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Reusable Biodata Item Widget
class BiodataItem extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback? onTap;

  const BiodataItem({
    required this.label,
    required this.value,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label Section
            Expanded(
              flex: 3,
              child: Text(
                label,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ),
            // Value Section
            Expanded(
              flex: 4,
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            // Arrow Icon
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
