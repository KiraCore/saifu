import 'package:flutter/material.dart';
import 'package:sip_3_mobile/screens/create_signature.dart';

class OptionButton extends StatelessWidget {
  final option;

  const OptionButton({this.option});
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              onTap: () {
                if (option == 'Create a new wallet') {
                  Navigator.pop(context);
                  Future.delayed(Duration(seconds: 5));
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateSignature()));
                }
              },
              splashColor: Colors.purple,
              child: Card(
                color: Colors.white,
                shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                borderOnForeground: true,
                elevation: 0,
                child: ListTile(
                  title: Text(
                    option,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w300, color: Colors.black),
                  ),
                ),
              ),
            )));
  }
}
