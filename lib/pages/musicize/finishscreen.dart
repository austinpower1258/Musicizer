/*
UPDATED: 7/29/20
The finish screen page is shown after the user finishes his/her Musicize. 
It creates a graph based on the intensity data collected during the Musicize.
It also shows key statistics about the Musicize.

Copyright Musicizer LLC.
*/

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/animation.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../services/globals.dart' as globals;
import '../../services/hex_color.dart';
import '../../services/intensity_data.dart';

class FinishScreen extends StatefulWidget {
  Function callback;

  FinishScreen(this.callback);

  State<StatefulWidget> createState() => new _FinishScreenState();
}

class _FinishScreenState extends State<FinishScreen>
    with SingleTickerProviderStateMixin {
  final dbRef = FirebaseDatabase.instance.reference().child("users");

  var loading = false;
  var loaded = false;
  List<FlSpot> stops;

  AnimationController animationController;
  @override
  void initState() {
    super.initState();
    stops = [];

    for (IntensityData i in globals.data) {
      stops.add(new FlSpot(i.time.toDouble(), i.value.toDouble()));
    }
  }

  Widget build(BuildContext context) {
    return new Stack(children: <Widget>[

      // BLUE BACKGROUND
      Container(
        height: MediaQuery.of(context).size.height,
        color: HexColor('#5660E8'),
      ),

      // BOTTOM WHITE BACKGROUND
      Container(
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.bottomRight,
        child: Container(
          height: MediaQuery.of(context).size.height - 100,
          color: HexColor('#f3f3f3'),
        ),
      ),

      // MAIN CONTENT
      Container(
          child: ListView(children: <Widget>[
        Center(
            child: Container(
                padding: EdgeInsets.only(top: 20.0),
                decoration: new BoxDecoration(
                  color: HexColor('5660E8'),
                ),
               
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                           //CHECK ICON
                          Icon(
                            Icons.check_circle_outline,
                            color: Colors.white,
                            size: 75.0,
                          ),
                           //GOOD MUSICIZE
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text('Good Musicize,',
                                  style: TextStyle(
                                      fontSize: 20.0, color: Colors.white)),
                              AutoSizeText(globals.username,
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 60.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white)),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 125,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        //LINE GRAPH
                        child: LineChart(
                          LineChartData(
                            lineTouchData: LineTouchData(enabled: false),
                            lineBarsData: [
                              LineChartBarData(
                                spots: stops,
                                isCurved: true,
                                barWidth: 5,
                                colors: [
                                  Colors.white,
                                ],
                                belowBarData: BarAreaData(
                                  show: true,
                                  colors: [
                                    Colors.white.withOpacity(0.4),
                                    Colors.white.withOpacity(0.0),
                                  ],
                                  gradientColorStops: [0, 1],
                                  gradientFrom: Offset(0, 0),
                                  gradientTo: Offset(0, 1),
                                ),
                                dotData: FlDotData(
                                  show: false,
                                ),
                              ),
                            ],
                            minY: 0,
                            extraLinesData: ExtraLinesData(horizontalLines: [
                              HorizontalLine(
                                y: 2 * globals.level,
                                label: HorizontalLineLabel(
                                  labelResolver: (line) => 'Hii',
                                  alignment: Alignment.topRight,
                                  padding: const EdgeInsets.only(
                                      right: 5, bottom: 5),
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 9),
                                ),
                                dashArray: [5, 5],
                                color: Colors.white,
                              ),
                            ]),
                            gridData: FlGridData(show: false),
                            borderData: FlBorderData(show: false),
                            titlesData: FlTitlesData(
                              show: false,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              // MUSIC POINTS EARNED
                              AutoSizeText(
                                  '+' + globals.musicpointsEarned.toString(),
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 30.0,
                                      color: Colors.white)),
                              Text('TempoPoints',
                                  style: TextStyle(
                                      fontSize: 15.0, color: Colors.white)),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              // PERCENT ON PACE
                              Text(
                                  ((globals.onPace * 100) ~/
                                              globals.data.length)
                                          .toString() +
                                      "%",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 30.0,
                                      color: Colors.white)),
                              Text('On Pace',
                                  style: TextStyle(
                                      fontSize: 15.0, color: Colors.white)),
                            ],
                          ),
                        ],
                      ),

                      // MUSICIZE AGAIN(RETURN TO TIME-LEVEL)
                      new Container(
                          width: MediaQuery.of(context).size.width * 0.60,
                          height: 50.0,
                          margin: EdgeInsets.only(bottom: 125.0),
                          child: RaisedButton(
                              shape: new RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(10.0)),
                              color: Colors.white,
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Icon(Icons.refresh, color: Colors.black),
                                    AutoSizeText('Musicize Again',
                                        maxLines: 1,
                                        style: new TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black)),
                                  ]),
                              onPressed: () {
                                this.widget.callback(0);
                              })),
                    ],
                  ),
                )))
      ]))
    ]);
  }
}
