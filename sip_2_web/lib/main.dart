import 'dart:js' as js;
import 'package:flutter/material.dart';
import 'package:ninja/ninja.dart';

import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:sip_2/helpers/dialog_helper.dart';

final privateKeyPem = '''
-----BEGIN RSA PRIVATE KEY-----
MIIBOwIBAAJBAMv7Reawnxr0DfYN3IZbb5ih/XJGeLWDv7WuhTlie//c2TDXw/mW
914VFyoBfxQxAezSj8YpuADiTwqDZl13wKMCAwEAAQJAYaTrFT8/KpvhgwOnqPlk
NmB0/psVdW6X+tSMGag3S4cFid3nLkN384N6tZ+na1VWNkLy32Ndpxo6pQq4NSAb
YQIhAPNlJsV+Snpg+JftgviV5+jOKY03bx29GsZF+umN6hD/AiEA1ouXAO2mVGRk
BuoGXe3o/d5AOXj41vTB8D6IUGu8bF0CIQC6zah7LRmGYYSKPk0l8w+hmxFDBAex
IGE7SZxwwm2iCwIhAInnDbe2CbyjDrx2/oKvopxTmDqY7HHWvzX6K8pthZ6tAiAw
w+DJoSx81QQpD8gY/BXjovadVtVROALaFFvdmN64sw==
-----END RSA PRIVATE KEY-----''';

final privateKey = RSAPrivateKey.fromPEM(privateKeyPem);
final publicKey = privateKey.toPublicKey;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

// ignore: must_be_immutable
class MyHomePage extends StatefulWidget {
  var stdTx;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  var qrText = " ";
  QRViewController controller;
  var stdMsgData;
  TextEditingController txtController = new TextEditingController();
  TextEditingController splitcontroller = new TextEditingController(text: '120');
  List<String> barcodeText;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Saifu Web Application POC',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 20,
            ),
            Wrap(direction: Axis.horizontal, spacing: 10, alignment: WrapAlignment.center, children: [
              ConstrainedBox(
                constraints: new BoxConstraints(maxHeight: 300),
                child: SizedBox(
                  width: 600,
                  child: Container(
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                        color: Colors.transparent,
                        spreadRadius: 5,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ]),
                    child: TextField(
                      controller: txtController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.purpleAccent, width: 3),
                          ),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.purple, width: 1.0)),
                          hintText: 'Enter a text message of the arbitrary length'),
                      maxLines: null,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              SizedBox(
                width: 100,
                child: Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Colors.transparent,
                      spreadRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ]),
                  child: TextField(
                    controller: splitcontroller,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.purpleAccent, width: 3),
                      ),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.purple, width: 1.0)),
                    ),
                  ),
                ),
              ),
            ]),
            SizedBox(
              height: 20,
            ),
            Wrap(
              direction: Axis.horizontal,
              spacing: 10,
              children: [
                RaisedButton(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  color: Colors.white,
                  onPressed: () => generateBarcode(data: txtController.text, splitValue: int.parse(splitcontroller.text)),
                  child: Text('Encrypt & generate data'),
                ),
                RaisedButton(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  color: Colors.white,
                  onPressed: () {
                    DialogHelper.showScanner(context, txtController.text);
                  },
                  child: Text('Scan QRCode'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  generateBarcode({String data = " ", int splitValue}) async {
    String encrypted = publicKey.encryptOaepToBase64(data);
    var barcodeText = js.context.callMethod('splitStrings', [
      encrypted,
      splitValue
    ]);
    DialogHelper.showBarcode(context, barcodeText);
  }
}
