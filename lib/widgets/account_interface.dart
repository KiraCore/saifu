import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saifu/screens/create_mnemonic%20.dart';
import 'package:saifu/screens/import_qrcode.dart';
import 'package:saifu/screens/input_mnemonics.dart';

// ignore: must_be_immutable
class AccountInterface extends StatefulWidget {
  AccountInterface();
  @override
  _AccountInterfaceState createState() => _AccountInterfaceState();
}

class _AccountInterfaceState extends State<AccountInterface> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.white,
            body: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
              Text(
                "SAIFU",
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.black),
                textAlign: TextAlign.left,
              ),
              Container(
                  child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    "Create or import security words to get started.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                Icon(Icons.maximize_rounded),
                Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(20.0),
                    child: SafeArea(
                        child: Center(
                            child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
                      IntrinsicWidth(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color.fromARGB(180, 220, 220, 220).withOpacity(0.1),
                              border: new Border.all(
                                color: Color.fromARGB(180, 220, 220, 220).withOpacity(0.0),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TextButton(
                                style: ButtonStyle(
                                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(CupertinoPageRoute(builder: (context) => ImportQrcodeScanner()));
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Scan existing security words",
                                      style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
                                    ),
                                    Spacer(),
                                    Icon(
                                      Icons.qr_code_scanner_rounded,
                                      color: Colors.black,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color.fromARGB(180, 220, 220, 220).withOpacity(0.1),
                              border: new Border.all(
                                color: Color.fromARGB(180, 220, 220, 220).withOpacity(0.0),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TextButton(
                                style: ButtonStyle(
                                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                                ),
                                onPressed: () {
                                  showModalBottomSheet(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                                      ),
                                      isScrollControlled: true,
                                      isDismissible: true,
                                      context: context,
                                      builder: (context) => InputMnemonic());
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Input existing security words",
                                      style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
                                    ),
                                    Spacer(),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: Colors.black,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color.fromRGBO(134, 53, 213, 1),
                                      Color.fromRGBO(85, 53, 214, 1),
                                      Color.fromRGBO(7, 200, 248, 1),
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      spreadRadius: 2,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: TextButton(
                                        style: ButtonStyle(
                                          overlayColor: MaterialStateProperty.all(Colors.transparent),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).push(CupertinoPageRoute(builder: (context) => CreateMnemonic()));
                                        },
                                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                                          Text(
                                            "Create new security words",
                                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                                          ),
                                          Spacer(),
                                          Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            color: Colors.white,
                                          )
                                        ])))))
                      ]))
                    ]))))
              ]))
            ])));
  }
}
