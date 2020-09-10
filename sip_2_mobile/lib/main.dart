import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:ninja/ninja.dart';
import 'package:qr_flutter/qr_flutter.dart';

// This implementation currently doesn't require any changes to be down to
// on Android SDK, only IOS (for Swift Support - Deployment target: 11)

// Require KeyPairs
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

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Set<String> barcodeData = {};
  String _encryptedData = '';

  @override
  void initState() {
    super.initState();
  }

  // This allows for continous barcode streaming, user decides when to stop scanning for this POC.
  // Possible to automate this in later alternations
  startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver("#ff6666", "Done", true, ScanMode.BARCODE).listen((barcode) {
      print(barcode);
      if (barcode != '-1') {
        barcodeData.add(barcode);
      }
    });
  }

  //  Data is retrieved from the web and signed
  signs(var data) async {
    // Data is handled as a set for uniqueness inside the data of the Qr Code
    // No Repating Barcode is scanned
    // This is now converted into an Array
    List<String> newData = data.toList();
    // Data retrieved from web is encrypted using public key, it is decoded.
    // the data is decoded after each element is joined together to form a string
    String decrypted = privateKey.decryptOaepToUtf8(newData.join());
    // Mobile signs the decryted data
    final signature = privateKey.signPssToBase64(decrypted);
    // Signed data is encrypted before being set as a QR code to the browser
    setState(() {
      _encryptedData = publicKey.encryptOaepToBase64(signature);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(title: const Text('Saifu Mobile POC')),
            body: Builder(builder: (BuildContext context) {
              return Container(
                  alignment: Alignment.center,
                  child: Flex(direction: Axis.vertical, mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                    RaisedButton(onPressed: () => startBarcodeScanStream(), child: Text("Scan QR Code")),
                    RaisedButton(onPressed: () => signs(barcodeData), child: Text("Sign the data")),
                    _encryptedData == null || _encryptedData == '' ? Container() : QrImage(data: _encryptedData, version: QrVersions.auto, size: 320, gapless: false),
                    // Renders the QRcode to be shown to the browser
                    // It is possible for a QRcode to show an empty data hence Container(), which is empty is used
                  ]));
            })));
  }
}
