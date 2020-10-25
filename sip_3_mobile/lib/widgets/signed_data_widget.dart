import 'package:flutter/material.dart';
import 'package:qr/qr.dart';
import 'package:qr_flutter/qr_flutter.dart';

class SignedQRWidget extends StatelessWidget {
  final String result;
  SignedQRWidget({this.result});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                color: Colors.transparent,
                child: ListTile(
                  leading: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_back),
                  ),
                  title: Text(
                    'Signed QR CODE',
                    textAlign: TextAlign.center,
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.qr_code_rounded),
                    onPressed: () {},
                  ),
                )),
            ClipRRect(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
              child: Container(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: new BoxConstraints(maxHeight: 900),
                          child: Stack(
                            children: [
                              Container(
                                child: QrImage(
                                    data: result,
                                    version: QrVersions.auto,
                                    size: 400,
                                    errorCorrectionLevel: QrErrorCorrectLevel.H,
                                    errorStateBuilder: (cxt, err) {
                                      return Container(
                                        child: Center(
                                          child: Text(
                                            "QR code could not be generated",
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      );
                                    }),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          color: Colors.purple,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: RaisedButton(
                      onPressed: () {},
                      padding: EdgeInsets.all(15),
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: RaisedButton(
                      onPressed: () {},
                      padding: EdgeInsets.all(15),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
