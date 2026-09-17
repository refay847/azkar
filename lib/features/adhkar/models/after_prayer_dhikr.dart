class AfterPrayerDhikr {
  final int id;
  final String text;
  final String? note;
  final int count;

  const AfterPrayerDhikr({
    required this.id,
    required this.text,
    this.note,
    required this.count,
  });
}