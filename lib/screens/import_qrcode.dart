import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:sacco/sacco.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:sacco/wallet.dart';
import 'package:saifu/constants.dart';
import 'package:saifu/models/account.dart';
import 'package:saifu/screens/main_interface.dart';

const flashOn = 'FLASH ON';
const flashOff = 'FLASH OFF';
const frontCamera = 'FRONT CAMERA';
const backCamera = 'BACK CAMERA';

class ImportQrcodeScanner extends StatefulWidget {
  @override
  _ImportQrcodeScannerState createState() => _ImportQrcodeScannerState();
}

class _ImportQrcodeScannerState extends State<ImportQrcodeScanner> {
  var flashState = flashOn;
  var cameraState = frontCamera;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController controller;
  bool isValid = true;
  String qrData;
  final networkInfo = NetworkInfo(
    bech32Hrp: "kira",
    lcdUrl: "",
  );

  @override
  void initState() {
    super.initState();
    qrData = '';
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrData = scanData;
      });
    });
  }

  bool _isFlashOn(String current) {
    return flashOn == current;
  }

  bool _isBackCamera(String current) {
    return backCamera == current;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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
                          child: Text('Scan the QR code inside the frame',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                              )))),
                  QRView(
                      key: qrKey,
                      onQRViewCreated: _onQRViewCreated,
                      overlay: QrScannerOverlayShape(
                        borderColor: Colors.red,
                      )),
                  Positioned(
                      right: 0.0,
                      child: Row(children: [
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
                            ))
                      ])),
                  Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(children: [
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
                          )
                        ])),
                    Container(
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)), boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          )
                        ]),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                          SizedBox(height: 20),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Ensure 12 or more words that are separated by spacing"),
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: SizedBox(
                                  width: 100,
                                  child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.all(Radius.circular(20)),
                                      ),
                                      child: Center(
                                          child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Text('$qrData'),
                                      ))))),
                          isValid
                              ? Container()
                              : Center(
                                  child: Text("Invalid security words", style: TextStyle(color: Colors.red)),
                                ),
                          SizedBox(height: 20),
                          Consumer(builder: (context, watch, _) {
                            final accountState = watch(accountListProvider).state;
                            return IntrinsicHeight(
                                child: Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                                      Expanded(
                                          flex: 1,
                                          child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey.withOpacity(0.3),
                                                        spreadRadius: 2,
                                                        blurRadius: 7,
                                                        offset: Offset(0, 3),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Padding(
                                                      padding: const EdgeInsets.all(10.0),
                                                      child: TextButton(
                                                          style: ButtonStyle(
                                                            overlayColor: MaterialStateProperty.all(Colors.transparent),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.pop(context);
                                                          },
                                                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                                                            Container(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: Icon(
                                                                  Icons.arrow_back_rounded,
                                                                  color: Colors.black,
                                                                ))
                                                          ])))))),
                                      Expanded(
                                          flex: 4,
                                          child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        Color.fromRGBO(134, 53, 213, 1),
                                                        Color.fromRGBO(85, 53, 214, 1),
                                                        Color.fromRGBO(7, 200, 248, 1),
                                                      ],
                                                      begin: Alignment.centerLeft,
                                                      end: Alignment.centerRight,
                                                    ),
                                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey.withOpacity(0.3),
                                                        spreadRadius: 2,
                                                        blurRadius: 7,
                                                        offset: Offset(0, 3),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Padding(
                                                      padding: const EdgeInsets.all(10.0),
                                                      child: TextButton(
                                                          style: ButtonStyle(
                                                            overlayColor: MaterialStateProperty.all(Colors.transparent),
                                                          ),
                                                          onPressed: () async {
                                                            setState(() {
                                                              isValid = bip39.validateMnemonic(qrData);
                                                            });
                                                            if (isValid) {
                                                              final mnemonic = qrData.split(" ");
                                                              final wallet = Wallet.derive(mnemonic, networkInfo);
                                                              accountState.add(Account( type: 'KIRA', pubkey: wallet.bech32Address, privkey: wallet.privateKey.toString(), mnemonic: qrData));
                                                              try {
                                                                final String encodeData = Account.encodeAccounts(accountState);
                                                                await storage.write(key: 'database', value: encodeData);
                                                                Navigator.of(context).pushAndRemoveUntil(
                                                                    PageRouteBuilder(
                                                                      pageBuilder: (c, a1, a2) => MainInterface(),
                                                                    ),
                                                                    (route) => false);
                                                              } catch (e) {
                                                                print('Failed with error code: ${e.code}');
                                                                print(e.message);
                                                              }
                                                            } else {}
                                                          },
                                                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                                                            Text(
                                                              "Import",
                                                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                                                            )
                                                          ]))))))
                                    ])));
                          })
                        ]))
                  ])
                ]))));
  }
}
