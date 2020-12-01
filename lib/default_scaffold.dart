import 'package:chores_flutter/routes.dart';
import 'package:flutter/material.dart';

class DefaultScaffold extends StatefulWidget {
  DefaultScaffold({this.body, this.bottomNavigationBar});

  final Widget body;
  final Widget bottomNavigationBar;

  @override
  _DefaultScaffoldState createState() => _DefaultScaffoldState();
}

class _DefaultScaffoldState extends State<DefaultScaffold> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

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
        child: Container(
          color: Colors.blueGrey[100],
          child: ListView(
            children: [
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
                      Navigator.pushNamed(context, route.key);
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
      body: widget.body,
      bottomNavigationBar: widget.bottomNavigationBar,
    );
  }
}
