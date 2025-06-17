abstract class ChabotEvent {}

class SendMessageEvent extends ChabotEvent {
  final String message;
  SendMessageEvent(this.message);
}

class ReceiveMessageEvent extends ChabotEvent {
  final String message;
  ReceiveMessageEvent(this.message);
}

class StartNewChatEvent extends ChabotEvent {}

class LoadConversationEvent extends ChabotEvent {
  final int index;
  LoadConversationEvent(this.index);
}

class DeleteConversationEvent extends ChabotEvent {
  final int index;
  DeleteConversationEvent(this.index);
} 