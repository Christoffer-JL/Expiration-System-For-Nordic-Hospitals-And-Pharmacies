import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class CameraControlsWidget extends StatelessWidget {
  final MobileScannerController controller;

  const CameraControlsWidget({super.key, 
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          color: Colors.white,
          icon: ValueListenableBuilder(
            valueListenable: controller.torchState,
            builder: (context, state, child) {
              switch (state) {
                case TorchState.off:
                  return const Icon(Icons.flash_off, color: Colors.grey);
                case TorchState.on:
                  return const Icon(Icons.flash_on, color: Colors.yellow);
              }
            },
          ),
          iconSize: 32.0,
          onPressed: () => controller.toggleTorch(),
        ),
        IconButton(
          color: Colors.white,
          icon: ValueListenableBuilder(
            valueListenable: controller.cameraFacingState,
            builder: (context, state, child) {
              switch (state) {
                case CameraFacing.front:
                  return const Icon(Icons.camera_front);
                case CameraFacing.back:
                  return const Icon(Icons.camera_rear);
              }
            },
          ),
          iconSize: 32.0,
          onPressed: () => controller.switchCamera(),
        ),
      ],
    );
  }
}
