import 'package:chores_flutter/pages/default_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:chores_flutter/default_scaffold.dart';
import 'package:chores_flutter/pages/shopping_add_page.dart';
import 'package:chores_flutter/pages/shopping_list_page.dart';


class ShoppingPage extends StatefulWidget {
  @override
  _MyBodyState createState() => _MyBodyState();
}

class _MyBodyState extends State<ShoppingPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose(){
    _pageController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return DefaultScaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index){
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          ShoppingListPage(),
          ShoppingAddPage(),
        ],
      ),
      bottomNavigationBar: DefaultBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index){
          setState(() {
            _pageController.animateToPage(index, duration: Duration(milliseconds: 250), curve: Curves.ease);
          });
        },
      ),
    );
  }
}
