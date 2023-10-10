import 'package:flutter/src/widgets/container.dart';

class DavyOption {
  final String title;
  bool isSelected;
  final String optionId;

  DavyOption(
    this.optionId, {
    required this.title,
    required this.isSelected,
  });
}

class DavyMessageWithOptions {
  final String messageId;
  List<DavyOption> options;
  bool disableOptions;

  DavyMessageWithOptions({
    required this.messageId,
    required this.options,
    this.disableOptions = false,
  });

  map(Container Function(dynamic option) param0) {}
}
