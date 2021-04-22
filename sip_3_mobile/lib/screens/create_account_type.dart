import 'package:flutter/material.dart';
import 'package:sip_3_mobile/screens/create_kira_account.dart';

class CreateAccountType extends StatefulWidget {
  final String type;
  CreateAccountType({this.type});

  @override
  _CreateAccountTypeState createState() => _CreateAccountTypeState();
}

class _CreateAccountTypeState extends State<CreateAccountType> {
  @override
  Widget build(BuildContext context) {
    return widget.type == 'KIRA' ? CreateKiraAccount() : Container();
  }
}
