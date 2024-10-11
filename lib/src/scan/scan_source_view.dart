import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qrcode_diff/src/scan/scanner/scanner_with_overlay.dart';

class ScanSourceView extends StatelessWidget {
  const ScanSourceView({
    super.key,
    required this.successCallback,
    this.value,
  });

  final String? value;

  final Function(Barcode?) successCallback;

  Widget wrappedScanner(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          ScannerWithOverlay(
            successCallback: (Barcode? barcode) {
              successCallback(barcode);
              Navigator.pop(context);
            },
          )
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          child: const Text('Source QR code'),
          onPressed: () {
            showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              builder: wrappedScanner,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.85,
              ),
            );
          },
        )
      ],
    );
  }
}
