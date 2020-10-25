import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sip_3_mobile/constants.dart';
import 'package:flutter/services.dart' show rootBundle;

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
                    child: RaisedButton.icon(
                      icon: Icon(Icons.arrow_back_ios),
                      label: Text('PrivateKey'),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: privkey));
                      },
                    ),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: RaisedButton.icon(
                      icon: Icon(Icons.arrow_back_ios),
                      label: Text('publicKey'),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: pubkey));
                      },
                    ),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    child: RaisedButton.icon(
                      icon: Icon(Icons.arrow_forward_ios),
                      label: Text('Sign'),
                      onPressed: () async {
/*  
                        var newPubKey = await loadPub();
                        var newPrivKey = await loadPriv();

                        var result = await OpenPGP.sign("text", newPubKey, newPrivKey, 'Amenuel123');
                        print(result);
  
                        showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                            ),
                            isScrollControlled: true,
                            isDismissible: true,
                            context: context,
                            builder: (context) => SignedQRWidget(
                                  result: result,
                                ));

                                */
                      },
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
