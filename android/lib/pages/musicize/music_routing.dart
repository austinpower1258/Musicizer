import 'package:flutter/cupertino.dart';
import 'musicizing.dart';
import '../musicize/time_level.dart';
import 'searchcards.dart';
import '../../services/globals.dart' as globals; //GLOBALS
import 'finishscreen.dart';
class Running extends StatefulWidget {
  Function callback;

  Running(this.callback);

  @override
  _RunningState createState() => _RunningState();
}

class _RunningState extends State<Running> {
  final _formKey = GlobalKey<FormState>();
  int runningPage = 0;
  List<Widget> _runchildren;

  @override
  void initState() {
    super.initState();
    _runchildren = [
      TimeLevel(this.callback),
      SearchCards(this.callback),
      MusicizingWidget(this.callback),
      FinishScreen(this.callback),
    ];
  }

  void callback(runningPage) {
    setState(() {
      globals.runningPage = runningPage;
      this.widget.callback(runningPage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _runchildren[globals.runningPage];
  }
}


