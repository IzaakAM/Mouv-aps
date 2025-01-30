class Session {
  final String title;
  final int videoId;
  final String thumbnailUrl;
  final DateTime date;
  final int duration;
  bool completed = false;
  bool unauthorized = false;
  final List<String> steps;

  Session({
    required this.title,
    required this.videoId,
    required this.thumbnailUrl,
    required this.date,
    required this.duration,
    this.completed = false,
    this.unauthorized = false,
    required this.steps,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      title: json["title"] ?? "",
      duration: json["duration"] ?? 0,
      videoId: json["video_id"] ?? 0,
      thumbnailUrl: json["thumbnail_url"] ?? "https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png",
      unauthorized: json["unauthorized"] ?? false,
      completed: json["completed"] ?? false,
      steps: json["steps"] != null
          ? List<String>.from(json["steps"])
          : <String>[],
      date: DateTime.parse(json["date"] ?? DateTime.now().toString()),
    );
  }
}