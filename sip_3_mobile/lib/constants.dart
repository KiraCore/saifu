import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = new FlutterSecureStorage();
const Color greys = Color.fromRGBO(241, 241, 241, 1);

enum ListViewOptions {
  Export,
  Forget,
}

enum AccountOptions {
  Copy,
  Share,
  Base64
}
