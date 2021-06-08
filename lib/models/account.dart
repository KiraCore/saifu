import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class Account {
  final String type;
  final String pubkey;
  final String privkey;

  final String mnemonic;

  Account({this.type, this.pubkey, this.privkey, this.mnemonic});

  factory Account.fromJson(Map<String, dynamic> jsonData) {
    return Account(type: jsonData['type'], pubkey: jsonData['pubkey'], privkey: jsonData['privkey'], mnemonic: jsonData['mnemonic']);
  }

  static Map<String, dynamic> toMap(Account account) => {
        'type': account.type,

        'pubkey': account.pubkey,
        'privkey': account.privkey,
        'mnemonic': account.mnemonic.toString(),
        //'wallet': account.wallet
      };

  static String encodeAccounts(List<Account> account) => json.encode(
        account.map<Map<String, dynamic>>((account) => Account.toMap(account)).toList(),
      );

  static List<Account> decodeAccounts(String accounts) => (json.decode(accounts) as List<dynamic>).map<Account>((item) => Account.fromJson(item)).toList();
}

class AccountTypes {
  final String type;
  final String image;

  const AccountTypes({this.type, this.image});

  static const List<AccountTypes> typesSupported = <AccountTypes>[
    AccountTypes(type: 'KIRA', image: 'https://res-2.cloudinary.com/crunchbase-production/image/upload/c_lpad,h_256,w_256,f_auto,q_auto:eco/fpkkznhdu7i0bmdzxlqk.png'),
  ];
}

class AccountList extends StateNotifier<List<Account>> {
  AccountList(List<Account> initialList) : super(initialList ?? []);

  void add(String type, String pubkey, String privkey, String mnemonic) {
    state = [
      ...state,
      Account(type: type, pubkey: pubkey, privkey: privkey, mnemonic: mnemonic)
    ];
  }

  void remove(Account target) {
    state = state.where((removeTarget) => removeTarget.pubkey != target.pubkey).toList();
  }

  void updateAccount(Account target, String accounttype, String accountName) {
    state = [
      for (final type in state)
        if (type.pubkey == target.pubkey)
          Account(
            pubkey: target.pubkey,
            privkey: target.privkey,
            type: accounttype,
          )
        else
          type
    ];
  }
}

final accountListProvider = StateNotifierProvider<AccountList>((ref) => AccountList([]));
