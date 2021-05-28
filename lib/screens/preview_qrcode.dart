import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jdenticon_dart/jdenticon_dart.dart';
import 'package:sacco/sacco.dart';
import 'package:saifu/tx_offline_signer_mobile.dart';
import 'package:saifu/widgets/signedQRCode.dart';

// ignore: must_be_immutable
class PreviewQrCode extends StatefulWidget {
  final String type;
  final String pubkey;
  final String privkey;
  List<String> qrData = [];
  String mnemonic;

  PreviewQrCode({this.type, this.pubkey, this.privkey, this.qrData, this.mnemonic});
  Map<String, dynamic> jsondata;

  @override
  _PreviewQrCodeState createState() => _PreviewQrCodeState();
}

class _PreviewQrCodeState extends State<PreviewQrCode> {
  String transcationData;
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
      'gas': jsondata['fee']['gas'],
      'denom': jsondata['msgs'][0]['value']['amount'][0]['denom']
    };

    setState(() {
      transcationData = data;
    });
  }

  @override
  void dispose() {
    txtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Signature Request",
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
          ],
        ),
      ),
      Icon(Icons.horizontal_rule),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Account",
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.end,
                ),
                Text(
                  widget.jsondata["fromAddress"],
                  textAlign: TextAlign.end,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(35),
                  child: Container(
                    color: Colors.grey[100],
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "CHAIN-ID 1",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(2),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(1000),
            child: CircleAvatar(
              radius: 35,
              backgroundColor: Colors.white,
              child: SvgPicture.string(
                Jdenticon.toSvg(widget.jsondata["fromAddress"]),
                fit: BoxFit.contain,
                height: 70,
                width: 70,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Icon(Icons.arrow_forward_ios_rounded),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(2),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(1000),
            child: CircleAvatar(
              radius: 35,
              backgroundColor: Colors.white,
              child: SvgPicture.string(
                Jdenticon.toSvg(widget.jsondata["toAddress"]),
                fit: BoxFit.contain,
                height: 70,
                width: 70,
              ),
            ),
          ),
        ),
        Flexible(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    widget.jsondata["toAddress"],
                    textAlign: TextAlign.start,
                  ),
                  ClipRRect(
                      borderRadius: BorderRadius.circular(35),
                      child: Container(
                          color: Colors.grey[100],
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "CHAIN-ID 2",
                                textAlign: TextAlign.center,
                              ))))
                ])))
      ]),
      SizedBox(
        height: 10,
      ),
      IntrinsicWidth(
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(180, 220, 220, 220).withOpacity(0.1),
                  border: new Border.all(
                    color: Color.fromARGB(180, 220, 220, 220).withOpacity(0.0),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                ),
                child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextButton(
                        style: ButtonStyle(
                          overlayColor: MaterialStateProperty.all(Colors.transparent),
                        ),
                        onPressed: () {},
                        child: Column(children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Amount:",
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                ),
                                Spacer(),
                                Text(
                                  widget.jsondata["amount"] + " " + widget.jsondata["denom"],
                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(mainAxisSize: MainAxisSize.min, children: [
                                Text(
                                  "Gas",
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                ),
                                Spacer(),
                                Text(
                                  widget.jsondata["gas"],
                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
                                )
                              ])),
                          Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                children: [
                                  Text(
                                    "Memo:",
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Flexible(child: ConstrainedBox(constraints: BoxConstraints(maxHeight: 50), child: SingleChildScrollView(scrollDirection: Axis.vertical, child: Text(widget.jsondata["memo"], style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal)))))
                                ],
                              ))
                        ]))))),
        TextButton(
            onPressed: () {
              showAlertDialog(BuildContext context) {
                AlertDialog alert = AlertDialog(
                  content: Container(width: 500, child: Text(transcationData)),
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
            child: Text("See More:",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                ))),
        IntrinsicHeight(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(children: [
                  Expanded(
                      child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                          ),
                          child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TextButton(
                                  style: ButtonStyle(
                                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                                    Text(
                                      "Reject",
                                      style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.normal),
                                    )
                                  ]))))),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
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
                                color: Colors.grey.withOpacity(0.1),
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
                                    var map = TranscationofflineSignerMobile.signMobileTxData(widget.mnemonic, transcationData, "kira");
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
                                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                                    Text(
                                      "Approve signature",
                                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                                    )
                                  ])))))
                ])))
      ]))
    ]);
  }
}
