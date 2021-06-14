import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jdenticon_dart/jdenticon_dart.dart';
import 'package:sacco/network_info.dart';
import 'package:sacco/wallet.dart';
import 'package:saifu/constants.dart';
import 'package:saifu/models/account.dart';
import 'package:saifu/screens/main_interface.dart';

class InputMnemonic extends StatefulWidget {
  @override
  _InputMnemonicState createState() => _InputMnemonicState();
}

class _InputMnemonicState extends State<InputMnemonic> {
  bool isValid = true;
  TextEditingController menmonicTextController = TextEditingController();
  final networkInfo = NetworkInfo(
    bech32Hrp: "kira",
    lcdUrl: "",
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, _) {
      // ignore: invalid_use_of_protected_member
      final accountState = watch(accountListProvider).state;
      return Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  'Input Mnemonic',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                ),
              ),
            ],
          ),
          Icon(Icons.horizontal_rule_rounded),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: EdgeInsets.all(2),
              decoration: new BoxDecoration(shape: BoxShape.circle, color: Colors.white),
              child: SvgPicture.string(
                Jdenticon.toSvg(menmonicTextController.text),
                fit: BoxFit.contain,
                height: 150,
                width: 150,
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  onFieldSubmitted: (_) {},
                  keyboardType: TextInputType.text,
                  controller: menmonicTextController,
                  onChanged: (val) {
                    setState(() {
                      isValid = true;
                    });
                  },
                  decoration: InputDecoration(
                      hintText: "Ensure 12 or more words separated by spacing",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelStyle: TextStyle(color: Colors.black),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        borderSide: BorderSide(color: Colors.grey, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.grey, width: 2),
                      )),
                  //
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(35),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () async {
                      setState(() {
                        isValid = bip39.validateMnemonic(menmonicTextController.text);
                      });
                      if (isValid) {
                        final mnemonic = menmonicTextController.text.split(" ");
                        final wallet = Wallet.derive(mnemonic, networkInfo);
                        accountState.add(Account(type: 'KIRA', pubkey: wallet.bech32Address, privkey: wallet.privateKey.toString(), mnemonic: menmonicTextController.text));
                        try {
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
                      } else {}
                    },
                    icon: Icon(
                      Icons.done,
                      color: Colors.black,
                    ),
                  )),
            ],
          ),
          isValid
              ? Container()
              : Center(
                  child: Text("Invalid security words", style: TextStyle(color: Colors.red)),
                ),
          SizedBox(
            height: 10,
          ),
        ]),
      );
    });
  }
}
