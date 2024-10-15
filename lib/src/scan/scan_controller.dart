import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:qrcode_diff/src/scan/scan_model.dart';
import 'package:qrcode_diff/src/scan/scan_repository.dart';

class ScanController extends ChangeNotifier {
  final ScanModel _scan = ScanModel();

  final ScanRepository _scanRepository = ScanRepository();

  Uint8List _diff = Uint8List(0);

  ScanModel get scan => _scan;

  Uint8List get diff => _diff;

  bool get canGenerateDiff => _scan.isReady;

  Future<void> setTarget(String? value) async {
    _scan.target = value;
    await generateDiff();
  }

  Future<void> setSource(String? value) async {
    _scan.source = value;
    await generateDiff();
  }

  Future<void> generateDiff() async {
    if (!_scan.isReady) {
      return;
    }

    final res = await _scanRepository.getDiff(_scan);

    _diff = base64Decode(res);

    notifyListeners();
  }
}
