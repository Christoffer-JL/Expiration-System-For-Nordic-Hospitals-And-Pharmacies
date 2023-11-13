import 'package:flutter/material.dart';

class ExpandButton extends StatefulWidget {
  final String mainText;
  final IconData icon; // Icon for the button
  final List<String> expandedText;
  final VoidCallback? onPressed;
  final double cornerRadius;

  ExpandButton({
    required this.mainText,
    required this.icon,
    required this.expandedText,
    required this.onPressed,
    required this.cornerRadius,
  });

  @override
  _ExpandButtonState createState() => _ExpandButtonState();
}

class _ExpandButtonState extends State<ExpandButton> {
  bool _isExpanded = false;

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.lightBlue,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(widget.cornerRadius),
              topRight: Radius.circular(widget.cornerRadius),
            ),
          ),
          child: InkWell(
            onTap: () {
              _toggleExpansion();
              widget.onPressed?.call();
            },
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.mainText,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.white,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
        if (_isExpanded)
          Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.lightBlue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(widget.cornerRadius),
                bottomRight: Radius.circular(widget.cornerRadius),
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: widget.expandedText
                    .map((text) => Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 180.0),
                          child: Text(
                            text,
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ),
      ],
    );
  }
}
