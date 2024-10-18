import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannedBarcodeLabel extends StatelessWidget {
  const ScannedBarcodeLabel({
    super.key,
    required this.barcodes,
    this.color = Colors.white,
  });

  final Color color;

  final Stream<BarcodeCapture> barcodes;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: barcodes,
      builder: (context, snapshot) {
        final scannedBarcodes = snapshot.data?.barcodes ?? [];

        if (scannedBarcodes.isEmpty) {
          return Text(
            'Scan something!',
            overflow: TextOverflow.fade,
            style: TextStyle(color: color),
          );
        }

        return Text(
          scannedBarcodes.first.displayValue ?? 'No display value.',
          overflow: TextOverflow.fade,
          style: TextStyle(color: color),
        );
      },
    );
  }
}
