import 'package:flutter/material.dart';

class ScannerOverlay extends StatelessWidget {
  final Color overlayColor;
  //final double scanAreaSize;
  final double borderWidth;
  final double borderRadius;
  final double scanAreaWidth;
  final double scanAreaHeight;

  ScannerOverlay({
    this.overlayColor = Colors.black,
    //this.scanAreaSize = 200.0,
    this.borderWidth = 4,
    this.borderRadius = 20.0,
    this.scanAreaWidth = 200.0,
    this.scanAreaHeight = 200.0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomOverlayPainter(
          overlayColor: overlayColor,
          borderWidth: borderWidth,
          borderRadius: borderRadius,
          scanAreaWidth: scanAreaWidth,
          scanAreaHeight: scanAreaHeight,
        ),
        Align(
          alignment: Alignment.center,
          child: CustomPaint(
            foregroundPainter: BorderPainter(
              borderWidth: borderWidth,
              borderRadius: borderRadius,
            ),
            child: SizedBox(
              width: scanAreaWidth + 25,
              height: scanAreaHeight + 25,
            ),
          ),
        ),
      ],
    );
  }
}

class CustomOverlayPainter extends StatelessWidget {
  final Color overlayColor;
  final double borderWidth;
  final double borderRadius;
  final double scanAreaWidth;
  final double scanAreaHeight;

  CustomOverlayPainter({
    this.overlayColor = Colors.white,
    this.borderWidth = 4.0,
    this.borderRadius = 20.0,
    this.scanAreaWidth = 200.0,
    this.scanAreaHeight = 200.0,
  });

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        overlayColor,
        BlendMode.srcOut,
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.red,
              backgroundBlendMode: BlendMode.dstOut,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: Container(
                height: scanAreaHeight,
                width: scanAreaWidth,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class BorderPainter extends CustomPainter {
  final double borderWidth;
  final double borderRadius;
  

  BorderPainter({
    this.borderWidth = 4.0,
    this.borderRadius = 20.0,

  });

  @override
  void paint(Canvas canvas, Size size) {
    final double tRadius = 3 * borderRadius;
    final rect = Rect.fromLTWH(
      borderWidth,
      borderWidth,
      size.width -2 * borderWidth,
      size.height -2 * borderWidth,
    );
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));
    final clippingRect0 = Rect.fromLTWH(0, 0, tRadius, tRadius);
    final clippingRect1 = Rect.fromLTWH(size.width - tRadius, 0, tRadius, tRadius);
    final clippingRect2 = Rect.fromLTWH(0, size.height - tRadius, tRadius, tRadius);
    final clippingRect3 = Rect.fromLTWH(size.width - tRadius, size.height - tRadius, tRadius, tRadius);

    final path = Path()
      ..addRect(clippingRect0)
      ..addRect(clippingRect1)
      ..addRect(clippingRect2)
      ..addRect(clippingRect3);

    canvas.clipPath(path);
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = borderWidth,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
