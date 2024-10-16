import 'package:flutter/material.dart';
import 'package:qrcode_diff/src/scan/scan_controller.dart';
import 'package:qrcode_diff/src/scan/scan_result_view.dart';
import 'package:qrcode_diff/src/scan/scan_source_view.dart';
import 'package:qrcode_diff/src/scan/scan_target_view.dart';

class ScanView extends StatefulWidget {
  const ScanView({super.key, required this.controller});

  static const routeName = '/scan';

  final ScanController controller;

  @override
  ScanViewState createState() {
    return ScanViewState();
  }
}

class ScanViewState extends State<ScanView> {
  int _stepIndex = 0;

  void goToStep(int value) {
    if (value == 1 && widget.controller.scan.source == null) {
      return;
    }

    if (value == 2 && !widget.controller.canGenerateDiff) {
      return;
    }

    setState(() {
      _stepIndex = value;
    });
  }

  void nextStep() {
    return goToStep(_stepIndex + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stepper(
        type: StepperType.horizontal,
        currentStep: _stepIndex,
        onStepContinue: () => nextStep(),
        onStepTapped: (step) => goToStep(step),
        controlsBuilder: (context, ControlsDetails details) {
          return const Row(
            children: [],
          );
        },
        steps: <Step>[
          Step(
            state: widget.controller.scan.source != null ? StepState.complete : StepState.indexed,
            isActive: _stepIndex >= 0,
            title: const Text('Source'),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ScanSourceView(
                  scanSuccessCallback: (String value) async {
                    await widget.controller.setSource(value);
                    goToStep(1);
                  },
                ),
              ],
            ),
          ),
          Step(
            state: widget.controller.scan.target != null ? StepState.complete : StepState.indexed,
            isActive: _stepIndex >= 1,
            title: const Text('Target'),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ScanTargetView(
                  scanSuccessCallback: (String value) async {
                    await widget.controller.setTarget(value);
                    goToStep(2);
                  },
                ),
              ]
            ),
          ),
          Step(
            state: StepState.indexed,
            isActive: _stepIndex >= 2,
            title: const Text('Result'),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ScanResultView(
                  scan: widget.controller.scan,
                  resultImage: widget.controller.diff,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
