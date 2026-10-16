class AgentModel {
  final String id;
  final String name;
  final String agent; // 'claude', 'codex', 'opencode'

  const AgentModel({
    required this.id,
    required this.name,
    required this.agent,
  });
}

class AgentModels {
  static const List<AgentModel> claudeModels = [
    AgentModel(id: 'claude-3-7-sonnet', name: 'Claude 3.7 Sonnet', agent: 'claude'),
    AgentModel(id: 'claude-3-5-opus', name: 'Claude 3.5 Opus', agent: 'claude'),
    AgentModel(id: 'claude-3-5-haiku', name: 'Claude 3.5 Haiku', agent: 'claude'),
  ];

  static const List<AgentModel> codexModels = [
    AgentModel(id: 'gpt-4o', name: 'GPT-4o', agent: 'codex'),
    AgentModel(id: 'o1-preview', name: 'o1-preview', agent: 'codex'),
    AgentModel(id: 'gpt-4o-mini', name: 'GPT-4o Mini', agent: 'codex'),
  ];

  static const List<AgentModel> opencodeModels = [
    AgentModel(id: 'qwen2.5-coder', name: 'Qwen 2.5 Coder (Free)', agent: 'opencode'),
    AgentModel(id: 'deepseek-r1', name: 'DeepSeek R1 (Free)', agent: 'opencode'),
    AgentModel(id: 'llama-3.3-70b', name: 'Llama 3.3 70B (Free)', agent: 'opencode'),
  ];

  static List<AgentModel> forAgent(String agent) {
    switch (agent) {
      case 'codex':
        return codexModels;
      case 'opencode':
        return opencodeModels;
      case 'claude':
      default:
        return claudeModels;
    }
  }
}
