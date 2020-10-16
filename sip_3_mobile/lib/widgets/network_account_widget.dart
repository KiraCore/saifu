import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jdenticon_dart/jdenticon_dart.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:sip_3_mobile/models/signature_model.dart';
import 'package:sip_3_mobile/screens/qr_code_screen.dart';
import 'package:qr/qr.dart';

import '../constants.dart';

class NetworkAccount extends StatelessWidget {
  final String ethvatar;
  final String pubkey;
  final String type;
  const NetworkAccount({
    Key key,
    this.ethvatar,
    this.pubkey,
    this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController txtController = new TextEditingController();
    txtController.text = pubkey;
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
                    type,
                    textAlign: TextAlign.center,
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.qr_code_rounded),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: new BoxConstraints(maxHeight: 600),
                          child: Stack(
                            children: [
                              PrettyQr(typeNumber: 7, size: 200, data: '765675765675576567', errorCorrectLevel: QrErrorCorrectLevel.H, roundEdges: true),
                              Positioned.fill(
                                child: Align(
                                    alignment: Alignment.center,
                                    child: CircleAvatar(
                                      maxRadius: 30,
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.black,
                                      child: SvgPicture.string(
                                        Jdenticon.toSvg(ethvatar),
                                        fit: BoxFit.contain,
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          'Public Address: ',
                          textAlign: TextAlign.center,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Card(
                            color: greys,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: ConstrainedBox(
                                constraints: new BoxConstraints(maxHeight: 60),
                                child: TextField(
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
                              ),
                            ),
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
