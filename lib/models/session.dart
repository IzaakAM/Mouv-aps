class Session {
  final String title;
  final String videoUrl;
  final String thumbnailUrl;
  final int duration;
  bool isFinished = false;
  bool isLocked = false;

  Session({
    required this.title,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.duration,
    this.isFinished = false,
    this.isLocked = false,
  });
}