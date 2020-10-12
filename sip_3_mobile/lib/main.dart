import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sip_3_mobile/screens/main_interface_screen.dart';
import 'screens/onboarding_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with AfterLayoutMixin<SplashScreen> {
  Future firstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _first = (prefs.getBool('first') ?? false);
    if (_first) {
      //Navigator.of(context).push(new MaterialPageRoute(builder: (context) => OnBoarding()));
    } else {
      await prefs.setBool('seen', true);
      Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context) => OnBoarding()));
    }
  }

  @override
  void afterFirstLayout(BuildContext context) => firstTime();

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
