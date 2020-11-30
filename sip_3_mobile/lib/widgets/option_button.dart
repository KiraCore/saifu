import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:memoryfilepicker/memoryfilepicker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sip_3_mobile/models/account_model.dart';
import 'package:sip_3_mobile/widgets/create_account_modal.dart';

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

  Future<void> _openFileContent(BuildContext context, List<Account> accountState) async {
    final selectedFile = await MemoryFilePicker.getFile(type: FileType.custom, allowedExtensions: [
      'txt'
    ]);
    file = File(selectedFile.path);
    String contents = await file.readAsStringSync();
    var fileContent = jsonDecode(contents);
    accountState.add(Account(ethvatar: 'New Account', type: null, privkey: fileContent['privkey'], pubkey: fileContent['pubkey']));
    final String encodeData = Account.encodeAccounts(accountState);
    await storage.write(key: 'database', value: encodeData);
  }

  Future<void> _openFile(BuildContext context, List<Account> accountState) async {
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
    accountState.add(Account(ethvatar: 'New Account', type: null, privkey: fileContent['privkey'], pubkey: fileContent['pubkey']));
    final String encodeData = Account.encodeAccounts(accountState);
    await storage.write(key: 'database', value: encodeData);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, _) {
      // ignore: invalid_use_of_protected_member
      final accountState = watch(accountListProvider).state;
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
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateAccount()));
                  } else if (widget.option == 'Import private key as plaintext') {
                    _openFileContent(context, accountState);
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
