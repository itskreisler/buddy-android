import 'package:flutter/material.dart';
import '../services/app_state.dart';
import '../l10n/app_localizations.dart';
import '../widgets/bubble_face_widget.dart';
import 'chat_detail_screen.dart';

class ChatsScreen extends StatefulWidget {
  final AppState appState;

  const ChatsScreen({super.key, required this.appState});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  BubbleState _bubbleState = BubbleState.idle;

  @override
  Widget build(BuildContext buildContext) {
    final loc = AppLocalizations.of(buildContext)!;
    final chats = widget.appState.chats;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_comment_outlined),
            tooltip: loc.actionNewChat,
            onPressed: () => _showNewChatDialog(buildContext),
          ),
        ],
      ),
      body: Stack(
        children: [
          chats.isEmpty
              ? Center(
                  child: Text(
                    loc.actionNewChat,
                    style: Theme.of(buildContext).textTheme.bodyLarge,
                  ),
                )
              : ListView.builder(
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    final chat = chats[index];
                    return Dismissible(
                      key: Key(chat.id),
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) {
                        widget.appState.deleteChat(chat.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${loc.actionDelete}: ${chat.title}')),
                        );
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _agentColor(chat.agent),
                          child: Text(
                            chat.agent.substring(0, 1).toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(
                          chat.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('${chat.agent.toUpperCase()} · ${chat.model}'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChatDetailScreen(
                                appState: widget.appState,
                                chatId: chat.id,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
          if (widget.appState.bubbleEnabled)
            Positioned(
              right: 20,
              bottom: 80,
              child: BubbleFaceWidget(
                state: _bubbleState,
                onTap: () {
                  setState(() {
                    _bubbleState = _bubbleState == BubbleState.thinking
                        ? BubbleState.idle
                        : BubbleState.thinking;
                  });
                },
                onLongPress: () {
                  _showNewChatDialog(buildContext);
                },
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showNewChatDialog(buildContext),
        icon: const Icon(Icons.add),
        label: Text(loc.actionNewChat),
      ),
    );
  }

  Color _agentColor(String agent) {
    switch (agent) {
      case 'codex':
        return Colors.green.shade700;
      case 'opencode':
        return Colors.purple.shade700;
      case 'claude':
      default:
        return Colors.deepOrange.shade700;
    }
  }

  void _showNewChatDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.psychology, color: Colors.deepOrange),
              title: const Text('Claude Code'),
              subtitle: const Text('Anthropic Opus / Sonnet / Haiku'),
              onTap: () {
                Navigator.pop(ctx);
                _startChat(context, 'claude');
              },
            ),
            ListTile(
              leading: const Icon(Icons.smart_toy, color: Colors.green),
              title: const Text('Codex'),
              subtitle: const Text('ChatGPT GPT-4o / o1'),
              onTap: () {
                Navigator.pop(ctx);
                _startChat(context, 'codex');
              },
            ),
            ListTile(
              leading: const Icon(Icons.code, color: Colors.purple),
              title: const Text('OpenCode'),
              subtitle: const Text('Free open-weights models'),
              onTap: () {
                Navigator.pop(ctx);
                _startChat(context, 'opencode');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _startChat(BuildContext context, String agent) {
    final newChat = widget.appState.createChat(agent: agent);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatDetailScreen(
          appState: widget.appState,
          chatId: newChat.id,
        ),
      ),
    );
  }
}
