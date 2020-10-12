import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'package:sip_3_mobile/constants.dart';
import 'package:sip_3_mobile/widgets/network_account_widget.dart';
import 'package:sip_3_mobile/screens/qr_code_screen.dart';

class MainInterface extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Card(
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
                  title: Text('wallet name'),
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.blue,
                      maxRadius: 20,
                    ),
                  ),
                  subtitle: Text('PGP'),
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
                )),
              ],
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
