import 'package:flutter/material.dart';

class OptionChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final ValueChanged<bool>? onSelected;

  OptionChip({
    required this.label,
    required this.isSelected,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 8),
      child: FilterChip(
        backgroundColor: const Color(0xffF9F9F9),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        label: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xff333333),
          ),
        ),
        selected: isSelected,
        onSelected: onSelected,
      ),
    );
  }
}
