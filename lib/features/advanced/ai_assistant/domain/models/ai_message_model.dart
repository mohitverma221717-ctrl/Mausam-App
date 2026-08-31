class MausamAiMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;

  const MausamAiMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}
