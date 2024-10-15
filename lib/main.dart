import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:qrcode_diff/firebase_options.dart';
import 'package:qrcode_diff/src/scan/scan_controller.dart';
import 'src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  configureFirebaseEmulators();

  runApp(App(
    scanController: ScanController(),
  ));
}

void configureFirebaseEmulators() {
  const String emulatorHost = bool.hasEnvironment('EMULATOR_HOST')
      ? String.fromEnvironment('EMULATOR_HOST', defaultValue: '')
      : '';

  if (emulatorHost.isNotEmpty) {
    const int functionsEmulatorPort =
        bool.hasEnvironment('FUNCTIONS_EMULATOR_PORT')
            ? int.fromEnvironment('FUNCTIONS_EMULATOR_PORT',
                defaultValue: 5001)
            : 5001;

    FirebaseFunctions.instance
        .useFunctionsEmulator(emulatorHost, functionsEmulatorPort);
  }
}
