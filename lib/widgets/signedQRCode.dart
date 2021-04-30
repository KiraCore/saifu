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

  // When the screen is loaded, it breaks the signed transcation into 100 chracters limit
  @override
  void initState() {
    // Calls the function to handle this.
    frameSignature(widget.signedData, 100);
    super.initState();
  }

  // Function that recieves the data and the limit defined
  void frameSignature(var data, var splitValue) {
    // Splits the data
    RegExp frames = new RegExp(".{1," + splitValue.toStringAsFixed(0) + "}");
    // Encodes by utf8, base64
    String str = base64.encode(utf8.encode(data));

    //  Arranges the broken down data into a list
    Iterable<Match> matches = frames.allMatches(str);
    var list = matches.map((m) => m.group(0)).toList();
    widget.frameData = [];

    // Creates the structure of Qr code frame(s) and arranges the data inside them
    for (var i = 0; i < list.length; i++) {
      var pageCount = i + 1;
      var framesData = {
        "max": "${list.length}",
        "page": pageCount,
        "data": list[i]
      };

      // Data is converted into JSON format
      var jsonFrame = jsonEncode(framesData);

      // Once data is split, broken into chuncks, added into a list and the
      //  data for the QR codes are arranged. 
      // It is grouped together for each QR frame and stored into a List. 
      // Each list has a frame (with max, page, data). For every frame there 
      // is a QR code being produced. 
      setState(() {
        widget.frameData.add(jsonFrame);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: SizedBox(height: 300, width: 300, child: SaifuFastQR(data: widget.frameData)),
    );
  }
}
