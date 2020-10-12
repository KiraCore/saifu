import 'dart:convert';
import 'dart:typed_data';

import 'package:encryptions/encryptions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jdenticon_dart/jdenticon_dart.dart';
import 'package:openpgp/key_options.dart';
import 'package:openpgp/openpgp.dart';
import 'package:openpgp/options.dart';
import 'package:password_hash/salt.dart';
import 'package:sip_3_mobile/screens/main_interface_screen.dart';

import '../constants.dart';

// ignore: must_be_immutable
class Introduction extends StatefulWidget {
  String ethvatar = Jdenticon.toSvg('');
  Introduction({this.ethvatar});
  @override
  _IntroductionState createState() => _IntroductionState();
}

class _IntroductionState extends State<Introduction> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 50,
                ),
                SvgPicture.string(
                  widget.ethvatar,
                  fit: BoxFit.contain,
                  height: 75,
                  width: 75,
                  alignment: Alignment.centerLeft,
                ),
                Text(
                  "Saifu",
                  style: TextStyle(fontSize: 40, color: Colors.black),
                  textAlign: TextAlign.left,
                ),
                Text(
                  "Wallet.",
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.black),
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Select a wallet type to start.",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      SupportedTokenButton(
                        token: 'OpenPGP',
                        symbol: 'Email',
                        tokenURL: 'https://webpg.org/images/mozilla-thunderbird.png',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SupportedTokenButton extends StatelessWidget {
  final token;
  final symbol;
  final tokenURL;
  const SupportedTokenButton({this.token, this.symbol, this.tokenURL});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        height: 80,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: RaisedButton(
            color: greys,
            onPressed: () {
              showModalBottomSheet(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                ),
                isScrollControlled: true,
                isDismissible: true,
                context: context,
                builder: (context) => Container(
                    color: Colors.transparent,
                    child: Padding(
                      padding: MediaQuery.of(context).viewInsets,
                      child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                        CreatePGPAccountForm()
                      ]),
                    )),
              );
            },
            child: Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            token,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                          ),
                          Text(
                            symbol,
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w300, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(
                        '$tokenURL',
                      ),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}

class CreatePGPAccountForm extends StatefulWidget {
  @override
  _CreatePGPAccountFormState createState() => _CreatePGPAccountFormState();
}

List<GlobalKey<FormState>> _formKeys = [
  GlobalKey<FormState>(),
  GlobalKey<FormState>(),
  GlobalKey<FormState>(),
  GlobalKey<FormState>()
];

class _CreatePGPAccountFormState extends State<CreatePGPAccountForm> {
  String ethvatar = Jdenticon.toSvg('');
  String _name;
  String _email;
  String _passPhrase;
  String _confirmPassPhrase;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Create a PGP Account',
            style: TextStyle(fontSize: 17),
            textAlign: TextAlign.center,
          ),
          Divider(),
          Form(
            key: _formKeys[0],
            autovalidate: false,
            child: Column(
              children: <Widget>[
                TextFormField(
                  autofocus: false,
                  enableInteractiveSelection: false,
                  onSaved: (String val) => setState(() => _name = val),
                  validator: (value) {
                    if (value.isEmpty) return "You can't have an empty name";
                    if (value.length < 2) return "Name must have more than one character";
                  },
                  decoration: InputDecoration(labelText: 'Name', labelStyle: TextStyle(color: Colors.black), helperText: 'This has to be at least two characters in length.'),
                ),
              ],
            ),
          ),
          Form(
            key: _formKeys[1],
            autovalidate: false,
            child: Column(
              children: <Widget>[
                TextFormField(
                  autofocus: false,
                  enableInteractiveSelection: false,
                  onSaved: (String val) => setState(() => _email = val),
                  validator: (value) {
                    var email = value;
                    bool emailValid = RegExp(r"^[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?").hasMatch(email);
                    if (!emailValid) return "Invalid email";
                    if (value.isEmpty) return "You can't have an empty email";
                    if (value.length < 2) return "Email must have more than one character";
                  },
                  decoration: InputDecoration(labelText: 'Email', labelStyle: TextStyle(color: Colors.black), helperText: 'Provide a valid email address'),
                ),
              ],
            ),
          ),
          Form(
            key: _formKeys[2],
            autovalidate: false,
            child: Column(
              children: <Widget>[
                TextFormField(
                    autofocus: false,
                    enableInteractiveSelection: false,
                    obscureText: true,
                    onSaved: (String val) => setState(() => _passPhrase = val),
                    validator: (value) {
                      if (value.isEmpty) return "You can't have an empty password";
                      if (value.length < 2) return "Password must have more than one character";
                    },
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.black),
                    )),
              ],
            ),
          ),
          Form(
            key: _formKeys[3],
            autovalidate: false,
            child: Column(
              children: <Widget>[
                TextFormField(
                  autofocus: false,
                  obscureText: true,
                  enableInteractiveSelection: false,
                  onSaved: (String val) => setState(() => _confirmPassPhrase = val),
                  validator: (value) {
                    if (value.isEmpty) return "You can't have an empty assword";
                    if (value.length < 2) return "Password must have more than one character";
                    if (_passPhrase != _confirmPassPhrase) return "Passwords don't match";
                  },
                  decoration: InputDecoration(labelText: 'Confirm password', labelStyle: TextStyle(color: Colors.black), helperText: 'Repeat the same password again'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.all(15),
                  color: Colors.black,
                  textColor: Colors.white,
                  child: Text('Cancel'),
                ),
                RaisedButton(
                  padding: EdgeInsets.all(15),
                  color: Colors.white,
                  child: Text('Create account'),
                  onPressed: () async {
                    _formKeys[0].currentState.save();
                    _formKeys[1].currentState.save();
                    _formKeys[2].currentState.save();
                    _formKeys[3].currentState.save();
                    Argon2 argon2 = Argon2(iterations: 16, hashLength: 64, memory: 256, parallelism: 2);
                    if (_formKeys[0].currentState.validate() && _formKeys[1].currentState.validate() && _formKeys[2].currentState.validate() && _formKeys[3].currentState.validate()) {
                      var keyOptions = KeyOptions(rsaBits: 1024);
                      var keyPair = await OpenPGP.generate(options: Options(name: _name, email: _email, passphrase: _passPhrase.toString(), keyOptions: keyOptions));
                      Uint8List salt = utf8.encode(Salt.generateAsBase64String(4));
                      Uint8List privateKey = utf8.encode(keyPair.privateKey);
                      Uint8List encryptedKey = await argon2.argon2id(privateKey, salt);
                      try {
                        await storage.write(key: "pubkey", value: keyPair.publicKey);
                        await storage.write(key: "prvkey", value: encryptedKey.toString());
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MainInterface()));
                      } catch (e) {
                        print('Failed with error code: ${e.code}');
                        print(e.message);
                      }
                    }
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
