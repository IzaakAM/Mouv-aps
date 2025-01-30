class Recipe {
  final String title;
  final int videoId;
  final String thumbnailUrl;
  final int duration;
  final int requiredPoints;
  final String meal; // Breakfast, Lunch, Dinner
  final Map<String, int> ingredients;
  final List<String> steps;

  Recipe({
    required this.title,
    required this.videoId,
    required this.thumbnailUrl,
    required this.requiredPoints,
    required this.duration,
    required this.meal,
    required this.ingredients,
    required this.steps,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      title: json["title"] ?? "",
      videoId: json["video_id"] ?? "",
      thumbnailUrl: json["thumbnail_url"] ?? "",
      requiredPoints: json["required_points"] ?? 0,
      duration: json["duration"] ?? 0,
      meal: json["meal"] ?? "",
      ingredients: json["ingredients"] != null
          ? Map<String, int>.from(json["ingredients"])
          : <String, int>{},
      steps: json["steps"] != null
          ? List<String>.from(json["steps"])
          : <String>[],
    );
  }
}