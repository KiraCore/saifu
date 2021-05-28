import 'dart:convert';

import 'package:sacco/sacco.dart';

class TranscationofflineSignerMobile {
  static Map<String, dynamic> signMobileTxData(String mnemonicData, String bodyData, String bech32Hrp) {
    final networkInfo = NetworkInfo(
      bech32Hrp: "$bech32Hrp",
      lcdUrl: "",
    );

    final mnemonic = mnemonicData.split(" ");
    final wallet = Wallet.derive(mnemonic, networkInfo);
    var bytes = utf8.encode(bodyData);
    final signatureData = wallet.signTxData(bytes);
    final pubKeyCompressed = wallet.ecPublicKey.Q.getEncoded(true);
    final base64Signature = base64Encode(signatureData);
    final base64PubKey = base64Encode(pubKeyCompressed);
    final stdPublicKey = StdPublicKey(type: '/cosmos.crypto.secp256k1.PubKey', value: base64PubKey);

    Map<String, dynamic> map = {
      'signature': base64Signature,
      'publicKey': stdPublicKey
    };

    return map;
  }
}
