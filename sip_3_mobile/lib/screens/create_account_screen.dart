import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:encryptions/encryptions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jdenticon_dart/jdenticon_dart.dart';
import 'package:local_auth/local_auth.dart';
import 'package:password_hash/salt.dart';
import 'package:sip_3_mobile/screens/introduction_screen.dart';
import '../constants.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Create an account'),
        automaticallyImplyLeading: false,
        elevation: 0.0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: CreateAccountForm(),
        ),
      ),
    );
  }
}

class CreateAccountForm extends StatefulWidget {
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
  String ethvatar = Jdenticon.toSvg('');
  String _name;
  String _pin;
  String _confirmPin;

  LocalAuthentication auth = LocalAuthentication();
  bool enableBiometric = false;
  bool isSwitched = false;

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
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SvgPicture.string(
            ethvatar,
            fit: BoxFit.contain,
            height: 150,
            width: 150,
          ),
          Form(
            key: _formKeys[0],
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: <Widget>[
                TextFormField(
                  style: TextStyle(color: Colors.black),
                  autofocus: false,
                  enableInteractiveSelection: false,
                  onSaved: (String val) => setState(() => _name = val),
                  onChanged: (String name) => setState(() => ethvatar = Jdenticon.toSvg(name)),
                  validator: (value) {
                    if (value.isEmpty) return "You can't have an empty name";
                    if (value.length < 2) return "Name must have more than one character";
                    return null;
                  },
                  decoration: InputDecoration(labelText: 'Account Name', labelStyle: TextStyle(color: Colors.black), helperText: 'This has to be two characters in length.'),
                ),
              ],
            ),
          ),
          Form(
            key: _formKeys[1],
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: TextFormField(
              autofocus: false,
              enableInteractiveSelection: false,
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
              decoration: InputDecoration(labelText: 'Pin Number', labelStyle: TextStyle(color: Colors.black), helperText: 'This has to be at least 4 digits in length'),
            ),
          ),
          Form(
              key: _formKeys[2],
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: TextFormField(
                autofocus: false,
                enableInteractiveSelection: false,
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
                  if (value.length > 12) return "Pin must have a max of 12 digits";
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
                activeColor: Colors.grey),
          ),
          RaisedButton(
            textColor: Colors.black,
            padding: EdgeInsets.all(15),
            color: Colors.white,
            child: Text('Create account'),
            onPressed: () async {
              _formKeys[0].currentState.save();
              _formKeys[1].currentState.save();
              _formKeys[2].currentState.save();

              if (_formKeys[0].currentState.validate() && _formKeys[1].currentState.validate() && _formKeys[2].currentState.validate()) {
                Uint8List password = utf8.encode(_pin.toString());
                String generatedSalt = Salt.generateAsBase64String(4);
                Uint8List salt = utf8.encode(generatedSalt);
                Argon2 argon2 = Argon2(iterations: 16, hashLength: 64, memory: 256, parallelism: 2);
                Uint8List hash = await argon2.argon2id(password, salt);

                try {
                  await storage.write(key: "AccountName", value: _name);
                  await storage.write(key: "EncryptedPassword", value: hash.toString());
                  await storage.write(key: 'salt', value: generatedSalt);
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Introduction()));
                } catch (e) {
                  print('Failed with error code: ${e.code}');
                  print(e.message);
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
