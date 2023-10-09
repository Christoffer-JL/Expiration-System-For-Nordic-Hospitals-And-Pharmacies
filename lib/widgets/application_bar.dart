import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ApplicationBar extends StatelessWidget {
  final MobileScannerController cameraController;

  ApplicationBar({required this.cameraController});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Mobile Scanner'),
      actions: [
        IconButton(
          color: Colors.white,
          icon: ValueListenableBuilder(
            valueListenable: cameraController.torchState,
            builder: (context, state, child) {
              switch (state as TorchState) {
                case TorchState.off:
                  return const Icon(Icons.flash_off, color: Colors.grey);
                case TorchState.on:
                  return const Icon(Icons.flash_on, color: Colors.yellow);
              }
            },
          ),
          iconSize: 32.0,
          onPressed: () => cameraController.toggleTorch(),
        ),
        IconButton(
          color: Colors.white,
          icon: ValueListenableBuilder(
            valueListenable: cameraController.cameraFacingState,
            builder: (context, state, child) {
              switch (state as CameraFacing) {
                case CameraFacing.front:
                  return const Icon(Icons.camera_front);
                case CameraFacing.back:
                  return const Icon(Icons.camera_rear);
              }
            },
          ),
          iconSize: 32.0,
          onPressed: () => cameraController.switchCamera(),
        ),
      ],
    );
  }
}
