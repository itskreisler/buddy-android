import 'package:flutter/material.dart';
import '../services/app_state.dart';
import '../models/chat.dart';
import '../models/agent_models.dart';
import '../models/phone_tools.dart';
import '../l10n/app_localizations.dart';

class ChatDetailScreen extends StatefulWidget {
  final AppState appState;
  final String chatId;

  const ChatDetailScreen({
    super.key,
    required this.appState,
    required this.chatId,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _textController = TextEditingController();
  bool _isRecordingVoice = false;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final chat = widget.appState.chats.firstWhere((c) => c.id == widget.chatId);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(chat.title, style: const TextStyle(fontSize: 16)),
            GestureDetector(
              onTap: () => _showModelPicker(context, chat),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      chat.model,
                      style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down, size: 14),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: chat.messages.length,
              itemBuilder: (context, index) {
                final msg = chat.messages[index];
                return _buildMessageWidget(msg, loc);
              },
            ),
          ),
          if (_isRecordingVoice) _buildVoiceBar(loc),
          _buildInputBar(loc, chat),
        ],
      ),
    );
  }

  Widget _buildMessageWidget(Message msg, AppLocalizations loc) {
    switch (msg.kind) {
      case MessageKind.user:
        return Align(
          alignment: Alignment.centerRight,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              msg.text,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      case MessageKind.assistant:
        return Align(
          alignment: Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(msg.text),
          ),
        );
      case MessageKind.toolCall:
        return ExpansionTile(
          leading: const Icon(Icons.build_circle_outlined, size: 20),
          title: Text('1 tool call: ${msg.text}', style: const TextStyle(fontSize: 13)),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SelectableText(msg.text, style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
            )
          ],
        );
      case MessageKind.approval:
        return Card(
          color: Colors.amber.shade50,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.security, color: Colors.amber, size: 20),
                    SizedBox(width: 8),
                    Text('Approval Required', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 6),
                Text(msg.text),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() => msg.approved = false);
                      },
                      child: Text(loc.actionDeny, style: const TextStyle(color: Colors.red)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() => msg.approved = true);
                      },
                      child: Text(loc.actionApprove),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
    }
  }

  Widget _buildVoiceBar(AppLocalizations loc) {
    return Container(
      color: Colors.red.shade100,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.graphic_eq, color: Colors.red),
          const SizedBox(width: 8),
          const Expanded(child: Text('Listening...')),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => setState(() => _isRecordingVoice = false),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.red),
            onPressed: () {
              setState(() => _isRecordingVoice = false);
              _sendMessage('Voice message input audio', widget.chatId);
            },
          )
        ],
      ),
    );
  }

  Widget _buildInputBar(AppLocalizations loc, ChatSession chat) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(13, 0, 0, 0),
            blurRadius: 4,
          )
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.attach_file),
            onPressed: () => _showAttachmentPicker(),
          ),
          IconButton(
            icon: const Icon(Icons.mic),
            onPressed: () => setState(() => _isRecordingVoice = !_isRecordingVoice),
          ),
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: loc.promptTypeMessage,
                border: InputBorder.none,
              ),
              onSubmitted: (text) => _handleSend(chat),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            color: Theme.of(context).colorScheme.primary,
            onPressed: () => _handleSend(chat),
          ),
        ],
      ),
    );
  }

  void _handleSend(ChatSession chat) {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    _textController.clear();
    _sendMessage(text, chat.id);
  }

  void _sendMessage(String text, String chatId) async {
    widget.appState.addMessage(
      chatId,
      Message(
        id: 'msg-${DateTime.now().millisecondsSinceEpoch}',
        kind: MessageKind.user,
        text: text,
      ),
    );

    final lower = text.toLowerCase();
    String toolOutput = '';

    if (lower.contains('screen') || lower.contains('read')) {
      toolOutput = await PhoneTool.executeTool('read_screen', {});
    } else if (lower.contains('open')) {
      toolOutput = await PhoneTool.executeTool('open_app', {'package': 'com.whatsapp'});
    }

    if (toolOutput.isNotEmpty) {
      widget.appState.addMessage(
        chatId,
        Message(
          id: 'msg-tool-${DateTime.now().millisecondsSinceEpoch}',
          kind: MessageKind.toolCall,
          text: toolOutput,
        ),
      );
    }

    Future.delayed(const Duration(milliseconds: 600), () {
      widget.appState.addMessage(
        chatId,
        Message(
          id: 'msg-resp-${DateTime.now().millisecondsSinceEpoch}',
          kind: MessageKind.assistant,
          text: toolOutput.isNotEmpty
              ? 'Executed screen interaction via system accessibility service: $toolOutput'
              : 'I received your request: "$text". Operating task completed.',
        ),
      );
    });
  }

  void _showModelPicker(BuildContext context, ChatSession chat) {
    final models = AgentModels.forAgent(chat.agent);
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: models.map((m) {
            return ListTile(
              title: Text(m.name),
              trailing: chat.model == m.id ? const Icon(Icons.check, color: Colors.blue) : null,
              onTap: () {
                widget.appState.setChatModel(chat.id, m.id);
                Navigator.pop(ctx);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showAttachmentPicker() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Attachment picker opened (Photos & Files)')),
    );
  }
}
