import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jdenticon_dart/jdenticon_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sip_3_mobile/constants.dart';
import 'package:sip_3_mobile/models/signature_model.dart';
import 'package:sip_3_mobile/widgets/network_account_widget.dart';
import 'package:sip_3_mobile/widgets/option_button_widget.dart';

// ignore: must_be_immutable
class MainInterface extends StatefulWidget {
  bool retrievedData = false;
  @override
  _MainInterfaceState createState() => _MainInterfaceState();
}

class _MainInterfaceState extends State<MainInterface> {
  String ethvatar = '';
  String accountName = '';
  bool _loading;
  var database = [];
  @override
  void initState() {
    _loading = true;
    super.initState();
    getAccount();
  }

  void getAccount() async {
    try {
      String retrieveName = await storage.read(key: 'AccountName');
      String databaseString = await storage.read(key: 'database');
      List<Signature> decodedDatabase = Signature.decodeSignatures(databaseString);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('stage', 2);
      print(decodedDatabase);
      setState(() {
        _loading = false;
        database = decodedDatabase;
        accountName = retrieveName;
        ethvatar = Jdenticon.toSvg(retrieveName.toString());
      });
    } catch (e) {
      print('Failed with error code: ${e.code}');
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Container(child: Center(child: CircularProgressIndicator()))
        : WillPopScope(
            onWillPop: () async => false,
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                elevation: 0.0,
                actions: [],
                title: Text(
                  'saifu',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              floatingActionButton: FloatingActionButton(
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
                child: Icon(
                  Icons.add_circle_outline,
                  color: Colors.black,
                  size: 29,
                ),
                backgroundColor: Colors.white,
                elevation: 5,
                splashColor: Colors.grey,
              ),
              floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
              body: SafeArea(
                child: Consumer(builder: (context, watch, _) {
                  final signaturestate = watch(signatureListProvider).state;
                  signaturestate.clear();
                  for (int i = 0; i < database.length; i++) {
                    signaturestate.add(database[i]);
                  }
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              color: Colors.white,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      height: 40,
                                      width: 40,
                                      child: SvgPicture.string(
                                        Jdenticon.toSvg(accountName),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      accountName,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.black, fontSize: 20),
                                    ),
                                  ),
                                  Padding(padding: const EdgeInsets.only(left: 8.0), child: Container()),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: signaturestate.length == 0
                                ? Center(
                                    child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Text('Tap below to generate a new account'),
                                  ))
                                : ListView.builder(
                                    itemCount: signaturestate.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                        child: Card(
                                            child: ListTile(
                                          onTap: () {
                                            showModalBottomSheet(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                                                ),
                                                isScrollControlled: true,
                                                isDismissible: true,
                                                context: context,
                                                builder: (context) => NetworkAccount(type: signaturestate[index].type, ethvatar: signaturestate[index].ethvatar, pubkey: signaturestate[index].pubkey, privkey: signaturestate[index].privkey));
                                          },
                                          title: Text(signaturestate[index].type),
                                          leading: FlatButton(
                                            onPressed: () {
                                              Clipboard.setData(ClipboardData(
                                                text: signaturestate[index].pubkey,
                                              )).then((_) => {
                                                    Scaffold.of(context).showSnackBar(SnackBar(content: Text("Public key copied to Clipboard")))
                                                  });
                                            },
                                            child: Padding(
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
                                          ),
                                          trailing: PopupMenuButton<String>(
                                            onSelected: (value) async => {
                                              if (value.toString() == Constants.Forget)
                                                {
                                                  signaturestate.remove(signaturestate[index]),
                                                  await storage.write(key: 'database', value: Signature.encodeSignatures(signaturestate)),
                                                  getAccount()
                                                },
                                            },
                                            itemBuilder: (BuildContext context) {
                                              return Constants.choices.map((String choice) {
                                                return PopupMenuItem<String>(
                                                  value: choice,
                                                  child: Text(choice),
                                                );
                                              }).toList();
                                            },
                                          ),
                                        )),
                                      );
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
