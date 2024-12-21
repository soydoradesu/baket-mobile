// lib/features/user/pages/profile_page.dart
import 'package:baket_mobile/features/user/widgets/custom_super_tooltip.dart';
import 'package:baket_mobile/features/wishlist/pages/wishlist_page.dart';
import 'package:baket_mobile/features/product/pages/cart_page.dart';
import 'package:baket_mobile/services/logger_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:baket_mobile/core/constants/_constants.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart'; // For image picking
import 'dart:io'; // For handling File
import 'package:super_tooltip/super_tooltip.dart';

import '../models/user_profile.dart';
import '../services/profile_service.dart';
import '../dialogs/edit_dialogs.dart';
import '../widgets/biodata_item.dart';
import '../../product/services/cart_service.dart';

import 'package:baket_mobile/features/auth/pages/login.dart'; // Adjust if needed

class ProfileApp extends StatefulWidget {
  const ProfileApp({super.key});

  @override
  State<ProfileApp> createState() => _ProfileAppState();
}

class _ProfileAppState extends State<ProfileApp> {
  late Future<UserProfile> futureProfile;
  late ProfileService profileService;
  late CartService cartService;
  late int cartCount;

  // Tooltip controllers
  final _biodataTooltipController = SuperTooltipController();
  final _kontakTooltipController = SuperTooltipController();
  static const String biodataTooltipContent =
    'Bagian ini menampilkan informasi pribadi Anda seperti nama pengguna, tanggal lahir, dan jenis kelamin. Ketuk pada setiap bidang untuk mengedit dan pastikan detail Anda selalu akurat.';
  static const String kontakTooltipContent =
    'Bagian ini memuat detail kontak Anda seperti email dan nomor telepon. Memperbarui informasi ini secara rutin memastikan komunikasi yang lancar dan kemudahan dalam pemulihan akun.';

  static const String baseUrl = Endpoints.baseUrl;
  static const String fetchProfileUrl = '$baseUrl/user/json/';

  @override
  void initState() {
    super.initState();
    final request = context.read<CookieRequest>();
    profileService = ProfileService(request);
    cartService = CartService(request);
    futureProfile = fetchUserProfile(request);
    _fetchCartCount(); // Fetch cart count on initialization
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

  void _fetchCartCount() async {
    final count = await cartService.fetchCartCount();
    setState(() {
      cartCount = count;
    });
  }

  /// Picks an image from the gallery or camera and uploads it.
  Future<void> _pickAndUploadImage(BuildContext context) async {
    final picker = ImagePicker();
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () async {
                Navigator.of(context).pop();
                final pickedFile =
                    await picker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  await _uploadImage(File(pickedFile.path));
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Camera'),
              onTap: () async {
                Navigator.of(context).pop();
                final pickedFile =
                    await picker.pickImage(source: ImageSource.camera);
                if (pickedFile != null) {
                  await _uploadImage(File(pickedFile.path));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Uploads the selected image to the backend.
  Future<void> _uploadImage(File imageFile) async {
    // Show a loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final success = await profileService.uploadProfilePicture(imageFile);

    // Hide the loading indicator
    Navigator.of(context).pop();

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile picture updated successfully!')),
      );
      await refreshProfile(); // Refresh the profile to show the new picture
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update profile picture.')),
      );
    }
  }

  Future<bool>? _willPopCallback() async {
    // If the tooltip is open we don't pop the page on a backbutton press
    // but close the ToolTip
    if (_biodataTooltipController.isVisible) {
      await _biodataTooltipController.hideTooltip();
      return false;
    }
    if (_kontakTooltipController.isVisible) {
      await _kontakTooltipController.hideTooltip();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return PopScope(
      onPopInvokedWithResult: (didPop, result) => _willPopCallback,
      child: Scaffold(
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
              return SafeArea(
                child: buildProfilePage(context, user, request)
              );
            } else {
              return const Center(child: Text('No data available'));
            }
          },
        ),
      ),
    );
  }

  Widget buildProfilePage(
      BuildContext context, UserProfile user, CookieRequest request) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section
            Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    CircleAvatar(
                      backgroundImage:
                          NetworkImage('$baseUrl${user.profilePicture}'),
                      radius: 50,
                    ),
                    Positioned(
                      bottom: -12,
                      child: InkWell(
                        onTap: () async {
                          // Handle edit profile picture action
                          await _pickAndUploadImage(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border:
                                Border.all(color: Colors.grey[300]!, width: 1),
                          ),
                          padding: const EdgeInsets.all(4),
                          child: const Icon(
                            Icons.edit,
                            size: 20,
                            color: Color(0xFF01AAE8),
                          ),
                        ),
                      ),
                    ),
                  ],
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
                              const SnackBar(
                                  content: Text('Name updated successfully!')),
                            );
                            await refreshProfile();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Failed to update name.')),
                            );
                          }
                        }
                      },
                      child: Row(
                        children: [
                          Text(
                            '${user.firstName} ${user.lastName}',
                            style: GoogleFonts.raleway(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
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
                        style: GoogleFonts.raleway(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Wishlist Section

            InkWell(
              onTap: () {
                // Handle Tap Here
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const WishlistPage()),
                ).then((_) async {
                  _fetchCartCount();
                  await refreshProfile(); // or setState(...) if you need to refetch
                });
              },
              splashColor:
                  Colors.blue.withOpacity(0.3), // Customize splash color
              highlightColor:
                  Colors.blue.withOpacity(0.1), // Customize highlight color
              borderRadius:
                  BorderRadius.circular(12), // To match container radius
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.favorite, color: Colors.black),
                        const SizedBox(width: 16),
                        Text(
                          '${user.wishlistCount} dalam wishlist',
                          style: GoogleFonts.raleway(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'beli sekarang!',
                      style: GoogleFonts.raleway(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF01AAE8),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

// Cart Section
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartPage()),
                ).then((_) {
                  // Refresh cart count when returning
                  _fetchCartCount();
                });
              },
              splashColor: Colors.blue.withOpacity(0.3),
              highlightColor: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.shopping_cart, color: Colors.black),
                        const SizedBox(width: 16),
                        Text(
                          '$cartCount dalam keranjang',
                          style: GoogleFonts.raleway(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'checkout yuk!',
                      style: GoogleFonts.raleway(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF01AAE8),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            Divider(thickness: 1, height: 32, color: Colors.grey[300]),

            Row(
              children: [
                Text(
                  'Biodata Diri',
                  style: GoogleFonts.raleway(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF01AAE8),
                  ),
                ),
                const SizedBox(width: 10),
                CustomSuperTooltip(
                  tooltipText: biodataTooltipContent,
                  controller: _biodataTooltipController,
                ),
              ],
            ),
            const SizedBox(height: 8),
            BiodataItem(
              label: 'Username',
              value: user.username,
              onTap: () {
                // Update username if you have that endpoint
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Untuk sementara, username belum bisa diupdate')),
                );
              },
            ),
            BiodataItem(
              label: 'Tanggal Lahir',
              value: DateFormat('dd-MM-yyyy').format(user.birthDate),
              onTap: () async {
                final selectedDate =
                    await showDatePickerDialog(context, user.birthDate);
                if (selectedDate != null && selectedDate != user.birthDate) {
                  final updated =
                      await profileService.updateBirthDate(selectedDate);
                  if (updated) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Tanggal Lahir berhasil diupdate!')),
                    );
                    await refreshProfile();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Tanggal Lahir gagal diupdate :(')),
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
                if (newGender != null &&
                    newGender.isNotEmpty &&
                    newGender != user.gender) {
                  final updated = await profileService.updateGender(newGender);
                  if (updated) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Jenis Kelamin berhasil diupdate!')),
                    );
                    await refreshProfile();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Jenis Kelamin gagal diupdate :(')),
                    );
                  }
                }
              },
            ),

            Divider(thickness: 1, height: 32, color: Colors.grey[300]),

            Row(
              children: [
                Text(
                  'Kontak User',
                  style: GoogleFonts.raleway(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF01AAE8),
                  ),
                ),
                const SizedBox(width: 10),
                CustomSuperTooltip(
                  tooltipText: kontakTooltipContent,
                  controller: _kontakTooltipController,
                ),
              ],
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
                      const SnackBar(
                          content: Text('Email berhasil diupdate!')),
                    );
                    await refreshProfile();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Email gagal diupdate :(')),
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
                  title: 'Nomor HP',
                  initialValue: user.phoneNumber ?? '',
                  inputType: TextInputType.phone,
                );
                if (newPhone != null && newPhone.isNotEmpty) {
                  final updated = await profileService.updatePhone(newPhone);
                  if (updated) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Nomor HP berhasil diupdate!')),
                    );
                    await refreshProfile();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Nomor HP gagal diupdate :(')),
                    );
                  }
                }
              },
            ),
            const SizedBox(height: 64),

            Center(
              child: ElevatedButton.icon(
                onPressed: () async {
                  final response = await profileService.logoutUser();
                  String message = response["message"];
                  if (context.mounted) {
                    if (response["status"]) {
                      String uname = response["username"];
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text("$message Sampai jumpa, $uname.")),
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(message)),
                      );
                    }
                  }
                },
                icon: const Icon(Icons.logout, color: Colors.black54),
                label: const Text('Keluar Akun',
                    style: TextStyle(color: Colors.black)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[100],
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
