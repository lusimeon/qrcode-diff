import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qrcode_diff/src/scan/scan_result_view.dart';
import 'package:qrcode_diff/src/scan/scan_source_view.dart';
import 'package:qrcode_diff/src/scan/scan_target_view.dart';

class ScanView extends StatefulWidget {
  const ScanView({super.key});

  static const routeName = '/scan';

  @override
  ScanViewState createState() => ScanViewState();
}

class ScanViewState extends State<ScanView> {
  List<GlobalKey<FormState>> _formKeys = [];

  int _currentStep = 0;

  String? _source;

  String? _target;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stepper(
        steps: getSteps(),
        type: StepperType.horizontal,
        currentStep: _currentStep,
        onStepContinue: () => goToStep(_currentStep += 1),
        onStepTapped: (step) => goToStep(step),
        controlsBuilder: (context, ControlsDetails details) {
          return const Row(
            children: [],
          );
        },
      ),
    );
  }

  void goToStep(int step) {
    if (step < 0 || step > getSteps().length - 1) {
      return;
    }

    if (step == 1 && _source == null) {
      return;
    }

    if (step == 2 && (_source == null || _target == null)) {
      return;
    }

    setState(() {
      _currentStep = step;
    });
  }

  void setSource(String? value) {
    setState(() {
      _source = value;
    });

    goToStep(1);
  }

  void setTarget(String? value) {
    setState(() {
      _target = value;
    });


    goToStep(2);
  }

  List<Step> getSteps() {
    return <Step>[
      Step(
        state: _currentStep > 0 ? StepState.complete : StepState.indexed,
        isActive: _currentStep >= 0,
        title: const Text('Source'),
        content: ScanSourceView(
          successCallback: (Barcode? barcode) => setSource(barcode?.displayValue),
        ),
      ),
      Step(
        state: _currentStep > 1 ? StepState.complete : StepState.indexed,
        isActive: _currentStep >= 1,
        title: const Text('Target'),
        content: ScanTargetView(
          scanSuccessCallback: (Barcode? barcode) => setTarget(barcode?.displayValue),
          formSuccessCallback: (Barcode? barcode) => setTarget(barcode?.displayValue),
        ),
      ),
      Step(
        state: _currentStep > 2 ? StepState.complete : StepState.indexed,
        isActive: _currentStep >= 2,
        title: const Text('Result'),
        content: ScanResultView(
          source: _source ?? '',
          target: _target ?? '',
        ),
      ),
    ];
  }
}
