import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';
import 'package:sip_3_mobile/constants.dart';
import 'package:sip_3_mobile/screens/main_interface_screen.dart';
import 'package:sip_3_mobile/widgets/password_pad_widget.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with AfterLayoutMixin<Login> {
  @override
  void afterFirstLayout(BuildContext context) => _authenticate();
  String _pincode;
  LocalAuthentication auth = LocalAuthentication();

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticateWithBiometrics(localizedReason: 'Login with authentication', useErrorDialogs: true, stickyAuth: false);
    } on PlatformException catch (e) {
      if (e.code == auth_error.notAvailable) {
        print('Failed with error code: ${e.code}');
        print(e.message);
      }
      if (e.code == auth_error.permanentlyLockedOut) {
        print('Failed with error code: ${e.code}');
        print(e.message);
      }
    }
    if (!mounted) return;
    if (authenticated == true) {
      Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context) => MainInterface()));
    }
  }

  Future<void> getPassword() async {
    String password;
    await storage.write(key: "passwordhash", value: '1234');
    password = await storage.read(key: "passwordhash");
    setState(() {
      _pincode = password.toString();
    });
  }

  @override
  void initState() {
    super.initState();
    getPassword();
    _controller.addListener(() {
      if (_controller.text == _pincode) {
        Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context) => MainInterface()));
      }
    });
  }

  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, top: 50, bottom: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Saifu",
                style: TextStyle(fontSize: 40, color: Colors.black),
              ),
              Text(
                "Wallet.",
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Enter your max 10-digit passcode or biometric authenticate",
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.normal),
              ),
              SizedBox(
                height: 20,
              ),
              Wrap(
                direction: Axis.horizontal,
                alignment: WrapAlignment.center,
                children: [
                  SizedBox(
                    width: 200,
                    height: 50,
                    child: ClipRRect(
                      child: Container(
                        child: TextField(
                          controller: _controller,
                          textAlign: TextAlign.center,
                          obscureText: true,
                          readOnly: true,
                          keyboardType: TextInputType.number,
                          enableInteractiveSelection: false,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[500], width: 1.0)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Numpad(
                  controller: _controller,
                  buttonTextSize: 30,
                  textColor: Colors.black,
                  buttonColor: Colors.white,
                  authenticationSelected: () => _authenticate(),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
