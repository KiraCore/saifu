import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jdenticon_dart/jdenticon_dart.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share/share.dart';

import 'package:sip_3_mobile/screens/qr_code_screen.dart';

class NetworkAccount extends StatelessWidget {
  final String ethvatar;
  final String pubkey;
  final String type;
  final String privkey;
  const NetworkAccount({Key key, this.ethvatar, this.pubkey, this.type, this.privkey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController txtController = new TextEditingController();
    txtController.text = pubkey;
    return Container(
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              color: Colors.transparent,
              child: ListTile(
                leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back),
                ),
                title: Text(
                  ethvatar,
                  textAlign: TextAlign.center,
                ),
                trailing: IconButton(
                  icon: Container(),
                  onPressed: null,
                ),
              )),
          ClipRRect(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                type == 'PGP'
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text((pubkey.substring(60, 65) + "..." + pubkey.substring(pubkey.length - 40, pubkey.toString().length - 35)).replaceAll("\n", "")),
                          InkWell(
                              onTap: () {
                                Clipboard.setData(ClipboardData(
                                  text: pubkey,
                                ));
                              },
                              child: Icon(Icons.content_copy)),
                        ],
                      )
                    : Container(),
                ConstrainedBox(
                  constraints: new BoxConstraints(maxHeight: 400),
                  child: Stack(
                    children: [
                      QrImage(
                          data: pubkey,
                          version: QrVersions.auto,
                          size: 300,
                          errorCorrectionLevel: QrErrorCorrectLevel.L,
                          errorStateBuilder: (cxt, err) {
                            return Container(
                              child: Center(
                                child: Text(
                                  "QR code could not be generated!",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          }),
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
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: RaisedButton(
                    onPressed: () {
                      Share.share('Sharing public key via Saifu App: $pubkey');
                    },
                    padding: EdgeInsets.all(15),
                    color: Colors.white,
                    textColor: Colors.black,
                    child: Text('Share address'),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => QrCodeScanner(
                          key: key,
                          privkey: privkey,
                          pubkey: pubkey,
                        ),
                      ));
                    },
                    padding: EdgeInsets.all(15),
                    color: Colors.white,
                    textColor: Colors.black,
                    child: Text('Sign'),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
