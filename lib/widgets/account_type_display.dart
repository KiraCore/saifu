import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share/share.dart';
import 'package:saifu/constants.dart';
import 'package:saifu/models/account.dart';
import 'package:saifu/screens/qrcode_scan.dart';

// ignore: must_be_immutable
class AccountTypeDisplay extends StatefulWidget {
  String pubkey;
  String type;
  String privkey;
  String mnemonic;
  AccountTypeDisplay({Key key, this.pubkey, this.type, this.privkey, this.mnemonic}) : super(key: key);

  @override
  _AccountTypeDisplayState createState() => _AccountTypeDisplayState();
}

class _AccountTypeDisplayState extends State<AccountTypeDisplay> {
  TextEditingController accountNameController = TextEditingController();
  String _selectedText;
  Codec<String, String> stringToBase64;
  String encoded;
  @override
  void initState() {
    super.initState();
    accountNameController.text = widget.pubkey.replaceRange(7, widget.pubkey.length - 7, '....');
    _selectedText = widget.type;
    stringToBase64 = utf8.fuse(base64);
    encoded = stringToBase64.encode(widget.pubkey);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.transparent,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Consumer(
            builder: (context, watch, _) {
              // ignore: invalid_use_of_protected_member
              final accountState = watch(accountListProvider).state;
              return Container(
                  color: Colors.transparent,
                  child: ListTile(
                      leading: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.arrow_back),
                      ),
                      title: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                            padding: const EdgeInsets.all(0.0),
                            child: Text(
                              accountNameController.text,
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.ltr,
                            )
                            /*
                            
                            TextField(
                              controller: accountNameController,
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.ltr,
                              
                            onSubmitted: (value) async {
                              accountState.remove(accountState[accountState.indexWhere((element) => element.pubkey == widget.pubkey)]);
                              accountState.add(Account(ethvatar: value, privkey: widget.privkey, pubkey: widget.pubkey, type: _selectedText, mnemonic: widget.mnemonic));
                              await storage.write(key: 'database', value: Account.encodeAccounts(accountState)).then((value) => Navigator.pop(context));
                              //
                              
                              //Navigator.pop(context, true);
                            },
                        
                              decoration: InputDecoration(contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0), hintText: "Account Name", border: InputBorder.none, focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[300]), borderRadius: BorderRadius.circular(10.0))),
                            ),
                                */
                            ),
                      ),
                      trailing: AccountTypes.typesSupported.indexWhere((element) => element.type == widget.type) == -1
                          ? AbsorbPointer(
                              absorbing: false,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                                      child: Container(
                                          color: Colors.grey[300],
                                          child: DropdownButton<String>(
                                              hint: Text("Type"),
                                              value: _selectedText,
                                              items: AccountTypes.typesSupported.map((e) {
                                                return DropdownMenuItem<String>(
                                                  value: e.type,
                                                  child: Text(e.type),
                                                );
                                              }).toList(),
                                              onChanged: (String val) async {
                                                _selectedText = val;
                                                setState(() {
                                                  _selectedText = val;
                                                });
                                                accountState.remove(accountState[accountState.indexWhere((element) => element.pubkey == widget.pubkey)]);
                                                accountState.add(Account(privkey: widget.privkey, pubkey: widget.pubkey, type: _selectedText));
                                                await storage.write(key: 'database', value: Account.encodeAccounts(accountState));
                                              })))))
                          : PopupMenuButton<AccountOptions>(
                              onSelected: (value) async => {
                                    if (value == AccountOptions.Copy)
                                      {
                                        Clipboard.setData(ClipboardData(
                                          text: widget.pubkey,
                                        ))
                                      }
                                    else if (value == AccountOptions.Share)
                                      {
                                        Share.share('Sharing public key via Saifu App: ${widget.pubkey}')
                                      }
                                    else if (value == AccountOptions.Base64)
                                      {
                                        Clipboard.setData(ClipboardData(
                                          text: encoded,
                                        ))
                                      }
                                  },
                              itemBuilder: (BuildContext context) {
                                return <PopupMenuEntry<AccountOptions>>[
                                  PopupMenuItem(
                                    child: Text('Copy'),
                                    value: AccountOptions.Copy,
                                  ),
                                  PopupMenuItem(
                                    child: Text('Share'),
                                    value: AccountOptions.Share,
                                  ),
                                  PopupMenuItem(
                                    child: Text('Base64'),
                                    value: AccountOptions.Base64,
                                  )
                                ];
                              })));
            },
          ),
          ClipRRect(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                SizedBox(
                  height: 10,
                ),
                Stack(children: [
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 30),
                      child: QrImage(
                          data: widget.pubkey,
                          version: QrVersions.auto,
                          errorCorrectionLevel: QrErrorCorrectLevel.L,
                          errorStateBuilder: (cxt, err) {
                            return Container(
                                child: Center(
                                    child: Text(
                              "QR code could not be generated!",
                              textAlign: TextAlign.center,
                            )));
                          }))
                ]),
                SizedBox(
                  height: 10,
                )
              ])),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(children: [
                Expanded(child: Container()),
                SizedBox(
                  width: 10,
                ),
                Expanded(
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
                                  Navigator.pop(context);
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => QrCodePage(
                                            type: widget.type,
                                            privkey: widget.privkey,
                                            pubkey: widget.pubkey,
                                            mnemonic: widget.mnemonic,
                                          )));
                                },
                                child: Row(mainAxisSize: MainAxisSize.min, children: [
                                  Text(
                                    "Sign a transcation",
                                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                                  )
                                ])))))
              ]))
        ]));
  }
}
