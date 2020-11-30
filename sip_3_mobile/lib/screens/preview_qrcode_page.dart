import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sip_3_mobile/constants.dart';
import 'package:openpgp/openpgp.dart';
import 'package:sip_3_mobile/widgets/signedQRCode_modal.dart';

// ignore: must_be_immutable
class PreviewQrCodePage extends StatefulWidget {
  final String type;
  final String pubkey;
  final String privkey;
  List<String> qrData = [];
  var newQRData = '';
  PreviewQrCodePage({this.qrData, this.pubkey, this.privkey, this.type});

  @override
  _PreviewQrCodePageState createState() => _PreviewQrCodePageState();
}

class _PreviewQrCodePageState extends State<PreviewQrCodePage> {
  TextEditingController txtController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    txtController.text = widget.qrData.toString();
    passwordController.text = '';
  }

  @override
  void dispose() {
    txtController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [],
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(28.0),
                color: greys,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      TextField(
                        showCursor: false,
                        enableInteractiveSelection: false,
                        readOnly: true,
                        enabled: true,
                        controller: txtController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {},
                        maxLines: null,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: RaisedButton(
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.all(15),
                      color: Colors.white,
                      child: Text('Cancel'),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: RaisedButton(
                      onPressed: () async {
                        showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(35), topRight: Radius.circular(35)),
                          ),
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
                                        obscureText: true,
                                        controller: passwordController,
                                        decoration: InputDecoration(
                                            labelText: 'Enter your passphrase',
                                            helperText: 'This has to this selected account passphrase.',
                                            labelStyle: TextStyle(color: Colors.black),
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
                                    ),
                                    RaisedButton(
                                      color: Colors.white,
                                      onPressed: () async {
                                        print(widget.type);
                                        try {
                                          switch (widget.type) {
                                            case "PGP":
                                              var result = await OpenPGP.sign(txtController.text, widget.pubkey, widget.privkey, passwordController.text);
                                              Codec<String, String> stringToBase64 = utf8.fuse(base64);
                                              String encoded = stringToBase64.encode(result);

                                              List<String> data = [
                                                encoded
                                              ];
                                              Navigator.pop(context);
                                              showModalBottomSheet(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                                                  ),
                                                  isScrollControlled: true,
                                                  isDismissible: true,
                                                  context: context,
                                                  builder: (context) => SignedQRCode(data));
                                              break;
                                            default:
                                              showModalBottomSheet(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                                                  ),
                                                  isScrollControlled: true,
                                                  isDismissible: true,
                                                  context: context,
                                                  builder: (context) => SignedQRCode(widget.qrData));
                                          }
                                          passwordController.text = '';

/*
                                          showModalBottomSheet(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                                              ),
                                              isScrollControlled: true,
                                              isDismissible: true,
                                              context: context,
                                              builder: (context) => SignedQRCode(widget.qrData));
                                              */
                                        } on PlatformException catch (err) {
                                          print(err);
                                          //TODO Handle err
                                        } catch (err) {
                                          //TODO other types of Exceptions
                                        }
                                      },
                                      child: Text('Submit'),
                                    ),
                                  ],
                                ),
                              ]),
                            );
                          },
                        );
                      },
                      padding: EdgeInsets.all(15),
                      color: Colors.white,
                      textColor: Colors.black,
                      child: Text('Confirm Sign'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
