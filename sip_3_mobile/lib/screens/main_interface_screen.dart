import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import 'package:jdenticon_dart/jdenticon_dart.dart';

import 'package:sip_3_mobile/constants.dart';
import 'package:sip_3_mobile/models/signature_model.dart';
import 'package:sip_3_mobile/widgets/network_account_widget.dart';
import 'package:sip_3_mobile/screens/qr_code_screen.dart';

class MainInterface extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final signaturestate = watch(signatureListProvider.state);

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
        body: SafeArea(
          child: Padding(
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
                              child: Container(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: SizedBox(
                                child: Text(
                                  'Amanuel Yosief Mussie',
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
                                  Navigator.of(context).push(CupertinoPageRoute(
                                    builder: (context) => QrCodeScanner(),
                                  ));
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
                              //Navigator.of(context).push(MaterialPageRoute(builder: (context) => NetworkAccount()));
                              showModalBottomSheet(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                                  ),
                                  isScrollControlled: true,
                                  isDismissible: true,
                                  context: context,
                                  builder: (context) => NetworkAccount());
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
                                      Jdenticon.toSvg(signaturestate[index].ethvatar.toString()),
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

                  /*
                  RaisedButton.icon(onPressed: () => context.read(signatureListProvider).add('PGP', 'ethvatar', 'asdkaldad'), icon: Icon(Icons.help_outline), label: Text('HELLo')),
                  RaisedButton.icon(onPressed: () => context.read(signatureListProvider).remove(signaturestate[0]), icon: Icon(Icons.remove_circle_outlined), label: Text('HELLo'))
                  */
                ],
              ),
            ),
          ),
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
