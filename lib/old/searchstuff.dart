import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/scaled_tile.dart';
import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as prefix;
import 'globals.dart' as globals;

class Post {
  final String title;
  final String body;
  final String thumbnail;
  bool added;
  bool loading;
  var video;
  String audioStreamUrl;
  Post(this.title, this.body, this.thumbnail, this.video,
      {this.added = false, this.loading = false, this.audioStreamUrl = ''});
}

class Home extends StatefulWidget {
  Function callback;
  Home(this.callback);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var yt = prefix.YoutubeExplode();
  final SearchBarController<Post> _searchBarController = SearchBarController();
  bool isReplay = false;
  var loading = false;
  var loaded = false;
  Future<List<Post>> _getALlPosts(String text) async {
    await Future.delayed(Duration(seconds: text.length == 4 ? 10 : 1));
    // if (isReplay) return [Post("Replaying !", "Replaying body")];
    // if (text.length == 5) throw Error();
    // if (text.length == 6) return [];
    List<Post> posts = [];

    await yt.search.getVideosAsync(text).take(10).forEach((video) => {
          posts.add(new Post(
              video.title, video.author, video.thumbnails.highResUrl, video,
              added: false))
        });

    // var random = new Random();
    // for (int i = 0; i < 10; i++) {
    //   posts.add(Post("$text $i", "body random number : ${random.nextInt(100)}"));
    // }
    return posts;
  }

  void dispose() {
    super.dispose();
    yt.close();
  }

  void extractYoutube(String id, Post p) async {
    var yt = prefix.YoutubeExplode();
    globals.loadingSongs = true;
    p.loading = true;
    var manifest = await yt.videos.streamsClient.getManifest(p.video.id);
    var streams = manifest.audioOnly;
    var audio = streams.last.url;
    globals.audioStreamUrls.add(audio.toString());
    p.audioStreamUrl = audio.toString();
    globals.playlist.add(p.video);
    print('audioStreamUrls length is now: ' +
        globals.audioStreamUrls.length.toString());
    yt.close();
    setState(() {
      p.loading = false;
      globals.loadingSongs = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Stack(children: <Widget>[
            SearchBar<Post>(
              searchBarPadding: EdgeInsets.symmetric(horizontal: 10),
              headerPadding: EdgeInsets.symmetric(horizontal: 10),
              listPadding: EdgeInsets.symmetric(horizontal: 10),
              onSearch: _getALlPosts,
              searchBarController: _searchBarController,
              placeHolder: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                    Image(
                      image: NetworkImage(
                          'https://i.ibb.co/JmNn5zS/muisicizer-login-6.png',
                          scale: 0.5),
                    ),
                    Text('Start searching to add songs.',
                        style: TextStyle(fontSize: 20.0))
                  ])),
              cancellationWidget: Text("Cancel"),
              emptyWidget: Text("empty"),
              indexedScaledTileBuilder: (int index) =>
                  ScaledTile.count(1, index.isEven ? 2 : 1),
              // header: Row(
              //   children: <Widget>[
              //     RaisedButton(
              //       child: Text("sort"),
              //       onPressed: () {
              //         _searchBarController.sortList((Post a, Post b) {
              //           return a.body.compareTo(b.body);
              //         });
              //       },
              //     ),
              //     RaisedButton(
              //       child: Text("Desort"),
              //       onPressed: () {
              //         _searchBarController.removeSort();
              //       },
              //     ),
              //     RaisedButton(
              //       child: Text("Replay"),
              //       onPressed: () {
              //         isReplay = !isReplay;
              //         _searchBarController.replayLastSearch();
              //       },
              //     ),
              //   ],
              // ),
              onCancelled: () {
                print("Cancelled triggered");
              },
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              crossAxisCount: 2,
              onItemFound: (Post post, int index) {
                return Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(post.thumbnail),
                        colorFilter: new ColorFilter.mode(
                            Colors.black.withOpacity(0.4), BlendMode.darken),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Center(
                            child: ListTile(
                          title: AutoSizeText(post.title,
                              maxLines: 2,
                              style: TextStyle(
                                  fontFamily: 'Raleway',
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          isThreeLine: true,
                          subtitle: AutoSizeText(post.body,
                              maxLines: 1,
                              style: TextStyle(
                                  fontFamily: 'Raleway',
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic)),
                          // onTap: () {
                          //   Navigator.of(context).push(MaterialPageRoute(
                          //       builder: (context) => Detail()));
                          // },
                        )),
                        SizedBox(
                            height: 40.0,
                            width: 140.0,
                            child: new RaisedButton(
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(25.0)),
                                color: !post.added
                                    ? Colors.white
                                    : Color.fromARGB(0, 0, 0, 0),
                                child: !post.loading
                                    ? post.added
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                                Icon(Icons.check_circle_outline,
                                                    color: Colors.white),
                                                Text('Remove',
                                                    style: TextStyle(
                                                        color: Colors.white))
                                              ])
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                                Icon(Icons.add_circle_outline),
                                                AutoSizeText('Add Song')
                                              ])
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                            CircularProgressIndicator(),
                                            AutoSizeText('Loading...',
                                                style: TextStyle(
                                                    color: Colors.white))
                                          ]),
                                onPressed: () {
                                  if (!post.loading) {
                                    if (!post.added) {
                                      print('added: ' + post.title);
                                      
                                      print('playlist length is now: ' +
                                          globals.playlist.length.toString());
                                      globals.totalMinutes +=
                                          post.video.duration.inMinutes;
                                      if ((post.video.duration.inSeconds %
                                              60) >=
                                          30) {
                                        globals.totalMinutes++;
                                      }
                                      extractYoutube(
                                          post.video.id.toString(), post);
                                    } else {
                                      print('removed: ' + post.title);
                                      globals.totalMinutes -=
                                          post.video.duration.inMinutes;

                                      if ((post.video.duration.inSeconds %
                                              60) >=
                                          30) {
                                        globals.totalMinutes--;
                                      }
                                      globals.playlist.remove(post.video);
                                      globals.audioStreamUrls
                                          .remove(post.audioStreamUrl);
                                      print('stream urls length is now: ' +
                                          globals.audioStreamUrls.length
                                              .toString());
                                      print('playlist length is now: ' +
                                          globals.playlist.length.toString());
                                    }
                                    setState(() {
                                      post.added = !post.added;
                                    });
                                  }
                                })),
                      ],
                    ));
              },
            ),
            Container(
              margin: EdgeInsets.all(15.0),
              alignment: Alignment.bottomRight,
              child: SizedBox(
                  height: 50.0,
                  width: 50.0,
                  child: new RaisedButton(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(25.0)),
                      color: Colors.white,
                      child: Center(child: Icon(Icons.subdirectory_arrow_left)),
                      onPressed: () {
                        Navigator.pop(context, this.widget.callback());
                      })),
            )
          ]),
        ));
  }
}

class Detail extends StatelessWidget {
  @override
  // final Post post;

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => {
                if(!globals.loadingSongs && globals.audioStreamUrls.length == globals.playlist.length) {
                Navigator.of(context).pop()
                }
                else {
                  print('tevin do an alert thingy here.')
                }
              }
            ),
            Text("Detail"),
          ],
        ),
      ),
    );
  }
}
