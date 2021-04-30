import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:sacco/wallet.dart';
import 'package:sip_3_mobile/constants.dart';
import 'package:sip_3_mobile/screens/preview_qrcode.dart';
import 'package:sip_3_mobile/widgets/custom_button.dart';

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
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PreviewQrCode(
                type: widget.type,
                mnemonic: widget.mnemonic,
                privkey: widget.privkey,
                pubkey: widget.pubkey,
                qrData: qrData.toSet().toList(),
              ),
            ));
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
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                flex: 5,
                child: SizedBox(
                  child: Container(
                    color: Colors.grey[100],
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
                      'Place the QR code inside the frame.\n If QR frame has been adjusted, restart this screen',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        CircularProgressIndicator(),
                        Text(
                          "${percentage.toStringAsFixed(0)}" + "%",
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: "Cancel",
                      style: 4,
                      onButtonClick: () => Navigator.pop(context),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: CustomButton(
                    text: "Continue",
                    style: 1,
                    onButtonClick: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PreviewQrCode(
                            type: widget.type,
                            mnemonic: widget.mnemonic,
                            privkey: widget.privkey,
                            pubkey: widget.pubkey,
                            qrData: qrData.toSet().toList(),
                          ),
                        )),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
