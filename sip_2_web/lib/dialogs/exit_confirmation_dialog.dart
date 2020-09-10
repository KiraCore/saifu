import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

// ignore: must_be_immutable
class BarcodeDialog extends StatelessWidget {
  var barcodeText;
  BarcodeDialog({this.barcodeText});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildChild(context),
    );
  }

  _buildChild(BuildContext context) => Container(
        height: 700,
        width: 500,
        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.rectangle, borderRadius: BorderRadius.all(Radius.circular(12))),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 100,
              width: double.infinity,
              child: Container(
                color: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Generated Barcodes',
                style: TextStyle(fontSize: 25),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 200,
              width: 300,
              child: Container(
                  child: Swiper(
                duration: 100,
                indicatorLayout: PageIndicatorLayout.DROP,
                itemCount: barcodeText.length,
                scrollDirection: Axis.horizontal,
                autoplay: true,
                loop: false,
                pagination: new SwiperPagination(),
                itemBuilder: (BuildContext context, int index) {
                  return Stack(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0.0, 1.0), //(x,y)
                                blurRadius: 6.0,
                              ),
                            ],
                          ),
                          padding: EdgeInsets.all(20),
                          child: Container(color: Colors.white, child: BarcodeWidget(data: barcodeText[index], barcode: Barcode.qrCode(errorCorrectLevel: BarcodeQRCorrectionLevel.high)))),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Text(
                          '$index',
                          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.purple),
                        ),
                      ),
                    ),
                  ]);
                },
                viewportFraction: 0.8,
                scale: 0.9,
              )),
            ),
          ],
        ),
      );
}
