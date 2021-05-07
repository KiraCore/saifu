import 'package:flutter/material.dart';

import 'package:saifu/models/account.dart';
import 'package:saifu/screens/create_kira_account.dart';
import 'package:saifu/screens/main_interface.dart';

// ignore: must_be_immutable
class CreateAccount extends StatefulWidget {
  CreateAccount();
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => MainInterface())),
        child: Scaffold(
            resizeToAvoidBottomInset: true,
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
                          "Select a signature type to create.",
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
                                              case 'KIRA':
                                                {
                                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateKiraAccount()));
                                                }
                                                break;
                                              default:
                                                {}
                                                break;
                                            }
                                          },
                                          title: Text(AccountTypes.typesSupported[index].type),
                                          trailing: Padding(padding: const EdgeInsets.all(5.0), child: Image.network(AccountTypes.typesSupported[index].image))));
                                }))
                      ],
                    )))));
  }
}
