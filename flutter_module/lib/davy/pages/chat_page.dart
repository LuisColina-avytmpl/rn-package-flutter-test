import 'package:flutter_module/davy/constructors/davy_message_with_communicate_actions.dart';
import 'package:flutter_module/davy/constructors/davy_message_with_options.dart';
import 'package:flutter_module/davy/constructors/user_selected_option.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:uuid/uuid.dart';
import '../controllers/stream_controller_event.dart';
import '../commons/custom_chat_bubble.dart';
import '../helpers/timeout.dart';
import '../commons/custom_bottom_widget.dart';
import 'package:collection/collection.dart';
//import '../icons/icon_list.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

const String isLoading = "isLoadingIndicator";

class _ChatPageState extends State<ChatPage> {
  StreamControllerEvent streamControllerEvent = StreamControllerEvent();

  //static const streamControllerEvent = StreamControllerEvent();
  final List<types.Message> _messages = [];
  List<DavyMessageWithOptions> _messagesWithOptions = [];
  final List<DavyMessageWithCommunicateActions> _messageWithActions = [];
  final List<UserSelectedOption> _userSelectedOptions = [];

  var conversationId;
  var isChatbotThinking = false;
  var inputWidgetDisabled = true;
  final _user = const types.User(
    id: 'user',
  );
  final _davy = const types.User(
    id: 'davy',
  );

  @override
  void initState() {
    super.initState();
    _handleStreamingStart();
  }

  void _setChatbotIsThinking(bool value) {
    setState(() {
      isChatbotThinking = value;
    });
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _setConversationId(String id) {
    setState(() {
      conversationId = id;
    });
  }

  void _setInputWidgetDisabled(bool value) {
    setState(() {
      inputWidgetDisabled = value;
    });
  }

  void _removeLastMessage() {
    setState(() {
      for (int i = _messages.length - 1; i >= 0; i--) {
        if ((_messages[i] as types.TextMessage).text == isLoading) {
          _messages.removeAt(i);
          break; // Remove the first matching item and exit the loop
        }
      }
    });
  }

  void _addMessageWithOption({required DavyMessageWithOptions davyMessage}) {
    setState(() {
      _messagesWithOptions.add(davyMessage);
    });
  }

  void _addMessageWithCommunicateActions(
      {required DavyMessageWithCommunicateActions davyMessage}) {
    setState(() {
      _messageWithActions.add(davyMessage);
    });
  }

  void _addSelectedOption({required UserSelectedOption userSelectedOption}) {
    setState(() {
      _userSelectedOptions.add(userSelectedOption);
    });
  }

  void _handleStreamingStart() async {
    insetLoadingMessage();
    setTimeout(() async {
      StartConversationReturn streamingStart = await streamControllerEvent
          .startStreaming("start_conversation", _setChatbotIsThinking);

      final textMessage = types.TextMessage(
        author: _davy,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4(),
        text: streamingStart.responseBody,
      );
      _setConversationId(streamingStart.conversationId.toString());
      _removeLastMessage();
      _addMessage(textMessage);
      _setInputWidgetDisabled(false);
    }, 3000);
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
      previewData: previewData,
    );

    setState(() {
      _messages[index] = updatedMessage;
    });
  }

  void insetLoadingMessage() {
    final loadingTextMessage = types.TextMessage(
      author: _davy,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: isLoading,
    );

    _addMessage(loadingTextMessage);
  }

  void _handleChatbotResponse(String message) {
    //CHATBOT
    insetLoadingMessage();

    setTimeout(() async {
      await streamControllerEvent
          .sendMessage('send_message/$conversationId', message, (body) {
        // Process each body as it's received

        /* final List<DavyOption> optionsMock = [
          DavyOption("1", title: "Option 1", isSelected: false),
          DavyOption("2", title: "Option 2", isSelected: false),
          DavyOption("3", title: "Option 3", isSelected: false),
        ]; */

        /* final List<DavyCommunicateAction> communicateActionsMock = [
          DavyCommunicateAction(
            "Document 1",
            "https://www.google.com",
            ItemType.DOCUMENT,
            document,
          ),
          DavyCommunicateAction("Document 2", "https://www.google.com",
              ItemType.DOCUMENT, document),
          DavyCommunicateAction(
              "Link 3", "https://www.google.com", ItemType.LINK, openInWeb),
        ]; */

        final messageId = const Uuid().v4();
        final textMessage = types.TextMessage(
          author: _davy,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          id: messageId,
          text: body,
        );
        _removeLastMessage();
        _addMessage(textMessage);
        /*  _addMessageWithOption(
            davyMessage: DavyMessageWithOptions(
                messageId: messageId, options: optionsMock)); */
        /* _addMessageWithCommunicateActions(
            davyMessage: DavyMessageWithCommunicateActions(
                messageId: messageId, actions: communicateActionsMock)); */
      }, _setChatbotIsThinking);
      _setInputWidgetDisabled(false);
    }, 0);
  }

  void _handleSendPressed(String message, {bool? isOption}) {
    //USER
    final messageId = const Uuid().v4();
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: messageId,
      text: message,
    );
    _addMessage(textMessage);

    if (isOption == true) {
      _addSelectedOption(
          userSelectedOption: UserSelectedOption(messageId, message));
    }
    _setInputWidgetDisabled(true);
    //CHATBOT
    setTimeout(() {
      _handleChatbotResponse(message);
    }, 2000);
  }

  void _handleOptionSelected(
      int optionIndex, String messageId, String optionTitle) {
    setState(() {
      _messagesWithOptions = _messagesWithOptions.map((messageWithOptions) {
        if (messageWithOptions.messageId == messageId) {
          messageWithOptions.options =
              messageWithOptions.options.mapIndexed((index, option) {
            if (optionIndex == index) {
              option.isSelected = true;
            }
            return option;
          }).toList();
        }
        messageWithOptions.disableOptions = true;
        return messageWithOptions;
      }).toList();
    });

    _handleSendPressed(optionTitle, isOption: true);
  }

  void _handleOnSelectCommunicateAction() {
    //TODO
  }

  Widget bubbleBuilder(
    Widget child, {
    required types.Message message,
    required nextMessageInGroup,
  }) {
    UserSelectedOption? userSelectedOption = _userSelectedOptions
        .singleWhereOrNull((UserSelectedOption userSelectedOption) =>
            userSelectedOption.messageId == message.id);

    DavyMessageWithCommunicateActions? communicateActions =
        _messageWithActions.singleWhereOrNull(
            (DavyMessageWithCommunicateActions messageWithActions) =>
                messageWithActions.messageId == message.id);

    DavyMessageWithOptions? options = _messagesWithOptions.singleWhereOrNull(
        (DavyMessageWithOptions messageWithOptions) =>
            messageWithOptions.messageId == message.id);

    return CustomChatBubble(
        communicateActions: communicateActions,
        userSelectedOptionLabel: userSelectedOption?.optionLabel,
        messageId: message.id,
        onOptionSelected: _handleOptionSelected,
        options: options,
        text: (message as types.TextMessage).text,
        user: message.author.id,
        isLoading: _user.id != message.author.id && message.text == isLoading);
  }

  Widget customBottomWidget() {
    return CustomBottomWidget(
        onSubmit: _handleSendPressed, disabled: inputWidgetDisabled);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Chat(
      messages: _messages,
      onPreviewDataFetched: _handlePreviewDataFetched,
      user: _user,
      bubbleBuilder: bubbleBuilder,
      customBottomWidget: customBottomWidget(),
      onSendPressed: (PartialText) {}, // this line is required by the lib
    ));
  }
}
