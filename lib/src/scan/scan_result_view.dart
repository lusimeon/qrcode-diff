import 'package:flutter/material.dart';

class ScanResultView extends StatelessWidget {
  const ScanResultView({super.key});

  static const routeName = '/scan/result';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'See below the result of the scan',
            ),
          ],
        ),
      ),
    );
  }
}
