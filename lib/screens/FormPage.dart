import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:mouv_aps/models/form.dart';
import 'package:mouv_aps/screens/form_pages/IdentityFormPage.dart';
import 'package:mouv_aps/screens/form_pages/MedicalInfoFormPage.dart';
import 'package:mouv_aps/screens/form_pages/NutritionFormPage.dart';
import 'package:mouv_aps/screens/form_pages/PersonalDetailsFormPage.dart';
import 'package:mouv_aps/screens/form_pages/PhysicalExerciseFormPage.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  FormPageState createState() => FormPageState();
}

class FormPageState extends State<FormPage> {
  // One key per page
  final List<GlobalKey<FormState>> formKeys = List.generate(
    5,
    (_) => GlobalKey<FormState>(),
  );

  final UserForm userForm = UserForm();
  final PageController _pageController = PageController();
  int currentPage = 0;
  double progress = 0.0;

  // We'll update the formPages list so each page gets a formKey
  late final List<Widget> formPages;

  // total number of pages
  final int totalPages = 5;

  @override
  void initState() {
    super.initState();
    // Initialize pages in initState (or directly inline),
    // passing the appropriate formKey to each page
    formPages = [
      IdentityFormPage(formKey: formKeys[0]),
      PersonalDetailsFormPage(formKey: formKeys[1]),
      MedicalInfoFormpage(formKey: formKeys[2]),
      PhysicalExerciseFormpage(formKey: formKeys[3]),
      NutritionFormPage(formKey: formKeys[4]),
    ];
  }

  // Update the progress based on the current page
  void updateProgress() {
    setState(() {
      progress = (currentPage + 1) / totalPages;
    });
  }

  // Move to the next page IF validation passes
  void nextPage() {
    final isValid = formKeys[currentPage].currentState!.validate();
    if (!isValid) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Erreur'),
              content: const Text('Certains champs sont invalides.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            );
          });
      return; // do not proceed if invalid
    }
    formKeys[currentPage].currentState!.save();

    // If valid and we're NOT on the last page, increment page
    if (currentPage < totalPages - 1) {
      setState(() {
        currentPage++;
      });
      _pageController.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      updateProgress();
    } else {
      // Last page -> show submission dialog
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Soumettre le formulaire ?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Annuler'),
              ),
              TextButton(
                onPressed: () {
                  print("Form Submitted: ${userForm.toJson()}");
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Formulaire soumis avec succès!'),
                    ),
                  );
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  // Optional: If going back, no need to validate
  void previousPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
      });
      _pageController.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      updateProgress();
    }
  }

  @override
  Widget build(BuildContext context) {
    updateProgress();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Formulaire',
          style: GoogleFonts.oswald(
            fontSize: 30,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      body: Column(
        children: [
          // Progress bar at the top
          LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: Theme.of(context).colorScheme.inverseSurface,
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
          ),
          // PageView
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              // We disable swiping so we can strictly control
              // when the user can proceed
              children: formPages,
              onPageChanged: (index) {
                setState(() {
                  currentPage = index;
                  updateProgress();
                });
              },
            ),
          ),
          // Bottom navigation
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Show "Back" button if not on the first page
                if (currentPage != 0)
                  ElevatedButton(
                    onPressed: previousPage,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Icon(Icons.chevron_left),
                  ),
                const SizedBox(width: 16),
                // "Next" or "Submit"
                ElevatedButton(
                  onPressed: nextPage,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Icon(
                    currentPage == totalPages - 1
                        ? Icons.check
                        : Icons.chevron_right,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
