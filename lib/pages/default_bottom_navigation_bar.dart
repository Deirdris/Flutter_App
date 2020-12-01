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
        BottomNavigationBarItem(icon: Icon(Icons.article), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.edit), label: ''),
      ],
      onTap: onTap,
    );
  }
}
