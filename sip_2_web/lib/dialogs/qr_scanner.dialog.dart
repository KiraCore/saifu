import 'package:flutter/material.dart';
import 'package:ninja/ninja.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:sip_2/src/qr_code_scanner_web.dart';

// Custom dialog to handle QR Scanner, this retrieves and verifies a QRcode

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

Set<String> dataString = {};

// ignore: must_be_immutable
class QRScannerDialog extends StatefulWidget {
  var data;
  QRScannerDialog({this.data});
  @override
  _QRScannerDialogState createState() => _QRScannerDialogState();
}

class _QRScannerDialogState extends State<QRScannerDialog> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  var qrText = "";
  QRViewController controller;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
          color: Colors.white,
          height: 700,
          width: 500,
          child: Page(
            data: widget.data,
          )),
    );
  }
}

// ignore: must_be_immutable
class Page extends StatefulWidget {
  var data;
  Page({Key key, this.data}) : super(key: key);

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<Page> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Saifu Scanner',
            style: TextStyle(fontSize: 20),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 300,
            width: 400,
            child: QrCodeCameraWeb(
              qrCodeCallback: (qr) {
                setState(() {
                  dataString.add('$qr');
                });
                print(dataString);
                verifySignature(dataString, widget.data);
              },
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: Container(
            color: Colors.white,
            child: Text(dataString.join()),
          ),
        )
      ],
    );
  }

  verifySignature(var barcodedata, data) async {
    // Data is handled as a set for uniqueness inside the data of the Qr Code
    // No Repating Barcode is scanned
    // This is now converted into an Array
    List<String> newData = barcodedata.toList();
    // Data retrieved is retireved mobile is decrypted after each element is joined together to form a string
    String decrypted = privateKey.decryptOaepToUtf8(newData.join());
    // Verify the signature using encrypted data and the actual data (this is passed from the main page)

    print(publicKey.verifySsaPss(decrypted, data));
  }
}
