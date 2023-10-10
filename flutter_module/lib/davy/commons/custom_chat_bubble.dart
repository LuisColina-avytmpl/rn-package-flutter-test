import './message_bubble_container.dart';
import '../constructors/davy_message_with_communicate_actions.dart';
import '../constructors/davy_message_with_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../icons/icon_list.dart';
import 'option_chip.dart';

class CustomChatBubble extends StatefulWidget {
  final String messageId;
  final String text;
  final String user;
  final bool isLoading;
  final DavyMessageWithCommunicateActions? communicateActions;
  final DavyMessageWithOptions? options;
  final String? userSelectedOptionLabel;
  final void Function(int optionIndex, String messageId, String optionTitle)
      onOptionSelected;

  const CustomChatBubble(
      {Key? key,
      required this.text,
      required this.user,
      required this.isLoading,
      this.options,
      required this.onOptionSelected,
      required this.messageId,
      this.userSelectedOptionLabel,
      this.communicateActions})
      : super(key: key);

  @override
  _CustomBottomWidgetState createState() => _CustomBottomWidgetState();
}

class _CustomBottomWidgetState extends State<CustomChatBubble> {
  static const iconSize = 24.0;
  static const actionsIconSize = 18.0;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (widget.user == 'davy')
        CircleAvatar(
          backgroundColor: Color(0xff333333),
          child: Center(
            child: SvgPicture.asset(
              davyChatbot,
              color: Colors.white,
              height: iconSize,
              width: iconSize,
            ),
          ),
        ),
      MessageBubbleContainer(
        user: widget.user,
        isLoading: widget.isLoading,
        message: _buildMessage(),
      ),
    ]);
  }

  Widget _buildMessage() {
    final textMessage = Text(
      widget.text,
      style: const TextStyle(
          color: Color(0xff333333),
          fontSize: 16.0,
          height: 1.6,
          letterSpacing: 0.11,
          fontWeight: FontWeight.w400),
    );

    if (widget.user == "davy" && widget.communicateActions != null) {
      var actions = widget.communicateActions?.actions ?? [];
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textMessage,
          SizedBox(
            height: 16,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: actions
                .map(
                  (action) => Column(
                    children: [
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.only(
                              bottom: 16, top: 16, left: 16, right: 24),
                        ),
                        onPressed: () {},
                        icon: SvgPicture.asset(
                          action.icon,
                          color: Color(0xff333333),
                          height: actionsIconSize,
                          width: actionsIconSize,
                        ),
                        label: Text(action.title,
                            style: TextStyle(
                              color: Color(
                                  0xff333333), // Change the text color here
                            )),
                      ),
                      SizedBox(
                          height:
                              10.0), // Add the desired vertical spacing here
                    ],
                  ),
                )
                .toList(),
          )
        ],
      );
    }

    if (widget.user == "davy" && widget.options != null) {
      var options = widget.options?.options ?? [];
      var areButtonDisabled = widget.options?.disableOptions != null &&
          widget.options?.disableOptions == false;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textMessage,
          SizedBox(
            height: 16,
          ),
          Row(
            children: options
                .asMap()
                .map((index, option) {
                  var isOptionDisabled = option.isSelected
                      ? (bool value) {}
                      : areButtonDisabled
                          ? (bool value) {
                              widget.onOptionSelected(
                                  index, widget.messageId, option.title);
                            }
                          : null;
                  return MapEntry(
                      index,
                      OptionChip(
                        label: option.title,
                        isSelected: option.isSelected,
                        onSelected: isOptionDisabled,
                      ));
                })
                .values
                .toList(),
          )
        ],
      );
    }

    return textMessage;
  }
}
