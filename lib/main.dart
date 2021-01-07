/*
UPDATED: 7/29/20
Main page.

Copyright Musicizer LLC.
*/


import 'package:flutter/material.dart';
import 'services/authentication.dart';

import 'pages/root_page.dart';


void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage("assets/time.jpg"), context);
    return MaterialApp(
            title: 'Musicizer',
            debugShowCheckedModeBanner: false,
            theme: new ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: new RootPage(auth: new Auth()));
  }
}
