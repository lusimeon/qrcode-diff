import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qrcode_diff/src/global/modal_bottom_view.dart';
import 'package:qrcode_diff/src/scan/scanner/scanner_with_overlay.dart';

class ScanTargetView extends StatelessWidget {
  const ScanTargetView({
    super.key,
    required this.scanSuccessCallback,
    required this.formSuccessCallback,
  });

  final Function(Barcode?) scanSuccessCallback;

  final Function(Barcode?) formSuccessCallback;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(16),
            child: const Text(
              'Select the target provider',
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Column(
                  children: [
                    ElevatedButton(
                      child: const Text('Scan QR code'),
                      onPressed: () => showModalBottomView(
                        context: context,
                        title: 'Scan the QR code',
                        body: ScannerWithOverlay(
                          backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
                          successCallback: (Barcode? barcode) {
                            scanSuccessCallback(barcode);
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: const Text('or'),
                    ),
                    ElevatedButton(
                      child: const Text('Insert an URL'),
                      onPressed: () {},
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
