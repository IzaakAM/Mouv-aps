import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/recipe.dart';
import '../models/session.dart';
import '../widgets/recipe_card.dart';
import 'SessionPage.dart';

class HomePage extends StatefulWidget {
  final PageController pageController;

  const HomePage({super.key, required this.pageController});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // create recipes
    final recipes = List.generate(
      3,
      (index) => Recipe(
        title: "Recipe $index",
        duration: 30,
        videoUrl: "",
        thumbnailUrl:
            "https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png",
        id: 1,
        requiredPoints: 10,
        meal: 'breakfast',
        ingredients: {'ingredient1': 1},
        steps: ['step1', 'step2'],
      ),
    );
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: NextActivityView()),
            Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                child: RecipeView(recipes: recipes)),
            Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: HealthInfoButton(pageController: widget.pageController)),
          ],
        ),
      ),
    );
  }
}

class NextActivityView extends StatelessWidget {
  const NextActivityView({super.key});

  @override
  Widget build(BuildContext context) {
    // create session
    final session = Session(
      title: "Session 1",
      duration: 30,
      videoUrl: "",
      thumbnailUrl:
          "https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png",
      isLocked: false,
      steps: ['step1', 'step2'],
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Title
        Text(
          "Prochaine activité",
          style: GoogleFonts.oswald(
            textStyle: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 30,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        // Session
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SessionPage(session: session),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Image
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(9),
                      child: Image.network(
                        session.thumbnailUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
                // Info
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        session.title,
                        style: GoogleFonts.oswald(
                          textStyle: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.checklist_rounded),
                          const SizedBox(width: 10),
                          Text('${session.steps.length} exercices'),
                          const SizedBox(width: 20),
                          const Icon(Icons.hourglass_empty_rounded),
                          const SizedBox(width: 10),
                          Text('${session.duration} minutes'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class RecipeView extends StatelessWidget {
  final List<Recipe> recipes;

  const RecipeView({super.key, required this.recipes});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8),
      margin: const EdgeInsets.fromLTRB(10, 10, 0, 0),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
            width: 1,
          ),
          top: BorderSide(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
            width: 1,
          ),
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
            width: 1,
          ),
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          bottomLeft: Radius.circular(10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              "Un petit creux ?",
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:
                  recipes.map((recipe) => RecipeCard(recipe: recipe)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class HealthInfoButton extends StatelessWidget {
  final PageController pageController;

  const HealthInfoButton({super.key, required this.pageController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          "Détails",
          style: GoogleFonts.oswald(
            textStyle: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 30,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(height: 10),
        InkWell(
          onTap: () {
            pageController.animateToPage(
              3, // Health info page index
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Informations santé",
                  style: GoogleFonts.oswald(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
