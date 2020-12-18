import 'package:chores_flutter/controllers/user_controller.dart';
import 'package:chores_flutter/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  final userController = Get.find<UserController>();
  AnimationController animationController;
  final currentRoute = '/job'.obs;

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
        title: Obx(() => Text(routes[currentRoute].title)),
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
                          PopupMenuItem(
                            child: Text("Wyloguj"),
                            value: "logout",
                          ),
                        ]).then((value) {
                          if (value == "logout") {
                            GoogleSignIn().signOut();
                            FirebaseAuth.instance.signOut().then((value) => SystemNavigator.pop());
                          }
                          animationController.reverse();
                          return null;
                        });
                      },
                      child: Container(
                        key: drawerHeaderKey,
                        color: Colors.transparent,
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                        child: RotationTransition(
                          turns: animationController,
                          child: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Obx(
                  () => Column(
                    children: [
                      for (var route in routesList)
                        Container(
                          color: route.key == currentRoute() ? Colors.blueGrey[200] : Colors.blueGrey[100],
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
                              Navigator.of(context).pop();
                              if(currentRoute() == route.key){
                                return;
                              }
                              currentRoute.value = route.key;
                              navigatorKey.currentState.pushReplacementNamed(route.key);
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Navigator(
        key: navigatorKey,
        initialRoute: currentRoute(),
        onGenerateRoute: (settings) {
          print(settings.name);
          if (settings.name == '/') {
            return MaterialPageRoute(builder: (context) => Container(), settings: settings);
          }
          currentRoute.value = settings.name;
          return GetPageRoute(
            page: () => routes[settings.name].builder(context),
            transitionDuration: Duration(milliseconds: 500),
            settings: settings,
            transition: Transition.topLevel,
            curve: Curves.ease,
          );
        },
      ),
      bottomNavigationBar: widget.bottomNavigationBar,
    );
  }
}
