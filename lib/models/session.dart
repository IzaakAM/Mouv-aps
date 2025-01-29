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

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      title: json["title"] ?? "",
      duration: json["duration"] ?? 0,
      videoUrl: json["video_url"] ?? "",
      thumbnailUrl: json["thumbnail_url"] ?? "",
      isLocked: json["is_locked"] ?? false,
      isFinished: json["is_finished"] ?? false,
      steps: json["steps"] != null
          ? List<String>.from(json["steps"])
          : <String>[],
      date: DateTime.parse(json["date"] ?? DateTime.now().toString()),
    );
  }
}