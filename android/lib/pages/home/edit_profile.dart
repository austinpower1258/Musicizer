/*
UPDATED: 7/29/20
Edit User data page.
Copyright Musicizer LLC.
*/

//IMPORTS
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import '../../services/globals.dart' as globals;
import '../../services/hex_color.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../services/authentication.dart';

class EditProfile extends StatefulWidget {
  EditProfile({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;
  @override
  EditProfileState createState() => EditProfileState();
}

class EditProfileState extends State<EditProfile> {
  //SETTING DATABASE REFERENCE
  final dbRef = FirebaseDatabase.instance.reference().child('users');

  //INPUT CONTROLLERS FOR DIALOGS
  TextEditingController usernameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController cPasswordController = new TextEditingController();
  TextEditingController nPasswordController = new TextEditingController();

  //MESSAGES FOR DIALOGS
  String _errorMessage;
  String _sucessMessage;

  @override
  void initState() {
    super.initState();
    _errorMessage = "";
    _sucessMessage = "";
  }

  //USERNAME DIALOG
  _showUsernameDialog() async {
    await showDialog<String>(
      context: context,
      child: new AlertDialog(
        title: Text('Change your username'),
        contentPadding: const EdgeInsets.all(16.0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        content: new Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Row(
            children: <Widget>[
              new Expanded(
                child: new TextField(
                    autofocus: true,
                    obscureText: true,
                    decoration: new InputDecoration(
                      labelText: 'Current Password',
                    ),
                    controller: cPasswordController),
              )
            ],
          ),
          Row(
            children: <Widget>[
              new Expanded(
                child: new TextField(
                    autofocus: true,
                    obscureText: true,
                    decoration: new InputDecoration(
                        labelText: 'New Username', hintText: 'eg. johnsmith'),
                    controller: usernameController),
              )
            ],
          )
        ]),
        actions: <Widget>[
          new FlatButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              }),
          new FlatButton(
              child: const Text('Change'),
              onPressed: () {
                changeUsername(context);
              })
        ],
      ),
    );
  }

  //CHANGE USERNAME METHOD
  changeUsername(BuildContext context) async {
    try {
      await this
          .widget
          .auth
          .getCurrentUser()
          .then((user) => this.widget.auth.signIn(
                user.providerData[0].email,
                cPasswordController.text,
              ));
      dbRef
          .child(globals.userId)
          .child('username')
          .set(usernameController.text);
      Navigator.pop(context);
      _sucessMessage = "Your username is updated.";
      _showSuccessDialog();
    } catch (e) {
      _errorMessage = e.message;
      _showErrorDialog();
    }
  }

  //EMAIL DIALOG
  _showEmailDialog() async {
    await showDialog<String>(
      context: context,
      child: new AlertDialog(
        title: Text('Change your email'),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        contentPadding: const EdgeInsets.all(16.0),
        content: new Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Row(
            children: <Widget>[
              new Expanded(
                child: new TextField(
                    autofocus: true,
                    obscureText: true,
                    decoration: new InputDecoration(
                      labelText: 'Current Password',
                    ),
                    controller: cPasswordController),
              )
            ],
          ),
          Row(
            children: <Widget>[
              new Expanded(
                child: new TextField(
                    autofocus: true,
                    decoration: new InputDecoration(
                        labelText: 'New Email', hintText: 'eg. hi@example.com'),
                    controller: emailController),
              )
            ],
          )
        ]),
        actions: <Widget>[
          new FlatButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              }),
          new FlatButton(
              child: const Text('Change'),
              onPressed: () {
                changeEmail(context);
              })
        ],
      ),
    );
  }

  //CHANGE EMAIL METHOD
  changeEmail(BuildContext context) async {
    try {
      await this
          .widget
          .auth
          .getCurrentUser()
          .then((user) => this.widget.auth.signIn(
                user.providerData[0].email,
                cPasswordController.text,
              ));
      await this
          .widget
          .auth
          .getCurrentUser()
          .then((user) => user.updateEmail(emailController.text));
      Navigator.pop(context);
      _sucessMessage = "Your email is updated.";
      _showSuccessDialog();
    } catch (e) {
      print('caught');
      _errorMessage = e.message;
      _showErrorDialog();
    }
  }

  //PASSWORD DIALOG
  _showPasswordDialog() async {
    await showDialog<String>(
      context: context,
      child: new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: Text('Change your password'),
        contentPadding: const EdgeInsets.all(32.0),
        content: new Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Row(
            children: <Widget>[
              new Expanded(
                child: new TextField(
                    autofocus: true,
                    obscureText: true,
                    decoration:
                        new InputDecoration(labelText: 'Current Password'),
                    controller: cPasswordController),
              )
            ],
          ),
          Row(
            children: <Widget>[
              new Expanded(
                child: new TextField(
                    autofocus: true,
                    obscureText: true,
                    decoration: new InputDecoration(
                        labelText: 'New Password',
                        hintText: 'Choose something secure'),
                    controller: nPasswordController),
              )
            ],
          ),
        ]),
        actions: <Widget>[
          new FlatButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              }),
          new FlatButton(
              child: const Text('Change'),
              onPressed: () {
                changePassword(context);
              })
        ],
      ),
    );
  }

  //CHANGE PASSWORD METHOD
  changePassword(BuildContext context) async {
    try {
      await this
          .widget
          .auth
          .getCurrentUser()
          .then((user) => this.widget.auth.signIn(
                user.providerData[0].email,
                cPasswordController.text,
              ));
      globals.username = usernameController.text;
      dbRef.child(globals.userId).child("username").set(globals.username);
      Navigator.pop(context);
      _sucessMessage = "Your username is updated.";
      _showSuccessDialog();
    } catch (e) {
      _errorMessage = e.message;
      _showErrorDialog();
    }
  }

  //ERROR DIALOG
  _showErrorDialog() async {
    await showDialog<String>(
      context: context,
      child: new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        contentPadding: const EdgeInsets.all(16.0),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: new Text(_errorMessage),
            )
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              })
        ],
      ),
    );
  }

  //SUCCESS DIALOG
  _showSuccessDialog() async {
    await showDialog<String>(
      context: context,
      child: new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        contentPadding: const EdgeInsets.all(16.0),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: new Text(_sucessMessage),
            )
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              })
        ],
      ),
    );
  }

  Widget build(BuildContext context) {

    return new Scaffold(
        body: Stack(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height,
          color: HexColor('#5660E8'),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 250.0,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(
                  'https://image.freepik.com/free-vector/mini-people-with-bulb-light-idea_24877-56156.jpg',
                ),
                colorFilter: new ColorFilter.mode(
                    Colors.black.withOpacity(0.4), BlendMode.darken),
                fit: BoxFit.cover),
          ),
        ),
        ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                top: 100.0,
                left: 15.0,
                bottom: 15.0,
              ),
              child: Text('Edit Profile',
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  )),
            ),
            Container(
              height: MediaQuery.of(context).size.height - 250.0,
              margin: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 9.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                  ),

                  //USERNAME BUTTON
                  GestureDetector(
                      onTap: () => {_showUsernameDialog()},
                      child: Container(
                        padding: EdgeInsets.only(left: 8.0, right: 8.0),
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 15.0),
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
                            titleText: 'Change Username',
                            subtitleText: 'Make yourself presentable.',
                            icon: Icon(Icons.edit)),
                      )),

                  //PASSWORD BUTTON
                  GestureDetector(
                      onTap: () => {_showPasswordDialog()},
                      child: Container(
                        padding: EdgeInsets.only(left: 8.0, right: 8.0),
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 15.0),
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
                            titleText: 'Change Password',
                            subtitleText:
                                'Secure your account with a professional password.',
                            icon: Icon(Icons.security)),
                      )),

                  //EMAIL BUTTON
                  GestureDetector(
                      onTap: () => {_showEmailDialog()},
                      child: Container(
                        padding: EdgeInsets.only(left: 8.0, right: 8.0),
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 15.0),
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
                            titleText: 'Change Email',
                            subtitleText: 'Change your preferred email.',
                            icon: Icon(Icons.drafts)),
                      )),
                ],
              ),
            ),
          ],
        ),

        //RETURN BUTTON AND POSITIONING
        Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.bottomRight,
            child: Container(
                margin: EdgeInsets.all(10.0),
                width: 50.0,
                height: 50.0,
                child: RaisedButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    color: Colors.white,
                    child: Icon(Icons.subdirectory_arrow_left,
                        color: Colors.black),
                    onPressed: () {
                      Navigator.pop(context);
                    }))),
      ],
    ));
  }
}
