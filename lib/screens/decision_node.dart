class DecisionNode {
  final String question;
  final Map<String, DecisionNode> children;

  DecisionNode({required this.question, this.children = const {}});
}
