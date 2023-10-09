import 'package:flutter/material.dart';

class BottomSheetWidget extends StatefulWidget {
  String pc;
  String exp;
  String batch;
  String serial;

  BottomSheetWidget({
    required this.pc,
    required this.exp,
    required this.batch,
    required this.serial,
  });

  @override
  _BottomSheetWidgetState createState() => _BottomSheetWidgetState();

  // Method to update the content
  void updateContent(
      String newPc, String newExp, String newBatch, String newSerial) {
    pc = newPc;
    exp = newExp;
    batch = newBatch;
    serial = newSerial;
  }
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.pc),
          Text(widget.exp),
          Text(widget.batch),
          Text(widget.serial),
        ],
      ),
    );
  }
}
