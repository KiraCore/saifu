import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:sacco/sacco.dart';
import 'package:sacco/wallet.dart';
import 'package:sip_3_mobile/constants.dart';
import 'package:sip_3_mobile/models/account_model.dart';
import 'package:sip_3_mobile/screens/main_interface_page.dart';

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
  //String qrText = '';
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
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                flex: 5,
                child: SizedBox(
                  child: Container(
                    color: greys,
                    child: Stack(
                      children: [
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
                        )
                      ],
                    ),
                  ),
                )),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'QR Scan \n Place the QR code inside the frame.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: SizedBox(
                      height: 100,
                      width: 100,
                      child: Container(color: greys, child: Center(child: Text('$qrData'))),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Consumer(builder: (context, watch, _) {
                  final accountState = watch(accountListProvider).state;
                  return Row(
                    children: [
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
                      Expanded(
                        child: RaisedButton(
                          onPressed: () async {
                            final mnemonic = qrData.split(" ");
                            final wallet = Wallet.derive(mnemonic, networkInfo);
                            try {
                              accountState.add(Account(ethvatar: 'New Kira Account', type: 'KIRA', pubkey: wallet.bech32Address, privkey: wallet.privateKey.toString(), mnemonic: mnemonic.toString()));
                              final String encodeData = Account.encodeAccounts(accountState);
                              await storage.write(key: 'database', value: encodeData);
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MainInterface()));
                            } catch (e) {
                              print('Failed with error code: ${e.code}');
                              print(e.message);
                            }
                          },
                          padding: EdgeInsets.all(15),
                          color: Colors.white,
                          textColor: Colors.black,
                          child: Text('Continue'),
                        ),
                      ),
                    ],
                  );
                })),
          ],
        ),
      ),
    );
  }
}
