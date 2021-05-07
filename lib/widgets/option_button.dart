import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:saifu/screens/import_qrcode.dart';
import 'package:saifu/widgets/create_account.dart';
import 'package:saifu/widgets/custom_button.dart';

class FloatingButton extends StatefulWidget {
  final option;
  FloatingButton({this.option});

  @override
  _FloatingButtonState createState() => _FloatingButtonState();
}

class _FloatingButtonState extends State<FloatingButton> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, _) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomButton(
              style: 4,
              text: widget.option,
              onButtonClick: () {
                if (widget.option == 'Create a new wallet') {
                  Navigator.pop(context);
                  Future.delayed(Duration(seconds: 5));
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateAccount()));
                } else if (widget.option == 'Import private key via Qrcode') {
                  showDialog(context: context, builder: (context) => ImportQrcodeScanner());
                }
              },
            ),
          ],
        ),
      );
    });
  }
}
