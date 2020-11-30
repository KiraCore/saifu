import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jdenticon_dart/jdenticon_dart.dart';
import 'package:sip_3_mobile/constants.dart';
import 'package:sip_3_mobile/models/account_model.dart';
import 'package:sip_3_mobile/widgets/account_type_display.dart';
import 'package:sip_3_mobile/widgets/alert_dialog_widget.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String ethvatar = '';
  String accountName = '';
  bool _loading;
  var database = [];
  Directory dir;
  bool fileExists = false;
  Map<String, dynamic> fileContent;

  int seleteposition = 2;

  TextEditingController customController = TextEditingController();

  Future<void> retrieveInformation() async {
    try {
      String retrieveName = await storage.read(key: 'AccountName');
      String databaseString = await storage.read(key: 'database');
      List<Account> decodedDatabase = Account.decodeAccounts(databaseString);

      setState(() {
        _loading = false;
        database = decodedDatabase;
        accountName = retrieveName;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      print('Failed with error code: ${e.code}');
      print(e.message);
    }
  }

  void createFile(Map<String, dynamic> content, Directory dir, String fileName) {
    File file = new File(dir.path + "/" + fileName);
    print(file.path);
    file.createSync();
    fileExists = true;
    file.writeAsStringSync(json.encode(content));
  }

  @override
  void initState() {
    _loading = true;
    super.initState();
/*
    getExternalStorageDirectory().then((value) {
      dir = value;
      /*https://flutter.dev/docs/cookbook/persistence/reading-writing-files
      https://pub.dev/packages/downloads_path_provider
      https://flutterforum.co/t/how-to-save-to-a-particular-folder/1616/13 
      String dir = value.path;
      String dirPath = '${value.path}/Pictures';
      print(dirPath);
      */
    });
    //getTemporaryDirectory();
    */
    retrieveInformation();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Container(child: Center(child: CircularProgressIndicator()))
        : ClipRRect(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(35), topRight: Radius.circular(35)),
            child: Container(
              color: Colors.grey[100],
              child: Consumer(builder: (context, watch, _) {
                // ignore: invalid_use_of_protected_member
                final accountState = watch(accountListProvider).state;
                accountState.clear();
                for (int i = 0; i < database.length; i++) {
                  accountState.add(database[i]);
                }

                return ClipRRect(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          margin: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  accountName,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                                ),
                              ),
                              Padding(padding: const EdgeInsets.only(left: 8.0), child: Container()),
                            ],
                          ),
                        ),
                        Expanded(
                          child: accountState.length == 0
                              ? InkWell(
                                  onTap: retrieveInformation,
                                  child: Center(
                                      child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Text('Tap to refresh. To click the button below to generate a new account'),
                                  )),
                                )
                              : RefreshIndicator(
                                  onRefresh: retrieveInformation,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                                    child: ListView.builder(
                                        itemCount: accountState.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(35),
                                              child: Card(
                                                  elevation: 0.0,
                                                  color: Colors.white,
                                                  child: InkWell(
                                                    splashColor: Colors.blue,
                                                    customBorder: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    onTap: () {},
                                                    child: ListTile(
                                                      onTap: () {
                                                        showModalBottomSheet(
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                                                            ),
                                                            isScrollControlled: true,
                                                            isDismissible: true,
                                                            context: context,
                                                            builder: (context) => AccountTypeDisplay(type: accountState[index].type, ethvatar: accountState[index].ethvatar, pubkey: accountState[index].pubkey, privkey: accountState[index].privkey));
                                                      },
                                                      title: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text(accountState[index].ethvatar),
                                                      ),
                                                      leading: FlatButton(
                                                        splashColor: Colors.white,
                                                        onPressed: () {
                                                          Clipboard.setData(ClipboardData(
                                                            text: accountState[index].pubkey,
                                                          )).then((_) => {
                                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                  content: Text("Public key copied to Clipboard"),
                                                                ))
                                                              });
                                                        },
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(8.0),
                                                          child: CircleAvatar(
                                                              maxRadius: 20,
                                                              backgroundColor: Colors.white,
                                                              child: CircleAvatar(
                                                                maxRadius: 19,
                                                                backgroundColor: Colors.white,
                                                                child: SvgPicture.string(
                                                                  Jdenticon.toSvg(accountState[index].pubkey),
                                                                  fit: BoxFit.contain,
                                                                ),
                                                              )),
                                                        ),
                                                      ),
                                                      trailing: PopupMenuButton<ListViewOptions>(
                                                        onSelected: (value) async => {
                                                          if (value == ListViewOptions.Forget)
                                                            {
                                                              createAlertDialog(context).then((value) async => {
                                                                    if (value == 'Delete')
                                                                      {
                                                                        accountState.remove(accountState[index]),
                                                                        await storage.write(key: 'database', value: Account.encodeAccounts(accountState)),
                                                                        retrieveInformation(),
                                                                      }
                                                                  })
                                                            }
                                                          else if (value == ListViewOptions.Export)
                                                            {
                                                              fileContent = {
                                                                'pubkey': accountState[index].pubkey,
                                                                'privkey': accountState[index].privkey
                                                              },
                                                              createFile(fileContent, dir, 'saifu_wallet_' + accountName + accountState[index].ethvatar)
                                                            }
                                                        },
                                                        itemBuilder: (BuildContext context) {
                                                          return <PopupMenuEntry<ListViewOptions>>[
                                                            PopupMenuItem(
                                                              child: Text('Export'),
                                                              value: ListViewOptions.Export,
                                                            ),
                                                            PopupMenuItem(
                                                              child: Text('Forget'),
                                                              value: ListViewOptions.Forget,
                                                            ),
                                                          ];
                                                        },
                                                      ),
                                                    ),
                                                  )),
                                            ),
                                          );
                                        }),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          );
  }
}
