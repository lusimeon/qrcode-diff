import 'package:flutter/material.dart';
import 'package:qrcode_diff/src/scan/scan_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code diff'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {},
          ),
        ],
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: const Text('Scan QR code'),
              onPressed: () {
                Navigator.restorablePushNamed(
                  context,
                  ScanView.routeName,
                );
              },
            ),
          ],
        )
      )
    );
  }
}
