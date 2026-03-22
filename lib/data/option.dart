class Option {
  final String label;
  final String emoji;
  final String? next;
  final String? finalMsg;
  final String? finalEmoji;

  const Option({
    required this.label,
    required this.emoji,
    this.next,
    this.finalMsg,
    this.finalEmoji,
  });
}
