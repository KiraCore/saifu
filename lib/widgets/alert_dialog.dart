import 'package:flutter/material.dart';

Future<String> createAlertDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            Text("Are you sure you want to delete?"),
            Text('This action cannot be undone'),
          ]),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
                child: Text(
                  "Delete",
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () => Navigator.of(context).pop('Delete')),
          ],
        );
      });
}
