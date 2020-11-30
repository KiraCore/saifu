import 'dart:convert';
import 'package:flutter_riverpod/all.dart';

class Account {
  final String type;
  final String ethvatar;
  final String pubkey;
  final String privkey;

  Account({this.type, this.ethvatar, this.pubkey, this.privkey});

  factory Account.fromJson(Map<String, dynamic> jsonData) {
    return Account(type: jsonData['type'], ethvatar: jsonData['ethvatar'], pubkey: jsonData['pubkey'], privkey: jsonData['privkey']);
  }

  static Map<String, dynamic> toMap(Account account) => {
        'type': account.type,
        'ethvatar': account.ethvatar,
        'pubkey': account.pubkey,
        'privkey': account.privkey
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
    AccountTypes(type: 'PGP', image: 'https://img.pngio.com/gray-circle-icon-free-gray-shape-icons-grey-circle-png-256_256.png'),
    /*
    AccountTypes(type: 'Bech32', image: 'https://en.bitcoin.it/w/images/en/2/29/BC_Logo_.png'),
    AccountTypes(type: 'P2PKH', image: 'https://img.pngio.com/gray-circle-icon-free-gray-shape-icons-grey-circle-png-256_256.png'),
    AccountTypes(type: 'P2SH', image: 'https://img.pngio.com/gray-circle-icon-free-gray-shape-icons-grey-circle-png-256_256.png'),
    AccountTypes(type: 'Ethereum', image: 'https://cdn.iconscout.com/icon/free/png-256/ethereum-16-646072.png'),
    AccountTypes(type: 'KeyBase', image: 'https://res-3.cloudinary.com/crunchbase-production/image/upload/c_lpad,h_256,w_256,f_auto,q_auto:eco/v1505765479/zghucdtjjevivjihplty.png'),
    */
  ];
}

class AccountList extends StateNotifier<List<Account>> {
  AccountList(List<Account> initialList) : super(initialList ?? []);

  void add(String type, String ethvatar, String pubkey, String privkey) {
    state = [
      ...state,
      Account(type: type, ethvatar: ethvatar, pubkey: pubkey, privkey: privkey)
    ];
  }

  void remove(Account target) {
    state = state.where((removeTarget) => removeTarget.pubkey != target.pubkey).toList();
  }

  void updateAccount(Account target, String accounttype, String accountName) {
    state = [
      for (final type in state)
        if (type.pubkey == target.pubkey) Account(pubkey: target.pubkey, privkey: target.privkey, type: accounttype, ethvatar: accountName) else type
    ];
  }
}

final accountListProvider = StateNotifierProvider<AccountList>((ref) => AccountList([]));
