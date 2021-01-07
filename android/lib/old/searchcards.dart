import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as prefix;
import 'globals.dart' as globals;
import 'package:conditional_builder/conditional_builder.dart';
import 'package:file_picker/file_picker.dart';
import 'hex_color.dart';
import 'package:animate_do/animate_do.dart';
import 'searchstuff.dart';
import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
//import 'package:mccounting_text/mccounting_text.dart';
//import 'home_page.dart';
//import 'package:audio_picker/audio_picker.dart';
//import 'running.dart';

class SearchCards extends StatefulWidget {
  Function callback;

  SearchCards(this.callback);

  State<StatefulWidget> createState() => new _SearchCardsState();
}

List list = [];
final List<String> entries = <String>['A', 'B', 'C'];
final List<int> colorCodes = <int>[600, 500, 100];

class _SearchCardsState extends State<SearchCards> {
  var yt = prefix.YoutubeExplode();
  var loading = false;
  var loaded = false;
  AlertDialog alert;
  Timer timer1;
  @override
  void initState() {
    super.initState();
    loaded = false;
    timer1 = new Timer.periodic(
      Duration(milliseconds: 200),
      (Timer t) => checkUrls(),
    );
  }

  void refresh() {
    setState(() {});
  }

  void checkUrls() {
    print('audioStreamUrls: ' + globals.audioStreamUrls.length.toString());
    print('videos: ' + globals.playlist.length.toString());
    if (globals.audioStreamUrls.length == globals.playlist.length) {
      this.widget.callback(2, timer1.cancel());
    }
  }

  @override
  void dispose() {
    super.dispose();
    timer1.cancel();
  }

  void extractYoutube() async {
    for (var video in globals.playlist) {
      var yt = prefix.YoutubeExplode();
      loading = true;
      var manifest = await yt.videos.streamsClient.getManifest(video.id);
      var streams = manifest.audioOnly;
      var audio = streams.last.url;
      globals.audioStreamUrls.add(audio.toString());
      print(globals.audioStreamUrls);
      yt.close();
    }
  }

  void openAudioPicker() async {
    // showLoading();
    var path = await FilePicker.getMultiFilePath(type: FileType.audio);
    // dismissLoading();
    setState(() {
      globals.path =
          path; //Map -> add (path)  --- choose music in playlist, delete items from playlist
    });
  }

  void deleteFromPlaylist(int index) {
    // globals.audioStreamUrls.remove(globals.audioStreamUrls[index]);
    globals.totalMinutes -= globals.playlist[index].duration.inMinutes;
    if ((globals.playlist[index].duration.inSeconds % 60) >= 30) {
      globals.totalMinutes--;
    }
    globals.playlist.remove(globals.playlist[index]);
    globals.audioStreamUrls.remove(globals.audioStreamUrls[index]);
  }

  void callback(int index) {
    setState(() {
      deleteFromPlaylist(index);
    });
  }

  showAlertDialog(BuildContext context) {
    // set up the AlertDialog

    alert = AlertDialog(
      title: Text("Loading your Musicize..."),
      // content: CircularProgressIndicator(),
      // actions: [
      //   cancelButton,
      //   continueButton,
      // ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          if (loaded) {
            print('done with getting TEMP urls');
            // Navigator.pop(context, this.widget.callback(2));
          } else {
            print('getting urls');
            globals.audioStreamUrls = [];
            extractYoutube();
          }

          return alert;
        });
      },
    );

    // show the dialog

    // globals.audioStreamUrls = [];
    // extractYoutube();
  }

  Widget build(BuildContext context) {
    return new Container(
        padding: EdgeInsets.only(top: 16.0),
        // margin: EdgeInsets.only(bottom: 50.0),
        color: HexColor('5660E8'),
        // color: HexColor('19CFFC'),
        child: Stack(children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: 300.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage('https://i.ibb.co/6nHYkp1/playlist.png'),
                  colorFilter: new ColorFilter.mode(
                            Colors.black.withOpacity(0.7), BlendMode.darken),
                  fit: BoxFit.cover),
              
            ),
          ),

          ListView(
            children: <Widget>[
              Container(
                  height: 150.0,

                  // width: 500.0,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Flexible(
                                  //flex: 2,
                                  child: Container(
                                      padding: EdgeInsets.only(
                                          left: 20.0, right: 10.0),
                                      child: GestureDetector(
                                          onTap: () {
                                            this.widget.callback(0);
                                          },
                                          child: Icon(
                                            Icons.arrow_back,
                                            color: Colors.white,
                                            size: 36.0,
                                          )))),

                              FadeInUp(
                                  child: Text('Choose Your Music',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        fontFamily: 'Raleway',
                                        fontSize: 20,
                                      ))),

                              // Text('7 Songs | 38 mins'),

                              // Flexible(child:
                              // ImgCrop(
                              //   key: imgCropKey,
                              //   chipRadius: 50.0,
                              //   image: NetworkImage(
                              //       'https://walkwest.com/wp-content/uploads/2019/09/Kim-Holderness.jpg'),
                              // )), // you selected image file
                            ],
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // GestureDetector(
                            //     onTap: () => {
                            //           Navigator.push(
                            //             context,
                            //             MaterialPageRoute(
                            //                 builder: (context) =>
                            //                     Home(this.refresh)),
                            //           ),
                            //         },
                            //     child: GFSearchBar(
                            //       searchBoxInputDecoration: InputDecoration(
                            //         enabledBorder: const OutlineInputBorder(
                            //           borderSide: BorderSide(
                            //             color: Colors.white,
                            //           ),
                            //         ),
                            //         focusedBorder: OutlineInputBorder(
                            //           borderSide: BorderSide(
                            //             color: Colors.white,
                            //           ),
                            //         ),
                            //         suffixIcon:
                            //             Icon(Icons.search, color: Colors.white),
                            //         border: InputBorder.none,
                            //         hintText: 'Search for a song...',
                            //         hintStyle: TextStyle(
                            //             color: Colors.white, fontFamily: 'Raleway'),
                            //         contentPadding: const EdgeInsets.only(
                            //           left: 16,
                            //           right: 20,
                            //           top: 8,
                            //           bottom: 16,
                            //         ),
                            //       ),
                            //       searchList: list,
                            //       searchQueryBuilder: (query, list) {
                            //         //list.clear();
                            //         Navigator.push(
                            //           context,
                            //           MaterialPageRoute(
                            //               builder: (context) => Home(this.refresh)),
                            //         );
                            //       },
                            //       overlaySearchListItemBuilder: (item) {
                            //         return Container(
                            //           padding: const EdgeInsets.all(8),
                            //           child: GFListTile(titleText: item.title),
                            //         );
                            //       },
                            //       onItemSelected: (item) {
                            //         setState(() {
                            //           if (item != null) {
                            //             print('a');
                            //             globals.playlist.add(item);
                            //             globals.video = item;
                            //             globals.totalMinutes +=
                            //                 item.duration.inMinutes;
                            //             if ((item.duration.inSeconds % 60) >= 30) {
                            //               globals.totalMinutes++;
                            //             }
                            //             print(globals.playlist.toString());
                            //             // extractYoutube(item.id.value);
                            //           }
                            //         });
                            //       },
                            //     )),
                            Container(
                              padding: EdgeInsets.only(left: 20.0),
                              child: Text(globals.username + '\'s Playlist',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 35.0,
                                      // color: Colors.black,
                                      fontWeight: FontWeight.w700)),
                            ),

                            Container(
                              padding: EdgeInsets.only(left: 20.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    globals.playlist.length.toString() +
                                        ' Songs | ' +
                                        globals.totalMinutes.toString() +
                                        ' Mins',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Raleway',
                                    ),
                                    textAlign: TextAlign.left,
                                  )
                                ],
                              ),
                            )
                          ],
                        )
                      ])),
              Container(
                  // height: MediaQuery.of(context).size.height - 286.0,

                  // margin: globals.playlist.length == 0 ? EdgeInsets.only(
                  //     top: 10.0, left: 10.0, right: 10.0, bottom: 70.0) : EdgeInsets.only(
                  //     top: 0.0, left: 0.0, right: 10.0, bottom: 70.0),
                  margin: EdgeInsets.only(
                      top: 10.0, left: 10.0, right: 10.0, bottom: 70.0),
                  decoration: BoxDecoration(
                      // color: globals.playlist.length == 0 ? Colors.white : Color.fromARGB(0,0,0,0),
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.0),
                        topRight: Radius.circular(15.0),
                        bottomLeft: Radius.circular(15.0),
                        bottomRight: Radius.circular(15.0),
                      )),
                  child: Container(
                      padding: EdgeInsets.only(left: 16.0, top: 16.0, bottom: 16.0),
                      // padding: EdgeInsets.all(3),
                      child: new Expanded(
                          child: ListView(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              physics: ClampingScrollPhysics(),

                              // mainAxisAlignment: MainAxisAlignment.center,
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                            ConditionalBuilder(
                              condition: loading,
                              builder: (context) => GFLoader(),
                            ),
                            if (globals.playlist.length == 0) ...[
                              Container(
                                height: MediaQuery.of(context).size.height - 285,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Text(
                                      'There\'s nothing here...',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.0,
                                          fontFamily: 'Raleway'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            ConditionalBuilder(
                              condition: globals.playlist != [],
                              builder: (context) => VideoLayout(this.callback),
                            ),
                          ]))))
            ],
          ),
          // Text('Austin can\'t even do imports himself', style: TextStyle(fontSize: 50, color: Colors.white)),
          Container(
              margin: EdgeInsets.all(10.0),
              alignment: Alignment.bottomCenter,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    new SizedBox(
                        width: 140.0,
                        height: 50.0,
                        child: RaisedButton(
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)),
                            color: HexColor('#19CFFC'),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Icon(Icons.add_circle_outline,
                                      color: Colors.white),
                                  AutoSizeText('Add Music',
                                      maxLines: 1,
                                      style: new TextStyle(
                                          fontSize: 14.0,
                                          // s
                                          fontFamily: 'Raleway',
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white)),
                                ]),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Home(this.refresh)));
                            })),
                    new SizedBox(
                        width: 140.0,
                        height: 50.0,
                        child: RaisedButton(
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)),
                            color: HexColor('#19CFFC'),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Icon(Icons.check, color: Colors.white),
                                  AutoSizeText('Musicize',
                                      maxLines: 1,
                                      style: new TextStyle(
                                          fontSize: 14.0,
                                          // letterSpacing: 0.50,
                                          fontFamily: 'Raleway',
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white)),
                                ]),
                            onPressed: () {
                              print(globals.playlist);
                              print(globals.audioStreamUrls.length);
                              if (globals.playlist != [] && !loading && globals.audioStreamUrls.length != 0 &&
                              globals.playlist.length != 0 && globals.playlist.length == globals.audioStreamUrls.length) {
                                this.widget.callback(2);
                              }
                            })),
                    //   new RaisedButton(
                    //   shape: new RoundedRectangleBorder(
                    //       borderRadius: new BorderRadius.circular(50.0)),
                    //   color: Colors.white,
                    //   child:  Row(children: <Widget>[
                    //     Icon(Icons.add_circle_outline),
                    //     Text('+',  style: new TextStyle(
                    //           fontSize: 14.0,
                    //           letterSpacing: 0.50,
                    //           fontFamily: 'Raleway',
                    //           fontWeight: FontWeight.w900,
                    //           color: HexColor('#5660E8'))),],

                    //   onPressed: ),
                    //   ],
                    // )
                  ])),
        ]));

    /*
      return Container(
        child: new ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
        children: <Widget>[
          Text("Add to Playlist"
          ),
          GFSearchBar(
            searchList: list,
            searchQueryBuilder: (query, list) {
              //list.clear();
              yt.search
                  .getVideosAsync(query)
                  .take(10)
                  .forEach((video) => {list.add(video)});
              list.removeRange(0, 10);
              return list;
            },
            overlaySearchListItemBuilder: (item) {
              return Container(
                padding: const EdgeInsets.all(8),
                child: GFListTile(titleText: item.title),
              );
            },
            onItemSelected: (item) {
              setState(() {
                globals.playlist.add(item);
                globals.video = item;
                print(globals.playlist.toString());
                extractYoutube(item.id.value);
                
              });
            },
          ),
          ConditionalBuilder(
            condition: loading,
            builder: (context) => GFLoader(),
          ),
          // ListView(
          //   padding: const EdgeInsets.all(8),
          //   children: <Widget>[
          //     GFCard(
          //       boxFit: BoxFit.cover,
          //       colorFilter: new ColorFilter.mode(
          //           Colors.black.withOpacity(0.50), BlendMode.darken),
          //       imageOverlay: NetworkImage(
          //         globals.video.thumbnails.highResUrl,
          //       ),
          //       title: GFListTile(
          //         title: Text(globals.video.title,
          //             style: TextStyle(color: GFColors.WHITE)),
          //       ),
          //     ),
          //   ],
          // ),
          // ConditionalBuilder(
          //   condition: loaded,
          //   builder: (context) => VideoLayout(),
          //   // GFCard(
          //   //   boxFit: BoxFit.cover,
          //   //   colorFilter: new ColorFilter.mode(
          //   //       Colors.black.withOpacity(0.50), BlendMode.darken),
          //   //   imageOverlay: NetworkImage(
          //   //     globals.video.thumbnails.highResUrl,
          //   //   ),
          //   //   title: GFListTile(
          //   //     title: Text(globals.video.title,
          //   //         style: TextStyle(color: GFColors.WHITE)),
          //   //   ),
          //   // ),
          // ),
          
          /*Padding(
              padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
              child: SizedBox(
                  height: 40.0,
                  child: new RaisedButton(
                    elevation: 5.0,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    color: Colors.blue,
                    child: new Text('Import Audio',
                        style:
                            new TextStyle(fontSize: 20.0, color: Colors.white)),
                    onPressed: () {
                      setState(() {
                        openAudioPicker();
                      });
                    },
                  )))*/
          Padding(
              padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
              child: SizedBox(
                  height: 40.0,
                  child: new RaisedButton(
                    elevation: 5.0,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    color: Colors.blue,
                    child: new Text('Musicize!',
                        style:
                            new TextStyle(fontSize: 20.0, color: Colors.white)),
                    onPressed: () {
                      setState(() {
                        if (globals.audioStreamUrls.length != 0 &&
                            loading == false) {
                          this.widget.callback(2);
                        }
                      });
                    },
                  ))),
          // ListView.builder(
          //     padding: const EdgeInsets.all(8),
          //     itemCount: entries.length,
          //     itemBuilder: (BuildContext context, int index) {
          //       return Container(
          //         height: 50,
          //         color: Colors.amber[colorCodes[index]],
          //         child: Center(child: Text('Entry ${entries[index]}')),
          //       );
          
          VideoLayout(),
          //     })
        ],
      ),
      );*/
  }
}

class VideoLayout extends StatefulWidget {
  Function callback;

  VideoLayout(this.callback);

  State<StatefulWidget> createState() => new _VideoLayoutState();
}

class _VideoLayoutState extends State<VideoLayout> {
  @override
  Widget build(BuildContext context) {
    return _myListView(context);
  }

  Widget _myListView(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: globals.playlist.length,
      itemBuilder: (context, index) {
        return GFListTile(
            color: Colors.white,
            padding: EdgeInsets.all(8.0),
            margin: EdgeInsets.symmetric(vertical: 5.0),
            avatar: GFAvatar(
                shape: GFAvatarShape.standard,
                backgroundImage: NetworkImage(
                    globals.playlist[index].thumbnails.highResUrl,
                    scale: 1.5)),
            title: AutoSizeText(globals.playlist[index].title,
                maxLines: 2,
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.w600)),
            subTitle: AutoSizeText(globals.playlist[index].author,
                maxLines: 1,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 12.0)),
            description: AutoSizeText(
                globals.playlist[index].duration.toString().split('.')[0],
                maxLines: 1,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w300,
                    fontSize: 10.0,
                    fontStyle: FontStyle.italic)),
            icon: GFIconButton(
              color: Color.fromARGB(0, 0, 0, 0),
              onPressed: () {
                setState(() {
                  this.widget.callback(index);
                });
              },
              icon: Icon(Icons.highlight_off, color: Colors.black, size: 20.0),
            ));
      },
    );
  }
}
