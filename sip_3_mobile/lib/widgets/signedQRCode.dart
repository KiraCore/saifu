import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:saifu_fast_qr/saifu_fast_qr.dart';

// ignore: must_be_immutable
class SignedQRCode extends StatefulWidget {
  var signedData;
  var frameData = [];
  SignedQRCode(this.signedData);

  @override
  _SignedQRCodeState createState() => _SignedQRCodeState();
}

class _SignedQRCodeState extends State<SignedQRCode> {
  void frameSignature(var data, var splitValue) {
    RegExp frames = new RegExp(".{1," + splitValue.toStringAsFixed(0) + "}");
    String str = base64.encode(utf8.encode(data));
    Iterable<Match> matches = frames.allMatches(str);
    var list = matches.map((m) => m.group(0)).toList();
    widget.frameData = [];
    for (var i = 0; i < list.length; i++) {
      var pageCount = i + 1;
      var framesData = {
        "max": "${list.length}",
        "page": pageCount,
        "data": list[i]
      };
      var jsonFrame = jsonEncode(framesData);
      setState(() {
        widget.frameData.add(jsonFrame);
      });
    }
  }

  @override
  void initState() {
    frameSignature(widget.signedData, 100);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: SizedBox(height: 300, width: 300, child: SaifuFastQR(data: widget.frameData)),
    );
  }
}
