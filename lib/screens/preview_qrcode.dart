import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jdenticon_dart/jdenticon_dart.dart';
import 'package:sacco/sacco.dart';
import 'package:saifu/widgets/signedQRCode.dart';

// ignore: must_be_immutable
class PreviewQrCode extends StatefulWidget {
  final String type;
  final String pubkey;
  final String privkey;
  List<String> qrData = [];
  String mnemonic;

  Map<String, dynamic> jsondata;

  PreviewQrCode({this.qrData, this.pubkey, this.privkey, this.type, this.mnemonic});

  @override
  _PreviewQrCodeState createState() => _PreviewQrCodeState();
}

class _PreviewQrCodeState extends State<PreviewQrCode> {
  TextEditingController txtController = new TextEditingController();

  @override
  void initState() {
    super.initState();

    String data = "";
    var dataset = [];
    for (var i = 0; i < widget.qrData.length; i++) {
      var decodeJson = json.decode(widget.qrData[i]);
      dataset.add(decodeJson);
    }

    dataset.sort((m1, m2) {
      return m1["page"].compareTo(m2["page"]);
    });

    for (var i = 0; i < dataset.length; i++) {
      String dataValue = utf8.decode(base64.decode(dataset[i]['data']));
      data = data + dataValue;
    }
    var jsondata = jsonDecode(data);
    widget.jsondata = {
      'memo': jsondata['memo'],
      'chainID': jsondata['chain_id'],
      'type': jsondata['msgs'][0]['type'],
      'fromAddress': jsondata['msgs'][0]['value']['from_address'],
      'toAddress': jsondata['msgs'][0]['value']['to_address'],
      'from_address': jsondata['msgs'][0]['value']['from_address'],
      'amount': jsondata['msgs'][0]['value']['amount'][0]['amount'],
      'denom': jsondata['msgs'][0]['value']['amount'][0]['denom']
    };

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
                padding: const EdgeInsets.all(30.0),
                color: Colors.white,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              widget.jsondata['type'],
                              style: TextStyle(color: Colors.black, fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(2),
                            decoration: new BoxDecoration(
                              color: Colors.purple,
                              shape: BoxShape.circle,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(1000),
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: SvgPicture.string(
                                  Jdenticon.toSvg(widget.jsondata['fromAddress']),
                                  fit: BoxFit.contain,
                                  height: 70,
                                  width: 70,
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                          Text("-" + widget.jsondata['amount'] + " ${widget.jsondata['denom']}")
                        ],
                      ),
                      Container(
                          color: Colors.grey[100],
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("FROM"),
                              Text(widget.jsondata['fromAddress'])
                            ],
                          )),
                      Icon(Icons.arrow_downward),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(2),
                            decoration: new BoxDecoration(
                              color: Colors.purple,
                              shape: BoxShape.circle,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(1000),
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: SvgPicture.string(
                                  Jdenticon.toSvg(widget.jsondata['toAddress']),
                                  fit: BoxFit.contain,
                                  height: 70,
                                  width: 70,
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                          Text("+" + widget.jsondata['amount'] + " ${widget.jsondata['denom']}")
                        ],
                      ),
                      Container(
                          color: Colors.grey[100],
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("TO"),
                              Text(widget.jsondata['toAddress']),
                              Divider(),
                              Text("Memo:"),
                              Text(widget.jsondata['memo'])
                            ],
                          )),
                      TextButton(
                        onPressed: () {
                          showAlertDialog(BuildContext context) {
                            AlertDialog alert = AlertDialog(
                              content: Container(width: 500, child: Text(txtController.text)),
                            );
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(width: 400, child: alert);
                              },
                            );
                          }

                          showAlertDialog(context);
                        },
                        child: Text(
                          "See More:",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
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
                        final networkInfo = NetworkInfo(
                          bech32Hrp: "kira",
                          lcdUrl: "",
                        );
                        String newphrases = widget.mnemonic;
                        final mnemonic = newphrases.split(" ");
                        final wallet = Wallet.derive(mnemonic, networkInfo);
                        var bodyData = txtController.text;
                        var bytes = utf8.encode(bodyData);
                        final signatureData = wallet.signTxData(bytes);
                        final pubKeyCompressed = wallet.ecPublicKey.Q.getEncoded(true);

                        final base64Signature = base64Encode(signatureData);
                        final base64PubKey = base64Encode(pubKeyCompressed);
                        final stdPublicKey = StdPublicKey(type: '/cosmos.crypto.secp256k1.PubKey', value: base64PubKey);
                        Map<String, dynamic> map = {
                          'signature': base64Signature,
                          'publicKey': stdPublicKey
                        };
                        Navigator.pop(context);
                        showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                            ),
                            isScrollControlled: true,
                            isDismissible: true,
                            context: context,
                            builder: (context) => SignedQRCode(json.encode(map)));
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
