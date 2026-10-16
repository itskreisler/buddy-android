import 'package:flutter/material.dart';
import '../models/chat.dart';
import '../models/session.dart';

class AppState extends ChangeNotifier {
  final List<ChatSession> _chats = [];
  final List<ActiveSession> _sessions = [];

  final bool _onboarded = true;
  bool _developerMode = false;
  bool _bubbleEnabled = true;
  String _voiceEngine = 'phone'; // 'phone', 'claude', 'chatgpt'
  String _themeMode = 'system'; // 'system', 'light', 'dark'
  Locale? _locale; // null = system default, Locale('en'), Locale('es')

  final String _agentClaudeStatus = 'Signed in';
  final String _agentCodexStatus = 'Not signed in';
  final String _agentOpenCodeStatus = 'Ready (Free)';

  List<ChatSession> get chats => List.unmodifiable(_chats);
  List<ActiveSession> get sessions => List.unmodifiable(_sessions);

  bool get onboarded => _onboarded;
  bool get developerMode => _developerMode;
  bool get bubbleEnabled => _bubbleEnabled;
  String get voiceEngine => _voiceEngine;
  String get themeMode => _themeMode;
  Locale? get locale => _locale;

  String get agentClaudeStatus => _agentClaudeStatus;
  String get agentCodexStatus => _agentCodexStatus;
  String get agentOpenCodeStatus => _agentOpenCodeStatus;

  AppState() {
    _seedInitialData();
  }

  void _seedInitialData() {
    final chat1 = ChatSession(
      id: 'chat-1',
      title: 'Welcome & System Setup',
      agent: 'claude',
      model: 'claude-3-7-sonnet',
      messages: [
        Message(
          id: 'm1',
          kind: MessageKind.assistant,
          text: 'Hello! I am Buddy. I can help control your phone, manage tasks, and run AI models locally.',
        ),
      ],
    );

    final chat2 = ChatSession(
      id: 'chat-2',
      title: 'OpenCode Free Assistant',
      agent: 'opencode',
      model: 'qwen2.5-coder',
      messages: [
        Message(
          id: 'm2',
          kind: MessageKind.user,
          text: 'Check my recent notifications.',
        ),
        Message(
          id: 'm3',
          kind: MessageKind.toolCall,
          text: 'read_screen() -> 3 notifications found',
        ),
        Message(
          id: 'm4',
          kind: MessageKind.assistant,
          text: 'You have 3 notifications: 1 email from Sam, 1 calendar reminder, and 1 system alert.',
        ),
      ],
    );

    _chats.addAll([chat1, chat2]);

    _sessions.add(ActiveSession(
      id: 'ses-101',
      agent: 'claude',
      status: 'running',
    ));
  }

  ChatSession createChat({String agent = 'claude', String title = 'New Chat'}) {
    final id = 'chat-${DateTime.now().millisecondsSinceEpoch}';
    final newChat = ChatSession(
      id: id,
      title: title,
      agent: agent,
    );
    _chats.insert(0, newChat);
    notifyListeners();
    return newChat;
  }

  void deleteChat(String id) {
    _chats.removeWhere((c) => c.id == id);
    notifyListeners();
  }

  void addMessage(String chatId, Message message) {
    final chatIndex = _chats.indexWhere((c) => c.id == chatId);
    if (chatIndex != -1) {
      _chats[chatIndex].messages.add(message);
      if (_chats[chatIndex].messages.length == 1 && message.kind == MessageKind.user) {
        _chats[chatIndex].title = message.text.length > 25
            ? '${message.text.substring(0, 25)}...'
            : message.text;
      }
      notifyListeners();
    }
  }

  void setChatModel(String chatId, String model) {
    final chat = _chats.firstWhere((c) => c.id == chatId);
    chat.model = model;
    notifyListeners();
  }

  void stopSession(String sessionId) {
    final idx = _sessions.indexWhere((s) => s.id == sessionId);
    if (idx != -1) {
      _sessions.removeAt(idx);
      notifyListeners();
    }
  }

  void toggleDeveloperMode(bool val) {
    _developerMode = val;
    notifyListeners();
  }

  void toggleBubble(bool val) {
    _bubbleEnabled = val;
    notifyListeners();
  }

  void setVoiceEngine(String engine) {
    _voiceEngine = engine;
    notifyListeners();
  }

  void setThemeMode(String mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void setLocale(Locale? loc) {
    _locale = loc;
    notifyListeners();
  }
}
