import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qrcode_diff/src/scan/scan_model.dart';
import 'package:qrcode_diff/src/scan/scan_repository.dart';

class ScanController extends ChangeNotifier {
  final ScanModel _scan = ScanModel();

  final ScanRepository _scanRepository = ScanRepository();

  Uint8List _diff = Uint8List(0);

  ScanModel get scan => _scan;

  Uint8List get diff => _diff;

  bool get canGenerateDiff => _scan.isReady;

  void setTarget(Barcode? value) {
    _scan.target = value;

    notifyListeners();
  }

  void setSource(Barcode? value) {
    _scan.source = value;

    notifyListeners();
  }

  Future<void> generateDiff() async {
    if (!_scan.isReady) {
      return;
    }

    final res = await _scanRepository.computeDiff(_scan);

    _diff = base64Decode(res);
  }
}
