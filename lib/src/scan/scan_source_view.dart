import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qrcode_diff/src/global/modal_bottom_view.dart';
import 'package:qrcode_diff/src/scan/scanner/scanner_with_overlay.dart';

class ScanSourceView extends StatelessWidget {
  const ScanSourceView({
    super.key,
    required this.successCallback,
  });

  final Function(Barcode?) successCallback;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: const Text(
              'Select the source provider',
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Column(
                  children: [
                    ElevatedButton(
                      child: const Text('Source QR code'),
                      onPressed: () => showModalBottomView(
                        context: context,
                        title: 'Scan the QR code',
                        body: ScannerWithOverlay(
                          backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
                          successCallback: (Barcode? barcode) {
                            successCallback(barcode);
                            Navigator.pop(context);
                          },
                        )
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
