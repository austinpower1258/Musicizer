import 'package:flutter/material.dart';
//import 'package:color/color.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'globals.dart' as globals;
//import 'root_page.dart';
import 'services/authentication.dart';
import 'hex_color.dart';

class LoginSignupPage extends StatefulWidget {
  LoginSignupPage({this.auth, this.loginCallback});

  final BaseAuth auth;
  final VoidCallback loginCallback;

  @override
  State<StatefulWidget> createState() => new _LoginSignupPageState();
}

class _LoginSignupPageState extends State<LoginSignupPage> {
  final _formKey = new GlobalKey<FormState>();
  final _resetFormKey = new GlobalKey<FormState>();
  final dbRef = FirebaseDatabase.instance.reference().child("users");

  String _email;
  String _password;
  String _errorMessage;
  String _successMessage;

  bool _isLoginForm;
  bool _isLoading;
  bool signedUp = false;
  String userId = "";

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
      globals.tempFill = true;
    });
    bool validateAndSave() {
      final form = _formKey.currentState;
      if (form.validate()) {
        form.save();
        return true;
      }
      return false;
    }

    if (validateAndSave()) {
      try {
        if (_isLoginForm) {
          userId = await widget.auth.signIn(_email, _password);
          globals.page = 0;
          print('Signed in: $userId');
          // Navigator.push(
          // context,
          // MaterialPageRoute(builder: (context) => RootPage())
          // );
        } else {
          userId = await widget.auth.signUp(_email, _password);

          globals.userId = userId;
          //widget.auth.sendEmailVerification();
          //_showVerifyEmailSentDialog();
          signedUp = true;

          _successMessage = "Your account has been created.";
          _showSuccessDialog();
          print('Signed up user: $userId');
          dbRef.child(userId).set({
            "musicpoints": 0,
            "username": globals.username,
            "pfpUrl":
                'https://i0.wp.com/sheenhousing.org/wp-content/uploads/2015/04/GenericProfilePhoto-Blue-Round.png?fit=1500%2C1500&ssl=1',
          });
          setState(() {
            _isLoading = false;
          });
          toggleFormMode();
        }
        if (userId.length > 0 && userId != null && _isLoginForm) {
          print('Trying login callback');
          widget.loginCallback();
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          _showErrorDialog();
          _formKey.currentState.reset();
        });
      }
    }
  }

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    _isLoginForm = true;
    super.initState();
  }

  void resetForm() {
    _formKey.currentState.reset();
    _errorMessage = "";
  }

  void toggleFormMode() {
    resetForm();
    setState(() {
      signedUp = false;
      _isLoginForm = !_isLoginForm;
    });
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: HexColor('#5660E8'),
      body: Stack(
        children: <Widget>[
          // loginText(),
          // showLogo(),
          showForm(),
        ],
      ),
    );
  }

  Widget showLogo() {
    return new Stack(
      // mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(left: 50.0),
            child: Image(
                image: NetworkImage(
                    'https://i.ibb.co/JmNn5zS/muisicizer-login-6.png'))),
        Container(
            margin: EdgeInsets.only(left: 25.0, top: 25.0),
            child: Row(
              children: <Widget>[
                Hero(
                    tag: 'hero',
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                      child: CircleAvatar(
                        backgroundColor: HexColor('#5660E8'),
                        radius: 25.0,
                        child: Image.asset('assets/musicizer.png', scale: 0.5),
                      ),
                    )),
                Text('Musicizer',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Raleway',
                        color: HexColor('#5660E8'),
                        fontSize: 20.0))
              ],
            )),
      ],
    );
  }

  Widget loginText() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        child: Text(
          _isLoginForm ? 'Login' : 'Create Account',
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 25,
            fontFamily: 'Raleway',
            fontWeight: FontWeight.w700,
            color: HexColor('#5660E8'),
          ),
        ));
  }

  Widget requestText() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(25.0, 0.0, 0.0, 15.0),
        child: Text(
          'Please login to your account.',
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Raleway',
            fontWeight: FontWeight.w300,
            color: Colors.white,
          ),
        ));
  }

  Widget showEmailInput() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: new TextFormField(
        style: TextStyle(
            color: HexColor('#5660E8'), decorationColor: Colors.white),
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            fillColor: Colors.white,
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.email, color: HexColor('#5660E8')),
            labelText: 'Email Address',
            labelStyle: new TextStyle(
                color: HexColor('#5660E8'),
                fontFamily: 'Raleway',
                fontSize: 14.0)),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  void submitResetRequest() async {
    try {
      await widget.auth.resetPassword(globals.resetEmail);
      _successMessage =
          "Instructions to reset your password have been sent to " +
              globals.resetEmail +
              ".";
      _showSuccessDialog();
      Navigator.of(context).pop();
    } catch (e) {
      _errorMessage = e.message;

      _showErrorDialog();
    }
  }

  // user defined function
  void _showDialog() {
    String resetEmail;

    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Form(
            key: _resetFormKey,
            child: AlertDialog(
              title: new Text("Send a email to reset your password"),
              content: Padding(
                padding: EdgeInsets.fromLTRB(0.0, 0, 0.0, 0.0),
                child: new TextFormField(
                  style: TextStyle(
                      color: HexColor('#5660E8'),
                      decorationColor: Colors.white),
                  maxLines: 1,
                  // obscureText: true,
                  autofocus: false,
                  decoration: new InputDecoration(
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email, color: HexColor('#5660E8')),
                      labelText: 'Email',
                      labelStyle: new TextStyle(
                          color: HexColor('#5660E8'),
                          fontFamily: 'Raleway',
                          fontSize: 14.0)),
                  validator: (value) =>
                      value.isEmpty ? 'Email can\'t be empty' : null,
                  onSaved: (value) => globals.resetEmail = value.trim(),
                ),
              ),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                new FlatButton(
                  child: new Text("Close"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                new FlatButton(
                  child: new Text("Submit"),
                  onPressed: () {
                    final form = _resetFormKey.currentState;
                    if (form.validate()) form.save();

                    print(globals.resetEmail);

                    submitResetRequest();
                    // print(email + ': email');

                    // if (_errorMessage == ""
                    // ) {
                    //   Navigator.of(context).pop();
                    //   _showSuccessDialog();
                    // }
                  },
                ),
              ],
            ));
      },
    );
  }

  // user defined function
  void _showSuccessDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Success"),
          content: new Text(_successMessage),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Error"),
          content: new Text(_errorMessage),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget showUsernameInput() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: new TextFormField(
        style: TextStyle(
            color: HexColor('#5660E8'), decorationColor: Colors.white),
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            prefixIcon: Icon(Icons.person, color: HexColor('#5660E8')),
            labelText: 'Username',
            fillColor: Colors.white,
            border: OutlineInputBorder(),
            labelStyle: new TextStyle(
                color: HexColor('#5660E8'),
                fontFamily: 'Raleway',
                fontSize: 14.0)),
        validator: (value) => value.isEmpty ? 'Username can\'t be empty' : null,
        onSaved: (value) => globals.username = value.trim(),
      ),
    );
  }

  Widget showPasswordInput() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 0, 0.0, 0.0),
      child: new TextFormField(
        style: TextStyle(
            color: HexColor('#5660E8'), decorationColor: Colors.white),
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
            fillColor: Colors.white,
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.lock, color: HexColor('#5660E8')),
            labelText: 'Password',
            labelStyle: new TextStyle(
                color: HexColor('#5660E8'),
                fontFamily: 'Raleway',
                fontSize: 14.0)),
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => _password = value.trim(),
      ),
    );
  }

  Widget showPrimaryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
        child: SizedBox(
          height: 50.0,
          width: 150.0,
          child: new RaisedButton(
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(5.0)),
              color: Colors.white,
              child: new Text(_isLoginForm ? 'Login' : 'Register',
                  style: new TextStyle(
                      fontSize: 14.0,
                      letterSpacing: 0.50,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w900,
                      color: HexColor('#5660E8'))),
              onPressed: validateAndSubmit),
        ));
  }

  Widget showSecondaryButton() {
    return new FlatButton(
        child: new Text(_isLoginForm ? 'Register Here' : 'Go To Login',
            style: new TextStyle(
                fontSize: 14.0,
                letterSpacing: 0.50,
                fontFamily: 'Raleway',
                color: HexColor('#19CFFC'),
                fontWeight: FontWeight.w900)),
        onPressed: toggleFormMode);
  }

  Widget showResetButton() {
    return new FlatButton(
        child: new Text('Forgot password?',
            style: new TextStyle(
                fontSize: 14.0,
                letterSpacing: 0.50,
                fontFamily: 'Raleway',
                color: HexColor('#19CFFC'),
                fontWeight: FontWeight.w900)),
        onPressed: _showDialog);
  }

  Widget showForm() {
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              showLogo(),
              // loginText(),
              // requestText(),
              Container(
                height: _isLoginForm ? 250.0 : 300.0,
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 25.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      loginText(),
                      if (!_isLoginForm) ...[
                        showUsernameInput(),
                      ],
                      showEmailInput(),
                      showPasswordInput(),
                    ]),
              ),
              if (_isLoginForm) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    showResetButton(),
                  ],
                )
              ],
              Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    showSecondaryButton(),
                    showPrimaryButton(),
                  ]),

              // if (signedUp) ...[

              // ],
              // showErrorMessage(),
            ],
          ),
        ));
  }

  Widget showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            fontFamily: 'Raleway',
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget showRegisteredMessage() {
    return new Text(
      'Successfully created account',
      style: TextStyle(
          fontSize: 13.0,
          color: Colors.green,
          height: 1.0,
          fontFamily: 'Raleway',
          fontWeight: FontWeight.w300),
    );
  }
}
