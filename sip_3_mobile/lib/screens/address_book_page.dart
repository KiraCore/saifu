import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:sip_3_mobile/constants.dart';
import 'package:sip_3_mobile/models/address_book_model.dart';
import 'package:sip_3_mobile/widgets/add_address_modal.dart';
import 'package:sip_3_mobile/widgets/alert_dialog_widget.dart';

class AddressBookPage extends StatefulWidget {
  @override
  _AddressBookPageState createState() => _AddressBookPageState();
}

class _AddressBookPageState extends State<AddressBookPage> {
  bool _loading;
  var database = [];
  var myString = '';

  Future<void> retrieveInformation() async {
    try {
      String databaseString = await storage.read(key: 'Addressdatabase');
      List<AddressBook> decodeAddressDatabase = AddressBook.decodeAddressBook(databaseString);
      setState(() {
        _loading = false;
        database = decodeAddressDatabase;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      print('Failed with error code: ${e.code}');
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
        : Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.only(topLeft: Radius.circular(35), topRight: Radius.circular(35)),
            ),
            child: Consumer(builder: (context, watch, _) {
              // ignore: invalid_use_of_protected_member
              final addressState = watch(addressBookProvider).state;
              addressState.clear();
              for (int i = 0; i < database.length; i++) {
                addressState.add(database[i]);
              }
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: const Text(
                            'Address Book',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                          ),
                        ),
                        Spacer(),
                        Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: IconButton(
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
                              },
                            )),
                      ],
                    ),
                    Expanded(
                      child: addressState.length == 0
                          ? InkWell(
                              onTap: retrieveInformation,
                              child: Center(
                                  child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text('Tap to refresh or Add a new contact'),
                              )),
                            )
                          : RefreshIndicator(
                              onRefresh: retrieveInformation,
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                                child: ListView.builder(
                                    itemCount: addressState.length,
                                    itemBuilder: (context, index) {
                                      return Card(
                                        child: Dismissible(
                                          key: ValueKey(myString),
                                          // ignore: missing_return
                                          confirmDismiss: (direction) async {
                                            // Handle Swipe Effects
                                            if (direction == DismissDirection.endToStart) {
                                              createAlertDialog(context).then((value) async => {
                                                    if (value == 'Delete')
                                                      {
                                                        addressState.remove(addressState[index]),
                                                        await storage.write(key: 'Addressdatabase', value: AddressBook.encodeAddressBook(addressState)),
                                                        retrieveInformation(),
                                                      }
                                                  });
                                            } else if (direction == DismissDirection.startToEnd) {
                                              Clipboard.setData(ClipboardData(text: addressState[index].pubKey));
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("public key copied")));
                                              return false;
                                            }
                                          },
                                          background: CopySwipe(),
                                          secondaryBackground: RemoveSwipe(),
                                          child: ListTile(
                                            isThreeLine: true,
                                            onTap: () {},
                                            title: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(addressState[index].name),
                                            ),
                                            subtitle: Text(
                                              addressState[index].pubKey + addressState[index].pubKey + addressState[index].pubKey,
                                              style: TextStyle(color: Colors.grey[400]),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
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
              );
            }),
          );
  }
}

class CopySwipe extends StatelessWidget {
  const CopySwipe({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      color: Colors.grey[300],
      child: Align(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 10,
              ),
              Icon(
                Icons.copy,
                color: Colors.white,
              ),
              Text(
                "Copy",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }
}

class RemoveSwipe extends StatelessWidget {
  const RemoveSwipe({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Align(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Icon(
                Icons.delete,
                color: Colors.white,
              ),
              Text(
                "Remove",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.right,
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }
}
