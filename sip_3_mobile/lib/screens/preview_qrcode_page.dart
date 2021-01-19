import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sacco/sacco.dart';
import 'package:sip_3_mobile/constants.dart';
import 'package:sip_3_mobile/screens/qrcode_page.dart';
import 'package:sip_3_mobile/widgets/signedQRCode_modal.dart';

// ignore: must_be_immutable
class PreviewQrCodePage extends StatefulWidget {
  final String type;
  final String pubkey;
  final String privkey;
  List<String> qrData = [];
  String mnemonic;

  var newQRData = '';
  PreviewQrCodePage({this.qrData, this.pubkey, this.privkey, this.type, this.mnemonic});

  @override
  _PreviewQrCodePageState createState() => _PreviewQrCodePageState();
}

class _PreviewQrCodePageState extends State<PreviewQrCodePage> {
  TextEditingController txtController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    String data = "";
    var dataset = [];
    // Decode the information
    for (var i = 0; i < widget.qrData.length; i++) {
      var base64Str = base64.decode(widget.qrData[i]);
      var bytes = utf8.decode(base64Str);
      var decodeJson = json.decode(bytes);
      dataset.add(decodeJson);
    }
    // Sort into corrrect page order
    dataset.sort((m1, m2) {
      return m1["page"].compareTo(m2["page"]);
    });

    // Iterate sorted information to collect the data to show
    for (var i = 0; i < dataset.length; i++) {
      String dataValue = dataset[i]['data'];
      data = data + dataValue;
    }
    setState(() {
      txtController.text = data;
    });
  }

  @override
  void dispose() {
    txtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [],
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(28.0),
                color: greys,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      TextField(
                        showCursor: false,
                        enableInteractiveSelection: false,
                        readOnly: true,
                        enabled: true,
                        controller: txtController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {},
                        maxLines: null,
                      ),
                    ],
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
                        var bytes = utf8.encode(txtController.text);
                        final networkInfo = NetworkInfo(
                          bech32Hrp: "kira",
                          lcdUrl: "",
                        );

                        final removedBrackets = widget.mnemonic.substring(1, widget.mnemonic.length - 1);
                        final mnemnonicParts = removedBrackets.split(', ');
                        final wallet = Wallet.derive(mnemnonicParts, networkInfo);
                        final signatureData = wallet.signTxData(bytes);
                        final pubKeyCompressed = wallet.ecPublicKey.Q.getEncoded(true);

                        final base64Signature = base64Encode(signatureData);
                        final base64PubKey = base64Encode(pubKeyCompressed);

                        String ourJsonString = '{"signatureData":"$base64Signature", "pubKeyCompressed":"$base64PubKey"}';

                        Navigator.pop(context);

                        showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                            ),
                            isScrollControlled: true,
                            isDismissible: true,
                            context: context,
                            builder: (context) => SignedQRCode([
                                  ourJsonString
                                ]));
                      },
                      padding: EdgeInsets.all(15),
                      color: Colors.white,
                      textColor: Colors.black,
                      child: Text('Confirm Sign'),
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
