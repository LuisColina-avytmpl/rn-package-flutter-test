import './typing_indicator.dart';
import 'package:flutter/material.dart';

class MessageBubbleContainer extends StatelessWidget {
  final String user;
  final bool isLoading;
  final Widget message;

  MessageBubbleContainer(
      {required this.user, required this.isLoading, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 12, right: 12, top: 16.0, bottom: 16.0),
      margin: EdgeInsets.only(top: 6),
      decoration: BoxDecoration(
        color: user == 'davy' ? Color(0xffF9F9F9) : Color(0xffDCD6F7),
        borderRadius: BorderRadius.only(
          bottomRight:
              user == 'davy' ? Radius.circular(12.0) : Radius.circular(0.0),
          topLeft:
              user == 'davy' ? Radius.circular(0.0) : Radius.circular(12.0),
          topRight: Radius.circular(12.0),
          bottomLeft: Radius.circular(12.0),
        ),
      ),
      child: isLoading ? TypingIndicator() : message,
    );
  }
}
