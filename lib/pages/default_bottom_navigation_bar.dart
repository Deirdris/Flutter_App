import 'package:flutter/material.dart';

class DefaultBottomNavigationBar extends StatelessWidget {
  DefaultBottomNavigationBar({
    Key key,
    this.currentIndex,
    this.onTap,
  }) : super(key: key);

  final int currentIndex;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: [
        BottomNavigationBarItem(icon: currentIndex == 0 ? Icon(Icons.article) : Icon(Icons.article_outlined), label: ''),
        BottomNavigationBarItem(icon: currentIndex == 1 ? Icon(Icons.edit) : Icon(Icons.edit_outlined), label: ''),
      ],
      onTap: onTap,
    );
  }
}
