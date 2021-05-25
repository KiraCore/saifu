import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:flutter_riverpod/all.dart';
import 'package:sacco/network_info.dart';
import 'package:sacco/sacco.dart';
import 'package:saifu/constants.dart';
import 'package:saifu/models/account.dart';
import 'package:saifu/screens/main_interface.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CreateMnemonic extends StatefulWidget {
  @override
  _CreateMnemonicState createState() => _CreateMnemonicState();
}

class _CreateMnemonicState extends State<CreateMnemonic> {
  String mnemonic;
  List<String> wordList;
  @override
  void initState() {
    this.mnemonic = bip39.generateMnemonic(strength: 256);
    this.wordList = mnemonic.split(' ');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, _) {
      final accountState = watch(accountListProvider).state;
      return Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              Spacer(),
              Container(
                  padding: const EdgeInsets.only(left: 30.0, right: 30, top: 20),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text("Here is your 24 security words, that only you posses.\nStore it safely.\nKeep it private \n",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                        )),
                    Text('Should you lose your security words.\nYou will lose access your account.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: 400),
                        child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Wrap(spacing: 5, children: [
                              for (var word in wordList)
                                SizedBox(
                                    width: 125,
                                    child: Card(
                                        child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Row(children: [
                                              Text((wordList.indexOf(word) + 1).toString() + " "),
                                              Text(word, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w500)),
                                            ]))))
                            ]))),
                    SizedBox(
                      height: 10,
                    ),
                    IntrinsicHeight(
                        child: Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)), boxShadow: [
                                BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 2, blurRadius: 7, offset: Offset(0, 3))
                              ]),
                              child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: TextButton(
                                      style: ButtonStyle(
                                        overlayColor: MaterialStateProperty.all(Colors.transparent),
                                      ),
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) => new AlertDialog(
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                content: Builder(builder: (context) {
                                                  return Container(
                                                      width: 300,
                                                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                                                        QrImage(
                                                            data: wordList.toString(),
                                                            version: QrVersions.auto,
                                                            errorCorrectionLevel: QrErrorCorrectLevel.L,
                                                            errorStateBuilder: (cxt, err) {
                                                              return Container(
                                                                  child: Center(
                                                                      child: Text(
                                                                "QR code could not be generated!",
                                                                textAlign: TextAlign.center,
                                                              )));
                                                            })
                                                      ]));
                                                })));
                                      },
                                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                                        Container(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(
                                              Icons.qr_code_rounded,
                                              color: Colors.black,
                                            ))
                                      ]))))),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
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
                                      onPressed: () {},
                                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                                        Container(
                                            padding: const EdgeInsets.all(8.0),
                                            child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    mnemonic = bip39.generateMnemonic(strength: 256);
                                                    wordList = mnemonic.split(' ');
                                                  });
                                                },
                                                child: Icon(
                                                  Icons.refresh,
                                                  color: Colors.black,
                                                )))
                                      ]))))),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
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
                                      onPressed: () {},
                                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                                        Container(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(
                                              Icons.download_rounded,
                                              color: Colors.black,
                                            ))
                                      ])))))
                    ]))
                  ])),
              Spacer(),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IntrinsicHeight(
                      child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                    Expanded(
                        flex: 1,
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 7,
                                      offset: Offset(0, 3), // changes position of shadow
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
                                          Navigator.pop(context);
                                        },
                                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                                          Container(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.arrow_back_rounded,
                                                color: Colors.black,
                                              ))
                                        ])))))),
                    Expanded(
                        flex: 4,
                        child: Padding(
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
                                      color: Colors.grey.withOpacity(0.3),
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
                                          showDialog(
                                              context: context,
                                              builder: (context) => new AlertDialog(
                                                  title: Text(
                                                    "Select Token",
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                                  content: ConstrainedBox(
                                                      constraints: BoxConstraints(maxHeight: 400),
                                                      child: SingleChildScrollView(
                                                          scrollDirection: Axis.vertical,
                                                          child: Column(children: [
                                                            for (int index = 0; index < AccountTypes.typesSupported.length; index++)
                                                              Padding(
                                                                  padding: const EdgeInsets.all(8.0),
                                                                  child: Container(
                                                                      decoration: BoxDecoration(
                                                                        color: Colors.white,
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
                                                                      child: TextButton(
                                                                          onPressed: () async {
                                                                            switch (AccountTypes.typesSupported[index].type.toString()) {
                                                                              case 'KIRA':
                                                                                {
                                                                                  final networkInfo = NetworkInfo(
                                                                                    bech32Hrp: "kira",
                                                                                    lcdUrl: "",
                                                                                  );
                                                                                  final wallet = Wallet.derive(wordList, networkInfo);
                                                                                  await generateKiraAccount(accountState, wallet, context);
                                                                                }
                                                                                break;
                                                                              default:
                                                                                {}
                                                                                break;
                                                                            }
                                                                          },
                                                                          child: Row(children: [
                                                                            Image.network(
                                                                              AccountTypes.typesSupported[index].image,
                                                                              width: 50,
                                                                            ),
                                                                            Padding(
                                                                                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                                                                                child: Text(
                                                                                  AccountTypes.typesSupported[index].type.toString(),
                                                                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 15),
                                                                                ))
                                                                          ]))))
                                                          ])))));
                                        },
                                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                                          Text(
                                            "I confirm, I have made a backup",
                                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                                          )
                                        ]))))))
                  ])))
            ],
          ));
    });
  }

  Future generateKiraAccount(List<Account> accountState, Wallet wallet, BuildContext context) async {
    var mnemonic = wordList.toString();
    var mnemonicString = mnemonic.substring(1, mnemonic.length - 1);
    var newphrases = mnemonicString.replaceAll(new RegExp(r'[^\w\s]+'), '');

    try {
      accountState.add(Account(ethvatar: 'New Kira Account', type: 'KIRA', pubkey: wallet.bech32Address, privkey: wallet.privateKey.toString(), mnemonic: newphrases));
      final String encodeData = Account.encodeAccounts(accountState);
      await storage.write(key: 'database', value: encodeData);
      Navigator.of(context).pushAndRemoveUntil(
          PageRouteBuilder(
            pageBuilder: (c, a1, a2) => MainInterface(),
          ),
          (route) => false);
    } catch (e) {
      print('Failed with error code: ${e.code}');
      print(e.message);
    }
  }
}
