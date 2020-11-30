import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sip_3_mobile/lifecycle_manager.dart';
import 'package:sip_3_mobile/screens/login_page.dart';
import 'screens/onboarding_page.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LifeCycleManager();
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future getStage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int stage = (prefs.getInt('stage') ?? 0);
    if (stage == 0) {
      Navigator.of(context).push(new MaterialPageRoute(builder: (context) => OnBoardingPage()));
    } else if (stage == 1) {
      Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }

  @override
  void initState() {
    super.initState();
    getStage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
