import 'package:chores_flutter/pages/default_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:chores_flutter/pages/shopping_add_page.dart';
import 'package:chores_flutter/pages/shopping_list_page.dart';
import 'package:get/get.dart';

class _ShoppingPageController extends GetxController {
  PageController pageController = PageController();

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}

class ShoppingPage extends StatelessWidget {
  final controller = Get.put(_ShoppingPageController());
  final currentIndex = 0.obs;

  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller.pageController,
        onPageChanged: (index) {
          currentIndex.value = index;
        },
        children: [
          ShoppingListPage(),
          ShoppingAddPage(),
        ],
      ),
      bottomNavigationBar: Obx(
        () => DefaultBottomNavigationBar(
          currentIndex: currentIndex(),
          onTap: (index) {
            controller.pageController.animateToPage(index, duration: Duration(milliseconds: 250), curve: Curves.ease);
          },
        ),
      ),
    );
  }
}
