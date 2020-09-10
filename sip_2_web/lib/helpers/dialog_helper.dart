import 'package:flutter/material.dart';
import 'package:sip_2/dialogs/exit_confirmation_dialog.dart';
import 'package:sip_2/dialogs/qr_scanner.dialog.dart';

// Controls the routes for our custom Dialogs
class DialogHelper {
  static showBarcode(context, var barcodeText) => showDialog(
      context: context,
      builder: (context) => BarcodeDialog(
            barcodeText: barcodeText,
          ));

  static showScanner(context, var data) => showDialog(
      context: context,
      builder: (context) => QRScannerDialog(
            data: data,
          ));
}
