import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mouv_aps/models/recipe.dart';
import 'package:mouv_aps/screens/AllRecipesPage.dart';
import 'package:mouv_aps/widgets/recipe_card.dart';

// Association of the meals in English and French
Map<String, String> meals = {
  'Breakfast': 'Petit-déjeuner',
  'Lunch': 'Déjeuner',
  'Dinner': 'Dîner',
};

class CookingPage extends StatefulWidget {
  const CookingPage({super.key});

  @override
  State<CookingPage> createState() => _CookingPageState();
}

class _CookingPageState extends State<CookingPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            RecipeView(meal: 'Breakfast'),
            RecipeView(meal: 'Lunch'),
            RecipeView(meal: 'Dinner'),
          ],
        ),
      ),
    );
  }
}

class RecipeView extends StatelessWidget {
  const RecipeView({super.key, required this.meal});

  final String meal; // Breakfast, Lunch, Dinner

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            meals[meal]!,
            style: GoogleFonts.oswald(
              textStyle: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 30,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: <Widget>[
                RecipeCard(
                  recipe: Recipe(
                      id: 1,
                      title: 'Recipe 1',
                      videoUrl:
                          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
                      requiredPoints: 10,
                      duration: 20,
                      meal: meal,
                      ingredients: {'ingredient1': 1},
                      steps: ['step1', 'step2'],
                      thumbnailUrl:
                          'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png'),
                ),
                RecipeCard(
                  recipe: Recipe(
                      id: 2,
                      title: 'Recipe 2',
                      videoUrl:
                          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
                      requiredPoints: 10,
                      duration: 20,
                      meal: meal,
                      ingredients: {'ingredient1': 1},
                      steps: ['step1', 'step2'],
                      thumbnailUrl:
                          'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png'),
                ),
                RecipeCard(
                  recipe: Recipe(
                      id: 3,
                      title: 'Recipe 3',
                      videoUrl:
                          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
                      requiredPoints: 10,
                      duration: 20,
                      meal: meal,
                      ingredients: {'ingredient1': 1},
                      steps: ['step1', 'step2'],
                      thumbnailUrl:
                          'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png'),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_circle_right_outlined, size: 40),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AllRecipesPage(meal: meal),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
