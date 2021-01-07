/*
UPDATED: 7/29/20
This is the main home page after logging in for Musicizer. 
1. Statistics (music points every day per week)
2. Leaderboard

Copyright Musicizer LLC.
*/
import 'dart:math';
import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/animation.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../services/authentication.dart';
import '../../services/globals.dart' as globals;
import '../../services/hex_color.dart';

import '../../widgets/leaderboard.dart';


class MainWidget extends StatefulWidget {
  MainWidget({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget>
    with SingleTickerProviderStateMixin {
  // AudioPlayer advancedPlayer = AudioPlayer();
  Animation pointsAnimation;
  Animation scheduleAnimation;
  Animation avgAnimation;
  AnimationController animationController;

  final dbRef = FirebaseDatabase.instance.reference().child("users");

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  

  // Location location = new Location();
  // Future<LocationData> userLocation;

  final FirebaseDatabase _database = FirebaseDatabase.instance;

  List<double> _userAccelerometerValues;

  //bool _isEmailVerified = false;

  Future<int> getMusicPoints() async {
    await dbRef
        .child(globals.userId)
        .child("musicpoints")
        .once()
        .then((DataSnapshot snapshot) {
      globals.musicpoints = snapshot.value;
    });

    return globals.musicpoints;

    // print("finished musicpoints");
  }

  @override
  void initState() {
    print('starting state');
    super.initState();

    animationController =
        AnimationController(duration: Duration(seconds: 2), vsync: this);
    print(globals.musicpoints.toString());
    getMusicPoints().then((value) => {
          pointsAnimation = IntTween(begin: 0, end: value).animate(
              CurvedAnimation(
                  parent: animationController, curve: Curves.easeOut))
        });
    scheduleAnimation = IntTween(begin: 0, end: 8).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeOut));
    avgAnimation = IntTween(begin: 0, end: 32).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeOut));

    animationController.forward();
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

  @override
  Widget build(BuildContext context) {
   

    setState(() {
      getMusicPoints();
    });
    return new Stack(children: <Widget>[
      // SizedBox(
      Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
      ),

      Container(
        height: MediaQuery.of(context).size.height,
        // width: 1000.0,
        alignment: Alignment.topCenter,
        // child: Transform.rotate(
        // angle: -pi / 32.0,
        child: Container(
          height: 300,
          decoration: BoxDecoration(
            color: HexColor('#5660E8'),
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(25.0),
              bottomLeft: Radius.circular(25.0),
            ),
          ),
          // width: 400,
          // padding: const EdgeInsets.all(8.0),
        ),
        // ),
      ),

      Container(
        decoration: new BoxDecoration(
            // color: HexColor('#5660E8'),
            /*gradient: new LinearGradient(
            colors: [HexColor('#84f7fe'), HexColor('#6fa8f5')],
            begin: const FractionalOffset(0.0, 1.0),
            end: const FractionalOffset(0.0, 0.0),
            stops: [0.0, 0.5],
            tileMode: TileMode.clamp),*/
            ),
        // color: HexColor('19CFFC'),
        child: ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FadeInDown(
                      child: Container(
                        margin: EdgeInsets.all(8.0),
                        height: 40.0,
                        width: 125.0,
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              
                              Container(
                                
                                child: Image.asset('assets/musicizer.png', scale: 1),
                              ),
                              AutoSizeText(globals.musicpoints.toString(),
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      color: HexColor('#5660E8'),
                                      fontWeight: FontWeight.bold))
                            ]))),
                    FadeInDown(
                      child: Container(
                        height: 70.0,
                        width: 70.0,
                        margin: EdgeInsets.only(right: 4.0),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(35.0),
                            image: DecorationImage(
                                image: NetworkImage(globals.pfpUrl),
                                fit: BoxFit.cover)),
                      ),
                    ),
                  ]),
            ),

            Container(
                height: 100.0,
               
                margin: EdgeInsets.only(left: 24.0),
                // width: 500.0,

                child: Column(
                  
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      FadeInUp(
                          child: AutoSizeText(
                              'Hello, ' + globals.username.toString() + ".",
                              maxLines: 1,
                              
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 40,
                              ))),
                         FadeInUp(
                          child: AutoSizeText(
                              'Exercise at your own tempo.',
                              maxLines: 1,
                              
                              style: TextStyle(
                                color: Colors.white,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w200,

                                fontSize: 20,
                              ))),
                    ])),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                  bottomLeft: Radius.circular(15.0),
                  bottomRight: Radius.circular(15.0),
                )),
                child: Container(
                    padding: EdgeInsets.only(bottom: 16.0, top: 16.0),
                    child: new Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        // r
                        children: <Widget>[
                          // Container(
                          //   margin: EdgeInsets.only(left: 16.0),
                          //   child: Row(
                          //   children: <Widget>[AutoSizeText(

                          //   'Statistics', textAlign: TextAlign.left, style: TextStyle(fontSize: 30.0,
                          //   fontWeight: FontWeight.w500,
                          //   color: Colors.white,

                          //   )
                          // ),],
                          // ),

                          // ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 300.0,
                            child: BarChartSample1(),

                          ),
                          

                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                          //   children: <Widget>[
                          //     Column(
                          //       mainAxisAlignment: MainAxisAlignment.center,
                          //       crossAxisAlignment: CrossAxisAlignment.center,
                          //       children: <Widget>[
                          //         FadeInLeft(
                          //           child: SizedBox(
                          //             // width: 150,
                          //             // height: 150,

                          //             child: Container(
                          //               width: 150,
                          //             height: 150,
                          //           // height: 200,
                          //           // width: 175,

                          //           decoration: BoxDecoration(
                          //             boxShadow: [
                          //               BoxShadow(
                          //                 color:
                          //                     Colors.black.withOpacity(0.3),
                          //                 // spreadRadius: 1,
                          //                 blurRadius: 40,
                          //                 offset: Offset(0,
                          //                     0), // changes position of shadow
                          //               ),
                          //             ],
                          //             color: Colors.white,

                          //             borderRadius:
                          //                 new BorderRadius.circular(20.0),
                          //           ),
                          //           child: Column(
                          //             mainAxisAlignment: MainAxisAlignment.center,
                          //             children: <Widget>[
                          //             // Text('Total Points\n',
                          //             //     textAlign: TextAlign.left,
                          //             //     style: TextStyle(
                          //             //         color: Colors.grey,
                          //             //         fontFamily: 'Raleway',
                          //             //         fontSize: 14,
                          //             //         fontWeight: FontWeight.w400)),

                          //             Center(
                          //                 child: Column(children: <Widget>[
                          //               Column(children: <Widget>[
                          //                 AnimatedBuilder(
                          //                     animation: animationController,
                          //                     builder: (BuildContext context,
                          //                         Widget child) {
                          //                       return new AutoSizeText(
                          //                           pointsAnimation.value.toString(),
                          //                           maxLines: 1,
                          //                           style: TextStyle(
                          //                               fontSize: 40.0,
                          //                               color: HexColor('#5660E8'), fontFamily: 'Raleway', fontWeight: FontWeight.w600));
                          //                     }),

                          //                 // McCountingText(
                          //                 //   begin: globals.musicpoints
                          //                 //       .toDouble(),
                          //                 //   end: globals.musicpoints
                          //                 //       .toDouble(),
                          //                 //   style: TextStyle(
                          //                 //       fontSize: 30.0,
                          //                 //       color: Colors.white,
                          //                 //       fontWeight: FontWeight.w600),
                          //                 //   duration: Duration(seconds: 5),
                          //                 //   curve: Curves.fastOutSlowIn,
                          //                 // ),
                          //                 // Text(
                          //                 //   '10000',
                          //                 //   textAlign: TextAlign.center,
                          //                 //   style: TextStyle(
                          //                 //       fontSize: 30.0,
                          //                 //       color: Colors.white,
                          //                 //       fontWeight: FontWeight.w600),
                          //                 // ),
                          //                 Text('\nTempoPoints',
                          //                     textAlign: TextAlign.right,
                          //                     style: TextStyle(
                          //                         color: Colors.black,
                          //                         fontFamily: 'Raleway',
                          //                         fontSize: 14,
                          //                         fontWeight: FontWeight.w400)),
                          //               ]),
                          //             ])),
                          //           ]),
                          //         )))
                          //       ],
                          //     ),
                          //     FadeInRight(
                          //       child: Column(
                          //         children: <Widget>[
                          //           SizedBox (
                          //           child: Container(
                          //             height: 150,
                          //             width: 150,

                          //             decoration: BoxDecoration(
                          //               boxShadow: [
                          //                 BoxShadow(
                          //                   color:
                          //                     Colors.black.withOpacity(0.3),
                          //                 // spreadRadius: 1,
                          //                 blurRadius: 40,
                          //                 offset: Offset(0,
                          //                     0), // changes position of shadow
                          //                 ),
                          //               ],
                          //               color: Colors.white,
                          //               border: Border.all(
                          //           width: 1,
                          //           color: Colors.white,
                          //         ),
                          //               borderRadius:
                          //                   new BorderRadius.circular(20.0),
                          //             ),
                          //             child: Column(
                          //                mainAxisAlignment: MainAxisAlignment.center,
                          //               children: <Widget>[

                          //               Center(
                          //                   child: Column(children: <Widget>[
                          //                 Column(children: <Widget>[
                          //                   AnimatedBuilder(
                          //                       animation:
                          //                           animationController,
                          //                       builder:
                          //                           (BuildContext context,
                          //                               Widget child) {
                          //                         return new Text(
                          //                             avgAnimation.value
                          //                                 .toString(),
                          //                             style: TextStyle(
                          //                               color: HexColor('#5660E8'),
                          //                                 fontSize: 40.0,
                          //                                  fontFamily: 'Raleway', fontWeight: FontWeight.w600));
                          //                       }),
                          //                   // McCountingText(
                          //                   //   begin: 30,
                          //                   //   end: 30,
                          //                   //   style: TextStyle(
                          //                   //       fontSize: 30.0,
                          //                   //       fontWeight:
                          //                   //           FontWeight.w600),
                          //                   //   duration: Duration(seconds: 1),
                          //                   //   curve: Curves.fastOutSlowIn,
                          //                   // ),
                          //                   // Text(
                          //                   //   '36',
                          //                   //   textAlign: TextAlign.center,
                          //                   //   style: TextStyle(
                          //                   //       fontSize: 30.0,
                          //                   //       fontWeight:
                          //                   //           FontWeight.w600),
                          //                   // ),
                          //                   Text('\nmin/day',
                          //                       style: TextStyle(
                          //                          color: Colors.black,
                          //                           fontFamily: 'Raleway',
                          //                           fontSize: 14,
                          //                           fontWeight:
                          //                               FontWeight.w400))
                          //                 ]),
                          //               ])),
                          //             ]),
                          //           ))
                          //         ],
                          //       ),
                          //     )
                          //   ],
                          // ),
                          // Container(
                          //     padding: EdgeInsets.all(16.0),
                          //     child: Column(
                          //         mainAxisAlignment: MainAxisAlignment.center,
                          //         crossAxisAlignment:
                          //             CrossAxisAlignment.center,
                          //         children: <Widget>[
                          //           FadeIn(
                          //               child: Text('\nNext Run',
                          //                   style: TextStyle(
                          //                     color: HexColor('#5660E8'),
                          //                     fontFamily: 'Raleway',
                          //                     fontSize: 18,
                          //                     fontWeight: FontWeight.w400,
                          //                   ))),
                          //           Row(
                          //             mainAxisAlignment:
                          //                 MainAxisAlignment.spaceAround,
                          //             children: <Widget>[
                          //               FadeInLeft(
                          //                   child: Column(
                          //                 children: <Widget>[
                          //                   Container(
                          //                     padding: EdgeInsets.all(12.0),
                          //                     // height: 200,
                          //                     // width: 175,

                          //                     child: Column(
                          //                         children: <Widget>[
                          //                           Center(
                          //                               child: Column(
                          //                                   children: <
                          //                                       Widget>[
                          //                                 Column(
                          //                                     children: <
                          //                                         Widget>[
                          //                                       Row(
                          //                                         children: <
                          //                                             Widget>[
                          //                                           AnimatedBuilder(
                          //                                               animation:
                          //                                                   animationController,
                          //                                               builder:
                          //                                                   (BuildContext context, Widget child) {
                          //                                                 return new Text(scheduleAnimation.value.toString(),
                          //                                                     style: TextStyle(fontSize: 50.0, color: HexColor('#5660E8'), fontFamily: 'Raleway', fontWeight: FontWeight.w500));
                          //                                               }),
                          //                                           Text(
                          //                                             ':',
                          //                                             textAlign:
                          //                                                 TextAlign.center,
                          //                                             style: TextStyle(
                          //                                                 fontSize:
                          //                                                     50.0,
                          //                                                 color:
                          //                                                     HexColor('#5660E8'),
                          //                                                 fontWeight: FontWeight.w500),
                          //                                           ),
                          //                                           McCountingText(
                          //                                             begin:
                          //                                                 0,
                          //                                             end: 0,
                          //                                             style: TextStyle(
                          //                                                 fontSize:
                          //                                                     50.0,
                          //                                                 color:
                          //                                                     HexColor('#5660E8'),
                          //                                                 fontWeight: FontWeight.w600),
                          //                                             duration:
                          //                                                 Duration(seconds: 1),
                          //                                             curve: Curves
                          //                                                 .fastOutSlowIn,
                          //                                           ),
                          //                                           McCountingText(
                          //                                             begin:
                          //                                                 0,
                          //                                             end: 0,
                          //                                             style: TextStyle(
                          //                                                 fontSize:
                          //                                                     50.0,
                          //                                                 color:
                          //                                                     HexColor('#5660E8'),
                          //                                                 fontWeight: FontWeight.w600),
                          //                                             duration:
                          //                                                 Duration(seconds: 1),
                          //                                             curve: Curves
                          //                                                 .fastOutSlowIn,
                          //                                           ),
                          //                                         ],
                          //                                       ),
                          //                                       Text('am',
                          //                                           textAlign:
                          //                                               TextAlign
                          //                                                   .right,
                          //                                           style: TextStyle(
                          //                                               color: HexColor('#5660E8'),
                          //                                               fontFamily:
                          //                                                   'Raleway',
                          //                                               fontSize:
                          //                                                   20,
                          //                                               fontWeight:
                          //                                                   FontWeight.w400)),
                          //                                     ]),
                          //                               ])),
                          //                         ]),
                          //                   )
                          //                 ],
                          //               )),
                          //               FadeInRight(
                          //                 child: Column(
                          //                   children: <Widget>[
                          //                     Container(
                          //                       padding: EdgeInsets.all(12.0),
                          //                       child:
                          //                           Column(children: <Widget>[
                          //                         Center(
                          //                             child:
                          //                                 Column(children: <
                          //                                     Widget>[
                          //                           Column(children: <Widget>[
                          //                             Text(
                          //                               '+200',
                          //                               textAlign:
                          //                                   TextAlign.center,
                          //                               style: TextStyle(
                          //                                   fontSize: 50.0,
                          //                                   color:
                          //                                       HexColor('#5660E8'),
                          //                                   fontWeight:
                          //                                       FontWeight
                          //                                           .w500),
                          //                             ),
                          //                             Text('MusicPoints',
                          //                                 style: TextStyle(
                          //                                     color: HexColor('#5660E8'),
                          //                                     fontFamily:
                          //                                         'Raleway',
                          //                                     fontSize: 20,
                          //                                     fontWeight:
                          //                                         FontWeight
                          //                                             .w400))
                          //                           ]),
                          //                         ])),
                          //                       ]),
                          //                     )
                          //                   ],
                          //                 ),
                          //               ),

                          //             ],
                          //           ),
                          //         ])),
                        ]))),
            // Container(
            //   margin: EdgeInsets.only(left: 24.0),

            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(5.0),
            //   ),
            //   child: Text(

            //     'Rankings',  style: TextStyle(fontSize: 30.0,
            //     fontWeight: FontWeight.w500,
            //     color:  HexColor('#5660E8'),

            //     ),
            //       ),
            // ),

            // Container(
            //     width: 200.0,
            //     height: 50.0,
            //     decoration: BoxDecoration(
            //       // color: HexColor('#f3f3f3'),
            //     ),
            //     margin: EdgeInsets.only(left: 24.0),
            //     child: Container(
            //       decoration:  BoxDecoration(
            //         // color: HexColor('#f3f3f3'),
            //       ),
            //       child: AutoSizeText(

            //     'Rankings', textAlign: TextAlign.left, style: TextStyle(fontSize: 30.0,
            //     fontWeight: FontWeight.w500,
            //     color: Colors.black,

            //     ),
            //       ),
            //   ),

            //   ),
            Container(
              padding: EdgeInsets.only(
                  top: 5.0, left: 5.0, right: 5.0, bottom: 50.0),
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    // spreadRadius: 1,
                    blurRadius: 40,
                    offset: Offset(0, 0), // changes position of shadow
                  ),
                ],
              ),
              child: Leaderboard(5, showText: true),
            )
          ],
        ),
      )
    ]);
  }
}

class BarChartSample1 extends StatefulWidget {
  final List<Color> availableColors = [
    Colors.purpleAccent,
    Colors.yellow,
    Colors.lightBlue,
    Colors.orange,
    Colors.pink,
    Colors.redAccent,
  ];

  @override
  State<StatefulWidget> createState() => BarChartSample1State();
}

class BarChartSample1State extends State<BarChartSample1> {
  final Color barBackgroundColor = Colors.grey[300];
  final Duration animDuration = const Duration(milliseconds: 250);

  int touchedIndex;
  bool loading = false;
  bool isPlaying = false;
  final dbRef = FirebaseDatabase.instance.reference().child("users");
  List<DayData> lastDays = [];
  void getDayData() async {
    loading = true;
    for (int i = 0; i < 7; i++) {
      print(i);
      await dbRef
          .child(globals.userId)
          .child("reports")
          .child(DateTime.now()
              .subtract(new Duration(days: i))
              .toString()
              .split(' ')[0])
          .once()
          .then((DataSnapshot snapshot) {
        if (snapshot.value != null) {
          var dailyPoints = 0;
          Map<dynamic, dynamic> values = snapshot.value;
          // print(snapshot.value);

          values.forEach((k, v) {
            dailyPoints += v["earned"];
          });

          print(dailyPoints);
          print(DayData(
              i, dailyPoints, DateTime.now().subtract(new Duration(days: i))));
          lastDays.add(new DayData(
              i, dailyPoints, DateTime.now().subtract(new Duration(days: i))));
        } else {
          print(DayData(i, 0, DateTime.now().subtract(new Duration(days: i))));
          lastDays.add(new DayData(
              i, 0, DateTime.now().subtract(new Duration(days: i))));
        }
      });
    }
    setState(() {
      loading = false;
    });

    print(lastDays);
  }

  initState() {
    super.initState();
    getDayData();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                    'Statistics',
                    style: TextStyle(
                        color: HexColor('#5660E8'),
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    'Daily Points Earned',
                    style: TextStyle(
                      
                        // color: HexColor('#5660E8'),
                        fontSize: 14,
                        fontWeight: FontWeight.w300),
                  ),
                  const SizedBox(
                    height: 38,
                  ),
                  if (!loading) ...[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: BarChart(
                          isPlaying ? randomData() : mainBarData(),
                          swapAnimationDuration: animDuration,
                        ),
                      ),
                    ),
                  ],
                  if (loading) ...[
                    Center(
                      child: SizedBox(
                        width: 50.0,
                        height: 50.0,
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ],
                  const SizedBox(
                    height: 12,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: const Color(0xff0f4a3c),
                  ),
                  onPressed: () {
                    setState(() {
                      isPlaying = !isPlaying;
                      if (isPlaying) {
                        refreshState();
                      }
                    });
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  int getMaxPoints() {
    int maxPoints = 200;

    for (DayData d in lastDays) {
      if (d.musicPoints > maxPoints) {
        maxPoints = d.musicPoints;
      }
    }
    return maxPoints;
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color barColor = Colors.blue,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: isTouched ? y + 1 : y,
          color: isTouched ? Colors.blue : HexColor('#5660E8'),
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: getMaxPoints().toDouble(),
            color: barBackgroundColor,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(7, (i) {
        switch (i) {
          case 0:
            return makeGroupData(lastDays[6].timestamp.weekday - 1,
                lastDays[6].musicPoints.toDouble(),
                isTouched: i == touchedIndex);
          case 1:
            return makeGroupData(lastDays[5].timestamp.weekday - 1,
                lastDays[5].musicPoints.toDouble(),
                isTouched: i == touchedIndex);
          case 2:
            return makeGroupData(lastDays[4].timestamp.weekday - 1,
                lastDays[4].musicPoints.toDouble(),
                isTouched: i == touchedIndex);
          case 3:
            return makeGroupData(lastDays[3].timestamp.weekday - 1,
                lastDays[3].musicPoints.toDouble(),
                isTouched: i == touchedIndex);
          case 4:
            return makeGroupData(lastDays[2].timestamp.weekday - 1,
                lastDays[2].musicPoints.toDouble(),
                isTouched: i == touchedIndex);
          case 5:
            return makeGroupData(lastDays[1].timestamp.weekday - 1,
                lastDays[1].musicPoints.toDouble(),
                isTouched: i == touchedIndex);
          case 6:
            return makeGroupData(lastDays[0].timestamp.weekday - 1,
                lastDays[0].musicPoints.toDouble(),
                isTouched: i == touchedIndex);
          default:
            return null;
        }
      });

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blueGrey,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String weekDay;
              switch (group.x.toInt()) {
                case 0:
                  weekDay = 'Monday';
                  break;
                case 1:
                  weekDay = 'Tuesday';
                  break;
                case 2:
                  weekDay = 'Wednesday';
                  break;
                case 3:
                  weekDay = 'Thursday';
                  break;
                case 4:
                  weekDay = 'Friday';
                  break;
                case 5:
                  weekDay = 'Saturday';
                  break;
                case 6:
                  weekDay = 'Sunday';
                  break;
              }
              return BarTooltipItem(weekDay + '\n' + (rod.y - 1).toString(),
                  TextStyle(color: Colors.yellow));
            }),
        touchCallback: (barTouchResponse) {
          setState(() {
            if (barTouchResponse.spot != null &&
                barTouchResponse.touchInput is! FlPanEnd &&
                barTouchResponse.touchInput is! FlLongPressEnd) {
              touchedIndex = barTouchResponse.spot.touchedBarGroupIndex;
            } else {
              touchedIndex = -1;
            }
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          textStyle: TextStyle(
              color: HexColor('#5660E8'),
              fontWeight: FontWeight.bold,
              fontSize: 14),
          margin: 16,
          getTitles: (double value) {
            switch (value.toInt()) {
              case 0:
                return 'M';
              case 1:
                return 'T';
              case 2:
                return 'W';
              case 3:
                return 'T';
              case 4:
                return 'F';
              case 5:
                return 'S';
              case 6:
                return 'S';
              default:
                return '';
            }
          },
        ),
        leftTitles: SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
    );
  }

  BarChartData randomData() {
    return BarChartData(
      barTouchData: BarTouchData(
        enabled: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          textStyle: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          margin: 16,
          getTitles: (double value) {
            switch (value.toInt()) {
              case 0:
                return 'M';
              case 1:
                return 'T';
              case 2:
                return 'W';
              case 3:
                return 'T';
              case 4:
                return 'F';
              case 5:
                return 'S';
              case 6:
                return 'S';
              default:
                return '';
            }
          },
        ),
        leftTitles: SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: List.generate(7, (i) {
        switch (i) {
          case 0:
            return makeGroupData(0, Random().nextInt(getMaxPoints()).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 1:
            return makeGroupData(1, Random().nextInt(getMaxPoints()).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 2:
            return makeGroupData(2, Random().nextInt(getMaxPoints()).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 3:
            return makeGroupData(3, Random().nextInt(getMaxPoints()).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 4:
            return makeGroupData(4, Random().nextInt(getMaxPoints()).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 5:
            return makeGroupData(5, Random().nextInt(getMaxPoints()).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 6:
            return makeGroupData(6, Random().nextInt(getMaxPoints()).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          default:
            return null;
        }
      }),
    );
  }

  Future<dynamic> refreshState() async {
    setState(() {});
    await Future<dynamic>.delayed(
        animDuration + const Duration(milliseconds: 50));
    if (isPlaying) {
      refreshState();
    }
  }
}

class DayData {
  int day;
  int musicPoints;
  DateTime timestamp;
  DayData(this.day, this.musicPoints, this.timestamp);

  String toString() {
    return "Day: " +
        this.day.toString() +
        " from today. " +
        this.musicPoints.toString() +
        " musicPoints earned.";
  }
}
