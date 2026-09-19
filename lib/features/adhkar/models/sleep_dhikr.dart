class SleepDhikr {
  final int id;
  final String text;
  final String? note;
  final int count;

  const SleepDhikr({
    required this.id,
    required this.text,
    this.note,
    required this.count,
  });
}