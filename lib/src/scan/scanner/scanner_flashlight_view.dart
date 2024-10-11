import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ToggleFlashlightButton extends StatelessWidget {
  const ToggleFlashlightButton({
    super.key,
    required this.controller,
    this.color = Colors.white,
  });

  final Color color;

  final MobileScannerController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, state, child) {
        if (!state.isInitialized || !state.isRunning) {
          return const SizedBox.shrink();
        }

        switch (state.torchState) {
          case TorchState.auto:
            return IconButton(
              color: color,
              iconSize: 32.0,
              icon: const Icon(Icons.flash_auto),
              onPressed: () async {
                await controller.toggleTorch();
              },
            );
          case TorchState.off:
            return IconButton(
              color: color,
              iconSize: 32.0,
              icon: const Icon(Icons.flash_off),
              onPressed: () async {
                await controller.toggleTorch();
              },
            );
          case TorchState.on:
            return IconButton(
              color: color,
              iconSize: 32.0,
              icon: const Icon(Icons.flash_on),
              onPressed: () async {
                await controller.toggleTorch();
              },
            );
          case TorchState.unavailable:
            return SizedBox.square(
              dimension: 48.0,
              child: Icon(
                Icons.no_flash,
                size: 32.0,
                color: color.withOpacity(0.5),
              ),
            );
        }
      },
    );
  }
}