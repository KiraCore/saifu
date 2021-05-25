import 'dart:convert';
import 'dart:typed_data';

import 'package:encryptions/encryptions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saifu/constants.dart';

class ChanagePasswordModal extends StatefulWidget {
  const ChanagePasswordModal({
    Key key,
  }) : super(key: key);

  @override
  _ChanagePasswordModalState createState() => _ChanagePasswordModalState();
}

class _ChanagePasswordModalState extends State<ChanagePasswordModal> {
  String _salt;
  String _storedPincode;
  String _currentpincode;
  String _newPincode;
  String _confirmPincode;

  FocusNode fPincode;
  FocusNode fNewPincode;
  FocusNode fConfirmPincode;

  List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  @override
  void initState() {
    super.initState();
    fPincode = FocusNode();
    fNewPincode = FocusNode();
    fConfirmPincode = FocusNode();
    retrieveInformation();
  }

  Future<void> retrieveInformation() async {
    String password = await storage.read(key: "EncryptedPassword");
    String salt = await storage.read(key: 'salt');

    setState(() {
      _storedPincode = password;
      _salt = salt;
    });
  }

  @override
  void dispose() {
    fPincode.dispose();
    fNewPincode.dispose();
    fConfirmPincode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, _) {
      return Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  'Change Password',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                ),
              ),
            ],
          ),
          Icon(Icons.horizontal_rule_rounded),
          SizedBox(
            height: 10,
          ),
          addCurrentPinCodeTextField(context),
          SizedBox(
            height: 10,
          ),
          addNewPinCodeTextField(context),
          SizedBox(
            height: 10,
          ),
          addConfirmPinCodeTextFild(),
          SizedBox(
            height: 10,
          ),
          FlatButton(
            child: Text('Confirm New Pincode'),
            onPressed: () async {
              _formKeys[0].currentState.save();
              _formKeys[1].currentState.save();
              _formKeys[2].currentState.save();

              if (_formKeys[0].currentState.validate() && _formKeys[1].currentState.validate() && _formKeys[2].currentState.validate()) {
                try {
                  Uint8List password = utf8.encode(_currentpincode);
                  Uint8List salt = utf8.encode(_salt);
                  Argon2 argon2 = Argon2(iterations: 16, hashLength: 64, memory: 256, parallelism: 2);
                  Uint8List hash = await argon2.argon2id(password, salt);
                  if (hash.toString() == _storedPincode.toString()) {
                    Uint8List password = utf8.encode(_confirmPincode.toString());
                    Uint8List hash = await argon2.argon2id(password, salt);
                    await storage.write(key: "EncryptedPassword", value: hash.toString());
                  }
                  Navigator.pop(context);
                } catch (err) {
                  print(err);
                }
              }
            },
          ),
        ]),
      );
    });
  }

  Form addConfirmPinCodeTextFild() {
    return Form(
      key: _formKeys[2],
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: <Widget>[
          TextFormField(
            focusNode: fConfirmPincode,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) {
              fConfirmPincode.unfocus();
            },
            onSaved: (String val) => _confirmPincode = val,
            obscureText: true,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            validator: (value) {
              if (value.isEmpty) return "You can't have an empty Pin";
              if (value.length < 4) return "Pin must be more than 3 digits";
              if (_newPincode != _confirmPincode) return "Pin number doesn't match";
              if (value.length > 12) return "Pin must have a max of 12 digits";
              return null;
            },
            decoration: InputDecoration(
                labelText: 'Confirm Pin Number',
                labelStyle: TextStyle(color: Colors.black),
                helperText: 'Re-enter the same pin. Pin numbers must match',
                floatingLabelBehavior: FloatingLabelBehavior.always,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  borderSide: BorderSide(color: Colors.grey, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.grey, width: 2),
                )),
          ),
        ],
      ),
    );
  }

  Form addNewPinCodeTextField(BuildContext context) {
    return Form(
      key: _formKeys[1],
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: <Widget>[
          TextFormField(
            focusNode: fNewPincode,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) {
              fNewPincode.unfocus();
              FocusScope.of(context).requestFocus(fConfirmPincode);
            },
            onSaved: (String val) => _newPincode = val,
            obscureText: true,
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
            decoration: InputDecoration(
                labelText: 'New Pincode',
                labelStyle: TextStyle(color: Colors.black),
                helperText: 'This has to be at least 4 digits in length',
                floatingLabelBehavior: FloatingLabelBehavior.always,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  borderSide: BorderSide(color: Colors.grey, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.grey, width: 2),
                )),
            //
          ),
        ],
      ),
    );
  }

  Form addCurrentPinCodeTextField(BuildContext context) {
    return Form(
      key: _formKeys[0],
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: <Widget>[
          TextFormField(
            focusNode: fPincode,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) {
              fPincode.unfocus();
              FocusScope.of(context).requestFocus(fNewPincode);
            },
            onSaved: (String val) => _currentpincode = val,
            obscureText: true,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            decoration: InputDecoration(
                labelText: 'Current Pincode',
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelStyle: TextStyle(color: Colors.black),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  borderSide: BorderSide(color: Colors.grey, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.grey, width: 2),
                )),
            //
          ),
        ],
      ),
    );
  }
}
