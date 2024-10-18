import 'package:cloud_functions/cloud_functions.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qrcode_diff/src/global/api_exception.dart';

class ScanService {
  ScanService();

  Future<Map> getDiff(Barcode source, Barcode target) async {
    try {
      final res = await FirebaseFunctions.instance.httpsCallable('generate_diff').call({
        'source': source.displayValue,
        'target': target.displayValue,
        'output': 'highlight',
      });

      if (res.data['error'] != null) {
        throw ApiException(message: res.data['error'], type: ApiExceptionType.warning);
      }

      return res.data;
    } on FirebaseFunctionsException catch (e) {
      throw ApiException(message: e.message);
    }
  }
}
