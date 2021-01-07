import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../services/hex_color.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../services/globals.dart' as globals;

class SettingsPage extends StatefulWidget {
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  
  
  bool switch1 = false;
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
          // alignment: Alignment.,
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
              child: Text('Settings',
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  )),
            ),
            Container(
              height: MediaQuery.of(context).size.height - 300.0,
              margin: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: <Widget>[
                  Container(
                      // padding: EdgeInsets.all(15.0),
                      margin:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 9.0),
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
                      child: SwitchListTile(
                                  value: globals.switch1,
                                  title: AutoSizeText("Use Tempo Modification Feature", maxLines: 1),
                                  onChanged: (value) {
                                    setState(() {
                                      globals.switch1 = value;
                                    });
                                    
                                  },
                                ),),

                  Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width - 100,
                    child: Center(
                      child: AutoSizeText('Alpha: basic features, new settings coming soon...', textAlign: TextAlign.center, maxLines: 2)),
                  ),
                  // Container(
                  //     // padding: EdgeInsets.all(15.0),
                  //     margin:
                  //         EdgeInsets.symmetric(vertical: 5.0, horizontal: 9.0),
                  //     decoration: BoxDecoration(
                  //       color: Colors.white,
                  //       // color: HexColor('#E9DC25'),
                  //       borderRadius: BorderRadius.circular(5.0),
                  //       boxShadow: [
                  //         new BoxShadow(
                  //           color: Color.fromARGB(
                  //             80,
                  //             0,
                  //             0,
                  //             0,
                  //           ),
                  //           offset: new Offset(0.0, 5.0),
                  //           blurRadius: 30.0,
                  //         ),
                  //       ],
                  //     ),
                  //     child: SwitchListTile(
                  //                 value: globals.switch1,
                  //                 title: AutoSizeText("Notifications", maxLines: 1),
                  //                 onChanged: (value) {
                  //                   setState(() {
                  //                     globals.switch1 = value;
                  //                   });
                                    
                  //                 },
                  //               ),),
                  //  Container(
                  //     // padding: EdgeInsets.all(15.0),
                  //     margin:
                  //         EdgeInsets.symmetric(vertical: 5.0, horizontal: 9.0),
                  //     decoration: BoxDecoration(
                  //       color: Colors.white,
                  //       // color: HexColor('#E9DC25'),
                  //       borderRadius: BorderRadius.circular(5.0),
                  //       boxShadow: [
                  //         new BoxShadow(
                  //           color: Color.fromARGB(
                  //             80,
                  //             0,
                  //             0,
                  //             0,
                  //           ),
                  //           offset: new Offset(0.0, 5.0),
                  //           blurRadius: 30.0,
                  //         ),
                  //       ],
                  //     ),
                  //     child: SwitchListTile(
                  //                 value: globals.switch1,
                  //                 title: AutoSizeText("Allow Bug Reporting", maxLines: 1),
                  //                 onChanged: (value) {
                  //                   setState(() {
                  //                     globals.switch1 = value;
                  //                   });
                                    
                  //                 },
                  //               ),),
                ],
              ),
            ),
          ],
        ),
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
                    // child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //     children: <Widget>[
                    child: Icon(Icons.subdirectory_arrow_left,
                        color: Colors.black),
                    // AutoSizeText(
                    //   'Return',
                    //   // maxLines: 1,
                    //   // style: new TextStyle(
                    //   //     fontSize: 14.0,
                    //   //     // s
                    //   //     fontFamily: 'Raleway',
                    //   //     fontWeight: FontWeight.w500,
                    //   //     color: Colors.white)),
                    // )
                    // ]),
                    onPressed: () {
                      Navigator.pop(context);
                    }))),
      ],
    ));
  }
}
