import 'package:flutter/material.dart';
import 'start/login_signup_page.dart';
import '../services/authentication.dart';
import 'package:firebase_database/firebase_database.dart';
import 'home/home_routing.dart';
import 'start/onboarding.dart';
import '../services/globals.dart' as globals;

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  SIGNUP_PAGE,
  LOGGED_IN,
}

class RootPage extends StatefulWidget {
  RootPage({this.auth});

  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;

  String _userId = "";

  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user?.uid;
        }

        authStatus =
            user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }

  void loginCallback() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid.toString();
      });
    });
    setState(() {
      print('refresh state after onboarding');
      authStatus = AuthStatus.LOGGED_IN;
    });
  }

  void logoutCallback() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
    });
  }

  void pageCallback() {
    setState(() {
      authStatus = AuthStatus.SIGNUP_PAGE;
    
    });
  }

  Widget buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return buildWaitingScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return new OnBoardingPage(
          auth: widget.auth,
          pageCallback: pageCallback,
        );
        break;
      case AuthStatus.SIGNUP_PAGE: 
        return new LoginSignupPage(
          auth: widget.auth,
          loginCallback: loginCallback,
        );
        break;
      case AuthStatus.LOGGED_IN:
        if (_userId.length > 0 && _userId != null) {
          //&& globals.tempFill) {
          globals.userId = _userId;
          final dbRef = FirebaseDatabase.instance.reference().child("users");
          dbRef
              .child(globals.userId)
              .child("musicpoints")
              .once()
              .then((DataSnapshot snapshot) {
            globals.musicpoints = snapshot.value;
          });
          dbRef
              .child(globals.userId)
              .child("username")
              .once()
              .then((DataSnapshot snapshot) {
            globals.username = snapshot.value;
          });
          dbRef
              .child(globals.userId)
              .child("pfpUrl")
              .once()
              .then((DataSnapshot snapshot) {
            globals.pfpUrl = snapshot.value as String;
            print(globals.pfpUrl);
          });

          return new Routing(
            userId: _userId,
            auth: widget.auth,
            logoutCallback: logoutCallback,
          );
        } else
          return OnBoardingPage(
              auth: widget.auth, pageCallback: pageCallback);
        break;
      default:
        return buildWaitingScreen();
    }
  }
}
