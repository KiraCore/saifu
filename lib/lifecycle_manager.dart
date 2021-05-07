import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:saifu/main.dart';
import 'package:saifu/screens/login.dart';

class MobileLifeCycle extends StatefulWidget {
  final Widget child;

  const MobileLifeCycle({Key key, this.child}) : super(key: key);
  @override
  _MobileLifeCycleState createState() => _MobileLifeCycleState();
}

class _MobileLifeCycleState extends State<MobileLifeCycle> with WidgetsBindingObserver {
  StreamController<bool> _showLockScreenStream = StreamController();
  StreamSubscription _showLockScreenSubs;
  GlobalKey<NavigatorState> _navigatorKey = GlobalKey();
  int stage;
  @override
  void initState() {
    getStage();
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _showLockScreenSubs = _showLockScreenStream.stream.listen((bool show) {
      if (mounted && show && stage != 0) {
        _showLockScreenDialog();
      }
    });
  }

  Future getStage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    stage = (prefs.getInt('stage') ?? 0);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _showLockScreenSubs?.cancel();
    super.dispose();
  }

  // Listen for when the app enter in background or foreground state.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // user returned to our app, we push an event to the stream
      _showLockScreenStream.add(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          // splashColor: Colors.purple,
          //highlightColor: Colors.purple,
          accentColor: Colors.purple,
          primaryColor: Colors.white,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: GoogleFonts.arimoTextTheme(Theme.of(context).textTheme.apply(
                fontFamily: 'Open Sans',
              ))),
      home: SplashScreen(),
    );
  }

  void _showLockScreenDialog() {
    _navigatorKey.currentState.pushReplacement(new MaterialPageRoute(builder: (BuildContext context) {
      return Login();
    }));
  }
}
