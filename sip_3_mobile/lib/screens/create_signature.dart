import 'package:flutter/material.dart';

import 'package:sip_3_mobile/models/signature_model.dart';
import 'package:sip_3_mobile/screens/create_signature_account.dart';

// ignore: must_be_immutable
class CreateSignature extends StatefulWidget {
  CreateSignature();
  @override
  _CreateSignatureState createState() => _CreateSignatureState();
}

class _CreateSignatureState extends State<CreateSignature> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
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
                "Select a signature type to create",
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
    );
  }
}
