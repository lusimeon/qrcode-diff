import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qrcode_diff/src/global/modal_bottom_view.dart';
import 'package:qrcode_diff/src/scan/scanner/scanner_with_overlay_view.dart';

class ScanTargetView extends StatefulWidget {
  const ScanTargetView({
    super.key,
    required this.scanSuccessCallback,
  });

  final Function(String) scanSuccessCallback;

  @override
  ScanTargetViewState createState() {
    return ScanTargetViewState();
  }
}

class ScanTargetViewState extends State<ScanTargetView> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(16),
                  child: const Text(
                    'Select the target provider',
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          ElevatedButton(
                            child: const Text('Scan QR code'),
                            onPressed: () => showModalBottomView(
                              context: context,
                              title: 'Scan the QR code',
                              body: ScannerWithOverlay(
                                backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
                                successCallback: (Barcode? barcode) {
                                  final value = barcode?.displayValue;

                                  if (value == null) {
                                    return;
                                  }

                                  Navigator.pop(context);

                                  widget.scanSuccessCallback(value);
                                },
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(16),
                            child: const Text('or'),
                          ),
                          ExpansionTile(
                            title: const Text('Insert a text'),
                            children: <Widget>[
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Text to compare',
                                ),
                                onSaved: (value) {
                                  if (value == null) {
                                    return;
                                  }

                                  widget.scanSuccessCallback(value);
                                },
                              ),
                              ElevatedButton(
                                child: const Text('Save'),
                                onPressed: () {
                                  final state = _formKey.currentState;

                                  if (state == null) {
                                    return;
                                  }

                                  state.save();
                                },
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
          ),
        ],
      ),
    );
  }
}
