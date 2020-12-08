import 'package:chores_flutter/controllers//user_controller.dart';
import 'package:chores_flutter/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class DefaultScaffold extends StatefulWidget {
  DefaultScaffold({this.body, this.bottomNavigationBar});

  final Widget body;
  final Widget bottomNavigationBar;

  @override
  _DefaultScaffoldState createState() => _DefaultScaffoldState();
}

class _DefaultScaffoldState extends State<DefaultScaffold> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey drawerHeaderKey = GlobalKey();
  final userController = Get.find<UserController>();
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this, upperBound: 0.5, duration: Duration(milliseconds: 250));
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var routesList = routes.entries.toList();

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            scaffoldKey.currentState.openDrawer();
          },
          splashRadius: 24,
        ),
        title: Text(routes[ModalRoute.of(context).settings.name].title),
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Container(
            color: Colors.blueGrey[100],
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    UserAccountsDrawerHeader(
                      accountName: Text(userController.user.displayName),
                      accountEmail: Text(userController.user.email),
                      currentAccountPicture: CircleAvatar(
                        backgroundImage: NetworkImage(userController.user.photoURL),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        final RenderBox button = drawerHeaderKey.currentContext.findRenderObject() as RenderBox;
                        final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
                        final RelativeRect position = RelativeRect.fromRect(
                          Rect.fromPoints(
                            button.localToGlobal(Offset(0, 56), ancestor: overlay),
                            button.localToGlobal(button.size.bottomRight(Offset(-8, 0)), ancestor: overlay),
                          ),
                          Offset.zero & overlay.size,
                        );
                        animationController.forward();
                        showMenu(context: context, position: position, items: [
                          PopupMenuItem(child: Text("Wyloguj"), value: "logout",),
                        ]).then((value) {
                          if(value == "logout"){
                            GoogleSignIn().signOut();
                            FirebaseAuth.instance.signOut().then((value) => SystemNavigator.pop());
                          }
                          animationController.reverse();
                          return null;
                        });
                      },
                      child: Padding(
                        key: drawerHeaderKey,
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                        child: RotationTransition(
                          turns: animationController,
                          child: Icon(
                            Icons.arrow_drop_down,
                            // isPopupMenuOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                            color: Colors.white,
                          ),
                        ),
                        // offset: Offset(0, 56),
                        // itemBuilder: (_) => [
                        //   PopupMenuItem(child: Text("Wyloguj")),
                        // ],
                      ),
                    ),
                  ],
                ),
                for (var route in routesList)
                  Container(
                    color:
                        route.key == ModalRoute.of(context).settings.name ? Colors.blueGrey[200] : Colors.blueGrey[100],
                    child: ListTile(
                      leading: Icon(
                        route.value.icon,
                        color: Colors.black,
                      ),
                      title: Text(
                        route.value.title,
                        style: TextStyle(fontSize: 20),
                      ),
                      onTap: () {
                        Navigator.pushReplacementNamed(context, route.key);
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(child: widget.body),
      bottomNavigationBar: widget.bottomNavigationBar,
    );
  }
}
