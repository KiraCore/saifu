import 'dart:convert';
import 'dart:typed_data';

import 'package:encryptions/encryptions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openpgp/key_options.dart';
import 'package:openpgp/openpgp.dart';
import 'package:openpgp/options.dart';
import 'package:password_hash/salt.dart';
import 'package:sip_3_mobile/models/signature_model.dart';
import 'package:sip_3_mobile/screens/main_interface_screen.dart';

import '../constants.dart';

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
  FocusNode fname;
  FocusNode femail;
  FocusNode fpassPhrase;
  FocusNode fconfirmPassPhrase;

  String _name;
  String _email;
  String _passPhrase;
  String _confirmPassPhrase;
  @override
  void initState() {
    super.initState();
    fname = FocusNode();
    femail = FocusNode();
    fpassPhrase = FocusNode();
    fconfirmPassPhrase = FocusNode();
  }

  @override
  void dispose() {
    fname.dispose();
    femail.dispose();
    fpassPhrase.dispose();
    fconfirmPassPhrase.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
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
                            FocusScope.of(context).requestFocus(femail);
                          },
                          onSaved: (String val) => _name = val,
                          validator: (value) {
                            if (value.isEmpty) return "You can't have an empty name";
                            if (value.length < 2) return "Name must have more than one character";
                            return null;
                          },
                          decoration: InputDecoration(labelText: 'Name', labelStyle: TextStyle(color: Colors.black), helperText: 'This has to be at least two characters in length.'),
                        ),
                      ],
                    ),
                  ),
                  Form(
                    key: _formKeys[1],
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          autofocus: false,
                          focusNode: femail,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            femail.unfocus();
                            FocusScope.of(context).requestFocus(fpassPhrase);
                          },
                          onSaved: (String val) => _email = val,
                          validator: (value) {
                            var email = value;
                            bool emailValid = RegExp(r"^[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?").hasMatch(email);
                            if (!emailValid) return "Invalid email";
                            if (value.isEmpty) return "You can't have an empty email";
                            if (value.length < 2) return "Email must have more than one character";
                            return null;
                          },
                          decoration: InputDecoration(labelText: 'Email', labelStyle: TextStyle(color: Colors.black), helperText: 'Provide a valid email address'),
                        ),
                      ],
                    ),
                  ),
                  Form(
                    key: _formKeys[2],
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                            autofocus: false,
                            focusNode: fpassPhrase,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) {
                              fpassPhrase.unfocus();
                              FocusScope.of(context).requestFocus(fconfirmPassPhrase);
                            },
                            obscureText: true,
                            onSaved: (String val) => _passPhrase = val,
                            validator: (value) {
                              if (value.isEmpty) return "You can't have an empty password";
                              if (value.length < 2) return "Password must have more than one character";
                              return null;
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
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          autofocus: false,
                          focusNode: fconfirmPassPhrase,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) {
                            fconfirmPassPhrase.unfocus();
                          },
                          obscureText: true,
                          onSaved: (String val) => _confirmPassPhrase = val,
                          validator: (value) {
                            if (value.isEmpty) return "You can't have an empty assword";
                            if (value.length < 2) return "Password must have more than one character";
                            if (_passPhrase != _confirmPassPhrase) return "Passwords don't match";
                            return null;
                          },
                          decoration: InputDecoration(labelText: 'Confirm password', labelStyle: TextStyle(color: Colors.black), helperText: 'Repeat the same password again'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Expanded(
                  child: RaisedButton(
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.all(15),
                    color: Colors.white,
                    textColor: Colors.black,
                    child: Text('Cancel'),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(child: Consumer(builder: (context, watch, _) {
                  final signaturestate = watch(signatureListProvider).state;
                  return RaisedButton(
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
                        var keyPair = await OpenPGP.generate(options: Options(name: _name.trim(), email: _email.trim(), passphrase: _passPhrase.toString(), keyOptions: keyOptions));

                        Uint8List salt = utf8.encode(Salt.generateAsBase64String(4));
                        Uint8List privateKey = utf8.encode(keyPair.privateKey);
                        //TODO: //Uint8List encryptedKey = await argon2.argon2id(privateKey, salt);
                        print(keyPair.privateKey);
                        try {
                          signaturestate.add(Signature(ethvatar: _name.trim(), type: 'PGP', pubkey: keyPair.publicKey, privkey: keyPair.privateKey));
                          final String encodeData = Signature.encodeSignatures(signaturestate);
                          await storage.write(key: 'database', value: encodeData);
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MainInterface()));
                        } catch (e) {
                          print('Failed with error code: ${e.code}');
                          print(e.message);
                        }
                      }
                    },
                  );
                })),
              ]))
        ]));
  }
}
