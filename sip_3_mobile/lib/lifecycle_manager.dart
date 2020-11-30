import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sip_3_mobile/main.dart';
import 'package:sip_3_mobile/screens/login_page.dart';

class LifeCycleManager extends StatefulWidget {
  final Widget child;

  const LifeCycleManager({Key key, this.child}) : super(key: key);
  @override
  _LifeCycleManagerState createState() => _LifeCycleManagerState();
}

class _LifeCycleManagerState extends State<LifeCycleManager> with WidgetsBindingObserver {
  StreamController<bool> _showLockScreenStream = StreamController();
  StreamSubscription _showLockScreenSubs;
  GlobalKey<NavigatorState> _navigatorKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _showLockScreenSubs = _showLockScreenStream.stream.listen((bool show) {
      if (mounted && show) {
        _showLockScreenDialog();
      }
    });
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
          primaryColor: Colors.white,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: Theme.of(context).textTheme.apply(
                fontFamily: 'Open Sans',
              )),
      home: SplashScreen(),
    );
  }

  void _showLockScreenDialog() {
    _navigatorKey.currentState.pushReplacement(new MaterialPageRoute(builder: (BuildContext context) {
      return LoginPage();
    }));
  }
}
