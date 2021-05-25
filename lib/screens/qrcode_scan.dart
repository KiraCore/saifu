import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:sacco/wallet.dart';
import 'package:saifu/screens/preview_qrcode.dart';

const flashOn = 'FLASH ON';
const flashOff = 'FLASH OFF';
const frontCamera = 'FRONT CAMERA';
const backCamera = 'BACK CAMERA';

class QrCodePage extends StatefulWidget {
  final String type;
  final String pubkey;
  final String privkey;
  final String mnemonic;
  final Wallet wallet;
  const QrCodePage({Key key, this.pubkey, this.privkey, this.type, this.mnemonic, this.wallet}) : super(key: key);

  @override
  _QrCodePageState createState() => _QrCodePageState();
}

class _QrCodePageState extends State<QrCodePage> {
  var flashState = flashOn;
  var cameraState = frontCamera;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController controller;
  List<String> qrData = [];
  int max = 0;
  double percentage = 0;

  @override
  void initState() {
    super.initState();
    qrData = [];
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;

    controller.scannedDataStream.listen((scanData) {
      setState(() {
        final decoded = jsonDecode(scanData);
        int max = int.parse(decoded['max']);
        var datasize = int.parse(qrData.toSet().length.toString());
        percentage = (datasize / max) * 100;
        qrData.add(scanData);
      });
      if (percentage == 100) {
        controller.dispose();
        Navigator.pop(context);
        showModalBottomSheet(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            ),
            isScrollControlled: false,
            isDismissible: true,
            backgroundColor: Colors.transparent,
            context: context,
            builder: (context) => Container(
                color: Colors.transparent,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(20.0),
                      child: SafeArea(
                          child: Center(
                              child: PreviewQrCode(
                        type: widget.type,
                        mnemonic: widget.mnemonic,
                        privkey: widget.privkey,
                        pubkey: widget.pubkey,
                        qrData: qrData.toSet().toList(),
                      ))))
                ])));
      }
    });
  }

  bool _isFlashOn(String current) {
    return flashOn == current;
  }

  bool _isBackCamera(String current) {
    return backCamera == current;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: SafeArea(
            child: Expanded(
                flex: 5,
                child: Stack(children: [
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'Scan the QR code inside the frame',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                    overlay: QrScannerOverlayShape(
                      borderColor: Colors.red,
                    ),
                  ),
                  Positioned(
                    right: 0.0,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            if (controller != null) {
                              controller.toggleFlash();
                              if (_isFlashOn(flashState)) {
                                setState(() {
                                  flashState = flashOff;
                                });
                              } else {
                                setState(() {
                                  flashState = flashOn;
                                });
                              }
                            }
                          },
                          icon: Icon(
                            Icons.flash_on,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (controller != null) {
                              controller.flipCamera();
                              if (_isBackCamera(cameraState)) {
                                setState(() {
                                  cameraState = frontCamera;
                                });
                              } else {
                                setState(() {
                                  cameraState = backCamera;
                                });
                              }
                            }
                          },
                          icon: Icon(
                            Icons.flip_camera_ios_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                  Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Text(
                            'Scan the QR code inside the frame',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(
                            Icons.horizontal_rule_rounded,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                    Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 10,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                          Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Expanded(
                                  flex: 3,
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisAlignment: MainAxisAlignment.center, children: [
                                    Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                        child: Column(children: [
                                          CircularProgressIndicator(
                                            valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
                                          ),
                                          Text(
                                            "${percentage.toStringAsFixed(0)}" + "%",
                                            textAlign: TextAlign.center,
                                          ),
                                          Center(
                                              child: Padding(
                                                  padding: const EdgeInsets.all(20.0),
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(35),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey.withOpacity(0.3),
                                                            spreadRadius: 2,
                                                            blurRadius: 7,
                                                            offset: Offset(0, 3),
                                                          ),
                                                        ],
                                                      ),
                                                      child: IconButton(
                                                          onPressed: () => Navigator.pop(context),
                                                          icon: Icon(
                                                            Icons.close_rounded,
                                                            color: Colors.black,
                                                          )))))
                                        ]))
                                  ])))
                        ]))
                  ])
                ]))));
  }
}
