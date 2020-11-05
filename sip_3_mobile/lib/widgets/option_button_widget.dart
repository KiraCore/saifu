import 'dart:convert';
import 'dart:io';

import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sip_3_mobile/models/signature_model.dart';
import 'package:sip_3_mobile/screens/create_signature.dart';

import '../constants.dart';

class OptionButton extends StatefulWidget {
  final option;

  OptionButton({this.option});

  @override
  _OptionButtonState createState() => _OptionButtonState();
}

class _OptionButtonState extends State<OptionButton> {
  var rootPath;
  var filePickerSelectMode;
  File file;
  String filePath;

  Future<void> _openFile(BuildContext context, List<Signature> signaturestate) async {
    rootPath = await getApplicationDocumentsDirectory();
    String path = await FilesystemPicker.open(
      context: context,
      rootDirectory: rootPath,
      fsType: FilesystemType.file,
      folderIconColor: Colors.white,
      fileTileSelectMode: filePickerSelectMode,
      requestPermission: () async => Permission.storage.request().isGranted,
    );
    file = File('$path');
    String contents = await file.readAsString();
    var fileContent = jsonDecode(contents);
    signaturestate.add(Signature(ethvatar: 'UNKNOWN', type: 'UnknownType', privkey: fileContent['privkey'], pubkey: fileContent['pubkey']));
    final String encodeData = Signature.encodeSignatures(signaturestate);
    await storage.write(key: 'database', value: encodeData);
    setState(() {
      filePath = path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, _) {
      final signaturestate = watch(signatureListProvider).state;
      return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: InkWell(
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onTap: () {
                  if (widget.option == 'Create a new wallet') {
                    Navigator.pop(context);
                    Future.delayed(Duration(seconds: 5));
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateSignature()));
                  } else if (widget.option == 'Import private key as plaintext') {
                    _openFile(context, signaturestate);
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
                      widget.option,
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w300, color: Colors.black),
                    ),
                  ),
                ),
              )));
    });
  }
}
