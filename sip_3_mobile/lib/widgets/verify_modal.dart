import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:openpgp/openpgp.dart';

class VerificationWidget extends StatefulWidget {
  @override
  _VerificationWidgetState createState() => _VerificationWidgetState();
}

class _VerificationWidgetState extends State<VerificationWidget> {
  TextEditingController originalMessageController;
  TextEditingController publicKeyController;
  TextEditingController txtController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Consumer(builder: (context, watch, _) {
      return Container(
        margin: EdgeInsets.all(10),
        padding: const EdgeInsets.all(10.0),
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: const Text(
                    'Verify Signature',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                  ),
                ),
                Spacer(),
                Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: IconButton(
                      icon: Icon(Icons.add_rounded),
                      onPressed: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext context) {
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
                                    Expanded(
                                      flex: 10,
                                      child: TextField(
                                        autofocus: true,
                                        decoration: InputDecoration(labelText: 'Enter your passphrase', labelStyle: TextStyle(color: Colors.black), helperText: 'This has to this selected account passphrase.'),
                                        obscureText: true,
                                        controller: null,
                                      ),
                                    ),
                                    RaisedButton(
                                      color: Colors.white,
                                      onPressed: () async {},
                                      child: Text('Submit'),
                                    ),
                                  ],
                                ),
                              ]),
                            );
                          },
                        );
                        /*
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext context) {
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
                                    Expanded(
                                      flex: 10,
                                      child: TextField(
                                        textInputAction: TextInputAction.next,
                                        onEditingComplete: () {},
                                        decoration: InputDecoration(
                                            hintText: 'Name',
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                              borderSide: BorderSide(color: Colors.grey, width: 1),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                              borderSide: BorderSide(color: Colors.grey, width: 2),
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 10,
                                      child: TextField(
                                        onEditingComplete: () {},
                                        textInputAction: TextInputAction.done,
                                        decoration: InputDecoration(
                                            hintText: 'Address',
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                              borderSide: BorderSide(color: Colors.grey, width: 1),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                              borderSide: BorderSide(color: Colors.grey, width: 2),
                                            )),
                                        controller: null,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                RaisedButton(
                                  color: Colors.white,
                                  onPressed: () async {},
                                  child: Text('Add'),
                                ),
                              ]),
                            );
                          },
                        );
                        */
                      },
                    )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              autofocus: true,
              textInputAction: TextInputAction.next,
              onEditingComplete: () {},
              controller: originalMessageController,
              decoration: InputDecoration(
                  labelText: 'Provide original message',
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
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              textInputAction: TextInputAction.next,
              onEditingComplete: () {},
              controller: publicKeyController,
              maxLines: 1,
              decoration: InputDecoration(
                  labelText: 'Provide the public key',
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
            ),
          ),
          RaisedButton(
            child: Text('Verify'),
            onPressed: () async {
              Codec<String, String> stringToBase64 = utf8.fuse(base64);
              String decodedSignature = stringToBase64.decode(txtController.text.toString());
              String decodedPublicKey = stringToBase64.decode(publicKeyController.text.toString());
              var resultVerification = await OpenPGP.verify(decodedSignature, originalMessageController.text, decodedPublicKey);
              print(resultVerification);
              Navigator.pop(context);
            },
          )
        ]),
      );
    }));
  }
}
