class Recipe {
  final String title;
  final int videoId;
  final String thumbnailUrl;
  final int duration;
  final int requiredPoints;
  final String meal; // breakfast, lunch, dinner
  final Map<String, String> ingredients;
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
      videoId: json["video_id"] ?? 0,
      thumbnailUrl: json["thumbnail_url"] ?? "https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png",
      requiredPoints: json["required_points"] ?? 0,
      duration: json["duration"] ?? 0,
      meal: json["category"] ?? "",
      ingredients: json["ingredients"] != null
          ? Map<String, String>.from(json["ingredients"])
          : <String, String>{},
      steps: json["steps"] != null
          ? List<String>.from(json["steps"])
          : <String>[],
    );
  }
}