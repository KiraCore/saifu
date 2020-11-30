import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:sip_3_mobile/constants.dart';
import 'package:sip_3_mobile/screens/preview_qrcode_page.dart';

const flashOn = 'FLASH ON';
const flashOff = 'FLASH OFF';
const frontCamera = 'FRONT CAMERA';
const backCamera = 'BACK CAMERA';

class QrCodePage extends StatefulWidget {
  final String type;
  final String pubkey;
  final String privkey;
  const QrCodePage({Key key, this.pubkey, this.privkey, this.type}) : super(key: key);

  @override
  _QrCodePageState createState() => _QrCodePageState();
}

class _QrCodePageState extends State<QrCodePage> {
  var flashState = flashOn;
  var cameraState = frontCamera;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController controller;
  //String qrText = '';
  List<String> qrData = [
    ""
  ];

  @override
  void initState() {
    super.initState();
    qrData = [
      "HELLO",
      "HOW ARE YOU"
    ];
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrData.add(scanData);
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
                      child: Container(
                          color: greys,
                          child: Center(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: qrData.toSet().toList().length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 20.0, bottom: 20, left: 8),
                                  child: SizedBox(
                                    width: 40,
                                    child: Center(
                                      child: Container(
                                        color: Colors.grey[300],
                                        child: Center(child: Text((index + 1).toString())),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )),
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
                      onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PreviewQrCodePage(
                              type: widget.type,
                              privkey: widget.privkey,
                              pubkey: widget.pubkey,
                              qrData: qrData.toSet().toList(),
                            ),
                          )),
                      padding: EdgeInsets.all(15),
                      color: Colors.white,
                      textColor: Colors.black,
                      child: Text('Continue'),
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
