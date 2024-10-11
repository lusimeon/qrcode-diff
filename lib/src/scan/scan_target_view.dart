import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qrcode_diff/src/scan/scanner/scanner_with_overlay.dart';

class ScanTargetView extends StatelessWidget {
  const ScanTargetView({
    super.key,
    required this.scanSuccessCallback,
    required this.formSuccessCallback,
    this.value,
  });

  final String? value;

  final Function(Barcode?) scanSuccessCallback;

  final Function(Barcode?) formSuccessCallback;

  Widget wrappedScanner(BuildContext context) {
    return Container(
      child: ScannerWithOverlay(
        successCallback: (Barcode? barcode) {
          scanSuccessCallback(barcode);
          Navigator.pop(context);
        },
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Text(
          'Select the target provider',
        ),
        ElevatedButton(
          child: const Text('Scan QR code'),
          onPressed: () {
            showModalBottomSheet<void>(
              context: context,
              builder: wrappedScanner
            );
          },
        ),
        ElevatedButton(
          child: const Text('Insert an URL'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ScannerWithOverlay(
                successCallback: formSuccessCallback,
              )),
            );  
          },
        ),
      ],
    );
  }
}
