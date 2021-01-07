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
import 'intensity_data.dart';
import 'package:flutter/animation.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_database/firebase_database.dart';

class Leaderboard extends StatefulWidget {
  int numOfTiles;
  bool showText;
  Leaderboard(this.numOfTiles, {this.showText = true});
  @override
  LeaderboardState createState() => LeaderboardState();
}

class LeaderboardState extends State<Leaderboard> {
  final dbRef = FirebaseDatabase.instance.reference().child('users');
  bool loading = false;

  void getLeaderboard() async {
    print('RUN');
    loading = true;
    var item = await dbRef.orderByChild('musicpoints').limitToFirst(100).once();
    Map m = item.value;
    List<Musicizer> tmp = [];
    m.forEach((key, value) {
      tmp.add(Musicizer.fromValue(value)..key = key);
    });
    tmp.sort((a, b) => b.musicpoints.compareTo(a.musicpoints));
    tmp.forEach((x) => globals.leaderboard.add(x));
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getLeaderboard();
  }

  Widget build(BuildContext context) {
    if (!loading) {
      return new Container(
          padding:
              EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0, top: 16.0),
          child: Column(
              // shrinkWrap: true,
              // physics: ClampingScrollPhysics(),
              // scrollDirection: Axis.vertical,
              children: <Widget>[
                if (this.widget.showText) ...[
                  Container(
                    // margin: Ed
                    margin: EdgeInsets.only(bottom: 20.0),
                    // decoration: BoxDecoration(
                    //   color: Colors.white,
                    //   borderRadius: BorderRadius.circular(5.0),
                    //   boxShadow: [

                    //   ],
                    // ),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            AutoSizeText('Leaderboard',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: HexColor('#5660E8'),
                                    fontSize: 25.0)),
                            Text('Compete against others.',
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                )),
                          ],
                        ),
                        Text('#1',
                        style: TextStyle(
                          fontSize: 25.0,
                        ),),
                      ],
                    ),
                  )
                ],
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                //   children: <Widget> [
                //     Column(
                //       children: <Widget>[

                //       ],
                //     ),
                //     Column(
                //       children: <Widget>[],
                //     ),

                //   ],

                // ),

                LeaderboardLayout(this.widget.numOfTiles),
              ]));
    } else {
      return SizedBox(
          width: 50.0, height: 50.0, child: CircularProgressIndicator());
    }
  }
}

class Musicizer {
  String key;
  String username = globals.username;
  int musicpoints = globals.musicpoints;
  String profileUrl = globals.pfpUrl;

  Musicizer(this.username, this.musicpoints, this.profileUrl);
  Musicizer.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        username = snapshot.value["username"],
        musicpoints = snapshot.value["musicpoints"],
        profileUrl = snapshot.value["pfpUrl"];

  Musicizer.fromValue(dynamic value)
      : username = value["username"],
        musicpoints = value["musicpoints"],
        profileUrl = value["pfpUrl"];
  toJson() {
    return {"username": username, "musicpoints": musicpoints, "pfpUrl": profileUrl};
  }
}

class LeaderboardLayout extends StatefulWidget {
  int numOfTiles;

  LeaderboardLayout(this.numOfTiles);

  State<StatefulWidget> createState() => new _LeaderboardLayoutState();
}

class _LeaderboardLayoutState extends State<LeaderboardLayout> {
  @override
  Widget build(BuildContext context) {
    return _myListView(context);
  }

  Widget _myListView(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: this.widget.numOfTiles,
      itemBuilder: (context, index) {
        if (index != 0) {
          return Container(
              margin: EdgeInsets.symmetric(vertical: 2.0),
              padding: EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                // color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: [],
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                      
                        
                        AutoSizeText((index + 1).toString() + '    ',
                            style: TextStyle(color: Colors.grey)),

                      Container(
                        height: 30.0,
                        width: 30.0,
                        margin: EdgeInsets.only(right: 8.0),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(15.0),
                            image: DecorationImage(
                                image: NetworkImage(globals.leaderboard[index]
                              .toJson()['pfpUrl']
                              .toString()),
                                fit: BoxFit.cover)),
                      ),
                        AutoSizeText(
                          globals.leaderboard[index]
                              .toJson()['username']
                              .toString(),
                        ),
                      ],
                    ),
                    AutoSizeText(
                      globals.leaderboard[index]
                          .toJson()['musicpoints']
                          .toString(),
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                          color: HexColor('#5660E8')),
                    )
                  ]));
        } else {
          return new Container(
              padding: EdgeInsets.all(15.0),
              margin: EdgeInsets.symmetric(vertical: 9.0),
              decoration: BoxDecoration(
                color: Colors.white,
                // color: HexColor('#E9DC25'),
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: [
                  new BoxShadow(
                    color: Color.fromARGB(
                      80,
                      0,
                      0,
                      0,
                    ),
                    offset: new Offset(0.0, 5.0),
                    blurRadius: 30.0,
                  ),
                ],
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        AutoSizeText('1  ',
                            style:
                                TextStyle(fontSize: 20.0, color: Colors.grey)),
                         Container(
                        height: 30.0,
                        width: 30.0,
                        margin: EdgeInsets.only(right: 8.0),
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(15.0),
                            image: DecorationImage(
                                image: NetworkImage(globals.leaderboard[index]
                              .toJson()['pfpUrl']
                              .toString()),
                                fit: BoxFit.cover)),
                      ),
                        AutoSizeText(
                          globals.leaderboard[0]
                              .toJson()['username']
                              .toString(),
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    AutoSizeText(
                      globals.leaderboard[0].toJson()['musicpoints'].toString(),
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                          color: HexColor('#5660E8')),
                    ),
                  ]));
        }
      },
    );
  }
}
