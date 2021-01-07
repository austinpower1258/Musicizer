import 'package:flutter/material.dart';
import 'authentication.dart';
import 'root_page.dart';
import 'location_service.dart';
import 'user_location.dart';
import 'package:provider/provider.dart';
//import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter/services.dart';

import 'dart:async';
import 'package:flutter/material.dart';


void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage("assets/time.jpg"), context);
    return StreamProvider<UserLocation>(
        create: (context) => LocationService().locationStream,
        child: MaterialApp(
            title: 'Musicizer',
            debugShowCheckedModeBanner: false,
            theme: new ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: new RootPage(auth: new Auth())));
  }
}
