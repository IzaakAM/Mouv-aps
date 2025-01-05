import 'package:flutter/material.dart';
import 'decision_tree.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final DecisionTree _decisionTree = DecisionTree();
  List<dynamic> _categories = [];
  List<dynamic> _currentQuestions = [];
  String? _currentCategory;
  String? _currentQuestionText;
  List<dynamic> _currentOptions = [];
  String? _finalResponse;

  @override
  void initState() {
    super.initState();
    _loadDecisionTree();
  }

  Future<void> _loadDecisionTree() async {
    await _decisionTree.loadTree('lib/screens/chatbot/tree.json');
    setState(() {
      _categories = _decisionTree.categories;
    });
  }


  void _navigateToCategory(String categoryName) {
    setState(() {
      _currentCategory = categoryName;
      _currentQuestions = _decisionTree.getQuestionsByCategory(categoryName);
      _currentQuestionText = null;
      _currentOptions = [];
    });
  }

  void _handleQuestion(Map<String, dynamic> question) {
    if (question['follow_up'] != null) {
      setState(() {
        _currentQuestionText = question['question'];
        _currentOptions = question['follow_up'];
      });
    } else if (question['response'] != null) {
      setState(() {
        _finalResponse = question['response'];
        _currentOptions = [];
      });
    }
  }

  Widget _buildCategoriesView() {
    return ListView.builder(
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        final category = _categories[index];
        return ListTile(
          title: Text(category['name']),
          onTap: () => _navigateToCategory(category['name']),
        );
      },
    );
  }

  Widget _buildQuestionsView() {
    return Column(
      children: [
        if (_currentCategory != null)
          Text(
            'Catégorie: $_currentCategory',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        const SizedBox(height: 10),
        if (_currentQuestions.isNotEmpty)
          Expanded(
            child: ListView.builder(
              itemCount: _currentQuestions.length,
              itemBuilder: (context, index) {
                final question = _currentQuestions[index];
                return ListTile(
                  title: Text(question['question']),
                  onTap: () => _handleQuestion(question),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildFinalResponseView() {
    return Center(
      child: Text(
        _finalResponse ?? '',
        style: const TextStyle(fontSize: 18),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_finalResponse != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Réponse"),
        ),
        body: _buildFinalResponseView(),
      );
    }

    if (_currentCategory == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Sélectionnez une catégorie"),
        ),
        body: _buildCategoriesView(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Questions dans $_currentCategory"),
      ),
      body: _buildQuestionsView(),
    );
  }
}