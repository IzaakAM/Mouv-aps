class Recipe {
  final int id;
  final String title;
  final String videoUrl;
  final String thumbnailUrl;
  final int duration;
  final int requiredPoints;
  final String meal; // Breakfast, Lunch, Dinner
  final Map<String, int> ingredients;
  final List<String> steps;

  Recipe({
    required this.id,
    required this.title,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.requiredPoints,
    required this.duration,
    required this.meal,
    required this.ingredients,
    required this.steps,
  });
}