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
  final UserForm userForm = UserForm();
  final PageController _pageController = PageController();
  int currentPage = 0;
  double progress = 0.0;

  // Define the form fields for each page
  final List<Widget> formPages = [
    IdentityFormPage(),
    PersonalDetailsFormPage(),
    MedicalInfoFormpage(),
    PhysicalExerciseFormpage(),
    NutritionFormPage()
  ];

  // Define the total number of pages
  final int totalPages = 5;

  // Update the progress based on the current page
  void updateProgress() {
    setState(() {
      progress = (currentPage + 1) / totalPages;
    });
  }

  // Move to the next page
  void nextPage() {
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
      // Open pop up
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Soumettre le formulaire ?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Annuler'),
              ),
              TextButton(
                onPressed: () {
                  print("Form Submitted: ${userForm.toJson()}");
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Formulaire soumis avec succès!')),
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

  @override
  Widget build(BuildContext context) {
    updateProgress();
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulaire',
            style: GoogleFonts.oswald(
                fontSize: 30,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.primary)),
      ),
      body: Column(
        children: [
          // Progress bar at the top
          LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: Theme.of(context).colorScheme.inverseSurface,
            valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary),
            borderRadius: const BorderRadius.all(Radius.circular(4)),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              children: formPages,
              onPageChanged: (index) {
                setState(() {
                  currentPage = index;
                  updateProgress();
                });
              },
            ),
          ),
          // Next button at the bottom
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (currentPage != 0)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        currentPage--;
                      });
                      _pageController.animateToPage(
                        currentPage,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                      updateProgress();
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Icon(Icons.chevron_left),
                  ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: nextPage,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Icon(
                    currentPage == totalPages - 1
                        ? Icons.check
                        : Icons.chevron_right,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
