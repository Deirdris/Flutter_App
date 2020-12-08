import 'package:chores_flutter/default_scaffold.dart';
import 'package:chores_flutter/pages/chores_add_page.dart';
import 'package:chores_flutter/pages/chores_list_page.dart';
import 'package:chores_flutter/pages/default_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class _ChoresPageController extends GetxController {
  final pageController = PageController();

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}

class ChoresPage extends StatelessWidget {
  final controller = Get.put(_ChoresPageController());
  final currentIndex = 0.obs;

  Widget build(BuildContext context) {
    return DefaultScaffold(
      body: PageView(
        controller: controller.pageController,
        onPageChanged: (index) {
          currentIndex.value = index;
        },
        children: [
          ChoresListPage(),
          ChoresAddPage(),
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
