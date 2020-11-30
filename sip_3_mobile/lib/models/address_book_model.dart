import 'dart:convert';
import 'package:flutter_riverpod/all.dart';

class AddressBook {
  final String name;
  final String pubKey;

  AddressBook({this.name, this.pubKey});

  factory AddressBook.fromJson(Map<String, dynamic> jsonData) {
    return AddressBook(
      name: jsonData['name'],
      pubKey: jsonData['pubKey'],
    );
  }

  static Map<String, dynamic> toMap(AddressBook contact) => {
        'name': contact.name,
        'pubKey': contact.pubKey
      };

  static String encodeAddressBook(List<AddressBook> contact) => json.encode(
        contact.map<Map<String, dynamic>>((contact) => AddressBook.toMap(contact)).toList(),
      );

  static List<AddressBook> decodeAddressBook(String address) => (json.decode(address) as List<dynamic>).map<AddressBook>((item) => AddressBook.fromJson(item)).toList();
}

class AddressBookList extends StateNotifier<List<AddressBook>> {
  AddressBookList(List<AddressBook> initialList) : super(initialList ?? []);
  
  void add(String name, String pubKey) {
    state = [
      ...state,
      AddressBook(name: name, pubKey: pubKey)
    ];
  }

  void remove(AddressBook target) {
    state = state.where((removeTarget) => removeTarget.pubKey != target.pubKey).toList();
  }
}

final addressBookProvider = StateNotifierProvider<AddressBookList>((ref) => AddressBookList([]));
