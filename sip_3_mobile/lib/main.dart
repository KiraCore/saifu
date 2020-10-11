import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future firstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _first = (prefs.getBool('first') ?? false);
    if (_first) {
      Navigator.of(context).push(new MaterialPageRoute(builder: (context) => OnBoarding()));
    } else {
      await prefs.setBool('seen', true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
