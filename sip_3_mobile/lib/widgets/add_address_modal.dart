import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sip_3_mobile/constants.dart';
import 'package:sip_3_mobile/models/address_book_model.dart';

class AddAddressModal extends StatefulWidget {
  const AddAddressModal({
    Key key,
  }) : super(key: key);

  @override
  _AddAddressModalState createState() => _AddAddressModalState();
}

class _AddAddressModalState extends State<AddAddressModal> {
  String _name;
  String _publicKey;
  FocusNode fName;
  FocusNode fPublicKey;

  List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  @override
  void initState() {
    super.initState();
    fName = FocusNode();
    fPublicKey = FocusNode();
  }

  @override
  void dispose() {
    fName.dispose();
    fPublicKey.dispose();
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
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  'Add Contact',
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                ),
              ),
            ],
          ),
          Form(
            key: _formKeys[0],
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: <Widget>[
                TextFormField(
                  focusNode: fName,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    fName.unfocus();
                    FocusScope.of(context).requestFocus(fPublicKey);
                  },
                  onSaved: (String val) => _name = val,
                  validator: (value) {
                    if (value.isEmpty) return "You can't have an empty name";
                    if (value.length < 2) return "Name must have more than one character";
                    return null;
                  },
                  decoration: InputDecoration(
                      labelText: 'Name',
                      helperText: 'This has to be at least two characters in length.',
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
                  //
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                flex: 9,
                child: Form(
                  key: _formKeys[1],
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        focusNode: fPublicKey,
                        onEditingComplete: () {
                          fPublicKey.unfocus();
                        },
                        onSaved: (String val) => _publicKey = val,
                        validator: (value) {
                          if (value.trim().isEmpty) return "You can't have an empty public key";
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: 'Public key',
                            helperText: 'This cannot be empty.',
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
                        //
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                  child: IconButton(
                icon: Icon(Icons.arrow_forward_ios),
                onPressed: () async {
                  _formKeys[0].currentState.save();
                  _formKeys[1].currentState.save();

                  if (_formKeys[0].currentState.validate() && _formKeys[1].currentState.validate()) {
                    try {
                      addressBookState.add(AddressBook(name: _name, pubKey: _publicKey));
                      final String encodeData = AddressBook.encodeAddressBook(addressBookState);
                      await storage.write(key: 'Addressdatabase', value: encodeData);

                      Navigator.pop(context);
                    } on PlatformException catch (err) {
                      print(err);
                      //TODO Handle err
                    } catch (err) {
                      //TODO other types of Exceptions
                    }
                  }
                },
              )),
            ],
          ),
        ]),
      );
    });
  }
}
