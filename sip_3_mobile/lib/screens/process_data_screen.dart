import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sip_3_mobile/constants.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:qr_flutter/qr_flutter.dart';

import 'package:openpgp/openpgp.dart';

// ignore: must_be_immutable
class ProcessData extends StatelessWidget {
  final String pubkey;
  final String privkey;
  List<String> qrData = [];
  ProcessData({this.qrData, this.pubkey, this.privkey});

  Future<String> loadPub() async {
    return await rootBundle.loadString('assets/pubkey.txt');
  }

  Future<String> loadPriv() async {
    return await rootBundle.loadString('assets/privatekey.txt');
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController txtController = new TextEditingController();
    txtController.text = qrData.toString();
    TextEditingController passwordController = new TextEditingController();
    passwordController.text = '';
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  child: Container(
                    color: greys,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            TextField(
                              readOnly: true,
                              showCursor: false,
                              enableInteractiveSelection: false,
                              enabled: true,
                              controller: txtController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                              maxLines: null,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
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
                      child: Text('Cancel'),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: RaisedButton(
                      onPressed: () async {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext context) {
                            return Padding(
                              padding: EdgeInsets.only(
                                left: 20,
                                right: 20,
                                top: 20,
                                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                              ),
                              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 10,
                                      child: TextField(
                                        autofocus: true,
                                        decoration: InputDecoration(labelText: 'Enter your passphrase', labelStyle: TextStyle(color: Colors.black), helperText: 'This has to this selected account passphrase.'),
                                        obscureText: true,
                                        controller: passwordController,
                                      ),
                                    ),
                                    RaisedButton(
                                      color: Colors.white,
                                      onPressed: () async {
                                        try {
                                          var result = await OpenPGP.sign("text", pubkey, privkey, "123");
                                          print(result);
                                          Navigator.pop(context);

                                          showModalBottomSheet(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                                              ),
                                              isScrollControlled: true,
                                              isDismissible: true,
                                              context: context,
                                              builder: (context) => Padding(
                                                    padding: const EdgeInsets.all(20.0),
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        ConstrainedBox(
                                                          constraints: new BoxConstraints(maxHeight: 300),
                                                          child: QrImage(
                                                              data: result,
                                                              version: QrVersions.auto,
                                                              size: 200,
                                                              errorCorrectionLevel: QrErrorCorrectLevel.L,
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
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 20),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                              children: [
                                                                Expanded(
                                                                  flex: 10,
                                                                  child: Card(
                                                                    color: greys,
                                                                    child: Container(child: ConstrainedBox(constraints: new BoxConstraints(maxHeight: 100), child: SingleChildScrollView(child: Text("$result + $result")))),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex: 1,
                                                                  child: IconButton(
                                                                      icon: Icon(Icons.content_copy),
                                                                      onPressed: () {
                                                                        Clipboard.setData(ClipboardData(
                                                                          text: result,
                                                                        ));
                                                                      }),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ));
                                        } on PlatformException catch (err) {
                                          print(err);
                                          //TODO Handle err
                                        } catch (err) {
                                          //TODO other types of Exceptions
                                        }
                                      },
                                      child: Text('Submit'),
                                    ),
                                  ],
                                ),
                              ]),
                            );
                          },
                        );
                      },
                      padding: EdgeInsets.all(15),
                      color: Colors.white,
                      textColor: Colors.black,
                      child: Text('Sign'),
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
