import 'package:qrcode_diff/src/scan/scan_model.dart';
import 'package:qrcode_diff/src/scan/scan_service.dart';

class ScanRepository {
  ScanRepository();

  final ScanService _scanService = ScanService();

  Future<String> getDiff(ScanModel model) async {
    final source = model.source;
    final target = model.target;

    if (source == null || target == null) {
      return '';
    }

    final res = await _scanService.getDiff(source, target);

    return res['imageBase64'] ?? '';

  }
}
