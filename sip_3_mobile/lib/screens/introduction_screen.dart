import 'package:flutter/material.dart';
import 'package:jdenticon_dart/jdenticon_dart.dart';
import 'package:sip_3_mobile/models/signature_model.dart';
import 'package:sip_3_mobile/screens/create_signature_account.dart';

// ignore: must_be_immutable
class Introduction extends StatefulWidget {
  String ethvatar = Jdenticon.toSvg('');
  Introduction({this.ethvatar});
  @override
  _IntroductionState createState() => _IntroductionState();
}

class _IntroductionState extends State<Introduction> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 50,
                ),
                /*
                SvgPicture.string(
                  'widget.ethvatar',
                  fit: BoxFit.contain,
                  height: 75,
                  width: 75,
                  alignment: Alignment.centerLeft,
                ),
                */

                Text(
                  "Saifu",
                  style: TextStyle(fontSize: 40, color: Colors.black),
                  textAlign: TextAlign.left,
                ),
                Text(
                  "Wallet.",
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.black),
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Select a signature type to start.",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: SupportedTypes.signatureTypesSupported.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            onTap: () {
                              print(SupportedTypes.signatureTypesSupported[index].type.toString());
                              switch (SupportedTypes.signatureTypesSupported[index].type.toString()) {
                                case 'PGP':
                                  {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => SignatureAccount(
                                              type: 'PGP',
                                            )));
                                  }
                                  break;
                                default:
                                  {}
                                  break;
                              }
                            },
                            title: Text(SupportedTypes.signatureTypesSupported[index].type),
                            trailing: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Image.network(SupportedTypes.signatureTypesSupported[index].image),
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
