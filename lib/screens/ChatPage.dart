import 'package:flutter/material.dart';
import 'ChatPageDecisionTreeLoader.dart';
import 'package:google_fonts/google_fonts.dart';

class Person {
  String name;
  String profession;
  String profilePhotoUrl;
  String dernierMessage;

  Person(this.name, this.profession, this.profilePhotoUrl, this.dernierMessage);
}

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
  List<dynamic> _chatRecipients = [];

  @override
  void initState() {
    super.initState();
    _loadDecisionTree();
    _initializePersons();
  }

  void _initializePersons() {
    _chatRecipients = [
      Person('Alice', "Coach", 'assets/coach.webp',
          'Moi : Bonjour, j\'aurais une question'),
      Person('Sophie', "Docteur", 'assets/doctor.webp',
          'Sophie : Enchantée, je suis la professionnelle de santé'),
      Person('Charlie', "Nutritioniste", 'assets/nutritionist.webp',
          'Charlie : Enchanté, je suis le nutritioniste'),
    ];
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

  void _goBack() {
    if (_finalResponse != null) {
      setState(() {
        _finalResponse = null;
        _currentQuestionText = null;
        _currentOptions = [];
      });
    } else if (_currentQuestionText != null) {
      setState(() {
        _currentQuestionText = null;
        _currentOptions = [];
      });
    } else if (_currentCategory != null) {
      setState(() {
        _currentCategory = null;
        _currentQuestions = [];
      });
    }
  }

  Widget _buildCategoriesView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(0.1),
          child: Text(
            "Veuillez choisir une catégorie :",
            style: GoogleFonts.oswald(
              textStyle: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 30,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        Flexible(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 16.0),
                      textStyle: GoogleFonts.oswald(
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      minimumSize:
                          const Size(200, 50), // Adjust the size as needed
                    ),
                    onPressed: () => _navigateToCategory(category['name']),
                    child: Text(category['name']),
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(0.1),
          child: Text(
            "Mes derniers messages :",
            style: GoogleFonts.oswald(
              textStyle: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 30,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        Flexible(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _chatRecipients.length,
            itemBuilder: (context, index) {
              final person = _chatRecipients[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(person.profilePhotoUrl),
                  ),
                  title: Text(
                    '${person.name} - ${person.profession}',
                    style: GoogleFonts.oswald(),
                  ),
                  subtitle: Text(
                    person.dernierMessage,
                    style: GoogleFonts.oswald(),
                  ),
                  onTap: () {},
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionsView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: _goBack,
            ),
            if (_currentCategory != null)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
          ],
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
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _goBack,
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

  Widget _chatSanteView() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Entrez du texte',
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('Message envoyé avec succès $professionnel!'),
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

  Widget _buildPainQuestionView() {
    Map<String, dynamic> _selectedOptions = {};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: _goBack,
            ),
            if (_currentCategory != null)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
          ],
        ),
        const SizedBox(height: 10),
        if (_currentQuestionText != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _currentQuestionText!,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        if (_currentOptions.isNotEmpty)
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                child: Column(
                  children: _currentOptions.map((option) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            option['question'],
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        ...option['options'].map<Widget>((opt) {
                          return ListTile(
                            title: Text(opt),
                            leading: Radio(
                              value: opt,
                              groupValue: _selectedOptions[option['question']],
                              onChanged: (value) {
                                setState(() {
                                  _selectedOptions[option['question']] = value;
                                });
                              },
                              fillColor: MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.selected)) {
                                    return Theme.of(context).colorScheme.primary;
                                  }
                                  return Colors.grey;
                                },
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              // Handle form submission
            },
            child: const Text("Envoi"),
          ),
        ),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Builder(
        builder: (context) {
          if (_finalResponse != null) {
            if (_finalResponse ==
                "Envoyer un message au professionnel de santé.") {
              professionnel = "au professionnel de santé";
              return _chatSanteView();
            }
            if (_finalResponse == "Envoyer un message au coach.") {
              professionnel = "au coach";
              return _chatSanteView();
            }
            if (_finalResponse == "Envoyer un message à la diététicienne.") {
              professionnel = "à la diététicienne";
              return _chatSanteView();
            }
            return _buildFinalResponseView();
          }

          if (_currentCategory == null) {
            return _buildCategoriesView();
          }

          if (_currentQuestionText ==
              "Est-ce normal de ressentir des douleurs après une séance ?") {
            return _buildPainQuestionView();
          }

          return _buildQuestionsView();
        },
      ),
    );
  }
}
