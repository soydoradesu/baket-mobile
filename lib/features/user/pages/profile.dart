// lib/features/user/pages/profile_page.dart
import 'package:baket_mobile/core/bases/widgets/_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:baket_mobile/core/themes/_themes.dart';
import 'package:baket_mobile/features/user/widgets/shimmer.dart'; // Import shimmer widgets
import 'package:baket_mobile/features/user/widgets/biodata_item.dart'; // Updated BiodataItem
import 'package:baket_mobile/features/user/widgets/custom_super_tooltip.dart';
import 'package:baket_mobile/features/wishlist/pages/wishlist_page.dart';
import 'package:baket_mobile/features/product/pages/cart_page.dart';
import 'package:baket_mobile/features/auth/pages/login.dart';
import 'package:baket_mobile/core/constants/_constants.dart';
import 'package:baket_mobile/features/user/models/user_profile.dart';
import 'package:baket_mobile/features/user/services/profile_service.dart';
import 'package:baket_mobile/features/user/dialogs/edit_dialogs.dart';
import 'package:baket_mobile/features/product/services/cart_service.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:io';
import 'package:super_tooltip/super_tooltip.dart';

class ProfileApp extends StatefulWidget {
  const ProfileApp({Key? key}) : super(key: key);

  @override
  State<ProfileApp> createState() => _ProfileAppState();
}

class _ProfileAppState extends State<ProfileApp> {
  late Future<UserProfile> futureProfile;
  late ProfileService profileService;
  late CartService cartService;
  int? cartCount;

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
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          CustomSnackbar.snackbar(
            message: 'Foto profil berhasil diupdate!',
            icon: Icons.check_circle,
            color: BaseColors.success,
          ),
        );
      await refreshProfile(); // Refresh the profile to show the new picture
    } else {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          CustomSnackbar.snackbar(
            message: 'Foto profil gagal diupdate',
            icon: Icons.error,
            color: BaseColors.error,
          ),
        );
    }
  }

  void _showProfilePicturePreview(String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(16.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              children: [
                Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  // Handle errors
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey.shade200,
                    child: const Center(
                        child: Icon(Icons.error_outline, size: 60)),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    icon:
                        const Icon(Icons.close, color: Colors.white, size: 30),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool> _willPopCallback() async {
    // If the tooltip is open, close it instead of popping the page
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
        body: SafeArea(
          // Ensuring SafeArea wraps the entire content
          child: FutureBuilder<UserProfile>(
            future: futureProfile,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Display shimmer placeholders selectively
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile Section Shimmer
                        const ShimmerProfileSection(),
                        const SizedBox(height: 32),

                        // Wishlist Section Shimmer
                        const ShimmerWishlistSection(),
                        const SizedBox(height: 16),

                        // Cart Section Shimmer
                        const ShimmerCartSection(),
                        const SizedBox(height: 32),

                        Divider(
                          thickness: 1,
                          height: 32,
                          color: Colors.grey[300],
                        ),

                        // Biodata Diri Section Header (No shimmer)
                        Row(
                          children: [
                            Text(
                              'Biodata Diri',
                              style: FontTheme.raleway22w700blue1(),
                            ),
                            const SizedBox(width: 10),
                            CustomSuperTooltip(
                              tooltipText: biodataTooltipContent,
                              controller: _biodataTooltipController,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Biodata Items: labels as text, values as shimmer
                        BiodataItem(
                          label: 'Username',
                          value: '', // Empty since it's loading
                          onTap: () {},
                          isLoading: true, // Shimmer on value
                        ),
                        const SizedBox(height: 8),
                        BiodataItem(
                          label: 'Tanggal Lahir',
                          value: '', // Empty since it's loading
                          onTap: () {},
                          isLoading: true, // Shimmer on value
                        ),
                        const SizedBox(height: 8),
                        BiodataItem(
                          label: 'Jenis Kelamin',
                          value: '', // Empty since it's loading
                          onTap: () {},
                          isLoading: true, // Shimmer on value
                        ),

                        Divider(
                          thickness: 1,
                          height: 32,
                          color: Colors.grey[300],
                        ),

                        // Kontak User Section Header (No shimmer)
                        Row(
                          children: [
                            Text(
                              'Kontak User',
                              style: FontTheme.raleway22w700blue1(),
                            ),
                            const SizedBox(width: 10),
                            CustomSuperTooltip(
                              tooltipText: kontakTooltipContent,
                              controller: _kontakTooltipController,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Kontak Items: labels as text, values as shimmer
                        BiodataItem(
                          label: 'Email',
                          value: '', // Empty since it's loading
                          onTap: () {},
                          isLoading: true, // Shimmer on value
                        ),
                        const SizedBox(height: 8),
                        BiodataItem(
                          label: 'Nomor Hp',
                          value: '', // Empty since it's loading
                          onTap: () {},
                          isLoading: true, // Shimmer on value
                        ),
                        const SizedBox(height: 64),

                        // Logout Button Section (Centered)
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center, // Center the button
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {}, // Disabled during loading
                              icon: const Icon(Icons.logout,
                                  color: BaseColors.gray2),
                              label: Text(
                                'Keluar Akun',
                                style: FontTheme.raleway14w500black2(),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: BaseColors.gray5,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
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
                    InkWell(
                      onTap: () => _showProfilePicturePreview(
                          '$baseUrl${user.profilePicture}'),
                      child: CircleAvatar(
                        backgroundImage:
                            NetworkImage('$baseUrl${user.profilePicture}'),
                        radius: 50,
                      ),
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
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
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
                Expanded(
                  // Use Expanded to prevent overflow
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () async {
                          final result = await showNameDialog(
                            context,
                            currentFirst: user.firstName ?? user.username,
                            currentLast: user.lastName ?? '',
                          );
                          if (result != null) {
                            final updated = await profileService.updateName(
                              result['first_name']!,
                              result['last_name']!,
                            );
                            if (updated) {
                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(
                                  CustomSnackbar.snackbar(
                                    message: 'Nama berhasil diupdate!',
                                    icon: Icons.check_circle,
                                    color: BaseColors.success,
                                  ),
                                );
                              await refreshProfile();
                            } else {
                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(
                                  CustomSnackbar.snackbar(
                                    message: 'Nama gagal diupdate',
                                    icon: Icons.error,
                                    color: BaseColors.error,
                                  ),
                                );
                            }
                          }
                        },
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${user.firstName == '' ? user.username : user.firstName} '
                                '${user.lastName}',
                                style: FontTheme.raleway22w700black(),
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
                          style: FontTheme.raleway12w700white(),
                        ),
                      ),
                    ],
                  ),
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
                  MaterialPageRoute(
                    builder: (context) => const WishlistPage(),
                  ),
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
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
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
                          style: FontTheme.raleway14w600black(),
                        ),
                      ],
                    ),
                    Text(
                      'beli sekarang!',
                      style: FontTheme.raleway12w700blue1(),
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
                        cartCount == null
                            ? const ShimmerCartCount() // Use shimmer widget
                            : Text(
                                '$cartCount dalam keranjang',
                                style: FontTheme.raleway14w600black(),
                              ),
                      ],
                    ),
                    Text(
                      'checkout yuk!',
                      style: FontTheme.raleway12w700blue1(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            Divider(thickness: 1, height: 32, color: Colors.grey[300]),

            // Biodata Diri Section
            Row(
              children: [
                Text(
                  'Biodata Diri',
                  style: FontTheme.raleway22w700blue1(),
                ),
                const SizedBox(width: 10),
                CustomSuperTooltip(
                  tooltipText: biodataTooltipContent,
                  controller: _biodataTooltipController,
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Biodata Items
            BiodataItem(
              label: 'Username',
              value: user.username,
              onTap: () {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    CustomSnackbar.snackbar(
                      message: 'Belum bisa diupdate!',
                      icon: Icons.error,
                      color: BaseColors.error,
                    ),
                  );
              },
              isLoading: false, // No shimmer on value
            ),
            const SizedBox(height: 8),
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
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        CustomSnackbar.snackbar(
                          message: 'Tgl lahir berhasil diupdate!',
                          icon: Icons.check_circle,
                          color: BaseColors.success,
                        ),
                      );
                    await refreshProfile();
                  } else {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        CustomSnackbar.snackbar(
                          message: 'Tgl lahir gagal diupdate',
                          icon: Icons.error,
                          color: BaseColors.error,
                        ),
                      );
                  }
                }
              },
              isLoading: false, // No shimmer on value
            ),
            const SizedBox(height: 8),
            BiodataItem(
              label: 'Jenis Kelamin',
              value: user.gender ?? 'Tidak Diketahui',
              onTap: () async {
                final newGender = await showGenderDialog(
                  context,
                  user.gender ?? 'Tidak Diketahui',
                );
                if (newGender != null &&
                    newGender.isNotEmpty &&
                    newGender != user.gender) {
                  final updated = await profileService.updateGender(newGender);
                  if (updated) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        CustomSnackbar.snackbar(
                          message: 'Gender berhasil diupdate!',
                          icon: Icons.check_circle,
                          color: BaseColors.success,
                        ),
                      );
                    await refreshProfile();
                  } else {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        CustomSnackbar.snackbar(
                          message: 'Gender gagal diupdate',
                          icon: Icons.error,
                          color: BaseColors.error,
                        ),
                      );
                  }
                }
              },
              isLoading: false, // No shimmer on value
            ),

            Divider(thickness: 1, height: 32, color: Colors.grey[300]),

            // Kontak User Section
            Row(
              children: [
                Text(
                  'Kontak User',
                  style: FontTheme.raleway22w700blue1(),
                ),
                const SizedBox(width: 10),
                CustomSuperTooltip(
                  tooltipText: kontakTooltipContent,
                  controller: _kontakTooltipController,
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Kontak Items
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
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        CustomSnackbar.snackbar(
                          message: 'Email berhasil diupdate!',
                          icon: Icons.check_circle,
                          color: BaseColors.success,
                        ),
                      );
                    await refreshProfile();
                  } else {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        CustomSnackbar.snackbar(
                          message: 'Email gagal diupdate!',
                          icon: Icons.error,
                          color: BaseColors.error,
                        ),
                      );
                  }
                }
              },
              isLoading: false, // No shimmer on value
            ),
            const SizedBox(height: 8),
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
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        CustomSnackbar.snackbar(
                          message: 'Nomor HP berhasil diupdate!',
                          icon: Icons.check_circle,
                          color: BaseColors.success,
                        ),
                      );
                    await refreshProfile();
                  } else {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        CustomSnackbar.snackbar(
                          message: 'Nomor HP gagal diupdate!',
                          icon: Icons.error,
                          color: BaseColors.error,
                        ),
                      );
                  }
                }
              },
              isLoading: false, // No shimmer on value
            ),
            const SizedBox(height: 64),

            // Logout Button Section (Centered)
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Center the button
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    final response = await profileService.logoutUser();
                    String message = response["message"];
                    if (context.mounted) {
                      if (response["status"]) {
                        String uname = response["username"];
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            CustomSnackbar.snackbar(
                              message: 'Sampai jumpa, $uname.',
                              icon: Icons.logout,
                              color: BaseColors.success,
                            ),
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
                  icon: const Icon(Icons.logout, color: BaseColors.gray2),
                  label: Text(
                    'Keluar Akun',
                    style: FontTheme.raleway14w500black2(),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: BaseColors.gray5,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Shimmer for Cart Count Text (Used in Profile Page)
class ShimmerCartCount extends StatelessWidget {
  const ShimmerCartCount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Adjust width to be responsive
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: screenWidth * 0.35, // 35% of screen width
        height: 16,
        color: Colors.white,
      ),
    );
  }
}
