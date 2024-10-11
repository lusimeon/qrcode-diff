import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qrcode_diff/src/scan/scanner/scanner_open_image_view.dart';
import 'package:qrcode_diff/src/scan/scanner/scanner_flashlight_view.dart';
import 'package:qrcode_diff/src/scan/scanner/scanner_error_view.dart';

class ScannerWithOverlay extends StatefulWidget {
  const ScannerWithOverlay({super.key, required this.successCallback});

  final Function(Barcode?) successCallback;

  @override
  ScannerWithOverlayState createState() => ScannerWithOverlayState();
}

class ScannerWithOverlayState extends State<ScannerWithOverlay> {
  final MobileScannerController controller = MobileScannerController(
    formats: const [BarcodeFormat.qrCode],
    torchEnabled: false,
    returnImage: false,
  );

  void _handleBarcode(BarcodeCapture barcodes) {
    if (!mounted || null == barcodes.raw) {
      return;
    }

    widget.successCallback(barcodes.barcodes.firstOrNull);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    final scanWindow = Rect.fromCenter(
      width: size.width * 0.75,
      height: size.width * 0.75,
      center: size.center(Offset.zero),
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        Center(
          child: MobileScanner(
            fit: BoxFit.contain,
            controller: controller,
            scanWindow: scanWindow,
            errorBuilder: (context, error, child) {
              return ScannerErrorWidget(error: error);
            },
            onDetect: _handleBarcode,
          ),
        ),
        ValueListenableBuilder(
          valueListenable: controller,
          builder: (context, value, child) {
            if (!value.isInitialized ||
                !value.isRunning ||
                value.error != null) {
              return const SizedBox();
            }

            return CustomPaint(
              painter: ScannerOverlay(scanWindow: scanWindow),
            );
          },
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.all(size.height * 0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ToggleFlashlightButton(controller: controller),
                AnalyzeImageFromGalleryButton(controller: controller),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await controller.dispose();
  }
}

class ScannerOverlay extends CustomPainter {
  const ScannerOverlay({
    required this.scanWindow,
    this.borderRadius = 12.0,
  });

  final Rect scanWindow;
  final double borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPath = Path()..addRect(Rect.largest);

    final cutoutPath = Path()
      ..addRRect(
        RRect.fromRectAndCorners(
          scanWindow,
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
          bottomLeft: Radius.circular(borderRadius),
          bottomRight: Radius.circular(borderRadius),
        ),
      );

    final backgroundPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    final backgroundWithCutout = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );

    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    final borderRect = RRect.fromRectAndCorners(
      scanWindow,
      topLeft: Radius.circular(borderRadius),
      topRight: Radius.circular(borderRadius),
      bottomLeft: Radius.circular(borderRadius),
      bottomRight: Radius.circular(borderRadius),
    );

    canvas.drawPath(backgroundWithCutout, backgroundPaint);
    canvas.drawRRect(borderRect, borderPaint);
  }

  @override
  bool shouldRepaint(ScannerOverlay oldDelegate) {
    return scanWindow != oldDelegate.scanWindow ||
        borderRadius != oldDelegate.borderRadius;
  }
}
