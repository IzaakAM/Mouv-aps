import 'dart:convert';
import 'package:flutter/services.dart';
import 'decision_node.dart';

class TreeLoader {
  static Future<DecisionNode> loadDecisionTree() async {
    final data = await rootBundle.loadString('assets/tree.json');
    final Map<String, dynamic> json = jsonDecode(data);
    return _parseDecisionTree(json);
  }

  static DecisionNode _parseDecisionTree(Map<String, dynamic> json) {
    final children = (json['children'] as Map<String, dynamic>?)?.map(
      (key, value) => MapEntry(key, _parseDecisionTree(value)),
    ) ?? {};
    return DecisionNode(
      question: json['question'] as String,
      children: children,
    );
  }
}
