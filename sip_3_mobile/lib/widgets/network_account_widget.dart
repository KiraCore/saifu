import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:sip_3_mobile/screens/qr_code_screen.dart';
import 'package:qr/qr.dart';

import '../constants.dart';

class NetworkAccount extends StatelessWidget {
  const NetworkAccount({
    Key key,
  }) : super(key: key);

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
                    'wallet_name',
                    textAlign: TextAlign.center,
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.qr_code_rounded),
                    onPressed: () {
                      Navigator.of(context).push(CupertinoPageRoute(
                        builder: (context) => QrCodeScanner(),
                      ));
                    },
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
                    SizedBox(
                      height: 50,
                      width: 50,
                    ),
                    Center(
                      child: SizedBox(
                          child: PrettyQr(
                        typeNumber: 3,
                        size: 200,
                        data: 'testData',
                        errorCorrectLevel: QrErrorCorrectLevel.M,
                        roundEdges: true,
                      )),
                    ),
                    SizedBox(
                      height: 50,
                      width: 25,
                    ),
                    Column(
                      children: [
                        Text(
                          'Public Address: ',
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Card(
                          color: greys,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('_address'),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
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
                      color: Colors.black,
                      textColor: Colors.white,
                      child: Text('Copy address'),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: RaisedButton(
                      onPressed: () {},
                      padding: EdgeInsets.all(15),
                      color: Colors.black,
                      textColor: Colors.white,
                      child: Text('Share Address'),
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
