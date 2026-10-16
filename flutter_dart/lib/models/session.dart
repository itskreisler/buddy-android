class ActiveSession {
  final String id;
  final String agent;
  final String status; // 'running', 'idle', 'stopped'
  final DateTime startedAt;

  ActiveSession({
    required this.id,
    required this.agent,
    required this.status,
    DateTime? startedAt,
  }) : startedAt = startedAt ?? DateTime.now();
}
