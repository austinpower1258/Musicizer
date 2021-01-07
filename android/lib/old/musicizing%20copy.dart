import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'authentication.dart';
import 'login_signup_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'todo.dart';
import 'home_page.dart';
import 'globals.dart' as globals;
/*
import 'dart:async';
import 'running.dart';
import 'package:location/location.dart';
import 'location_service.dart';
import 'package:sensors/sensors.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'user_location.dart';
import 'package:wakelock/wakelock.dart';
import 'package:audioplayers_with_rate/audio_cache.dart';
import 'package:audioplayers_with_rate/audioplayers.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';
import 'dart:math';
import 'running.dart';
import 'package:speedometer/speedometer.dart';
import 'package:screen/screen.dart';
import 'package:speedometer/speedometer.dart';
import 'package:rxdart/rxdart.dart';

class MusicizingWidget extends StatefulWidget {
  @override
  _MusicizingWidgetState createState() => _MusicizingWidgetState();
}

class _MusicizingWidgetState extends State<MusicizingWidget> {
  List<double> _userAccelerometerValues;
  AudioPlayer advancedPlayer = AudioPlayer();
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
  AudioPlayerStateChangeHandler audioPlayerStateChangeHandler;
  AudioPlayerState _audioPlayerState;
  AudioPlayerState get state => _audioPlayerState;
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

  PublishSubject<double> eventObservable = new PublishSubject();

  Future<int> playMusic() async {
    Wakelock.enable();
    double brightness = await Screen.brightness;
    globals.brightness = brightness;
    setState(() {
      musicPointsEarned = 0;
      musicSpeed = 1.0;
      state = AudioPlayerState.STOPPED;
      this.state = state;
      print(state);
      advancedPlayer.play(globals.path, isLocal: true);
      state = AudioPlayerState.PLAYING;
      this.state = state;
      print(state);
    });
  }

  @override
  void initState() {
    super.initState();
    const time = const Duration(seconds: 1);
    new Timer.periodic(time,
        (Timer t) => eventObservable.add(intensity));
  }

  @override
  void dispose() {
    advancedPlayer = null;
    _onTodoAddedSubscription.cancel();
    _onTodoChangedSubscription.cancel();
    super.dispose();
  }

  set state(AudioPlayerState state) {
    if (audioPlayerStateChangeHandler != null) {
      audioPlayerStateChangeHandler(state);
    }
    _audioPlayerState = state;
  }

  void tempoModification(double intensity) {
    if (intensity < intensityLevel) {
      if (musicSpeed - diff - 0.1 >= 0.4) {
        musicSpeed = musicSpeed - diff;
      }
    }
    if (intensity >= intensityLevel) {
      if (musicSpeed + diff <= 1.0) {
        musicSpeed = musicSpeed + diff;
      }
    }

    if (musicSpeed > 0.95) {
      musicPointsEarned = musicPointsEarned + globals.level.toInt();
      globals.musicpoints = globals.musicpoints + globals.level.toInt();
      dbRef
          .child(globals.username)
          .child("musicpoints")
          .set(globals.musicpoints);
    }

    setState(() {
      state = AudioPlayerState.PLAYING;
      this.state = state;
      print(state);
      advancedPlayer.setRate(musicSpeed);
    });
  }

  @override
  Widget build(BuildContext context) {
    var userLocation = Provider.of<UserLocation>(context);

    userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      intensity = sqrt(pow(event.x, 2) + pow(event.y, 2) + pow(event.z, 2));
    });

    final ThemeData somTheme = new ThemeData(
        primaryColor: Colors.blue[700],
        accentColor: Colors.deepPurpleAccent,
        backgroundColor: Colors.blue[300]);

    if (globals.runningPage == 1) {
      setState(() {
        dbRef
            .child(globals.username)
            .child("musicpoints")
            .once()
            .then((DataSnapshot snapshot) {
          globals.musicpoints = snapshot.value;
        });
        globals.speed = userLocation?.speed;
        if (state == AudioPlayerState.PLAYING) {
          print('a');
          tempoModification(intensity);
        }
      });
      return new Scaffold(
          body: Center(
              child: Container(
        padding: EdgeInsets.all(16.0),
        child: new ListView(
          shrinkWrap: true,
          children: <Widget>[
            Text(
                  '\nMusicPoints: ' +
                  globals.musicpoints.toString() +
                  "\n" +
                  'MusicPointsEarned: ' +
                  musicPointsEarned.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30.0),
            ),
            Padding(
              padding: new EdgeInsets.all(40.0),
              child: new SpeedOMeter(
                  start: start,
                  end: end,
                  highlightStart: (_lowerValue / end),
                  highlightEnd: (_upperValue / end),
                  themeData: somTheme,
                  eventObservable: this.eventObservable),
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
                child: SizedBox(
                    height: 40.0,
                    child: new RaisedButton(
                      elevation: 5.0,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      color: Colors.blue,
                      child: new Text('Resume',
                          style: new TextStyle(
                              fontSize: 20.0, color: Colors.white)),
                      onPressed: () {
                        advancedPlayer.resume();
                        setState(() {
                          state = AudioPlayerState.PLAYING;
                          this._audioPlayerState = state;
                        });
                      },
                    ))),
            Padding(
                padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
                child: SizedBox(
                    height: 40.0,
                    child: new RaisedButton(
                      elevation: 5.0,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      color: Colors.blue,
                      child: new Text('Pause',
                          style: new TextStyle(
                              fontSize: 20.0, color: Colors.white)),
                      onPressed: () {
                        advancedPlayer.pause();
                        setState(() {
                          state = AudioPlayerState.PAUSED;
                          this._audioPlayerState = state;
                        });
                      },
                    ))),
            Padding(
                padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
                child: SizedBox(
                    height: 40.0,
                    child: new RaisedButton(
                      elevation: 5.0,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      color: Colors.blue,
                      child: new Text('Powersave Mode',
                          style: new TextStyle(
                              fontSize: 20.0, color: Colors.white)),
                      onPressed: () {
                        globals.powersaveMode = true;
                        Screen.setBrightness(0);
                        Screen.keepOn(true);
                      },
                    ))),
            Padding(
                padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
                child: SizedBox(
                    height: 40.0,
                    child: new RaisedButton(
                      elevation: 5.0,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      color: Colors.blue,
                      child: new Text('Play Music',
                          style: new TextStyle(
                              fontSize: 20.0, color: Colors.white)),
                      onPressed: () {
                        setState(() {
                          state = AudioPlayerState.PLAYING;
                          playMusic();
                        });
                      },
                    ))),
            Padding(
                padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
                child: SizedBox(
                    height: 40.0,
                    child: new RaisedButton(
                      elevation: 5.0,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      color: Colors.blue,
                      child: new Text('Exit',
                          style: new TextStyle(
                              fontSize: 20.0, color: Colors.white)),
                      onPressed: () {
                        Wakelock.disable();
                        advancedPlayer.stop();
                        setState(() {
                          state = AudioPlayerState.STOPPED;
                          this._audioPlayerState = state;
                          globals.runningPage = 0;
                        });
                      },
                    ))),
          ],
        ),
      )));
    } else {
      return HomePage();
    }
  }
}
*/