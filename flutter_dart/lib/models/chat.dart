enum MessageKind { user, assistant, toolCall, approval }

class Message {
  final String id;
  final MessageKind kind;
  final String text;
  final List<String> attachments;
  final DateTime timestamp;
  bool? approved;

  Message({
    required this.id,
    required this.kind,
    required this.text,
    this.attachments = const [],
    DateTime? timestamp,
    this.approved,
  }) : timestamp = timestamp ?? DateTime.now();
}

class ChatSession {
  final String id;
  String title;
  String agent; // 'claude', 'codex', 'opencode'
  String model;
  final List<Message> messages;
  final DateTime createdAt;

  ChatSession({
    required this.id,
    required this.title,
    this.agent = 'claude',
    this.model = 'claude-3-7-sonnet',
    List<Message>? messages,
    DateTime? createdAt,
  })  : messages = messages ?? [],
        createdAt = createdAt ?? DateTime.now();
}
