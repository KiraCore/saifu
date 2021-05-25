import 'dart:convert';
import 'dart:typed_data';

import 'package:encryptions/encryptions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';
import 'package:saifu/constants.dart';
import 'package:saifu/screens/main_interface.dart';
import 'package:saifu/widgets/password_keyboard.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _pincode;
  String _salt;
  bool _enabledBiometric = false;
  LocalAuthentication auth = LocalAuthentication();

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticateWithBiometrics(localizedReason: 'LoginPage with authentication', useErrorDialogs: true, stickyAuth: false);
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

  Future<void> _retrieveInformation() async {
    String enabledBiometric = await storage.read(key: 'enabledBiometric');
    String password = await storage.read(key: "EncryptedPassword");
    String salt = await storage.read(key: 'salt');
    setState(() {
      _pincode = password;
      _salt = salt;
      _enabledBiometric = enabledBiometric == 'true';
      if (_enabledBiometric == true) _authenticate();
    });
  }

  @override
  void initState() {
    super.initState();
    _retrieveInformation();
    _controller.addListener(() async {
      Uint8List password = utf8.encode(_controller.text);
      Uint8List salt = utf8.encode(_salt);
      Argon2 argon2 = Argon2(iterations: 16, hashLength: 64, memory: 256, parallelism: 2);
      Uint8List hash = await argon2.argon2id(password, salt);
      if (hash.toString() == _pincode.toString()) {
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
                padding: const EdgeInsets.only(top: 0),
                child: Container(
                    child: Column(children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "saifu",
                            style: TextStyle(fontSize: 50, color: Colors.black),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Icon(Icons.maximize_rounded),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 3,
                      child: ClipRRect(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                          child: Container(
                              color: Colors.grey[100],
                              child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
                                Container(
                                  child: Column(
                                    children: [
                                      Text(
                                        "Enter your pincode or biometric to gain access",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(fontSize: 16, color: Colors.black),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        color: Colors.white,
                                        child: Wrap(
                                          direction: Axis.horizontal,
                                          children: [
                                            SizedBox(
                                              width: 300,
                                              height: 50,
                                              child: ClipRRect(
                                                child: Container(
                                                  color: Colors.white,
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
                                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 1.0)),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.all(35.0),
                                    child: Align(
                                        child: AspectRatio(
                                            aspectRatio: 1 / 1,
                                            child: Container(
                                                child: Numpad(
                                              enabledBiometric: _enabledBiometric,
                                              controller: _controller,
                                              buttonTextSize: 30,
                                              textColor: Colors.black,
                                              buttonColor: Colors.white,
                                              authenticationSelected: () => _authenticate(),
                                            )))))
                              ]))))
                ])))));
  }
}
