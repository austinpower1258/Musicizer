/*
UPDATED: 7/29/20
The Time-Level screen allows the user the input the time and level for their musicize.
Copyright Musicizer LLC.
*/
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as prefix;
import 'package:animate_do/animate_do.dart';
import 'package:flutter/gestures.dart';
import 'package:getflutter/getflutter.dart';
import '../../services/hex_color.dart';
import '../../services/globals.dart' as globals;


class TimeLevel extends StatefulWidget {
  Function callback;

  TimeLevel(this.callback);

  @override
  _TimeLevelState createState() => _TimeLevelState();
}

class _TimeLevelState extends State<TimeLevel> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final navigatorKey = GlobalKey<NavigatorState>();
  var yt = prefix.YoutubeExplode();
  bool loaded = false;
  List<bool> lengthActive = [true, false, false, false];
  @override
  void initState() {
    super.initState();
  }

  String percentageModifier(double value) {
    final roundedValue = value.ceil().toInt().toString();
    return '$roundedValue%';
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(children: <Widget>[
      Container(
        height: MediaQuery.of(context).size.height,
        color: HexColor('#f3f3f3'),
      ),
      Container(
        height: MediaQuery.of(context).size.height,
        // width: 1000.0,
        alignment: Alignment.topCenter,
        // child: Transform.rotate(
        // angle: -pi / 32.0,
        child: Container(
          height: MediaQuery.of(context).size.height - 300,
          // width: 400,
          // padding: const EdgeInsets.all(8.0),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25.0),
              bottomRight: Radius.circular(25.0),
            ),
            color: HexColor('#5660E8'),
          ),
        ),
        // ),
      ),
      Container(
        height: MediaQuery.of(context).size.height,

        // color: HexColor('19CFFC'),
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: <Widget>[
            Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                height: 200.0,
                // width: 500.0,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      FadeInUp(
                        child: Text('Musicize',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 32,
                            )),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 10.0),
                              width: 50.0,
                              height: 50.0,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              child: Center(
                                child: Text('1',
                                    style: TextStyle(
                                        color: HexColor('#5660E8'),
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.w300)),
                              ),
                            ),
                            Text('Intensity',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    color: Colors.white,
                                    fontSize: 24.0))
                          ]),
                      Container(
                        margin: EdgeInsets.only(top: 10.0, left: 20.0, bottom: 10.0),
                        child: SliderWidget(min: 1, max: 10, fullWidth: true),
                      ),
                    ])),
            // Container(
            //   margin: EdgeInsets.all(0),
            //   width: MediaQuery.of(context).size.width - 50,
            //   child: Text('1. Intensity',
            // textAlign: TextAlign.left,
            //     style: TextStyle(
            //       color: Colors.white,

            //       fontSize: 24.0,
            //       fontWeight: FontWeight.w500,
            //     )),
            // ),

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   // crossAxisAlignment: CrossAxisAlignment.center,
            //   children: <Widget>[
            //     Container(
            //       margin: EdgeInsets.symmetric(vertical: 25.0),
            //       width: 50.0,
            //       height: 50.0,
            //       decoration: BoxDecoration(
            //         color: Colors.white,
            //         borderRadius: BorderRadius.circular(25.0),
            //       ),
            //       child: Center(
            //         child: Text('1', style: TextStyle(
            //           fontSize: 20.0,
            //         )),
            //       ),
            //     ),
            //     SleekCircularSlider(
            //       appearance: CircularSliderAppearance(
            //           angleRange: 180,
            //           startAngle: 180,
            //           size: 200.0,
            //           animationEnabled: true,
            //           customWidths:
            //               CustomSliderWidths(progressBarWidth: 15),
            //           customColors: CustomSliderColors(
            //             gradientStartAngle: 270,
            //             gradientEndAngle: 360,
            //             trackColor: Colors.white,
            //             progressBarColors: [
            //               Colors.white,
            //               // HexColor('#5660E8'),
            //               Colors.white,
            //             ],
            //             shadowColor: Colors.white,
            //           ),
            //           infoProperties: InfoProperties(
            //               mainLabelStyle: TextStyle(
            //                   color: Colors.white,
            //                   fontSize: 45,
            //                   fontWeight: FontWeight.w500),
            //               modifier: percentageModifier,
            //               // topLabelText: 'Level',
            //               bottomLabelText: 'Intensity',
            //               bottomLabelStyle: TextStyle(
            //                   fontSize: 20, color: Colors.white))),
            //       min: 1,
            //       max: 100,
            //       initialValue: 50,
            //       onChange: (double value) {
            //         globals.level = (value ~/ 10).toDouble();
            //       },
            //     )
            //   ],
            // ),
            Container(
                height: MediaQuery.of(context).size.height - 270.0,
                margin: EdgeInsets.only(top: 10.0, left: 10.0),
                // width: MediaQuery.of(context).size.width - 28,
                // padding: EdgeInsets.only(left: 32.0, right: 32.0),
                child: new Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 10.0),
                              width: 50.0,
                              height: 50.0,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              child: Center(
                                child: Text('2',
                                    style: TextStyle(
                                        color: HexColor('#5660E8'),
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.w300)),
                              ),
                            ),
                            Text('Time',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    color: Colors.white,
                                    fontSize: 24.0))
                          ]),
                      // mainAxisSize: MainAxisSize.max,
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // crossAxisAlignment: CrossAxisAlignment.start,

                      Container(
                          margin: EdgeInsets.only(left: 10.0),
                          child: SizedBox(
                            height: 200.0,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: <Widget>[
                                // Row(
                                //   mainAxisAlignment:
                                //       MainAxisAlignment.start,
                                //   children: <Widget>[
                                //     Text('\n2. Time\n',
                                //         style: TextStyle(
                                //           color: HexColor('#5660E8'),
                                //           fontFamily: 'Raleway',
                                //           fontSize: 22.0,
                                //           fontWeight: FontWeight.w500,
                                //         )),

                                //   ],
                                // ),

                                Row(
                                  //  scrollDirection: Axis.horizontal,
                                  children: <Widget>[
                                    GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            lengthActive = [
                                              false,
                                              false,
                                              false,
                                              false
                                            ];
                                            lengthActive[0] = true;
                                            globals.minutes = (0 + 1) * 15;
                                          });
                                        },
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              FadeInLeft(
                                                child: Column(
                                                  children: <Widget>[
                                                    MinutesCard(lengthActive[0],
                                                        (0 + 1) * 15),
                                                  ],
                                                ),
                                              )
                                            ])),
                                    GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            lengthActive = [
                                              false,
                                              false,
                                              false,
                                              false
                                            ];
                                            lengthActive[1] = true;
                                            globals.minutes = (1 + 1) * 15;
                                          });
                                        },
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              FadeInLeft(
                                                child: Column(
                                                  children: <Widget>[
                                                    MinutesCard(lengthActive[1],
                                                        (1 + 1) * 15),
                                                  ],
                                                ),
                                              )
                                            ])),
                                    GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            lengthActive = [
                                              false,
                                              false,
                                              false,
                                              false
                                            ];
                                            lengthActive[2] = true;
                                            globals.minutes = (2 + 1) * 15;
                                          });
                                        },
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              FadeInRight(
                                                child: Column(
                                                  children: <Widget>[
                                                    MinutesCard(lengthActive[2],
                                                        (2 + 1) * 15),
                                                  ],
                                                ),
                                              )
                                            ])),
                                    GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            lengthActive = [
                                              false,
                                              false,
                                              false,
                                              false
                                            ];
                                            lengthActive[3] = true;
                                            globals.minutes = (3 + 1) * 15;
                                          });
                                        },
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              FadeInRight(
                                                child: Column(
                                                  children: <Widget>[
                                                    MinutesCard(lengthActive[3],
                                                        (3 + 1) * 15),
                                                  ],
                                                ),
                                              )
                                            ])),
                                  ],
                                ),
                              ],
                            ),
                          )),
                      Container(
                          height: 120.0,
                          // padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                          decoration: BoxDecoration(
                            // boxShadow: [
                            //   BoxShadow(
                            //     color: Colors.black.withOpacity(0.3),
                            //     // spreadRadius: 1,
                            //     blurRadius: 20,
                            //     offset:
                            //         Offset(0, 0), // changes position of shadow
                            //   ),
                            // ],
                            // color: Colors.white,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    FadeInLeft(
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 10.0),
                                            child: Column(children: <Widget>[
                                             
                                              
                                              GFButton(
                                                  icon: Icon(
                                                      Icons.arrow_forward,
                                                      size: 20,
                                                      color: HexColor('#5660E8')),
                                                  onPressed: () {
                                                    setState(() {
                                                      this.widget.callback(1);
                                                    } );
                                                  },
                                                  text: "Continue",
                                                  padding: EdgeInsets.only(
                                                      left: 16.0, right: 16.0),
                                                  textStyle: TextStyle(
                                                      fontFamily: 'Raleway',
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 20,
                                                      color: Colors.indigo[400]),
                                                  size: GFSize.LARGE,
                                                  shape: GFButtonShape.pills,
                                                  color: Colors.white,
                                                  borderSide: BorderSide(
                                                  color: HexColor('#5660E8'),
                                                 ), 
                                                
                                                  fullWidthButton: false,
                                                ),   
                                            ]),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ])),
                    ]))
          ],
        ),
      )
    ]);
  }
}

class MinutesCard extends StatelessWidget {
  bool active;
  int mins;
  MinutesCard(bool active, int mins) {
    this.active = active;
    this.mins = mins;
  }

  Widget build(BuildContext context) {
    if (active) {
      return Stack(children: <Widget>[Container(
          width: 100.0,
          height: 150.0,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 7,
                offset: Offset(0, 6), // changes position of shadow
              )
            ],
            gradient: LinearGradient(
              begin: Alignment(0.0, 0.0),
              end: Alignment(
                  1.0, 1.0), // 10% of the width, so there are ten blinds.
              colors: [
                HexColor('#4e54c8'),
                
                HexColor('#5660E8'),
                
              ],
              stops: [0.0,1.0], // whitish to gray
              tileMode:
                  TileMode.repeated, // repeats the gradient over the canvas
            ),
            border: Border.all(color: Colors.white, width: 2),
            borderRadius: new BorderRadius.circular(20.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
         
                  Text(
                    this.mins.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.w600),
                  ),
                  Text('min',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Raleway',
                          fontSize: 14,
                          fontWeight: FontWeight.w400))
           
        
            
          ])),
          Container(
              width: 100.0,
              height: 150.0,
              alignment: Alignment.topRight,
              padding: EdgeInsets.only(top: 15.0, right: 10.0),
              child: Icon(Icons.check, color: Colors.white),
            ),
          ]);
    } else {
      return Container(
        margin: EdgeInsets.only(left: 5.0, right: 5.0),
        width: 100.0,
          height: 150.0,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 7,
              offset: Offset(0, 6), // changes position of shadow
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment(0.0, 0.0),
            end: Alignment(1.0, 1.0),
            stops: [0, 1], // 10% of the width, so there are ten blinds.
            colors: [
              HexColor('#4e54c8'),
                
                HexColor('#5660E8'),
            ], // whitish to gray
            tileMode: TileMode.repeated, // repeats the gradient over the canvas
          ),
          // image: DecorationImage(
          //     fit: BoxFit.cover,
          //     colorFilter: new ColorFilter.mode(
          //         Colors.black.withOpacity(0.4), BlendMode.darken),
          //     image: AssetImage('assets/time.jpg')),
          // color: HexColor('#5660E8'),
          borderRadius: new BorderRadius.circular(20.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
        
      
              Text(
                this.mins.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.0,
                    fontWeight: FontWeight.w600),
              ),
              Text('min',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Raleway',
                      fontSize: 14,
                      fontWeight: FontWeight.w400))
         
       
        ]),
      );
    }
  }
}

class SliderWidget extends StatefulWidget {
  final double sliderHeight;
  final int min;
  final int max;
  final fullWidth;

  SliderWidget(
      {this.sliderHeight = 50,
      this.max = 10,
      this.min = 1,
      this.fullWidth = false});

  @override
  _SliderWidgetState createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  double _value = 0;

  @override
  Widget build(BuildContext context) {
    double paddingFactor = .2;

    if (this.widget.fullWidth) paddingFactor = .3;

    return Container(
      width: this.widget.fullWidth
          ? double.infinity
          : (this.widget.sliderHeight) * 5.5,
      height: (this.widget.sliderHeight),
      decoration: new BoxDecoration(
        borderRadius: new BorderRadius.all(
          Radius.circular((this.widget.sliderHeight * .3)),
        ),
        gradient: new LinearGradient(
            colors: [
              Colors.white,
              Colors.white,
            ],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 1.00),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(this.widget.sliderHeight * paddingFactor,
            2, this.widget.sliderHeight * paddingFactor, 2),
        child: Row(
          children: <Widget>[
            Text(
              '${this.widget.min}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: this.widget.sliderHeight * .3,
                fontWeight: FontWeight.w700,
                color: HexColor('#5660E8'),
              ),
            ),
            SizedBox(
              width: this.widget.sliderHeight * .1,
            ),
            Expanded(
              child: Center(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: HexColor('#5660E8').withOpacity(1),
                    inactiveTrackColor: HexColor('#5660E8').withOpacity(.5),

                    trackHeight: 4.0,
                    thumbShape: CustomSliderThumbCircle(
                      thumbRadius: this.widget.sliderHeight * .4,
                      min: this.widget.min,
                      max: this.widget.max,
                    ),
                    overlayColor: HexColor('#5660E8').withOpacity(.4),
                    //valueIndicatorColor: Colors.white,
                    activeTickMarkColor: HexColor('#5660E8'),
                    inactiveTickMarkColor: Colors.red.withOpacity(.7),
                  ),
                  child: Slider(
                      value: _value,
                      onChanged: (value) {
                        setState(() {
                          _value = value;
                          globals.level = this.widget.min.toDouble() + ((this.widget.max - this.widget.min) * value).floor();
                          print(globals.level);
                        });
                      }),
                ),
              ),
            ),
            SizedBox(
              width: this.widget.sliderHeight * .1,
            ),
            Text(
              '${this.widget.max}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: this.widget.sliderHeight * .3,
                fontWeight: FontWeight.w700,
                // color: HexColor('#5660E8'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomSliderThumbCircle extends SliderComponentShape {
  final double thumbRadius;
  final int min;
  final int max;

  const CustomSliderThumbCircle({
    @required this.thumbRadius,
    this.min = 1,
    this.max = 10,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    Animation<double> activationAnimation,
    Animation<double> enableAnimation,
    bool isDiscrete,
    TextPainter labelPainter,
    RenderBox parentBox,
    SliderThemeData sliderTheme,
    TextDirection textDirection,
    double value,
  }) {
    final Canvas canvas = context.canvas;

    final paint = Paint()
      ..color = HexColor('#5660E8')
      ..style = PaintingStyle.fill;

    TextSpan span = new TextSpan(
      style: new TextStyle(
        fontSize: thumbRadius * .8,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      text: getValue(value),
    );

    TextPainter tp = new TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr);
    tp.layout();
    Offset textCenter =
        Offset(center.dx - (tp.width / 2), center.dy - (tp.height / 2));

    canvas.drawCircle(center, thumbRadius * .9, paint);
    tp.paint(canvas, textCenter);
  }

  String getValue(double value) {
    return (min + ((max - min) * value).floor()).toString();
  }
}
