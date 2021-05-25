import 'dart:convert';
import 'dart:typed_data';

import 'package:encryptions/encryptions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:password_hash/salt.dart';
import 'package:saifu/widgets/account_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:saifu/constants.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

// Screen for creating an User Account

class CeateLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Create your account",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Icon(Icons.maximize_rounded),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: Offset(0, 3), 
                ),
              ],
            ),
            padding: const EdgeInsets.only(top: 50.0, left: 50, right: 50, bottom: 10),
            child: CreateAccountForm(),
          ),
        ],
      ),
    );
  }
}

class CreateAccountForm extends StatefulWidget {
  bool loading = false;
  @override
  _CreateAccountFormState createState() => _CreateAccountFormState();
}

List<GlobalKey<FormState>> _formKeys = [
  GlobalKey<FormState>(),
  GlobalKey<FormState>(),
  GlobalKey<FormState>(),
  GlobalKey<FormState>()
];

class _CreateAccountFormState extends State<CreateAccountForm> {
  FocusNode fname, fpin, fconfirmPin;
  String _name, _pin, _confirmPin;
  LocalAuthentication auth = LocalAuthentication();
  bool enabledBiometric = false;
  bool isSwitched = false;

  @override
  void initState() {
    super.initState();
    fname = FocusNode();
    fpin = FocusNode();
    fconfirmPin = FocusNode();
  }

  @override
  void dispose() {
    fname.dispose();
    fpin.dispose();
    fconfirmPin.dispose();
    super.dispose();
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticateWithBiometrics(localizedReason: 'Enable biometric authentication', useErrorDialogs: true, stickyAuth: false);
    } on PlatformException catch (e) {
      print('Failed with error code: ${e.code}');
      print(e.message);
    }
    if (!mounted) return;
    setState(() {
      authenticated ? isSwitched = true : isSwitched = false;
      enabledBiometric = true;
    });
  }

  Future<void> _stopAuthentication() async {
    bool stopAuthentication = false;
    try {
      stopAuthentication = await auth.stopAuthentication();
    } on PlatformException catch (e) {
      print('Failed with error code: ${e.code}');
      print(e.message);
    }
    if (!mounted) return;
    setState(() {
      stopAuthentication ? isSwitched = false : isSwitched = true;
      isSwitched = false;
      enabledBiometric = false;
    });
  }

  _createUser() async {
    Uint8List password = utf8.encode(_pin.toString());
    String generatedSalt = Salt.generateAsBase64String(10);
    Uint8List salt = utf8.encode(generatedSalt);
    Argon2 argon2 = Argon2(iterations: 16, hashLength: 64, memory: 256, parallelism: 2);
    Uint8List hash = await argon2.argon2id(password, salt);
    try {
      await storage.write(key: "AccountName", value: _name.trim());
      await storage.write(key: "EncryptedPassword", value: hash.toString());
      await storage.write(key: 'salt', value: generatedSalt);
      await storage.write(key: 'enabledBiometric', value: enabledBiometric.toString());
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('stage', 1);
      Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context) => AccountInterface()));
    } catch (e) {
      print('Failed with error code: ${e.code}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
        Form(
            key: _formKeys[0],
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: TextFormField(
                autofocus: true,
                focusNode: fname,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  fname.unfocus();
                  FocusScope.of(context).requestFocus(fpin);
                },
                style: TextStyle(color: Colors.black),
                onSaved: (String val) => setState(() => _name = val),
                validator: (value) {
                  if (value.isEmpty) return "You can't have an empty name";
                  if (value.length < 2) return "Name must have more than one character";
                  return null;
                },
                inputFormatters: [],
                decoration: InputDecoration(labelText: 'Account Name', labelStyle: TextStyle(color: Colors.black), helperText: 'This has to be two characters in length.'))),
        Form(
            key: _formKeys[1],
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: TextFormField(
                autofocus: false,
                focusNode: fpin,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  fpin.unfocus();
                  FocusScope.of(context).requestFocus(fconfirmPin);
                },
                obscureText: true,
                onSaved: (String val) => setState(() => _pin = val),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                validator: (value) {
                  if (value.isEmpty) return "You can't have an empty Pin";
                  if (value.length < 4) return "Pin must be more than 3 digits";
                  if (value.length > 10) return "Pin must have a max of 10 digits";
                  return null;
                },
                decoration: InputDecoration(labelText: 'Pin Number', labelStyle: TextStyle(color: Colors.black), helperText: 'This has to be at least 4 digits in length'))),
        Form(
            key: _formKeys[2],
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: TextFormField(
              autofocus: false,
              focusNode: fconfirmPin,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) {
                fconfirmPin.unfocus();
              },
              obscureText: true,
              onSaved: (String val) => setState(() => _confirmPin = val),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              validator: (value) {
                if (value.isEmpty) return "You can't have an empty Pin";
                if (value.length < 4) return "Pin must be more than 3 digits";
                if (_pin != _confirmPin) return "Pin number doesn't match";
                if (value.length > 10) return "Pin must have a max of 10 digits";
                return null;
              },
              decoration: InputDecoration(labelText: 'Confirm Pin Number', labelStyle: TextStyle(color: Colors.black), helperText: 'Re-enter the same pin. Pin numbers must match'),
            )),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Text('Enable Biometric Authentication'),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            child: Switch(
                value: isSwitched,
                onChanged: (value) {
                  if (!mounted) return;
                  setState(() {
                    if (isSwitched == false) {
                      _authenticate();
                    } else {
                      _stopAuthentication();
                    }
                  });
                },
                activeColor: Colors.black),
          ),
        ),
        widget.loading
            ? Container(
                padding: EdgeInsets.all(10),
                child: SpinKitRing(
                  color: Colors.black,
                  // size: loaderWidth ,
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        //ADD If you need more
                        Color.fromRGBO(134, 53, 213, 1),
                        Color.fromRGBO(85, 53, 214, 1),
                        Color.fromRGBO(7, 200, 248, 1),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextButton(
                      style: ButtonStyle(
                        overlayColor: MaterialStateProperty.all(Colors.transparent),
                      ),
                      onPressed: () {
                        setState(() {
                          try {
                            widget.loading = true;
                            _formKeys[0].currentState.save();
                            _formKeys[1].currentState.save();
                            _formKeys[2].currentState.save();
                            if (_formKeys[0].currentState.validate() && _formKeys[1].currentState.validate() && _formKeys[2].currentState.validate()) {
                              FocusScope.of(context).unfocus();
                              _createUser();
                            } else {
                              widget.loading = false;
                            }
                          } catch (e) {}
                        });
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Create account",
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ]),
    );
  }
}
