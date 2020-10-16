import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = new FlutterSecureStorage();
const Color greys = Color.fromRGBO(241, 241, 241, 1);

class Constants {
  static const String Export = 'Export Account';
  static const String Forget = 'Forget Account';

  static const List<String> choices = <String>[
    Export,
    Forget
  ];
}
