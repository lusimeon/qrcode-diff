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
  bool _textInputTileExpanded = false;

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
                            textColor: Theme.of(context).colorScheme.primary,
                            collapsedTextColor: Theme.of(context).colorScheme.primary,
                            collapsedBackgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
                            collapsedIconColor: Theme.of(context).colorScheme.primary,
                            backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                            ),
                            title: const Text('Use a text'),
                            trailing: RotatedBox(
                              quarterTurns: _textInputTileExpanded
                                  ? 2
                                  : 0,
                              child: const Icon(Icons.arrow_drop_down_circle)
                            ),
                            onExpansionChanged: (bool expanded) => setState(() {
                              _textInputTileExpanded = expanded;
                            }),
                            childrenPadding: const EdgeInsets.all(16),
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 32 ),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    labelStyle: TextStyle(fontStyle: FontStyle.italic),
                                    labelText: 'Insert your text…',
                                  ),
                                  onSaved: (value) {
                                    if (value == null) {
                                      return;
                                    }

                                    widget.scanSuccessCallback(value);
                                  },
                                ),
                              ),
                              ElevatedButton(
                                child: const Text('Process'),
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
