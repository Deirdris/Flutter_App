import 'package:chores_flutter/data/chores_user.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Bootstrap extends StatefulWidget {
  @override
  _BootstrapState createState() => _BootstrapState();
}

class _BootstrapState extends State<Bootstrap> {
  Future initFuture;

  Future init(context) async {
    await Firebase.initializeApp();
    var provider = Provider.of<ChoresUser>(context, listen: false);
    bool isAuthenticated = await Provider.of<ChoresUser>(context, listen: false).checkAuthStatus();
    if(!isAuthenticated){
      await Provider.of<ChoresUser>(context, listen: false).signin();
    }else{
      await provider.fetchUserData();
    }
  }

  @override
  Widget build(BuildContext context) {
    if(initFuture == null){
      initFuture = init(context);
    }

    return Container(
      // width: MediaQuery.of(context),
      color: Colors.white,
      child: FutureBuilder(
        future: initFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.of(context).pushReplacementNamed("/job");
            });
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
