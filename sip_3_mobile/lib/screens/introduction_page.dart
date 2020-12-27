import 'package:flutter/material.dart';

import 'package:sip_3_mobile/models/account_model.dart';
import 'package:sip_3_mobile/screens/create_account_type_page.dart';

// ignore: must_be_immutable
class IntroductionPage extends StatefulWidget {
  IntroductionPage();
  @override
  _IntroductionPageState createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  @override
  void initState() {
    super.initState();
  }

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
                      itemCount: AccountTypes.typesSupported.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            onTap: () {
                              switch (AccountTypes.typesSupported[index].type.toString()) {
                                case 'PGP':
                                  {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => CreateAccountTypeInterface(
                                              type: 'PGP',
                                            )));
                                  }
                                  break;
                                case 'KIRA':
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => CreateAccountTypeInterface(
                                            type: 'KIRA',
                                          )));
                                  break;
                                default:
                                  {}
                                  break;
                              }
                            },
                            title: Text(AccountTypes.typesSupported[index].type),
                            trailing: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Image.network(AccountTypes.typesSupported[index].image),
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
