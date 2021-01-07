import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as prefix;
//import 'running.dart';
import 'globals.dart' as globals;
import 'package:conditional_builder/conditional_builder.dart';
//import 'package:audio_picker/audio_picker.dart';
//import 'package:file_picker/file_picker.dart';
//import 'home_page.dart';
import 'hex_color.dart';
import 'package:animate_do/animate_do.dart';
//import 'package:mccounting_text/mccounting_text.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'intensity_data.dart';
import 'package:flutter/animation.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_database/firebase_database.dart';

class FinishScreen extends StatefulWidget {
  Function callback;

  FinishScreen(this.callback);

  State<StatefulWidget> createState() => new _FinishScreenState();
}

List list = [];
final List<String> entries = <String>['A', 'B', 'C'];
final List<int> colorCodes = <int>[600, 500, 100];

class _FinishScreenState extends State<FinishScreen>
    with SingleTickerProviderStateMixin {
  final dbRef = FirebaseDatabase.instance.reference().child("users");
  var yt = prefix.YoutubeExplode();
  var loading = false;
  var loaded = false;
  List<FlSpot> stops;
  Animation pointsAnimation;
  Animation scheduleAnimation;
  Animation avgAnimation;
  AnimationController animationController;
  @override
  void initState() {
    super.initState();
    stops = [];
    for(IntensityData i in globals.data) {
      stops.add(new FlSpot(i.time.toDouble(), i.value.toDouble()));
    }
    animationController =
        AnimationController(duration: Duration(seconds: 2), vsync: this);

    pointsAnimation = IntTween(begin: 0, end: globals.musicpointsEarned)
        .animate(CurvedAnimation(
            parent: animationController, curve: Curves.easeOut));
    scheduleAnimation = IntTween(begin: 0, end: 80).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeOut));
    animationController.forward();
  }

  Widget build(BuildContext context) {
    const cutOffYValue = 0.0;
    const dateTextStyle = TextStyle(
        fontSize: 10, color: Colors.purple, fontWeight: FontWeight.bold);

    return new Stack(children: <Widget>[
      Container(
        height: MediaQuery.of(context).size.height,
        color: HexColor('#5660E8'),
      ),
      Container(
        height: MediaQuery.of(context).size.height,
        // width: 1000.0,
        alignment: Alignment.bottomRight,
        // child: Transform.rotate(
        // angle: -pi / 32.0,
        child: Container(
          height: MediaQuery.of(context).size.height - 100,
          // width: 400,
          // padding: const EdgeInsets.all(8.0),
          color: HexColor('#f3f3f3'),
        ),
        // ),
      ),
      Container(
          child: ListView(children: <Widget>[
        Center(
            child: Container(
                padding: EdgeInsets.only(top: 20.0),
                decoration: new BoxDecoration(
                  color: HexColor('5660E8'),
                  /*gradient: new LinearGradient(
            colors: [HexColor('#4E8FFF') , HexColor('#4EFFF3')],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),*/
                ),
                // color: HexColor('19CFFC'),
                child: Container(
                  // color: Colors.blue,
                  // color: Colors.white,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Icon(
                            Icons.check_circle_outline,
                            color: Colors.white,
                            size: 75.0,
                          ),
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
                                  colors: [Colors.white.withOpacity(0.4), Colors.white.withOpacity(0.0),],
                                  gradientColorStops: [0,1],
                                  cutOffY: cutOffYValue,
                                  gradientFrom: Offset(0,0),
                                  gradientTo: Offset(0,1),
                                  applyCutOffY: true,
                                ),
                                // aboveBarData: BarAreaData(
                                //   show: true,
                                //   colors: [Colors.orange.withOpacity(0.6)],
                                //   cutOffY: cutOffYValue,
                                //   applyCutOffY: true,
                                // ),
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
              padding: const EdgeInsets.only(right: 5, bottom: 5),
              style: const TextStyle(color: Colors.black, fontSize: 9),
                                ),

                                 dashArray: [5, 5],
                                 color: Colors.white,
                                 
                              ),
                            ]),
                            gridData: FlGridData(show: false),
                            borderData: FlBorderData(show: false),
                            titlesData: FlTitlesData(
                              show: false,
                              // bottomTitles: SideTitles(
                              //     showTitles: true,
                              //     reservedSize: 14,
                              //     textStyle: dateTextStyle,
                              //     getTitles: (value) {
                              //       switch (value.toInt()) {
                              //         case 0:
                              //           return 'Jan';
                              //         case 1:
                              //           return 'Feb';
                              //         case 2:
                              //           return 'Mar';
                              //         case 3:
                              //           return 'Apr';
                              //         case 4:
                              //           return 'May';
                              //         case 5:
                              //           return 'Jun';
                              //         case 6:
                              //           return 'Jul';
                              //         case 7:
                              //           return 'Aug';
                              //         case 8:
                              //           return 'Sep';
                              //         case 9:
                              //           return 'Oct';
                              //         case 10:
                              //           return 'Nov';
                              //         case 11:
                              //           return 'Dec';
                              //         default:
                              //           return '';
                              //       }
                              //     }),
                              // leftTitles: SideTitles(
                              //   showTitles: true,
                              //   getTitles: (value) {
                              //     return '\$ ${value + 0.5}';
                              //   },
                              // ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
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
                                            // letterSpacing: 0.50,

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

class SimpleLineChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  SimpleLineChart(this.seriesList, {this.animate});

  /// Creates a [LineChart] with sample data and no transition.
  factory SimpleLineChart.withSampleData() {
    return new SimpleLineChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.LineChart(
      seriesList, animate: animate,
      defaultRenderer:
          new charts.LineRendererConfig(includeArea: true, stacked: true),
      domainAxis: new charts.NumericAxisSpec(
          showAxisLine: false, renderSpec: new charts.NoneRenderSpec()),
      primaryMeasureAxis: new charts.NumericAxisSpec(
          showAxisLine: false, renderSpec: new charts.NoneRenderSpec()),

      /// This is an OrdinalAxisSpec to match up with BarChart's default
      /// ordinal domain axis (use NumericAxisSpec or DateTimeAxisSpec for
      /// other charts).
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<IntensityData, int>> _createSampleData() {
    return [
      new charts.Series<IntensityData, int>(
        id: 'Your Run Results',
        colorFn: (_, __) => charts.MaterialPalette.white,
        areaColorFn: (_, __) => charts.MaterialPalette.white,
        domainFn: (IntensityData intensity, _) => intensity.time,
        measureFn: (IntensityData intensity, _) => intensity.value,
        data: globals.data,
      )
    ];
  }
}
