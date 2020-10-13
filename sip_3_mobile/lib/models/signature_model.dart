import 'package:flutter_riverpod/all.dart';

class Signature {
  Signature({this.type, this.ethvatar, this.pubkey});

  final String type;
  final String ethvatar;
  final String pubkey;
}

class SupportedTypes {
  final String type;
  final String image;

  const SupportedTypes({this.type, this.image});

  static const List<SupportedTypes> signatureTypesSupported = <SupportedTypes>[
    SupportedTypes(type: 'PGP', image: 'https://img.pngio.com/gray-circle-icon-free-gray-shape-icons-grey-circle-png-256_256.png'),
    SupportedTypes(type: 'Bech32', image: 'https://en.bitcoin.it/w/images/en/2/29/BC_Logo_.png'),
    SupportedTypes(type: 'P2PKH', image: 'https://img.pngio.com/gray-circle-icon-free-gray-shape-icons-grey-circle-png-256_256.png'),
    SupportedTypes(type: 'P2SH', image: 'https://img.pngio.com/gray-circle-icon-free-gray-shape-icons-grey-circle-png-256_256.png'),
    SupportedTypes(type: 'Ethereum', image: 'https://cdn.iconscout.com/icon/free/png-256/ethereum-16-646072.png'),
  ];
}

class SignatureList extends StateNotifier<List<Signature>> {
  SignatureList(List<Signature> initialList) : super(initialList ?? []);

  void add(String type, String ethvatar, String pubkey) {
    state = [
      ...state,
      Signature(type: type, ethvatar: ethvatar, pubkey: pubkey)
    ];
  }

  void remove(Signature target) {
    state = state.where((todo) => todo.pubkey != target.pubkey).toList();
  }
}

final signatureListProvider = StateNotifierProvider<SignatureList>((ref) => SignatureList([
      Signature(type: 'testType', ethvatar: 'testEthVatar', pubkey: 'ethPubKey')
    ]));
