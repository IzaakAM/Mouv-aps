import 'dart:convert';
import 'package:flutter/services.dart';

class DecisionTree {
  List<dynamic> categories = [];

  /// Charge les catégories et les questions depuis le JSON
  Future<void> loadTree(String path) async {
    final data = await rootBundle.loadString(path);
    final parsedData = json.decode(data);
    categories = parsedData['categories'];
  }

  /// Retourne les questions pour une catégorie donnée
  List<dynamic> getQuestionsByCategory(String categoryName) {
    final category = categories.firstWhere(
      (cat) => cat['name'] == categoryName,
      orElse: () => {},
    );
    return category['questions'] ?? [];
  }

  /// Retourne les événements pour la section Notifications
  List<dynamic> getNotifications() {
    final category = categories.firstWhere(
      (cat) => cat['name'] == "Notifications",
      orElse: () => {},
    );
    return category['events'] ?? [];
  }
}
