import 'package:flutter/material.dart';
import 'ChatPageDecisionTreeLoader.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final DecisionTree _decisionTree = DecisionTree();
  List<dynamic> _categories = [];
  List<dynamic> _currentQuestions = [];
  String? _currentCategory;
  String? _currentQuestionText;
  List<dynamic> _currentOptions = [];
  String? _finalResponse;
  String? professionnel;
  @override
  void initState() {
    super.initState();
    _loadDecisionTree();
  }

  Future<void> _loadDecisionTree() async {
    await _decisionTree.loadTree('assets/tree.json');
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

  void _resetToStart() {
    setState(() {
      _currentCategory = null;
      _currentQuestions = [];
      _currentQuestionText = null;
      _currentOptions = [];
      _finalResponse = null;
    });
  }

  Widget _buildCategoriesView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Aligne le texte à gauche
      children: [
        Padding(
          padding: const EdgeInsets.all(
              17.4), // Ajoute un espacement autour du texte
          child: Text(
            "Veuillez choisir une catégorie",
            style: GoogleFonts.oswald(
              textStyle: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 30,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              return ListTile(
                title: Text(category['name']),
                onTap: () => _navigateToCategory(category['name']),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionsView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment
          .start, // Assure que tout le contenu est aligné à gauche
      children: [
        if (_currentCategory != null)
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0), // Ajoute un peu d'espacement autour du texte
            child: Text(
              "Catégorie: $_currentCategory",
              textAlign: TextAlign.left,
              style: GoogleFonts.oswald(
                textStyle: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 30,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _finalResponse ?? '',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              _resetToStart();
            },
            child: const Text("Revenir au début"),
          ),
        ],
      ),
    );
  }

  Widget _chatSanteView() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Entrez du texte',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                    // Afficher un message de confirmation
                    ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Message envoyé avec succès $professionnel!'),
                    ),
                    );
                  _resetToStart();
                },
              ),
            ],
          ),
          Text(
            _finalResponse ?? '',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              _resetToStart();
            },
            child: const Text("Revenir au début"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          // Gérer l'affichage des vues selon l'état de la conversation
          if (_finalResponse != null) {
            if (_finalResponse == "Envoyer un message au professionnel de santé.") {
              professionnel = "au professionnel de santé";
              return _chatSanteView();
            }
            if (_finalResponse == "Envoyer un message au coach.") {
              professionnel = "au coach";
              return _chatSanteView();
            }
            print(_finalResponse);
            if (_finalResponse == "Envoyer un message à la diététicienne.") {
              professionnel = "à la diététicienne";
              return _chatSanteView();
            }
            return _buildFinalResponseView();
          }

          if (_currentCategory == null) {
            return _buildCategoriesView();
          }

          return _buildQuestionsView();
        }, // Manquait cette accolade fermante pour le builder
      ),
    );
  }
}
