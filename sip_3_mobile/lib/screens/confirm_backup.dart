import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sacco/sacco.dart';
import 'package:sip_3_mobile/constants.dart';
import 'package:sip_3_mobile/models/account.dart';
import 'package:sip_3_mobile/screens/main_interface.dart';
import 'package:sip_3_mobile/widgets/custom_button.dart';

// ignore: must_be_immutable
class ConfirmBackup extends StatefulWidget {
  List<String> wordList;
  List<String> confirmList;
  List<String> matchList = [];
  ConfirmBackup(this.wordList);

  @override
  _ConfirmBackupState createState() => _ConfirmBackupState();
}

class _ConfirmBackupState extends State<ConfirmBackup> {
  TextEditingController txtController = new TextEditingController();
  final networkInfo = NetworkInfo(
    bech32Hrp: "kira",
    lcdUrl: "",
  );

  @override
  void initState() {
    widget.confirmList = List.from(widget.wordList);
    widget.confirmList.shuffle();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final wallet = Wallet.derive(widget.wordList, networkInfo);
    return Consumer(builder: (context, watch, _) {
      // ignore: invalid_use_of_protected_member
      final accountState = watch(accountListProvider).state;
      return Scaffold(
        appBar: AppBar(
          title: Text('Confirm your seed'),
          elevation: 0.0,
          centerTitle: true,
          actions: [
            CustomButton(
              style: 5,
              text: "Skip",
              onButtonClick: () async {
                await generateKiraAccount(accountState, wallet, context);
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Text('Please enter your seed phrases in the correct order'),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                readOnly: true,
                enableInteractiveSelection: false,
                controller: txtController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple, width: 3.0),
                  ),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.purple, width: 1.0)),
                ),
                maxLines: null,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
                      children: [
                        Container(
                          margin: new EdgeInsets.symmetric(vertical: 10.0),
                          child: Wrap(
                            spacing: 20,
                            children: [
                              for (var word in widget.confirmList)
                                Wrap(children: [
                                  Stack(children: [
                                    RaisedButton(
                                        onPressed: () {
                                          txtController.text = txtController.text + ' ' + word;

                                          setState(() {
                                            widget.matchList.add(word);
                                            widget.confirmList.remove(word);
                                          });
                                        },
                                        child: Text(word, style: TextStyle(fontWeight: FontWeight.w500)),
                                        textColor: Colors.black,
                                        color: Colors.white,
                                        shape: new RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        )),
                                  ])
                                ])
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
                icon: Icon(Icons.refresh),
                color: Colors.purple,
                onPressed: () {
                  setState(() {
                    widget.confirmList = List.from(widget.wordList);
                    txtController.text = "";
                    widget.matchList = [];
                    widget.confirmList.shuffle();
                  });
                }),
            Column(
              children: [
                Container(
                    child: widget.confirmList.isNotEmpty
                        ? Container()
                        : listEquals(widget.wordList, widget.matchList)
                            ? Container(
                                decoration: BoxDecoration(boxShadow: [
                                  BoxShadow(color: Colors.grey.withOpacity(0.025), offset: Offset(0, 3))
                                ]),
                                child: Padding(
                                    padding: const EdgeInsets.only(left: 30.0, right: 30, bottom: 10),
                                    child: CustomButton(
                                      onButtonClick: () async {
                                        await generateKiraAccount(accountState, wallet, context);
                                      },
                                      style: 1,
                                      text: "Confirm",
                                    )),
                              )
                            : Container(
                                decoration: BoxDecoration(boxShadow: [
                                  BoxShadow(color: Colors.grey.withOpacity(0.025), offset: Offset(0, 3))
                                ]),
                                child: Padding(
                                    padding: const EdgeInsets.only(left: 30.0, right: 30, bottom: 10),
                                    child: CustomButton(
                                      style: 1,
                                      text: "Incorrecct, try again",
                                    )),
                              )),
              ],
            ),
          ],
        ),
      );
    });
  }

  Future generateKiraAccount(List<Account> accountState, Wallet wallet, BuildContext context) async {
    var mnemonic = widget.wordList.toString();
    var mnemonicString = mnemonic.substring(1, mnemonic.length - 1);
    var newphrases = mnemonicString.replaceAll(new RegExp(r'[^\w\s]+'), '');

    try {
      accountState.add(Account(ethvatar: 'New Kira Account', type: 'KIRA', pubkey: wallet.bech32Address, privkey: wallet.privateKey.toString(), mnemonic: newphrases));
      final String encodeData = Account.encodeAccounts(accountState);
      await storage.write(key: 'database', value: encodeData);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MainInterface()));
    } catch (e) {
      print('Failed with error code: ${e.code}');
      print(e.message);
    }
  }
}
