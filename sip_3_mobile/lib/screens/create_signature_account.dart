import 'package:flutter/material.dart';
import 'package:sip_3_mobile/widgets/create_pgp_widget.dart';

class SignatureAccount extends StatelessWidget {
  final String type;
  SignatureAccount({this.type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(type),
        elevation: 0.0,
        centerTitle: true,
      ),
      body: CreatePGPAccountForm(),
    );
  }
}
