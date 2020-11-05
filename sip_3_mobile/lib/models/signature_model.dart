import 'dart:convert';
import 'package:flutter_riverpod/all.dart';

class Signature {
  Signature({this.type, this.ethvatar, this.pubkey, this.privkey});

  final String type;
  final String ethvatar;
  final String pubkey;
  final String privkey;

  factory Signature.fromJson(Map<String, dynamic> jsonData) {
    return Signature(type: jsonData['type'], ethvatar: jsonData['ethvatar'], pubkey: jsonData['pubkey'], privkey: jsonData['privkey']);
  }

  static Map<String, dynamic> toMap(Signature signature) => {
        'type': signature.type,
        'ethvatar': signature.ethvatar,
        'pubkey': signature.pubkey,
        'privkey': signature.privkey
      };

  static String encodeSignatures(List<Signature> signatures) => json.encode(
        signatures.map<Map<String, dynamic>>((signature) => Signature.toMap(signature)).toList(),
      );

  static List<Signature> decodeSignatures(String signatures) => (json.decode(signatures) as List<dynamic>).map<Signature>((item) => Signature.fromJson(item)).toList();
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
    SupportedTypes(type: 'KeyBase', image: 'https://res-3.cloudinary.com/crunchbase-production/image/upload/c_lpad,h_256,w_256,f_auto,q_auto:eco/v1505765479/zghucdtjjevivjihplty.png'),
  ];
}

class SignatureList extends StateNotifier<List<Signature>> {
  SignatureList(List<Signature> initialList) : super(initialList ?? []);

  void add(String type, String ethvatar, String pubkey, String privkey) {
    state = [
      ...state,
      Signature(type: type, ethvatar: ethvatar, pubkey: pubkey, privkey: privkey)
    ];
  }

  void remove(Signature target) {
    state = state.where((todo) => todo.pubkey != target.pubkey).toList();
  }
}

final signatureListProvider = StateNotifierProvider<SignatureList>((ref) => SignatureList([]));
