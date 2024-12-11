// lib/features/user/pages/profile_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:intl/intl.dart';

import '../models/user_profile.dart';
import '../services/profile_service.dart';
import '../dialogs/edit_dialogs.dart';
import '../widgets/biodata_item.dart';

import 'package:baket_mobile/features/auth/pages/login.dart'; // Adjust if needed

class ProfileApp extends StatefulWidget {
  const ProfileApp({super.key});

  @override
  State<ProfileApp> createState() => _ProfileAppState();
}

class _ProfileAppState extends State<ProfileApp> {
  late Future<UserProfile> futureProfile;
  late ProfileService profileService;

  static const String baseUrl = 'http://127.0.0.1:8000';
  static const String fetchProfileUrl = '$baseUrl/user/json/';

  @override
  void initState() {
    super.initState();
    final request = context.read<CookieRequest>();
    profileService = ProfileService(request);
    futureProfile = fetchUserProfile(request);
  }

  Future<UserProfile> fetchUserProfile(CookieRequest request) async {
    final response = await request.get(fetchProfileUrl);
    return UserProfile.fromJson(response);
  }

  Future<void> refreshProfile() async {
    final request = context.read<CookieRequest>();
    setState(() {
      futureProfile = fetchUserProfile(request);
    });
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Profile'),
      //   backgroundColor: const Color(0xFF01AAE8),
      // ),
      body: FutureBuilder<UserProfile>(
        future: futureProfile,
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
                    InkWell(
                      onTap: () async {
                        final result = await showNameDialog(
                          context,
                          currentFirst: user.firstName,
                          currentLast: user.lastName,
                        );
                        if (result != null) {
                          final updated = await profileService.updateName(
                            result['first_name']!,
                            result['last_name']!,
                          );
                          if (updated) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Name updated successfully!')),
                            );
                            await refreshProfile();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Failed to update name.')),
                            );
                          }
                        }
                      },
                      child: Row(
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
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                      // Navigate to wishlist page if needed
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

            const Divider(thickness: 1, height: 32),

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
                // Update username if you have that endpoint
              },
            ),
            BiodataItem(
              label: 'Tanggal Lahir',
              value: DateFormat('dd-MM-yyyy').format(user.birthDate),
              onTap: () async {
                final selectedDate = await showDatePickerDialog(context, user.birthDate);
                if (selectedDate != null && selectedDate != user.birthDate) {
                  final updated = await profileService.updateBirthDate(selectedDate);
                  if (updated) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Birth date updated successfully!')),
                    );
                    await refreshProfile();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to update birth date.')),
                    );
                  }
                }
              },
            ),
            BiodataItem(
              label: 'Jenis Kelamin',
              value: user.gender,
              onTap: () async {
                final newGender = await showGenderDialog(context, user.gender);
                if (newGender != null && newGender.isNotEmpty && newGender != user.gender) {
                  final updated = await profileService.updateGender(newGender);
                  if (updated) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Gender updated successfully!')),
                    );
                    await refreshProfile();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to update gender.')),
                    );
                  }
                }
              },
            ),

            const Divider(thickness: 1, height: 32),

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
              onTap: () async {
                final newEmail = await showSingleFieldDialog(
                  context,
                  title: 'Email',
                  initialValue: user.email ?? '',
                  inputType: TextInputType.emailAddress,
                );
                if (newEmail != null && newEmail.isNotEmpty) {
                  final updated = await profileService.updateEmail(newEmail);
                  if (updated) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Email updated successfully!')),
                    );
                    await refreshProfile();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to update email.')),
                    );
                  }
                }
              },
            ),
            BiodataItem(
              label: 'Nomor Hp',
              value: user.phoneNumber ?? '-',
              onTap: () async {
                final newPhone = await showSingleFieldDialog(
                  context,
                  title: 'Phone Number',
                  initialValue: user.phoneNumber ?? '',
                  inputType: TextInputType.phone,
                );
                if (newPhone != null && newPhone.isNotEmpty) {
                  final updated = await profileService.updatePhone(newPhone);
                  if (updated) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Phone number updated successfully!')),
                    );
                    await refreshProfile();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to update phone.')),
                    );
                  }
                }
              },
            ),
            const SizedBox(height: 32),

            Center(
              child: ElevatedButton.icon(
                onPressed: () async {
                  final response = await profileService.logoutUser();
                  String message = response["message"];
                  if (context.mounted) {
                    if (response["status"]) {
                      String uname = response["username"];
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("$message Sampai jumpa, $uname.")),
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(message)),
                      );
                    }
                  }
                },
                icon: const Icon(Icons.logout, color: Colors.black54),
                label: const Text('Keluar Akun', style: TextStyle(color: Colors.black)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[100],
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
