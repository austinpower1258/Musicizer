/*
UPDATED: 7/29/20
This is  the profile page where the user can perform various tasks.

Copyright Musicizer LLC.
*/

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/globals.dart' as globals;
import 'package:firebase_database/firebase_database.dart';
import '../../services/hex_color.dart';
import 'dart:async';
import 'package:getflutter/getflutter.dart';
import 'package:animate_do/animate_do.dart';
import '../../services/authentication.dart';
import 'leaderboard_page.dart';
import 'settings.dart';
import 'edit_profile.dart';
import 'package:auto_size_text/auto_size_text.dart';

class ProfilePage extends StatefulWidget {
  createState() => _ProfilePageState();
  ProfilePage({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);
  final VoidCallback logoutCallback;
  final String userId;
  final BaseAuth auth;
}

class _ProfilePageState extends State<ProfilePage> {
  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (_) => Material(
        type: MaterialType.transparency,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          // Aligns the container to center
          children: <Widget>[
            Container(
              width: 300,
              height: MediaQuery.of(context).size.height - 94,
              child: ImageCapture(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  width: 80,
                  height: 50,
                  margin: EdgeInsets.only(bottom: 20, right: 30.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(75.0)),
                    color: Colors.white,
                  ),

                  // A simplified version of dialog.
                  child: new FlatButton(
                    child: new Text("Close"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                )
              ],
            )
          ],
        ),
      ),
      // builder: (BuildContext context) {
      //   // return object of type Dialog
      //   return AlertDialog(
      //     title: new Text("Change profile picture"),
      //     content: new ImageCapture(),
      //     actions: <Widget>[
      //       // usually buttons at the bottom of the dialog
      //       new FlatButton(
      //         child: new Text("Close"),
      //         onPressed: () {
      //           Navigator.of(context).pop();
      //         },
      //       ),
      //     ],
      //   );
      // },
    );
  }

  signOut() async {
    
    globals.runningPage = 0;
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }

  Widget build(BuildContext context) {
    return new Stack(children: <Widget>[
      Container(
        height: MediaQuery.of(context).size.height,
        color: HexColor('#5660E8'),
         
      ),
      Container(
        width: MediaQuery.of(context).size.width,
        height: 247.0,
        decoration: BoxDecoration(
            
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25.0),
              bottomRight: Radius.circular(25.0),
            ),
          ),
        child: ColorFiltered(
          child: ColorFiltered(
          child: Image.network(
            globals.pfpUrl,
            fit: BoxFit.cover,
          ),
          colorFilter: ColorFilter.mode(HexColor('#5660E8'), BlendMode.color),
        ),
          colorFilter: ColorFilter.mode(Colors.black, BlendMode.color),
        ),
      ),
      ListView(scrollDirection: Axis.vertical, shrinkWrap: true, children: <
          Widget>[
        Stack(children: <Widget>[
          Container(
              alignment: Alignment.bottomCenter,
              // color: HexColor('#5660E8'),

              child: Container(
                margin: EdgeInsets.only(top: 100.0, left: 10.0, right: 10.0, bottom: 15.0),
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: Colors.white,
                  // color: HexColor('#5660E8'),
                  boxShadow: [
                    BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                   offset: Offset(0, 6), // changes position of shadow
                     ),
                  ],
                  // color: HexColor('#ffffff'),
                  //   borderRadius: BorderRadius.only(
                  //     topLeft: Radius.circular(15.0),
                  //     topRight: Radius.circular(15.0),
                  //     bottomLeft: Radius.zero,
                  //     bottomRight: Radius.zero,
                  // )

                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Container(
                    padding: EdgeInsets.only(left: 16.0, right: 16.0),
                    child: new Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        // scrollDirection: Axis.vertical,
                        // shrinkWrap: true,
                        //physics: ClampingScrollPhysics(),
                        children: <Widget>[
                          Container(
                              padding: EdgeInsets.only(top: 130.0, bottom: 20.0),
                              decoration: new BoxDecoration(
                                  /*gradient: new LinearGradient(
              colors: [HexColor('#4E8FFF') , HexColor('#4EFFF3')],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),*/
                                  // color: HexColor('#5660E8'),
                                  ),
                              // color: HexColor('19CFFC'),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                // Center(
                                //     child: Container(
                                //         height: 200.0,
                                //         // width: 500.0,
                                //         child: )),
                                GestureDetector(
                                  onTap: () => {
                                    Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          LDPage()))
                                  },
                                  child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 10.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      new BoxShadow(
                                        color: Color.fromARGB(80, 0, 0, 0),
                                        blurRadius: 30.0,
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: GFListTile(
                                      titleText: 'Leaderboard',
                                      subtitleText: 'See the best in the world',
                                      icon: Icon(Icons.public )),
                                )),
                                 GestureDetector(
                                  onTap: () => {
                                    Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SettingsPage()))
                                  },
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 10.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      new BoxShadow(
                                        color: Color.fromARGB(80, 0, 0, 0),
                                        blurRadius: 30.0,
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: GFListTile(
                                      titleText: 'Settings',
                                      subtitleText: 'Configure your app the way you want it.',
                                      icon: Icon(Icons.settings)),
                                )),
                                // Container(
                                //    margin: EdgeInsets.symmetric(vertical: 10.0),
                                //   // decoration: BoxDecoration(
                                //   //   boxShadow: [
                                //   //     new BoxShadow(
                                //   //       color: Color.fromARGB
                                //   //     )
                                //   //   ]
                                //   // ),
                                //   decoration: BoxDecoration(
                                //     color: Colors.white,
                                //     boxShadow: [
                                //       new BoxShadow(
                                //         color: Color.fromARGB(80, 0, 0, 0),
                                //         blurRadius: 30.0,
                                //       )
                                //     ],
                                //     borderRadius: BorderRadius.circular(15.0),
                                //   ),
                                //   child: GFListTile(
                                //       titleText: 'Add Friends',
                                //       subtitleText:
                                //           'Musicize with your buddies... 6 feet social distancing of course.',
                                //       icon: Icon(Icons.person_add)),
                                // ),
                                GestureDetector(
                                  onTap: () => {
                                     Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          EditProfile(userId: widget.userId,
                    auth: widget.auth,
                    logoutCallback: widget.logoutCallback)))
                                  },
                                  child: Container(
                                   margin: EdgeInsets.symmetric(vertical: 10.0),
                                  // decoration: BoxDecoration(
                                  //   boxShadow: [
                                  //     new BoxShadow(
                                  //       color: Color.fromARGB
                                  //     )
                                  //   ]
                                  // ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      new BoxShadow(
                                        color: Color.fromARGB(80, 0, 0, 0),
                                        blurRadius: 30.0,
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: GFListTile(
                                      titleText: 'Edit Profile',
                                      subtitleText:
                                          'Make yourself look cool... at least in this app.',
                                      icon: Icon(Icons.person)),
                                )),
                                GestureDetector(
                                  onTap: () => {
                                    signOut()
                                  },
                                  child: Container(
                                   margin: EdgeInsets.symmetric(vertical: 10.0),
                                  // decoration: BoxDecoration(
                                  //   boxShadow: [
                                  //     new BoxShadow(
                                  //       color: Color.fromARGB
                                  //     )
                                  //   ]
                                  // ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      new BoxShadow(
                                        color: Color.fromARGB(80, 0, 0, 0),
                                        blurRadius: 30.0,
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: GFListTile(
                                      titleText: 'Sign Out',
                                      subtitleText: 'Take a break.',
                                      icon: Icon(Icons.eject )),
                                ),
                                ),
                                

                                // Row(
                                //   mainAxisAlignment:
                                //       MainAxisAlignment.spaceAround,
                                //   children: <Widget>[
                                //     Container(
                                //         width: 145.0,
                                //         height: 170.0,
                                //         padding: EdgeInsets.all(15.0),
                                //         margin:
                                //             EdgeInsets.symmetric(vertical: 2.0),
                                //         decoration: BoxDecoration(
                                //           borderRadius:
                                //               BorderRadius.circular(15.0),
                                //           color: Colors.white,
                                //           boxShadow: [
                                //             BoxShadow(
                                //               color:
                                //                   Colors.black.withOpacity(0.2),
                                //               spreadRadius: 5,
                                //               blurRadius: 7,
                                //               offset: Offset(0,
                                //                   6), // changes position of shadow
                                //             ),
                                //           ],
                                //         ),
                                //         child: Center(
                                //             child: Column(
                                //                 mainAxisAlignment:
                                //                     MainAxisAlignment.center,
                                //                 children: <Widget>[
                                //               Icon(
                                //                 Icons.person_add,
                                //                 size: 30,
                                //               ),
                                //               Text('Add Friends',
                                //                   style: TextStyle(
                                //                     fontFamily: 'Raleway',
                                //                     fontSize: 18,
                                //                   )),
                                //             ]))),
                                //     Container(
                                //         width: 135.0,
                                //         height: 170.0,
                                //         padding: EdgeInsets.all(15.0),
                                //         margin:
                                //             EdgeInsets.symmetric(vertical: 2.0),
                                //         decoration: BoxDecoration(
                                //           borderRadius:
                                //               BorderRadius.circular(15.0),
                                //           color: Colors.white,
                                //           boxShadow: [
                                //             BoxShadow(
                                //               color:
                                //                   Colors.black.withOpacity(0.2),
                                //               spreadRadius: 5,
                                //               blurRadius: 7,
                                //               offset: Offset(0,
                                //                   6), // changes position of shadow
                                //             ),
                                //           ],
                                //         ),
                                //         child: Center(
                                //             child: Column(
                                //                 mainAxisAlignment:
                                //                     MainAxisAlignment.center,
                                //                 children: <Widget>[
                                //               Icon(
                                //                 Icons.card_giftcard,
                                //                 size: 30,
                                //               ),
                                //               Column(
                                //                 children: <Widget>[
                                //                   Text('Rewards',
                                //                       style: TextStyle(
                                //                         fontFamily: 'Raleway',
                                //                         fontSize: 20,
                                //                       )),
                                //                   Text('unavailable in alpha',
                                //                       style: TextStyle(
                                //                         fontStyle:
                                //                             FontStyle.italic,
                                //                         fontFamily: 'Raleway',
                                //                         fontSize: 12,
                                //                       )),
                                //                 ],
                                //               ),
                                //             ]))),
                                //   ],
                                // ),
                                // FadeInUp(
                                //     child: Column(
                                //         mainAxisAlignment:
                                //             MainAxisAlignment.spaceAround,
                                //         children: <Widget>[
                                //       GFButton(
                                //           onPressed: () {
                                //             this.signOut();
                                //           },
                                //           text: "Sign Out",
                                //           textStyle:
                                //               TextStyle(fontFamily: 'Raleway'),
                                //           shape: GFButtonShape.pills,
                                //           size: GFSize.MEDIUM,
                                //           blockButton: true,
                                //           color: HexColor('#B154A2')),
                                //     ])),
                              ]))
                        ])),
              )),
          Container(
            margin: EdgeInsets.only(top: 50.0),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: <
                    Widget>[
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <
                  Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    SizedBox(
                        width: 120,
                        height: 120,
                        child: Stack(
                          children: <Widget>[
                            CircleAvatar(
                              radius: 120,
                              child: Container(
                                height: 120,
                                width: 120,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(60)),
                                  border: Border.all(
                                    color: Colors.white60,
                                    width: 4,
                                  ),
                                  // Specifies the background color and the opacity
                                ),
                              ),
                              backgroundImage: NetworkImage(globals.pfpUrl),
                            ),
                            Container(
                              child: GestureDetector(
                                  onTap: _showDialog,
                                  child: Container(
                                    padding:
                                        EdgeInsets.only(left: 4.0, right: 4.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      border: Border.all(
                                        color: Colors.white10,
                                        width: 4,
                                      ),
                                      boxShadow: [
                                        new BoxShadow(
                                          color: Color.fromARGB(150, 0, 0, 0),
                                          blurRadius: 7.0,
                                        ),
                                      ],
                                      // Specifies the background color and the opacity
                                    ),
                                    child: Icon(
                                      Icons.add_a_photo,
                                      color: Colors.black,
                                      size: 15,
                                    ),
                                  )),
                              alignment: Alignment.bottomRight,
                            ),
                          ],
                        )),
                    Container(
                      
                        padding: EdgeInsets.only(top: 8.0),
                        child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              AutoSizeText(globals.username.toString(),
                              maxLines: 1,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 36.0,
                                    fontWeight: FontWeight.w500,
                             
                                  ))
                            ])),

                    // Flexible(child:
                    // ImgCrop(
                    //   key: imgCropKey,
                    //   chipRadius: 50.0,
                    //   image: NetworkImage(
                    //       'https://walkwest.com/wp-content/uploads/2019/09/Kim-Holderness.jpg'),
                    // )), // you selected image file
                  ],
                ),
              ])
            ]),
          )
        ]),
      ])
    ]);
  }
}

/// Widget to capture and crop the image
class ImageCapture extends StatefulWidget {
  createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  /// Active image file
  File _imageFile;
  final picker = ImagePicker();
  bool finished = false;

  /// Cropper plugin
  // Future<void> _cropImage() async {
  //   File cropped = await ImageCropper.cropImage(
  //       sourcePath: _imageFile.path,
  //       // ratioX: 1.0,
  //       // ratioY: 1.0,
  //       // maxWidth: 512,
  //       // maxHeight: 512,
  //       toolbarColor: Colors.purple,
  //       toolbarWidgetColor: Colors.white,
  //       toolbarTitle: 'Crop It');

  //   setState(() {
  //     _imageFile = cropped ?? _imageFile;
  //   });
  // }
  void callback(bool finished) {
    setState(() {
      this.finished = finished;
    });
  }

  /// Select an image via gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    final selected = await picker.getImage(source: source);

    setState(() {
      _imageFile = File(selected.path);
    });
  }

  /// Remove image
  void _clear() {
    setState(() => _imageFile = null);
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.end,
        // scrollDirection: Axis.vertical,
        // physics: ClampingScrollPhysics(),
        children: <Widget>[
          if (_imageFile == null) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FadeInUp(
                    child: GestureDetector(
                        onTap: () => _pickImage(ImageSource.camera),
                        child: Container(
                          margin: EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 5,
                                blurRadius: 7,
                              )
                            ],
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(75.0)),
                          ),
                          child: GFListTile(
                              padding: EdgeInsets.all(0),
                              titleText: 'Take Photo',
                              icon: IconButton(
                                icon: Icon(
                                  Icons.photo_camera,
                                  size: 30,
                                ),
                                onPressed: () => _pickImage(ImageSource.camera),
                                color: Colors.blue,
                              )),
                        ))),
                /*
                FadeInUp(
                  child: Container(
                    margin: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 7,
                          // changes position of shadow
                        )
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: GFListTile(
                        padding: EdgeInsets.all(0),
                        titleText: 'Take Photo',
                        icon: IconButton(
                          icon: Icon(
                            Icons.photo_camera,
                            size: 30,
                          ),
                          onPressed: () => _pickImage(ImageSource.camera),
                          color: Colors.blue,
                        )),
                  ),
                ),*/
                FadeInUp(
                    child: GestureDetector(
                        onTap: () => _pickImage(ImageSource.gallery),
                        child: Container(
                          margin: EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 5,
                                blurRadius: 7,

                                // changes position of shadow
                              )
                            ],
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(75.0)),
                          ),
                          child: GFListTile(
                            padding: EdgeInsets.all(0),
                            titleText: 'Choose from Library',
                            icon: IconButton(
                              icon: Icon(
                                Icons.photo_library,
                                size: 30,
                              ),
                              onPressed: () => _pickImage(ImageSource.gallery),
                              color: Colors.blue,
                            ),
                          ),
                        )))

                // IconButton(
                //   icon: Icon(
                //     Icons.photo_library,
                //     size: 30,
                //   ),
                //   onPressed: () => _pickImage(ImageSource.gallery),
                //   color: Colors.pink,
                // ),
              ],
            ),
          ],
          if (_imageFile != null) ...[
            SizedBox(
                width: 200,
                height: 230,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 15.0),
                  // padding: EdgeInsets.only(left: 32, right: 32),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(100.0),
                    ),
                    color: Colors.white,
                  ),
                  child: Center(
                      child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(90.0),
                      ),
                      image: DecorationImage(
                          image: FileImage(_imageFile), fit: BoxFit.cover),
                    ),
                  )),
                )
                // padding: EdgeInsets.all(32),
                ),
            if (!finished) ...[
              FadeInUp(
                child: GestureDetector(
                    onTap: _clear,
                    child: Container(
                      margin: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 5,
                            blurRadius: 7,
                            // changes position of shadow
                          )
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(75.0)),
                      ),
                      child: GFListTile(
                        padding: EdgeInsets.all(0),
                        titleText: 'Redo',
                        icon: IconButton(
                          icon: Icon(
                            Icons.refresh,
                            size: 30,
                          ),
                          onPressed: () => _clear,
                          color: Colors.blue,
                        ),
                      ),
                    )),
              ),
            ],

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: <Widget>[
            //     // FlatButton(
            //     //   color: Colors.black,
            //     //   child: Icon(Icons.crop),
            //     //   onPressed: _cropImage,
            //     // ),
            //     FlatButton(

            //       child: Icon(Icons.refresh, color: Colors.white),
            //       onPressed: _clear,
            //     ),
            //   ],
            // ),

            Uploader(
              this.callback,
              file: _imageFile,
            ),
          ]
        ]);
  }
}

/// Widget used to handle the management of
class Uploader extends StatefulWidget {
  final File file;

  Function callback;

  Uploader(this.callback, {Key key, this.file}) : super(key: key);

  createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  final dbRef = FirebaseDatabase.instance.reference().child("users");
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://musicizer-832bd.appspot.com/');

  StorageUploadTask _uploadTask;

  void _startUpload() async {
    String filePath = 'profiles/${globals.userId}.png';

    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
      this.widget.callback(true);
    });
    dbRef
        .child(globals.userId)
        .child('pfpUrl')
        .set(await _storage.ref().child(filePath).getDownloadURL() as String);
    globals.pfpUrl =
        await _storage.ref().child(filePath).getDownloadURL() as String;
  }

  @override
  Widget build(BuildContext context) {
    if (_uploadTask != null) {
      return StreamBuilder<StorageTaskEvent>(
          stream: _uploadTask.events,
          builder: (context, snapshot) {
            var event = snapshot?.data?.snapshot;

            double progressPercent = event != null
                ? event.bytesTransferred / event.totalByteCount
                : 0;

            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (!_uploadTask.isComplete) ...[
                    CircularProgressIndicator(value: progressPercent),
                  ] else ...[
                    Container(
                      margin: EdgeInsets.all(4.0),
                      padding: EdgeInsets.all(4.0),
                      width: 120.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Icon(
                            Icons.check,
                            color: Colors.blue,
                            size: 36.0,
                          ),
                          Text('Complete',
                              style: TextStyle(
                                fontFamily: 'Raleway',
                              )),
                        ],
                      ),
                    )
                  ],
                ]);
          });
    } else {
      return FadeInUp(
          child: GestureDetector(
              onTap: _startUpload,
              child: Container(
                margin: EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      // changes position of shadow
                    )
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(75.0)),
                ),
                child: GFListTile(
                  padding: EdgeInsets.all(0),
                  titleText: 'Confirm',
                  icon: IconButton(
                    icon: Icon(
                      Icons.cloud_upload,
                      size: 30,
                    ),
                    onPressed: () => _startUpload,
                    color: Colors.blue,
                  ),
                ),
              )));
      // FlatButton.icon(
      //     color: Colors.blue,
      //     label: Text('Upload to Firebase'),
      //     icon: Icon(Icons.cloud_upload),
      //     onPressed: _startUpload);
    }
  }
}
