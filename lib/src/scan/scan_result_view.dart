import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:qrcode_diff/src/scan/scan_model.dart';

class ScanResultView extends StatelessWidget {
  const ScanResultView({
    super.key,
    required this.scan,
    this.resultImage,
  });

  final ScanModel scan;

  final Uint8List? resultImage;

  List<Map<String, dynamic>> getRows() {
    return [
      {'label': 'Source', 'value': scan.source, },
      {'label': 'Target', 'value': scan.target, },
      {'label': 'Same?', 'value': scan.target == scan.source ? 'Same' : 'Not same', }
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: const Text(
              'See below the result of the scan',
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Column(
                  children: [
                    resultImage != null
                      ? Image.memory(resultImage!)
                      : const CircularProgressIndicator(),
                    Table(
                      border: TableBorder.all(),
                      children: [
                        for (var row in getRows())
                          TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(row['label']),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(row['value'] ?? '', textAlign: TextAlign.center,),
                              ),
                            ],
                          ),
                      ],
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
