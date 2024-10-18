import 'package:mobile_scanner/mobile_scanner.dart';

class ScanModel {
  ScanModel({
    this.source,
    this.target,
  });

  Barcode? source, target;

  bool get isReady => source != null && target != null;

  factory ScanModel.fromJson(Map<String, String> json) {
    return ScanModel(
      target: Barcode(displayValue: json['target']),
      source: Barcode(displayValue: json['source']),
    );
  }
}
