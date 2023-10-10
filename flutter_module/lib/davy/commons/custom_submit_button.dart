import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../icons/icon_list.dart';

class CustomSubmitButton extends StatelessWidget {
  final TextEditingController searchController;
  final void Function(String) onSubmit;
  final bool disabled;

  CustomSubmitButton({
    required this.searchController,
    required this.onSubmit,
    required this.disabled,
  });

  static const double iconSize = 24.0;

  void _clearTextField() {
    searchController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        child: Ink(
          decoration: const ShapeDecoration(
            color: Color(0xFFDCD6F7),
            shape: CircleBorder(),
          ),
          child: IconButton(
            iconSize: iconSize,
            onPressed: disabled
                ? null
                : () {
                    onSubmit(searchController.text);
                    _clearTextField();
                  },
            icon: Transform.scale(
              filterQuality: FilterQuality.medium,
              scale: 0.5,
              child: Transform.scale(
                scale: 2,
                child: SvgPicture.asset(
                  paperPlane, // Replace with the path to your SVG file
                  width: iconSize,
                  height: iconSize,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
