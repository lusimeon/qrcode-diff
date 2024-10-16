import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class AnalyzeImageFromGalleryButton extends StatelessWidget {
  const AnalyzeImageFromGalleryButton({
    super.key,
    required this.controller,
    this.onDetect,
    this.color = Colors.white,
  });

  final Color color;

  final MobileScannerController controller;

  final Function(BarcodeCapture)? onDetect;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: color,
      icon: const Icon(Icons.image),
      iconSize: 32.0,
      onPressed: () async {
        final ImagePicker picker = ImagePicker();

        final XFile? image = await picker.pickImage(
          source: ImageSource.gallery,
        );

        if (image == null) {
          return;
        }

        final BarcodeCapture? barcodes = await controller.analyzeImage(
          image.path,
        );

        if (!context.mounted || barcodes == null) {
          return;
        }

        onDetect!(barcodes);
      },
    );
  }
}
