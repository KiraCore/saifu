import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jdenticon_dart/jdenticon_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sip_3_mobile/constants.dart';
import 'package:sip_3_mobile/models/signature_model.dart';
import 'package:sip_3_mobile/screens/qr_code_screen.dart';
import 'package:sip_3_mobile/widgets/network_account_widget.dart';
import 'package:sip_3_mobile/widgets/option_button_widget.dart';

// ignore: must_be_immutable
class MainInterface extends StatefulWidget {
  @override
  _MainInterfaceState createState() => _MainInterfaceState();
}

class _MainInterfaceState extends State<MainInterface> {
  String ethvatar = '';
  String _pubkey = '';
  String name = '';
  @override
  void initState() {
    getAccount();
    super.initState();
  }

  Future<void> getAccount() async {
    String pubkey;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    pubkey = await storage.read(key: "pubkey");
    await prefs.setInt('stage', 2);
    String retrieveName = prefs.getString('name');
    setState(() {
      _pubkey = pubkey.toString();
      name = retrieveName;
      ethvatar = Jdenticon.toSvg(pubkey.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: greys,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0.0,
          actions: [
            IconButton(icon: Icon(Icons.settings), onPressed: () {})
          ],
          title: Text(
            'saifu signer',
            style: TextStyle(fontWeight: FontWeight.normal),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => QrCodeScanner(),
            ));
          },
          child: Icon(
            Icons.qr_code,
            color: Colors.white,
            size: 29,
          ),
          backgroundColor: Colors.black,
          tooltip: 'Capture QRCode',
          elevation: 5,
          splashColor: Colors.grey,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: SafeArea(
          child: Consumer(builder: (context, watch, _) {
            final signaturestate = watch(signatureListProvider).state;
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Colors.white,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: 40,
                                width: 40,
                                child: SvgPicture.string(
                                  Jdenticon.toSvg(name),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: SizedBox(
                                  child: Text(
                                    name,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: IconButton(
                                  icon: Icon(Icons.add_circle),
                                  onPressed: () {
                                    showModalBottomSheet(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                                      ),
                                      isScrollControlled: false,
                                      isDismissible: true,
                                      backgroundColor: Colors.transparent,
                                      context: context,
                                      builder: (context) => Container(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            OptionButton(
                                              option: 'Create a new wallet',
                                            ),
                                            OptionButton(
                                              option: 'Import private key as plaintext',
                                            ),
                                            OptionButton(
                                              option: 'Import private key via key file',
                                            ),
                                            OptionButton(
                                              option: 'Import private key via seed words',
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                )),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: signaturestate.length,
                          itemBuilder: (context, index) {
                            return Card(
                                child: ListTile(
                              onTap: () {
                                showModalBottomSheet(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                                    ),
                                    isScrollControlled: true,
                                    isDismissible: true,
                                    context: context,
                                    builder: (context) => NetworkAccount(
                                          type: signaturestate[index].type,
                                          ethvatar: signaturestate[index].ethvatar,
                                          pubkey: signaturestate[index].pubkey,
                                        ));
                              },
                              title: Text(signaturestate[index].type),
                              leading: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                    maxRadius: 20,
                                    child: CircleAvatar(
                                      maxRadius: 19,
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.black,
                                      child: SvgPicture.string(
                                        Jdenticon.toSvg(signaturestate[index].ethvatar),
                                        fit: BoxFit.contain,
                                      ),
                                    )),
                              ),
                              trailing: PopupMenuButton<String>(
                                onSelected: choiceAction,
                                itemBuilder: (BuildContext context) {
                                  return Constants.choices.map((String choice) {
                                    return PopupMenuItem<String>(
                                      value: choice,
                                      child: Text(choice),
                                    );
                                  }).toList();
                                },
                              ),
                            ));
                          }),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

void choiceAction(String choice) {
  if (choice == Constants.Forget) {
    print('test');
  }
}
