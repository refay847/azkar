class Dhikr {
  final int id;
  final String text;
  final String? virtue;
  final int count;

  const Dhikr({
    required this.id,
    required this.text,
    this.virtue,
    required this.count,
  });
}