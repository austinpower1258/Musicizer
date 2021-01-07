/*
UPDATED: 7/29/20
This is the first page that the user sees and gives an overview of Musicizer.

Copyright Musicizer LLC.
*/

import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import '../../services/authentication.dart';
import '../../services/hex_color.dart';
class OnBoardingPage extends StatefulWidget {
  OnBoardingPage({this.auth, this.pageCallback});

  final BaseAuth auth;
  final VoidCallback pageCallback;

  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    
    this.widget.pageCallback();
  }

  Widget _buildImage(String assetName) {
    return Align(
      child: Image.asset('assets/$assetName.png', width: 250.0),
      alignment: Alignment.bottomCenter,
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.all(15.0),
    );

    return IntroductionScreen(
      key: introKey,
      pages: [
       
        PageViewModel(
          title: "Exercise at your tempo.",
          body:
              "Our revolutionary tempo-modification feature helps you keep a consistent pace.",
          image: _buildImage('onboarding-1'),
           decoration: PageDecoration(titleTextStyle: TextStyle(color: HexColor('#5660E8'), fontSize: 25.0, fontWeight: FontWeight.w500),),
        ),
        PageViewModel(
          title: "Stream music.",
          body:
              "Stream all of your favorite music, ad-free. Simply search for a song.",
          image: _buildImage('onboarding-2'),
           decoration: PageDecoration(titleTextStyle: TextStyle(color: HexColor('#5660E8'), fontSize: 25.0, fontWeight: FontWeight.w500),),
        ),
        PageViewModel(
          title: "Earn TempoPoints.",
          body: "Track your musicizing progress and compete against others in the world.",
          image: _buildImage('onboarding-3'),
          
          decoration: PageDecoration(titleTextStyle: TextStyle(color: HexColor('#5660E8'), fontSize: 25.0, fontWeight: FontWeight.w500),),
        ),
        
      ],
      onDone: () => _onIntroEnd(context),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      skip: const Text('Skip'),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: DotsDecorator(
        size: Size(10.0, 10.0),
        color: Colors.grey,
        activeColor: HexColor('#5660E8'),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}