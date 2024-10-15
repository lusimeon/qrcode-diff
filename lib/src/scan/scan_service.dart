import 'package:cloud_functions/cloud_functions.dart';

class ScanService {
  ScanService();

  Future getDiff(String source, String target) async {
    final res = await FirebaseFunctions.instance.httpsCallable('generate_diff').call({
      'source': source,
      'target': target,
      'output': 'highlight',
    });

    return res.data;
  }
}
