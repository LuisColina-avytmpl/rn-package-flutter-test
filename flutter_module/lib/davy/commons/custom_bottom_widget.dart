import '../commons/custom_submit_button.dart';
import 'package:flutter/material.dart';

class CustomBottomWidget extends StatefulWidget {
  final bool disabled;
  final void Function(String) onSubmit; // Callback property

  const CustomBottomWidget(
      {Key? key, required this.onSubmit, required this.disabled})
      : super(key: key);

  @override
  _CustomBottomWidgetState createState() => _CustomBottomWidgetState();
}

class _CustomBottomWidgetState extends State<CustomBottomWidget> {
  TextEditingController _searchController = TextEditingController();
  bool _isTextFieldEmpty = true; // Add this variable

  void _clearTextField() {
    _searchController.clear();
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_updateTextFieldStatus);
  }

  void _updateTextFieldStatus() {
    setState(() {
      _isTextFieldEmpty = _searchController.text.isEmpty;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 64, maxHeight: 150),
      decoration: const BoxDecoration(
        color: Color(0xFFF9F9F9),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                enabled: !widget.disabled,
                controller: _searchController,
                keyboardType:
                    TextInputType.multiline, // Allows multiple lines of text
                maxLines: null, // Allows unlimited lines of text
                decoration: const InputDecoration(
                  hintText: 'Ask to Chatbot...',
                  border: InputBorder.none,
                ),
              ),
            ),
            CustomSubmitButton(
              searchController: _searchController,
              onSubmit: widget.onSubmit,
              disabled: widget.disabled ||
                  _isTextFieldEmpty, // Disable if the text field is empty
            ),
          ],
        ),
      ),
    );
  }
}
