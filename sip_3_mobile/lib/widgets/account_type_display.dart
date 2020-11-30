import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openpgp/openpgp.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share/share.dart';
import 'package:sip_3_mobile/constants.dart';
import 'package:sip_3_mobile/models/account_model.dart';
import 'package:sip_3_mobile/models/address_book_model.dart';
import 'package:sip_3_mobile/screens/qrcode_page.dart';
import 'package:sip_3_mobile/widgets/add_address_modal.dart';

// ignore: must_be_immutable
class AccountTypeDisplay extends StatefulWidget {
  String ethvatar;
  String pubkey;
  String type;
  String privkey;
  AccountTypeDisplay({Key key, this.ethvatar, this.pubkey, this.type, this.privkey}) : super(key: key);

  @override
  _AccountTypeDisplayState createState() => _AccountTypeDisplayState();
}

class _AccountTypeDisplayState extends State<AccountTypeDisplay> {
  TextEditingController txtController = new TextEditingController();
  TextEditingController accountNameController = TextEditingController();
  String _selectedText;
  Codec<String, String> stringToBase64;
  String encoded;
  @override
  void initState() {
    super.initState();
    accountNameController.text = widget.ethvatar;
    txtController.text = widget.pubkey;
    _selectedText = widget.type;
    stringToBase64 = utf8.fuse(base64);
    encoded = stringToBase64.encode(widget.pubkey);
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController txtController = new TextEditingController();
    txtController.text = widget.pubkey;
    return Container(
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
                    title: TextField(
                      controller: accountNameController,
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.ltr,
                      onSubmitted: (value) async {
                        accountState.remove(accountState[accountState.indexWhere((element) => element.pubkey == widget.pubkey)]);
                        accountState.add(Account(ethvatar: value, privkey: widget.privkey, pubkey: widget.pubkey, type: _selectedText));
                        await storage.write(key: 'database', value: Account.encodeAccounts(accountState));
                      },
                      decoration: InputDecoration(contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0), hintText: "Account Name", border: InputBorder.none, focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[300]), borderRadius: BorderRadius.circular(10.0))),
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
                                      accountState.add(Account(ethvatar: accountNameController.text, privkey: widget.privkey, pubkey: widget.pubkey, type: _selectedText));
                                      await storage.write(key: 'database', value: Account.encodeAccounts(accountState));
                                    },
                                  ),
                                ),
                              ),
                            ),
                          )
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
                            }),
                  ));
            },
          ),
          ClipRRect(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                widget.type == 'PGP'
                    ? Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text((widget.pubkey.substring(60, 70) + "..." + widget.pubkey.substring(widget.pubkey.length - 45, widget.pubkey.toString().length - 35)).replaceAll("\n", "")),
                            ],
                          ),
                        ],
                      )
                    : Container(),
                SizedBox(
                  height: 10,
                ),
                Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 30),
                      decoration: BoxDecoration(color: Colors.white, shape: BoxShape.rectangle, borderRadius: BorderRadius.all(Radius.circular(12)), boxShadow: [
                        BoxShadow(color: Colors.grey, offset: Offset(0.0, 1.0), blurRadius: 15.0) //(x,y)
                      ]),
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
                                ),
                              ),
                            );
                          }),
                    ),
                    /*
                      Positioned.fill(
                        child: Align(
                            alignment: Alignment.center,
                            child: CircleAvatar(
                              maxRadius: 30,
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              child: SvgPicture.string(
                                Jdenticon.toSvg(widget.pubkey),
                                fit: BoxFit.contain,
                              ),
                            )),
                      ),
                      */
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: RaisedButton(
                    onPressed: () {
                      showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                          ),
                          isScrollControlled: true,
                          isDismissible: true,
                          context: context,
                          builder: (context) => VerifyWidget());
                    },
                    padding: EdgeInsets.all(15),
                    color: Colors.white,
                    textColor: Colors.black,
                    child: Text('Verify'),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => QrCodePage(
                          type: widget.type,
                          privkey: widget.privkey,
                          pubkey: widget.pubkey,
                        ),
                      ));
                    },
                    padding: EdgeInsets.all(15),
                    color: Colors.white,
                    textColor: Colors.black,
                    child: Text('Sign'),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class VerifyWidget extends StatefulWidget {
  const VerifyWidget({
    Key key,
  }) : super(key: key);

  @override
  _VerifyWidgetState createState() => _VerifyWidgetState();
}

class _VerifyWidgetState extends State<VerifyWidget> {
  TextEditingController originalMessageController = new TextEditingController();
  TextEditingController signedMessageController = new TextEditingController();
  FocusNode fOriginalMessage;
  FocusNode fSignedMessage;
  String _selectedText;
  @override
  void initState() {
    super.initState();
    originalMessageController.text = '';
    signedMessageController.text = '';
    fOriginalMessage = FocusNode();
    fSignedMessage = FocusNode();
  }

  @override
  void dispose() {
    fOriginalMessage.dispose();
    fSignedMessage.dispose();
    originalMessageController.dispose();
    signedMessageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, _) {
      // ignore: invalid_use_of_protected_member
      final addressBookState = watch(addressBookProvider).state;

      return Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: const Text(
                    'Verify Signature',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                  ),
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.add_rounded),
                  onPressed: () {
                    showModalBottomSheet(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                        ),
                        isScrollControlled: true,
                        isDismissible: true,
                        context: context,
                        builder: (context) => AddAddressModal());
                    fOriginalMessage.unfocus();
                    fSignedMessage.unfocus();
                  },
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                focusNode: fOriginalMessage,
                onEditingComplete: () {
                  fOriginalMessage.unfocus();
                  FocusScope.of(context).requestFocus(fSignedMessage);
                },
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                textInputAction: TextInputAction.next,
                controller: originalMessageController,
                decoration: InputDecoration(
                    labelText: 'Provide original message',
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
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                focusNode: fSignedMessage,
                onEditingComplete: () {
                  fSignedMessage.unfocus();
                },
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                textInputAction: TextInputAction.done,
                controller: signedMessageController,
                decoration: InputDecoration(
                    labelText: 'Provide signed message',
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
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      hint: Text("Select the public key"),
                      value: _selectedText,
                      items: addressBookState.map((e) {
                        return DropdownMenuItem<String>(
                          value: e.pubKey,
                          child:

                              /*
                            ListTile(
                              dense: true,
                              title: Text(e.name),
                              /*
                              subtitle: Text(
                                e.pubKey,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              */
                            )
                            */

                              Text(
                            e.name,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            maxLines: 1,
                          ),
                        );
                      }).toList(),
                      onChanged: (String val) async {
                        setState(() {
                          _selectedText = val;
                          print(_selectedText);
                        });
                      },
                    ),
                  ),
                ),
                Expanded(
                    child: IconButton(
                  icon: Icon(Icons.arrow_forward_ios),
                  onPressed: () async {
                    Codec<String, String> stringToBase64 = utf8.fuse(base64);
                    String decodedSignature = stringToBase64.decode(signedMessageController.text.toString());
                    // String decodedPublicKey = stringToBase64.decode(publicKeyController.text.toString());
                    print(_selectedText);
                    var resultVerification = await OpenPGP.verify(decodedSignature, originalMessageController.text, _selectedText);
                    print(resultVerification);
                    Navigator.pop(context);
                  },
                )),
              ],
            ),
          ]),
        ),
      );
    });
  }
}
