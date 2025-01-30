import 'package:flutter/material.dart';
import 'ChatPageDecisionTreeLoader.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// Import your Chat-related classes
import 'package:mouv_aps/models/conversation.dart';
import 'package:mouv_aps/providers/chat_provider.dart';
import 'ConversationPage.dart';

class Person {
  // ADDED backendUsername so we know who the staff is on the backend
  String name;
  String profession;
  String profilePhotoUrl;
  String dernierMessage;
  String backendUsername; // e.g. "alice"

  Person(this.name, this.profession, this.profilePhotoUrl,
      this.dernierMessage, this.backendUsername);
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

  // We keep the local "staff" list
  List<Person> _chatRecipients = [];

  @override
  void initState() {
    super.initState();
    _loadDecisionTree();
    _initializePersons();

    // ALSO fetch the real conversations from the ChatProvider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchConversations();
    });
  }

  // 1) fetch conversations
  Future<void> _fetchConversations() async {
    final chatProvider = context.read<ChatProvider>();
    await chatProvider.fetchConversations();
    // Once fetched, we can update UI so we can show last messages
    setState(() {});
  }

  // 2) define staff with real backend usernames
  void _initializePersons() {
    _chatRecipients = [
      Person(
        'Alice',
        "Coach",
        'assets/coach.webp',
        '...',
        'alice', // The backend username for Alice
      ),
      Person(
        'Sophie',
        "Docteur",
        'assets/doctor.webp',
        '...',
        'sophie', // The backend username for Sophie
      ),
      Person(
        'Charlie',
        "Nutritioniste",
        'assets/nutritionist.webp',
        '...',
        'charlie', // The backend username for Charlie
      ),
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

  ///
  /// 3) Helper method to open a conversation with a staff user
  ///
  Future<void> _openConversation(Person staff) async {
    final chatProvider = context.read<ChatProvider>();

    // 3a) Optionally, see if we already have a conversation with staff.backendUsername
    Conversation? existingConv = chatProvider.findConversationByUsername(staff.backendUsername);

    if (existingConv == null) {
      // 3b) If not found, create or send a first message
      // You can do a "hello" or empty message to auto-create conversation
      await chatProvider.sendMessageToUsername(staff.backendUsername, "Hello from me!");
      // Re-fetch or read from provider
      existingConv = chatProvider.findConversationByUsername(staff.backendUsername);
    }

    if (existingConv == null) {
      // If still null => some error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to open conversation.")),
      );
      return;
    }

    // 3c) Navigate to the conversation page
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ConversationPage(conversation: existingConv!)),
    );
  }

  ///
  /// 4) Build the main categories view, including "Mes derniers messages"
  ///
  Widget _buildCategoriesView() {
    // Access the ChatProvider data
    final chatProvider = context.watch<ChatProvider>();

    // Update the last message for each Person from real conversation data
    for (var p in _chatRecipients) {
      final conv = chatProvider.findConversationByUsername(p.backendUsername);
      if (conv != null && conv.messages.isNotEmpty) {
        p.dernierMessage = "${conv.messages.last.sender} : ${conv.messages.last.message}";
      } else {
        p.dernierMessage = "Aucun message récent";
      }
    }

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
                  onTap: () async {
                    // 4a) open the conversation with the staff
                    await _openConversation(person);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  ///
  /// The rest is your existing code for the chatbot
  ///
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
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
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
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                            ),
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

  // 5) The main build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chat & Questions")),
      body: Builder(
        builder: (context) {
          // If we have a finalResponse => show final or the "chatSanteView"
          if (_finalResponse != null) {
            if (_finalResponse == "Envoyer un message au professionnel de santé.") {
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

          // If no category selected => show the categories + last messages
          if (_currentCategory == null) {
            return _buildCategoriesView();
          }

          // If the question is the special "pain" => show the special form
          if (_currentQuestionText ==
              "Est-ce normal de ressentir des douleurs après une séance ?") {
            return _buildPainQuestionView();
          }

          // Otherwise show normal question list
          return _buildQuestionsView();
        },
      ),
    );
  }
}
