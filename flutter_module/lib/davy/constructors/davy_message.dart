import './davy_message_with_options.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class DavyMessage {
  final types.Message chatMessage;
  final DavyMessageWithOptions? davyOptions;

  DavyMessage({
    required this.chatMessage,
    this.davyOptions,
  });
}
