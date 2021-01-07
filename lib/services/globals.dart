/*
UPDATED: 7/29/20
TEMP solution for Musicizer's global variables.
Copyright Musicizer LLC.
*/

library musicizer.globals;

import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'intensity_data.dart';
import 'musicstream.dart';

//USER ACCOUNT DATA
String username = "";
String resetEmail = "";
int musicpoints = 0;
String userId;
var pfpUrl = "";

//LOGIN/LOGOUT LOGIC
bool tempFill = false;
bool signOutRequest = true;

//PAGE LOGIC
var navBar;
int page = 0;
int runningPage = 0;

//MUSICIZE FORM 1
double level = 1.0;
int minutes = 60;

//MUSIC PAGE
Map<String, String> path;
String audioStreamUrl;
List<MusicStream> streamPlaylist = [];
// List audioStreamUrls = [];
// List<Video> playlist = [];
Video video;
var loadingSongs = false;

//MUSICIZE MAIN PAGE
var advancedPlayer;
int musicpointsEarned = 0;
bool playing = false;
bool started = false;
int index = 0;
bool stop = false;

//exercise data
List<IntensityData> data = [];
int totalMinutes = 0;
int onPace = 0;
bool inSpeed = false;

//shuffle
var shuffle = false;

//SETTINGS PAGE
bool switch1 = true;

//LEADERBOARD WIDGET
List leaderboard = [];
