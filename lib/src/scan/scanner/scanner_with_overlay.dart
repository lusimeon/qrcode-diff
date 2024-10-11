import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qrcode_diff/src/scan/scanner/scanner_open_image_view.dart';
import 'package:qrcode_diff/src/scan/scanner/scanner_flashlight_view.dart';
import 'package:qrcode_diff/src/scan/scanner/scanner_error_view.dart';

class ScannerWithOverlay extends StatefulWidget {
  const ScannerWithOverlay({
    super.key,
    required this.successCallback,
    this.backgroundColor = Colors.white,
    this.borderColor = Colors.black,
  });

  final Color backgroundColor;

  final Color borderColor;

  final Function(Barcode?) successCallback;

  @override
  ScannerWithOverlayState createState() => ScannerWithOverlayState();
}

class ScannerWithOverlayState extends State<ScannerWithOverlay> with SingleTickerProviderStateMixin {
  bool _handled = false;

  late Animation<Color?> _successColorTween;

  late AnimationController _successAnimationController;

  final MobileScannerController _scannerController = MobileScannerController(
    formats: const [BarcodeFormat.qrCode],
  );

  @override
  void initState() {
    _successAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300)
    );

    _successColorTween = ColorTween(begin: widget.borderColor, end: Colors.green)
      .animate(_successAnimationController)
      ..addListener(() {
        if (!mounted) {
          return;
        }

        setState(() {});
      });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    final scanWindow = Rect.fromCenter(
      width: size.width * 0.75,
      height: size.width * 0.75,
      center: Offset(size.width / 2, size.height / 3.5),
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        Center(
          child: MobileScanner(
            fit: BoxFit.contain,
            controller: _scannerController,
            scanWindow: scanWindow,
            scanWindowUpdateThreshold: 0.5,
            errorBuilder: (context, error, child) {
              return ScannerErrorWidget(error: error);
            },
            onDetect: _handleBarcode,
          ),
        ),
        ValueListenableBuilder(
          valueListenable: _scannerController,
          builder: (context, value, child) {
            if (!value.isInitialized ||
                !value.isRunning ||
                value.error != null) {
              return const SizedBox();
            }

            return CustomPaint(
              painter: ScannerOverlay(
                scanWindow: scanWindow,
                backgroundColor: widget.backgroundColor,
                borderColor: _successColorTween.value ?? widget.borderColor,
              ),
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
                ToggleFlashlightButton(controller: _scannerController, color: widget.borderColor),
                AnalyzeImageFromGalleryButton(controller: _scannerController, color: widget.borderColor),
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
    _successAnimationController.dispose();
    await _scannerController.dispose();
  }

  void _handleBarcode(BarcodeCapture barcodes) {
    if (_handled) {
      return;
    }

    if (!mounted || null == barcodes.raw) {
      return;
    }

    setState(() {
      _handled = true;
    });

    _successAnimationController.repeat(reverse: true);

    Future.delayed(const Duration(seconds: 1), () {
      _successAnimationController.stop();
      widget.successCallback(barcodes.barcodes.firstOrNull);
    });
  }
}

class ScannerOverlay extends CustomPainter {
  const ScannerOverlay({
    required this.scanWindow,
    required this.backgroundColor,
    required this.borderColor,
    this.borderRadius = 12.0,
  });

  final Rect scanWindow;
  final double borderRadius;
  final Color borderColor;
  final Color backgroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPath = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

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
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    final backgroundWithCutout = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0;

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
    return true;
  }
}
