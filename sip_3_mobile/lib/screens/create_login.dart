import 'dart:convert';
import 'dart:typed_data';

import 'package:encryptions/encryptions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:password_hash/salt.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sip_3_mobile/constants.dart';
import 'package:sip_3_mobile/widgets/create_account.dart';
import 'package:sip_3_mobile/widgets/custom_button.dart';

class CeateLogin extends StatelessWidget {
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
  FocusNode fname;
  FocusNode fpin;
  FocusNode fconfirmPin;

  String _name;
  String _pin;
  String _confirmPin;

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

  _createAccount() async {
    _formKeys[0].currentState.save();
    _formKeys[1].currentState.save();
    _formKeys[2].currentState.save();

    if (_formKeys[0].currentState.validate() && _formKeys[1].currentState.validate() && _formKeys[2].currentState.validate()) {
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
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => CreateAccount()));
      } catch (e) {
        print('Failed with error code: ${e.code}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Form(
            key: _formKeys[0],
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: <Widget>[
                TextFormField(
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
              decoration: InputDecoration(labelText: 'Pin Number', labelStyle: TextStyle(color: Colors.black), helperText: 'This has to be at least 4 digits in length'),
            ),
          ),
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
          CustomButton(
            style: 1,
            text: "Create Account",
            onButtonClick: _createAccount,
          ),
        ],
      ),
    );
  }
}
