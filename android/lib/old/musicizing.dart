import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'authentication.dart';
import 'login_signup_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'todo.dart';
import 'home_page.dart';
import 'globals.dart' as globals;
import 'dart:async';
import 'running.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:location/location.dart';
import 'dart:core';
import 'package:sensors/sensors.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'user_location.dart';
import 'package:wakelock/wakelock.dart';
//import 'package:audioplayers_with_rate/audio_cache.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';
import 'package:flutter_plugin_playlist/flutter_plugin_playlist.dart';
import 'dart:math';
import 'running.dart';
import 'package:speedometer/speedometer.dart';
import 'package:screen/screen.dart';
import 'package:speedometer/speedometer.dart';
import 'package:getflutter/getflutter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/services.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as prefix;
import 'hex_color.dart';
import 'package:animate_do/animate_do.dart';
import 'intensity_data.dart';

class MusicizingWidget extends StatefulWidget {
  Function callback;

  MusicizingWidget(this.callback);

  @override
  _MusicizingWidgetState createState() => _MusicizingWidgetState();
}

class _MusicizingWidgetState extends State<MusicizingWidget> {
  List<double> _userAccelerometerValues;
  // RmxAudioPlayer globals.advancedPlayer = new RmxAudioPlayer();

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
  double musicSpeed = 0.95;
  static final double diff = 0.05;
  double intensity;
  double intensityLevel = 2 * globals.level;
  int musicPointsEarned = 0;
  int _page = 0;
  final List<Widget> _children = [];
  GlobalKey _bottomNavigationKey = GlobalKey();
  double _lowerValue = 20.0;
  double _upperValue = 40.0;
  int start = 0;
  int end = globals.level.toInt() * 20;
  int counter = 0;
  List<AudioTrack> playlistItems = [];
  int time = 0;
  bool _loading;
  double _progressValue;
  Timer timer1;
  Timer timer2;
  
  void callback(int index) {
    setState(() {
      globals.index = index;
    });
  }

  void finishReporting() async {
    print(DateTime.now().toString());
    await dbRef
        .child(globals.userId)
        .child('reports')
        .child(DateTime.now().toString().split(' ')[0])
        .child(DateTime.now().toString().split(' ')[1].split('.')[0])
        .set({
      "timestamp": DateTime.now().toString(),
      "length": time,
      "lengthOnPace": globals.onPace,
      "earned": globals.musicpointsEarned,
    });
    print('finished reporting.');
  }

  _MusicizingWidgetState() {
    /*if (globals.path != null && globals.audioStreamUrl != null) {
      playlistItems.add(new AudioTrack(
          album: 'a',
          artist: 'a',
          assetUrl:
              'https://r1---sn-a5mlrn76.googlevideo.com/videoplayback?expire=1591929841&ei=kZfiXqG-BMKJkgbKv7ww&ip=68.225.239.139&id=o-AMOv-xc82diLdOskiXba-5g2_C-zjx6QOxteK79dwYwa&itag=251&source=youtube&requiressl=yes&mh=by&mm=31%2C26&mn=sn-a5mlrn76%2Csn-n4v7sne7&ms=au%2Conr&mv=m&mvi=0&pl=19&initcwndbps=1350000&vprv=1&mime=audio%2Fwebm&gir=yes&clen=14240287&otfp=1&dur=751.021&lmt=1590733697756195&mt=1591908096&fvip=1&keepalive=yes&beids=23874723&c=WEB&txp=6211222&sparams=expire%2Cei%2Cip%2Cid%2Citag%2Csource%2Crequiressl%2Cvprv%2Cmime%2Cgir%2Cclen%2Cotfp%2Cdur%2Clmt&sig=AOq0QJ8wRgIhAO4UkR5g0kLWLCUlrDjFmmpfqlG0BdHdXnG-QF31tk-zAiEAhTeVcl3KxGeNE6pYHxOKuyRWXh_PSO1klGHKkjDslgo%3D&lsparams=mh%2Cmm%2Cmn%2Cms%2Cmv%2Cmvi%2Cpl%2Cinitcwndbps&lsig=AG3C_xAwRAIgS6ho2DnZ4KscP-PcmZR_fBB9c9odJyUEBx3iWA9T0tQCIDC5QU4zdWCHqs-u5AkoM-NlhfU1tN3cAlXJ1vc_8LuM',
          title: 'a',
          isStream: true));
    }*/
    /*if(globals.path != null) {
      playlistItems.add(new AudioTrack(assetUrl: 'https://ia801907.us.archive.org/32/items/HamiltonMusical/1-01%20Alexander%20Hamilton.mp3', isStream: true));
      globals.path.values.toList().forEach((path) => {
      playlistItems.add(new AudioTrack(album: path, artist: path, assetUrl: path, title: path))
    });
    
    }*/
  }

  /*
  @override
  void dispose() {
    globals.advancedPlayer = null;
    _onTodoAddedSubscription.cancel();
    _onTodoChangedSubscription.cancel();
    super.dispose();
  }*/
  @override
  void initState() {
    super.initState();
    globals.advancedPlayer = new AudioPlayer();

    _loading = false;
    _progressValue = 0.0;

    timer1 = new Timer.periodic(Duration(seconds: 1), (Timer t) => time++);

    const oneSec = const Duration(seconds: 1);

    timer2 = new Timer.periodic(oneSec, (Timer t) {
      setState(() {
        _progressValue = (time / (globals.minutes * 60.0));
        // we "finish" downloading here
        if (_progressValue.toStringAsFixed(1) == '1.0' || globals.stop) {
          _loading = false;
          t.cancel();
          print('a');
          _progressValue = 0.0;
          return;
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();

    _loading = false;
    timer1.cancel();
    timer2.cancel();
    _progressValue = 0.0;
  }

  // void _updateProgress() {
  //   const oneSec = const Duration(seconds: 1);
  //   new Timer.periodic(oneSec, (Timer t) {
  //     setState(() {
  //       _progressValue += 0.2;
  //       // we "finish" downloading here
  //       if (_progressValue.toStringAsFixed(1) == '1.0') {
  //         _loading = false;
  //         t.cancel();
  //         _progressValue:
  //         0.0;
  //         return;
  //       }
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final ThemeData somTheme = new ThemeData(
        primaryColor: Colors.blue[700],
        accentColor: Colors.deepPurpleAccent,
        backgroundColor: Colors.blue[300]);
    // setState(() {
    //   dbRef
    //       .child(globals.userId)
    //       .child("musicpoints")
    //       .once()
    //       .then((DataSnapshot snapshot) {
    //     globals.musicpoints = snapshot.value;
    //   });
    // });

    return new Container(
      padding: EdgeInsets.only(top: 15.0),
      decoration: new BoxDecoration(
        color: HexColor('#5660E8'),
        /*gradient: new LinearGradient(
            colors: [HexColor('#4E8FFF') , HexColor('#4EFFF3')],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),*/
      ),
      // color: HexColor('19CFFC'),
      child: Column(
        children: <Widget>[
          Center(
              child: Container(
                  height: 60.0,
                  // width: 500.0,
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              GFIconButton(
                                onPressed: () => {
                                  widget.callback(1),
                                },
                                icon: Icon(
                                  IconData(58834, fontFamily: 'MaterialIcons'),
                                  size: 24.0,
                                  color: Colors.white,
                                ),
                                color: Color.fromARGB(0, 0, 0, 0),
                              ),
                              Text(
                                  (time / 60).floor().toString() +
                                      ':' +
                                      ((time % 60 > 9)
                                          ? (time % 60).toString()
                                          : '0' + (time % 60).toString()),
                                  style: TextStyle(
                                    fontFamily: 'Raleway',
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  )),
                              GFIconButton(
                                onPressed: () => {
                                  setState(() {
                                    globals.stop = true;
                                    globals.advancedPlayer.stop();
                                    finishReporting();
                                    dispose();
                                    this.widget.callback(3);
                                  }),
                                },
                                icon: Icon(
                                  IconData(58829, fontFamily: 'MaterialIcons'),
                                  size: 24.0,
                                  color: Colors.white,
                                ),
                                color: Color.fromARGB(0, 0, 0, 0),
                              ),
                            ]),
                      ]))),
          Container(
              height: MediaQuery.of(context).size.height - 75.0,
              // padding: EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                  boxShadow: [
                    // BoxShadow(
                    //   color: Colors.black.withOpacity(0.2),
                    //   spreadRadius: 5,
                    //   blurRadius: 7,
                    //   offset: Offset(0, 6), // changes position of shadow
                    // ),
                  ],
                  // color: HexColor('#111877'),
                  color: HexColor('#5660E8'),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                    bottomLeft: Radius.zero,
                    bottomRight: Radius.zero,
                  )),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Center(
                        child: Container(
                            padding: EdgeInsets.only(
                                top: 8.0, left: 16.0, right: 16.0, bottom: 8.0),
                            child: new Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(20.0),
                                    child: Center(
                                        child: GFProgressBar(
                                      percentage: _progressValue,
                                      lineHeight: 20,
                                      alignment: MainAxisAlignment.spaceBetween,
                                      backgroundColor: Colors.black26,
                                      progressBarColor: GFColors.INFO,
                                    )),
                                  ),
                                  Container(
                                    width: 200.0,
                                    height: 200.0,
                                    decoration: BoxDecoration(
                                      color: globals.inSpeed
                                          ? GFColors.INFO
                                          : HexColor('#4047ac'),
                                      // : Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(100.0),
                                    ),
                                    child: Center(
                                        child: Container(
                                      height: 175.0,
                                      width: 175.0,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100.0),
                                        image: DecorationImage(
                                          image: NetworkImage(globals.shuffle ?  globals
                                              .playlist[globals.indexArr[globals.index]]
                                              .thumbnails
                                              .highResUrl : globals
                                              .playlist[globals.index]
                                              .thumbnails
                                              .highResUrl),
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ),
                                    )),
                                  ),
                                  Text('\n', style: TextStyle(fontSize: 8)),
                                  AutoSizeText(globals.shuffle ? globals.playlist[globals.indexArr[globals.index]].title :
                                      globals.playlist[globals.index].title,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontSize: 25.0,
                                        fontFamily: 'Raleway',
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  AutoSizeText(globals.shuffle ? globals.playlist[globals.indexArr[globals.index]].author : 
                                      globals.playlist[globals.index].author +
                                          '\n',
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontFamily: 'Raleway',
                                        color: Colors.grey,
                                      )),
                                  Text(globals.musicpoints.toString(),
                                      style: TextStyle(
                                        fontSize: 24.0,
                                        fontFamily: 'Raleway',
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  Text('TempoPoints',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontFamily: 'Raleway',
                                        color: Colors.white,
                                      )),
                                ]))),
                    Container(
                      margin: EdgeInsets.all(10.0),
                      height: 100.0,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 6), // changes position of shadow
                          ),
                        ],
                        color: Colors.white,
                        // color: HexColor('#5660e8'),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: PlayBar(this.callback),
                    ),
                  ])),
        ],
      ),
    );

    // return new Scaffold(
    //     body: Center(
    //         child: Container(
    //   padding: EdgeInsets.all(16.0),
    //   width: 400,
    //   child: new ListView(
    //     shrinkWrap: true,
    //     scrollDirection: Axis.vertical,

    //     children: <Widget>[

    //       //         Scaffold(
    //       //   backgroundColor: blueColor,
    //       //   body: Padding(
    //       //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
    //       //     child: ListView(
    //       //       children: <Widget>[
    //       //         Text(
    //       //           'Playlist',
    //       //           style: TextStyle(
    //       //               color: Colors.white,
    //       //               fontWeight: FontWeight.bold,
    //       //               fontSize: 38.0),
    //       //         ),
    //       //         SizedBox(
    //       //           height: 16.0,
    //       //         ),
    //       //         SongItem('In the Name of Love', 'Martin Garrix', martinGarrix),
    //       //         SongItem('Never Be Like You', 'Flume', flume),
    //       //         SongItem('Worry Bout Us', 'Rosie Lowe', rosieLowe),
    //       //         SongItem('In the Name of Love', 'Martin Garrix', martinGarrix),
    //       //         SongItem('In the Name of Love', 'Martin Garrix', martinGarrix),
    //       //       ],
    //       //     ),
    //       //   ),
    //       // ),
    //       Text(
    //         '\nMusicPoints: ' +
    //             globals.musicpoints.toString() +
    //             "\n" +
    //             'MusicPointsEarned: ' +
    //             musicPointsEarned.toString(),

    //         textAlign: TextAlign.center,
    //         style: TextStyle(fontSize: 30.0),
    //       ),
    //       Padding(
    //         padding: new EdgeInsets.all(40.0),
    //         child: new SpeedOMeter(
    //             start: start,
    //             end: end,
    //             highlightStart: (_lowerValue / end),
    //             highlightEnd: (_upperValue / end),
    //             themeData: somTheme,
    //             eventObservable: this.eventObservable),
    //       ),
    //       Padding(
    //           padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
    //           child: SizedBox(
    //               height: 40.0,
    //               child: new RaisedButton(
    //                 elevation: 5.0,
    //                 shape: new RoundedRectangleBorder(
    //                     borderRadius: new BorderRadius.circular(30.0)),
    //                 color: Colors.blue,
    //                 child: new Text('Resume',
    //                     style: new TextStyle(
    //                         fontSize: 20.0, color: Colors.white)),
    //                 onPressed: () {
    //                   setState(() {
    //                     if (globals.advancedPlayer.playbackState ==
    //                         AudioPlaybackState.paused) {
    //                       globals.advancedPlayer.play();
    //                     }
    //                   });
    //                 },
    //               ))),
    //       Padding(
    //           padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
    //           child: SizedBox(
    //               height: 40.0,
    //               child: new RaisedButton(
    //                 elevation: 5.0,
    //                 shape: new RoundedRectangleBorder(
    //                     borderRadius: new BorderRadius.circular(30.0)),
    //                 color: Colors.blue,
    //                 child: new Text('Pause',
    //                     style: new TextStyle(
    //                         fontSize: 20.0, color: Colors.white)),
    //                 onPressed: () {
    //                   double speed = musicSpeed;
    //                   globals.advancedPlayer.pause();
    //                   musicSpeed = speed;
    //                 },
    //               ))),
    //       Padding(
    //           padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
    //           child: SizedBox(
    //               height: 40.0,
    //               child: new RaisedButton(
    //                 elevation: 5.0,
    //                 shape: new RoundedRectangleBorder(
    //                     borderRadius: new BorderRadius.circular(30.0)),
    //                 color: Colors.blue,
    //                 child: new Text('Powersave Mode',
    //                     style: new TextStyle(
    //                         fontSize: 20.0, color: Colors.white)),
    //                 onPressed: () {
    //                   globals.powersaveMode = true;
    //                   Screen.setBrightness(0);
    //                   Screen.keepOn(true);
    //                 },
    //               ))),
    //       Padding(
    //           padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
    //           child: SizedBox(
    //               height: 40.0,
    //               child: new RaisedButton(
    //                 elevation: 5.0,
    //                 shape: new RoundedRectangleBorder(
    //                     borderRadius: new BorderRadius.circular(30.0)),
    //                 color: Colors.blue,
    //                 child: new Text('Play Music',
    //                     style: new TextStyle(
    //                         fontSize: 20.0, color: Colors.white)),
    //                 onPressed: () {
    //                   setState(() {
    //                     playMusic(globals.audioStreamUrls[0]);
    //                   });
    //                 },
    //               ))),
    //       Padding(
    //           padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
    //           child: SizedBox(
    //               height: 40.0,
    //               child: new RaisedButton(
    //                 elevation: 5.0,
    //                 shape: new RoundedRectangleBorder(
    //                     borderRadius: new BorderRadius.circular(30.0)),
    //                 color: Colors.blue,
    //                 child: new Text('Skip Forward',
    //                     style: new TextStyle(
    //                         fontSize: 20.0, color: Colors.white)),
    //                 onPressed: () {
    //                   setState(() {
    //                     globals.advancedPlayer.stop();
    //                     if (index == globals.audioStreamUrls.length - 1) {
    //                       index = 0;
    //                     } else {
    //                       index++;
    //                     }
    //                     playMusic(globals.audioStreamUrls[index]);
    //                     //globals.advancedPlayer.skipForward();
    //                   });
    //                 },
    //               ))),
    //       Padding(
    //           padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
    //           child: SizedBox(
    //               height: 40.0,
    //               child: new RaisedButton(
    //                 elevation: 5.0,
    //                 shape: new RoundedRectangleBorder(
    //                     borderRadius: new BorderRadius.circular(30.0)),
    //                 color: Colors.blue,
    //                 child: new Text('Skip Backward',
    //                     style: new TextStyle(
    //                         fontSize: 20.0, color: Colors.white)),
    //                 onPressed: () {
    //                   setState(() {
    //                     globals.advancedPlayer.stop();
    //                     if (index == 0) {
    //                       index = globals.audioStreamUrls.length - 1;
    //                     } else {
    //                       index--;
    //                     }
    //                     playMusic(globals.audioStreamUrls[index]);
    //                   });
    //                 },
    //               ))),
    //       Padding(
    //           padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
    //           child: SizedBox(
    //               height: 40.0,
    //               child: new RaisedButton(
    //                 elevation: 5.0,
    //                 shape: new RoundedRectangleBorder(
    //                     borderRadius: new BorderRadius.circular(30.0)),
    //                 color: Colors.blue,
    //                 child: new Text('Exit',
    //                     style: new TextStyle(
    //                         fontSize: 20.0, color: Colors.white)),
    //                 onPressed: () {
    //                   Wakelock.disable();
    //                   globals.advancedPlayer.pause();
    //                   setState(() {
    //                     this.widget.callback(0);
    //                   });
    //                 },
    //               ))),
    //     ],
    //   ),
    // )));
  }
}

class PlayBar extends StatefulWidget {
  PlayBar(this.callback);

  Function callback;

  @override
  _PlayBarState createState() => _PlayBarState();
}

class _PlayBarState extends State<PlayBar> {
  static final double diff = 0.05;

  int counter = 0;
  final dbRef = FirebaseDatabase.instance.reference().child("users");
  int end = globals.level.toInt() * 20;
  PublishSubject<double> eventObservable = new PublishSubject();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // RmxAudioPlayer globals.advancedPlayer = new RmxAudioPlayer();
  int index = 0;
  double intensity;
  double intensityLevel = 3 * globals.level;
  bool looping = false;
  double musicSpeed = 0.95;
  int seconds = 0;
  int start = 0;
  bool started = false;
  StreamSubscription<UserAccelerometerEvent> streamSubscription;
  Timer t1;
  Timer t2;
  Timer t3;
  Timer t4;
  Timer t5;
  Timer t6;
  Timer t7;

  GlobalKey _bottomNavigationKey = GlobalKey();
  final List<Widget> _children = [];
  Color _loopingColor = Colors.black;
  double _lowerValue = 20.0;
  int _page = 0;
  double _upperValue = 40.0;
  List<double> _userAccelerometerValues;

  @override
  void dispose() {
    super.dispose();

    globals.stop = true;
    globals.playing = false;
    t1.cancel();
    t2.cancel();
    t3.cancel();
    t4.cancel();
    t5.cancel();
    t6.cancel();
    t7.cancel();
    globals.advancedPlayer.stop();
    globals.advancedPlayer = null;
    streamSubscription.cancel();
  }

  @override
  void initState() {
    super.initState();
    globals.shuffle = false;
    globals.playing = false;
    globals.started = false;
    globals.inSpeed = false;
    globals.stop = false;
    globals.data = [];
    globals.index = 0;
    globals.onPace = 0;
    globals.musicpointsEarned = 0;

    randomizeArr();
    //tempoModification(intensity);
    t1 = new Timer.periodic(
      Duration(seconds: 3),
      (Timer t) =>
          globals.advancedPlayer.playbackState == AudioPlaybackState.playing
              ? incrementMusicPoints()
              : print('lol none for u'),
    );
    t2 = new Timer.periodic(Duration(seconds: 1), (Timer t) => seconds++);
    t3 = new Timer.periodic(
        Duration(seconds: 1),
        (Timer t) => globals.data.add(new IntensityData(
              seconds,
              intensity.toInt(),
            )));
    t4 = new Timer.periodic(
        Duration(seconds: 1),
        (Timer t) => print(globals.data[seconds - 1].time.toString() +
            ' speed: ' +
            globals.data[seconds - 1].value.toString()));
    t5 = new Timer.periodic(
        Duration(seconds: 1), (Timer t) => this.widget.callback(globals.index));
    const time = const Duration(seconds: 1);
    t6 = new Timer.periodic(time, (Timer t) => eventObservable.add(intensity));
    t7 = new Timer.periodic(
        Duration(milliseconds: 500),
        (Timer t) => (!globals.stop &&
                globals.advancedPlayer != null &&
                globals.advancedPlayer.playbackState ==
                    AudioPlaybackState.playing &&
                globals.switch1)
            ? tempoModification(intensity)
            : print('not modifying'));
    streamSubscription =
        userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      intensity = sqrt(pow(event.x, 2) + pow(event.y, 2) + pow(event.z, 2));
    });
  }

  Future<int> playMusic(url) async {
    print('trying to play music');
    var duration = await globals.advancedPlayer.setUrl(url).catchError((error) {
      // catch audio error ex: 404 url, wrong url ...
      print(error);
    });
    // await globals.advancedPlayer.setPlaylistItems(playlistItems,
    //     options: new PlaylistItemOptions(
    //       startPaused: true,
    //     )
    // );
    Wakelock.enable();

    musicSpeed = 0.95;
    globals.advancedPlayer.play();
    
    //globals.advancedPlayer.play(globals.path, isLocal: true);
    globals.started = true;
  }

  void incrementMusicPoints() {
    // if (globals.advancedPlayer.playbackState != null) {
    // if (musicSpeed > 0.95
    //     // &&
    //     //     globals.advancedPlayer.playbackState == AudioPlaybackState.playing
    //     ) {
    //   //musicPointsEarned = musicPointsEarned + globals.level.toInt();

    // }
    if (intensity >= intensityLevel) {
      globals.inSpeed = true;
      globals.musicpointsEarned += globals.level.toInt();
      globals.musicpoints += globals.level.toInt();

      dbRef.child(globals.userId).child("musicpoints").set(globals.musicpoints);
      globals.onPace += 1;
      print(globals.onPace);
    }
  }
  // }

  void changeSong() {
    if (globals.index == globals.audioStreamUrls.length - 1) {
      //this.widget.callback(globals.index);
      globals.index = 0;
    } else {
      //this.widget.callback(globals.index);
      globals.index++;
    }
  }

  void tempoModification(double intensity) {
    if (intensity != null && intensityLevel != null) {
      if (intensity < intensityLevel) {
        if (musicSpeed - diff - 0.1 >= 0.15) {
          musicSpeed = musicSpeed - diff;
        }
      }
      if (intensity >= intensityLevel) {
        if (musicSpeed + diff <= 1.0) {
          musicSpeed = musicSpeed + diff;
        }
      }

      if (musicSpeed > 0.95) {
        globals.inSpeed = true;
      } else {
        globals.inSpeed = false;
      }

      setState(() {
        try {
          globals.advancedPlayer.setSpeed(musicSpeed);
        } catch (error) {
          print('setting speed produces:' + error);
        }
      });
    }
  }

  void randomizeArr() {
    globals.indexArr = List<int>.generate(globals.audioStreamUrls.length, (int index) => index);
    globals.indexArr.shuffle();
    for (int i = 0; i < globals.audioStreamUrls.length; i++) {
      if (globals.indexArr[i] == globals.index) {
        int temp = globals.indexArr[globals.index];
        globals.indexArr[globals.index] = globals.index;
        globals.indexArr[i] = temp;
      }
    }
    print(globals.indexArr);
  }

  void indexShuffle() {
    globals.indexArr.shuffle();
    for (int i = 0; i < globals.audioStreamUrls.length; i++) {
      if (globals.indexArr[i] == globals.index) {
        int temp = globals.indexArr[globals.index];
        globals.indexArr[globals.index] = globals.index;
        globals.indexArr[i] = temp;
      }
    }
  }

  void randomizeSong(){

      
    if (globals.indexArr.length - 1 == globals.index) {
      print('index' + globals.index.toString());
      
      print(globals.indexArr[globals.index]);
      playMusic(globals.audioStreamUrls[globals.indexArr[globals.index]]);
      
      print(globals.indexArr);
    } else {
      print('index' + globals.index.toString());
      print(globals.indexArr[globals.index]);
      playMusic(globals.audioStreamUrls[globals.indexArr[globals.index]]);
    }

    
  }

  Widget build(BuildContext context) {
    print(globals.advancedPlayer.playbackState.toString());

    if (globals.stop) {
      globals.stop = false;
      dispose();
    }

    print(globals.index.toString() + "index here!");
    print(globals.indexArr[globals.index].toString() + "real shuffle index here!");

    //here is ending --> need to figure out how to refresh title and thumbnail picture
    if (!globals.shuffle) {
    if (globals.started &&
        looping &&
        globals.advancedPlayer.playbackState == AudioPlaybackState.completed) {
      globals.advancedPlayer.stop();
      playMusic(globals.audioStreamUrls[globals.index]);
    } else if ( globals.started &&
        globals.advancedPlayer.playbackState == AudioPlaybackState.completed) {
      globals.advancedPlayer.stop();
      changeSong();
      playMusic(globals.audioStreamUrls[globals.index]);
    }
    }

    if (globals.shuffle) {
      if (globals.indexArr.length == 0) {
        print('here');
        randomizeArr();
      }
      print(globals.indexArr);

      if (globals.started &&
        globals.advancedPlayer.playbackState == AudioPlaybackState.completed) {
    
          if (globals.index != globals.audioStreamUrls.length - 1) {
             globals.index++;
          }
          else {
            globals.index = 0;
          }
          globals.advancedPlayer.stop();
          randomizeSong();
      } 
    }

    
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        GFIconButton(
          shape: GFIconButtonShape.circle,
          onPressed: () => {
            looping = !looping,
            setState(() {
              if (_loopingColor == Colors.black) {
                _loopingColor = HexColor('#5660e8');
              } else {
                _loopingColor = Colors.black;
              }
            })
          },
          icon: Icon(
            IconData(57384, fontFamily: 'MaterialIcons'),
            color: _loopingColor,
            size: 25.0,
          ),
          color: Color.fromARGB(0, 0, 0, 0),
        ),
        GFIconButton(
          shape: GFIconButtonShape.circle,
          onPressed: () => {
            setState(() {
              if (globals.started) {
                globals.advancedPlayer.stop();

                if (globals.index == 0) {
                  globals.index = globals.audioStreamUrls.length - 1;
                } else {
                  globals.index--;
                }

                if (!globals.shuffle) {
                   this.widget.callback(globals.index);
                playMusic(globals.audioStreamUrls[globals.index]);
                
                } else {
                  this.widget.callback(globals.indexArr[globals.index]);
                  randomizeSong();
                }
              }
            })
          },
          icon: Icon(
            IconData(57413, fontFamily: 'MaterialIcons'),
            color: Colors.black,
            size: 25.0,
          ),
          color: Color.fromARGB(0, 0, 0, 0),
        ),
        GFIconButton(
          shape: GFIconButtonShape.circle,
          onPressed: () => {
            setState(() {
              globals.started = true;
              if (globals.playing == false) {
                if (globals.advancedPlayer.playbackState ==
                    AudioPlaybackState.paused) {
                  globals.advancedPlayer.play();
                } else {
                  playMusic(globals.audioStreamUrls[globals.index]);
                }
              } else {
                globals.advancedPlayer.pause();
              }

              globals.playing = !globals.playing;
            })
          },
          padding: EdgeInsets.only(right: 12.0, bottom: 12.0),
          icon: globals.playing
              ? Icon(IconData(57398, fontFamily: 'MaterialIcons'),
                  color: Colors.black, size: 40.0)
              : Icon(IconData(57401, fontFamily: 'MaterialIcons'),
                  color: Colors.black, size: 40.0),
          color: Color.fromARGB(0, 0, 0, 0),
        ),
        GFIconButton(
          shape: GFIconButtonShape.circle,
          onPressed: () => {
            setState(() {
              if (globals.started) {
                globals.advancedPlayer.stop();
                print(globals.index);
                if (globals.index == globals.audioStreamUrls.length - 1) {
                  globals.index = 0;
                } else {
                  globals.index++;
                }
                print(globals.index);
                
                 if (!globals.shuffle) {
                   this.widget.callback(globals.index);
                playMusic(globals.audioStreamUrls[globals.index]);
                } else {
                
                  this.widget.callback(globals.indexArr[globals.index]);
                 randomizeSong();
                }
              }
            })
          },
          icon: Icon(
            IconData(57412, fontFamily: 'MaterialIcons'),
            color: Colors.black,
            size: 25.0,
          ),
          color: Color.fromARGB(0, 0, 0, 0),
        ),
        GFIconButton(
          shape: GFIconButtonShape.circle,
          onPressed: () => {
            setState(() {

              globals.shuffle = !globals.shuffle;
              print(globals.shuffle);
            })
          },
          icon: Icon(
            IconData(57411, fontFamily: 'MaterialIcons'),
            color: (globals.shuffle) ? Colors.green : Colors.black,
            size: 25.0,
          ),
          color: Color.fromARGB(0, 0, 0, 0),
        ),
      ],
    );
  }
}

// class HorizontalProgressIndicator extends StatefulWidget {
//   @override
//   HorizontalProgressIndicatorState createState() => new HorizontalProgressIndicatorState();
// }

// class HorizontalProgressIndicatorState extends State<HorizontalProgressIndicator>
//     with SingleTickerProviderStateMixin {

//   AnimationController controller;

//   Animation animation;

//   double beginAnim = 0.0 ;
//   double endAnim = 1.0 ;

//   @override
//   void initState() {
//     super.initState();
//     controller = AnimationController(
//         duration: const Duration(seconds: 5), vsync: this);
//         animation = Tween(begin: beginAnim, end: endAnim).animate(controller)
//           ..addListener(() {
//             setState(() {
//               controller.forward();
//             });
//           });
//     }

//   @override
//   void dispose() {
//     controller.stop();
//     super.dispose();
//   }

//   startProgress(){

//     controller.forward();
//   }

//   stopProgress(){

//     controller.stop();
//   }

//   resetProgress(){

//     controller.reset();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//         child: Column(children: [
//           Container(
//           padding: EdgeInsets.all(20.0),
//           child: LinearProgressIndicator(
//             value: animation.value,
//           )),
//         ]
//     ));
//   }
// }
