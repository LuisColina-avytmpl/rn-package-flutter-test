enum ItemType {
  DOCUMENT,
  LINK,
}

class DavyCommunicateAction {
  String title;
  String link;
  ItemType type;
  String icon;

  DavyCommunicateAction(this.title, this.link, this.type, this.icon);
}

class DavyMessageWithCommunicateActions {
  final String messageId;
  List<DavyCommunicateAction> actions;

  DavyMessageWithCommunicateActions({
    required this.messageId,
    required this.actions,
  });
}
