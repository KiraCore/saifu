import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jdenticon_dart/jdenticon_dart.dart';
import 'package:sip_3_mobile/constants.dart';
import 'package:sip_3_mobile/models/account.dart';
import 'package:sip_3_mobile/widgets/account_type_display.dart';
import 'package:sip_3_mobile/widgets/alert_dialog.dart';

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  String accountName = '';
  bool _loading;
  var database = [];

  TextEditingController customController = TextEditingController();

  Future<void> retrieveInformation() async {
    setState(() {
      _loading = true;
    });
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

  @override
  void initState() {
    _loading = true;
    super.initState();
    retrieveInformation();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Container(child: Center(child: CircularProgressIndicator()))
        : ClipRRect(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(35), topRight: Radius.circular(35)),
            child: Container(
              color: Colors.white,
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
                                  textAlign: TextAlign.left,
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
                                    child: GridView.builder(
                                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 0, childAspectRatio: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 3)),
                                        itemCount: accountState.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(35),
                                              child: Card(
                                                color: Colors.grey[50],
                                                elevation: 0.0,
                                                child: InkWell(
                                                  onTap: () async {
                                                    bool navigateback = await showModalBottomSheet(
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                                                        ),
                                                        isScrollControlled: true,
                                                        isDismissible: true,
                                                        context: context,
                                                        builder: (context) => AccountTypeDisplay(
                                                              type: accountState[index].type,
                                                              ethvatar: accountState[index].ethvatar,
                                                              pubkey: accountState[index].pubkey,
                                                              privkey: accountState[index].privkey,
                                                              mnemonic: accountState[index].mnemonic,
                                                            ));

                                                    if (navigateback == true) retrieveInformation();
                                                  },
                                                  splashColor: Colors.black,
                                                  child: Stack(
                                                    children: [
                                                      Positioned(
                                                        right: 0,
                                                        child: PopupMenuButton<ListViewOptions>(
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
                                                                },
                                                            itemBuilder: (BuildContext context) {
                                                              return <PopupMenuEntry<ListViewOptions>>[
                                                                PopupMenuItem(
                                                                  child: Text('Forget'),
                                                                  value: ListViewOptions.Forget,
                                                                ),
                                                              ];
                                                            }),
                                                      ),
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Container(
                                                              padding: EdgeInsets.all(2),
                                                              decoration: new BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                                                              child: CircleAvatar(
                                                                  maxRadius: 30,
                                                                  backgroundColor: Colors.white,
                                                                  child: CircleAvatar(
                                                                    maxRadius: 29,
                                                                    backgroundColor: Colors.white,
                                                                    child: InkWell(
                                                                      splashColor: Colors.black,
                                                                      onTap: () {
                                                                        Clipboard.setData(ClipboardData(
                                                                          text: accountState[index].pubkey,
                                                                        )).then((_) => {
                                                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                                content: Text("Public key copied to Clipboard"),
                                                                              ))
                                                                            });
                                                                      },
                                                                      child: SvgPicture.string(
                                                                        Jdenticon.toSvg(accountState[index].pubkey),
                                                                        fit: BoxFit.contain,
                                                                        height: 70,
                                                                        width: 70,
                                                                      ),
                                                                    ),
                                                                  )),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Center(
                                                              child: ClipRRect(
                                                                borderRadius: BorderRadius.circular(30),
                                                                child: Container(
                                                                  color: Colors.white,
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.all(10.0),
                                                                    child: Text(
                                                                      accountState[index].pubkey.replaceRange(7, accountState[index].pubkey.length - 7, '....'),
                                                                      style: TextStyle(color: Colors.black),
                                                                      textAlign: TextAlign.center,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
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
