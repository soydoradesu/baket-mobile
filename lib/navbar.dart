import 'package:baket_mobile/app.dart';
import 'package:baket_mobile/features/articles/pages/articlemain.dart';
import 'package:baket_mobile/features/forum/presentation/pages/_pages.dart';
import 'package:baket_mobile/features/product/pages/product_page.dart';
import 'package:baket_mobile/features/user/pages/profile.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:get/get.dart';


class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());

    return Scaffold(
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
      bottomNavigationBar: Obx(
        () => Container(
          height: 80, // Adjust the height as needed
          decoration: const BoxDecoration(
            color: Colors.white, // Set the background color
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16), // Optional: Rounded corners
              topRight: Radius.circular(16),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12, // Optional: Shadow for elevation effect
                blurRadius: 10,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: controller.selectedIndex.value,
            onTap: (index) {
              controller.selectedIndex.value = index;
            },
            type: BottomNavigationBarType.fixed,
            selectedItemColor: const Color(0xFF01AAE8), // Blue for selected
            unselectedItemColor: Colors.grey, // Gray for unselected
            showSelectedLabels: true, // Show labels for selected items
            showUnselectedLabels: false, // Hide labels for unselected items
            elevation: 0, // Elevation removed; shadow handled by Container
            items: const [
              BottomNavigationBarItem(
                icon: Icon(LucideIcons.package),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(LucideIcons.messageCircle),
                label: 'Forum',
              ),
              BottomNavigationBarItem(
                icon: Icon(LucideIcons.newspaper),
                label: 'Artikel',
              ),
              BottomNavigationBarItem(
                icon: Icon(LucideIcons.userCircle),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    const ProductPage(),
    const ForumPage(),
    const ArticleMain(),
    const ProfileApp(),
  ];
}
