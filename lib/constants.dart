import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = new FlutterSecureStorage();

enum ListViewOptions {
  Forget,
}

enum AccountOptions {
  Copy,
  Share,
  Base64
}

class Constants {
  static const String Change = "Change Password";
  static const String About = "About us";

  static const List<String> choices = <String>[
    Change,
    About
  ];
}
