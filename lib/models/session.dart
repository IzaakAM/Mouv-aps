class Session {
  final String title;
  final String videoUrl;
  final String thumbnailUrl;
  final DateTime date;
  final int duration;
  bool isFinished = false;
  bool isLocked = false;
  final List<String> steps;

  Session({
    required this.title,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.date,
    required this.duration,
    this.isFinished = false,
    this.isLocked = false,
    required this.steps,
  });
}