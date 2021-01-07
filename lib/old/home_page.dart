import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'authentication.dart';
import 'home_cupertino.dart';
import 'musicizing.dart';
import 'login_signup_page.dart';
import 'running.dart';
import 'package:firebase_database/firebase_database.dart';
import 'todo.dart';
import 'globals.dart' as globals;
import 'dart:async';
import 'mainwidget.dart';
//import 'package:location/location.dart';
import 'location_service.dart';
import 'package:sensors/sensors.dart';
//import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'user_location.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:screen/screen.dart';
import 'hex_color.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //final router = Router();
  List<double> _accelerometerValues;
  List<double> _userAccelerometerValues;
  List<double> _gyroscopeValues;
  // AudioPlayer advancedPlayer = AudioPlayer();
  final dbRef = FirebaseDatabase.instance.reference().child("users");
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // Location location = new Location();
  // Future<LocationData> userLocation;

  final FirebaseDatabase _database = FirebaseDatabase.instance;
  //bool _isEmailVerified = false;
  StreamSubscription<Event> _onTodoAddedSubscription;
  StreamSubscription<Event> _onTodoChangedSubscription;
  final _textEditingController = TextEditingController();
  List<Todo> _todoList;
  Query _todoQuery;
  // AudioPlayerStateChangeHandler audioPlayerStateChangeHandler;
  // AudioPlayerState _audioPlayerState;
  // AudioPlayerState get state => _audioPlayerState;
  double musicSpeed = 1.0;
  static final double diff = 0.05;
  double intensity;
  static final int intensityLevel = 7;

  int _page = 0;
  PageController _pageController;

  GlobalKey _bottomNavigationKey = GlobalKey();

  @override
  void dispose() {
    // advancedPlayer = null;
    // _onTodoAddedSubscription.cancel();
    // _onTodoChangedSubscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _pageController = new PageController();
  }

  @override
  void callback(int runningPage) {
    setState(() {
      globals.runningPage = runningPage;
    });
  }

  signOut() async {
    // advancedPlayer.stop();
    globals.runningPage = 0;
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }

  void tabTapped(int index) {
    setState(() {
      _pageController.animateToPage(index,
          duration: Duration(milliseconds: 200), curve: Curves.easeOut);
    });
  }

  void pageChanged(int index) {
    setState(() {
      globals.page = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _children = [
      MainWidget(
          userId: widget.userId,
          auth: widget.auth,
          logoutCallback: widget.logoutCallback),
      Running(this.callback),
      ImageCapture(),
    ];

    setState(() {
      dbRef
          .child(globals.userId)
          .child("musicpoints")
          .once()
          .then((DataSnapshot snapshot) {
        globals.musicpoints = snapshot.value;
      });
      // if (state == AudioPlayerState.PLAYING) {
      //   print('a');
      //   tempoModification(intensity);
      // }
    });

    if (globals.runningPage == 0 || globals.runningPage == 3) {
      globals.navBar = new Container(
          // height: 50.0,
          alignment: Alignment.bottomCenter,
          // color: Colors.blue,
          child: Container(
            height: 61.0,
            // alignment: Alignment.bottomCenter,
            //  height: 50,
            margin:
                EdgeInsets.only(bottom: 7.5, top: 7.5, left: 15.0, right: 15.0),
            // height: 100.0,
            decoration: BoxDecoration(
              boxShadow: [
                new BoxShadow(
                  color: Color.fromARGB(130,0,0,0),
                  blurRadius: 5.0,
                ),
              ],
              // border: Border(top: BorderSide(width: 1.0, color: HexColor('#FFFFFF'))),
              color: HexColor('#ffffff'),
              borderRadius: new BorderRadius.circular(15.0),
            ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                //   child: Padding(
                //     padding:
                //         const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                    child: GNav(
                    gap: 8,
                    activeColor: Colors.white,
                    iconSize: 20,
                    // color: Colors.blue,
                    // backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    duration: Duration(milliseconds: 800),
                    tabBackgroundColor: HexColor('#5660E8'),
                    tabs: [
                      GButton(
                        iconSize: 25.0,
                        icon: Icons.home,
                        text: 'Home',
                        iconColor: HexColor('#111877'), //#F4C4F3
                      ),
                      GButton(
                        iconSize: 25.0,
                        icon: Icons.panorama_fish_eye,
                        text: 'Musicize',
                        iconColor: HexColor('#111877'),
                      ),
                      GButton(
                        iconSize: 25.0,
                        icon: Icons.people,
                        text: 'Profile',
                        iconColor: HexColor('#111877'),
                      ),
                    ],
                    selectedIndex: globals.page,
                    onTabChange: tabTapped,
                  ),
                  )
                  
                ]
                //   ),
                ),
          ));
    } else {
      globals.navBar = null;
    }

    return new Stack(children: <Widget>[
      // globals.navBar,
      Scaffold(
        resizeToAvoidBottomPadding: false,
        // bottomNavigationBar: globals.navBar,
        /*
        appBar: new AppBar(
          title: new Text('Home'),
          backgroundColor: HexColor('#19CFFC'),
        ),*/
        // body: SizedBox(
        //   height: MediaQuery.of(context).size.height,
        //   width: MediaQuery.of(context).size.width,
        //   child:
        body: Stack(fit: StackFit.passthrough, children: <Widget>[
          Container(
            child: new PageView(
              physics: globals.runningPage != 0 || globals.runningPage != 3
                  ? new NeverScrollableScrollPhysics()
                  : PageScrollPhysics(),
              controller: _pageController,
              onPageChanged: pageChanged,
              children: <Widget>[
                new MainWidget(
                    userId: widget.userId,
                    auth: widget.auth,
                    logoutCallback: widget.logoutCallback),
                new Running(this.callback),
                new ProfilePage(userId: widget.userId,
                    auth: widget.auth,
                    logoutCallback: widget.logoutCallback),
              ],
            ),
          ),
          SizedBox(
            // height: 100.0,
            child: globals.navBar,
          )
        ]),
      ),
    ]);
  }
}
