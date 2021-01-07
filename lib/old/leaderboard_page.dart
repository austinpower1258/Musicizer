import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_image_crop/simple_image_crop.dart';
import 'hex_color.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/animation.dart';
import 'package:mccounting_text/mccounting_text.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'leaderboard.dart';

class LDPage extends StatefulWidget {
  LDPageState createState() => LDPageState();
}

class LDPageState extends State<LDPage> {
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
                  'https://image.freepik.com/free-vector/happy-character-winning-prize-with-flat-design_23-2147894434.jpg',
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
              
              child: Text('Leaderboard',
                style: TextStyle(
                  fontSize: 40.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                )),
            ),
            
            Container(
              margin: EdgeInsets.only(
                   left: 15.0, right: 15.0, bottom: 15.0),
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Leaderboard(20, showText: false),
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
