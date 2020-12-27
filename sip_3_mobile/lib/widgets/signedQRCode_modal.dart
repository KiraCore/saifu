import 'package:flutter/material.dart';

import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:qr_flutter/qr_flutter.dart';

class SignedQRCode extends StatefulWidget {
  List<String> qrData;
  var newQRData;

  SignedQRCode(List<String> this.qrData);

  @override
  _SignedQRCodeState createState() => _SignedQRCodeState();
}

class _SignedQRCodeState extends State<SignedQRCode> {
  double rating = 50;
  var encoded;

  @override
  Widget build(BuildContext context) {
    return widget.qrData?.isEmpty || widget.qrData.contains("") ?? true
        ? Container()
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 500,
                child: Swiper(
                  duration: 100,
                  indicatorLayout: PageIndicatorLayout.DROP,
                  itemCount: widget.qrData.length,
                  scrollDirection: Axis.horizontal,
                  autoplay: true,
                  loop: false,
                  viewportFraction: 0.8,
                  scale: 0.9,
                  pagination: new RectSwiperPaginationBuilder(),
                  itemBuilder: (BuildContext context, int index) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(color: Colors.white, shape: BoxShape.rectangle, borderRadius: BorderRadius.all(Radius.circular(12)), boxShadow: [
                            BoxShadow(color: Colors.grey, offset: Offset(0.0, 1.0), blurRadius: 15.0) //(x,y)
                          ]),
                          child: QrImage(
                              data: widget.qrData[index],
                              version: QrVersions.auto,
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
                        ),
                      ],
                    );
                  },
                ),
              ),

              /*
                                                        ConstrainedBox(
                                                          constraints: new BoxConstraints(maxHeight: 400),
                                                          child: QrImage(
                                                              data: encoded,
                                                              version: QrVersions.auto,
                                                              size: 300,
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
                                                        */

              Slider(
                value: rating,
                min: 10,
                max: 1000,
                divisions: 10,
                activeColor: Colors.black,
                label: '$rating',
                onChanged: (newRating) {
                  rating = newRating;

                  var stringData = '';
                  for (int i = 0; i < widget.qrData.length; i++) {
                    stringData = stringData + widget.qrData[i].toString();
                    setState(() {
                      widget.newQRData = stringData;
                    });
                  }

                  RegExp exp = new RegExp(".{1," + rating.toStringAsFixed(0) + "}");
                  String str = widget.newQRData;
                  Iterable<Match> matches = exp.allMatches(str);
                  var list = matches.map((m) => m.group(0)).toList();
                  setState(() {
                    widget.qrData = list;
                  });
                },
              ),
            ],
          );
  }
}
