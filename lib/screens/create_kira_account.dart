import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:saifu/screens/confirm_backup.dart';
import 'package:saifu/widgets/custom_button.dart';

class CreateKiraAccount extends StatefulWidget {
  @override
  _CreateKiraAccountState createState() => _CreateKiraAccountState();
}

class _CreateKiraAccountState extends State<CreateKiraAccount> {
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
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          title: Text(
            'Kira Account',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Expanded(
              child: ClipRRect(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(50), topLeft: Radius.circular(50)),
                  child: Container(
                      padding: const EdgeInsets.only(left: 30.0, right: 30, top: 20),
                      child: Column(children: [
                        DefaultTextStyle(style: new TextStyle(inherit: true, fontWeight: FontWeight.w300, color: Colors.black), child: RichWidget()),
                        SizedBox(
                          height: 10,
                        ),
                        Expanded(
                            child: SizedBox(
                                child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Container(
                                        margin: new EdgeInsets.symmetric(vertical: 10.0),
                                        child: Wrap(spacing: 20, children: [
                                          for (var word in wordList)
                                            Wrap(children: [
                                              Stack(children: [
                                                RaisedButton(
                                                    onPressed: () {},
                                                    child: Text(word, style: TextStyle(fontWeight: FontWeight.w500)),
                                                    textColor: Colors.black,
                                                    color: Colors.white,
                                                    shape: new RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10.0),
                                                    )),
                                                Positioned(top: 0.0, right: 0.0, child: Container(width: 30, height: 20, decoration: BoxDecoration(color: Colors.purple, shape: BoxShape.circle), child: Center(child: Text((wordList.indexOf(word) + 1).toString(), style: TextStyle(color: Colors.white)))))
                                              ])
                                            ])
                                        ]))))),
                        CustomButton(
                            style: 1,
                            text: "I confirm, I've made a backup of my seed",
                            onButtonClick: () {
                              Navigator.of(context).pushReplacement(new CupertinoPageRoute(builder: (context) => new ConfirmBackup(wordList)));
                            }),
                        SizedBox(height: 10)
                      ]))))
        ]));
  }
}

class RichWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(style: DefaultTextStyle.of(context).style, children: <TextSpan>[
        TextSpan(text: 'The seed of this wallet has generated a list of 24 english phrases, This is your wallet backup and only you possess this seed. Save it somewhere safe and keep it private.\n\n', style: TextStyle(fontSize: 20)),
        TextSpan(
          text: 'Do not lose this seed. Should you lose this list of phrases, you will lose access to your funds.',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
      ]),
    );
  }
}
