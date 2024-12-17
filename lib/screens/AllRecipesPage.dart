import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/recipe.dart';
import '../widgets/recipe_card.dart';

// Association of the meals in English and French
Map<String, String> meals = {
  'Breakfast': 'Petit-déjeuner',
  'Lunch': 'Déjeuner',
  'Dinner': 'Dîner',
};

class AllRecipesPage extends StatelessWidget {
  final String meal;

  const AllRecipesPage({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    List<RecipeCard> recipes = [
      RecipeCard(
          recipe: Recipe(
        id: 1,
        title: 'Pancakes',
        thumbnailUrl:
            'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png',
        ingredients: {
          'farine': 200,
          'levure': 1,
          'oeufs': 2,
        },
        steps: [
          'Mélanger la farine et la levure',
          'Ajouter les oeufs',
          'Mélanger',
          'Cuire les pancakes dans une poêle chaude'
        ],
        duration: 20,
        requiredPoints: 10,
        meal: 'Breakfast',
        videoUrl: 'https://www.youtube.com/watch?v=3tQ1v0Y3yfA',
      )),
      RecipeCard(
          recipe: Recipe(
        id: 2,
        title: 'Spaghetti',
        thumbnailUrl:
            'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png',
        ingredients: {
          'spaghetti': 200,
          'viande hachée': 200,
          'tomates': 2,
        },
        steps: [
          'Faire cuire les spaghetti',
          'Faire revenir la viande hachée',
          'Ajouter les tomates',
          'Mélanger les spaghetti et la sauce'
        ],
        duration: 30,
        requiredPoints: 15,
        meal: 'Lunch',
        videoUrl: 'https://www.youtube.com/watch?v=3tQ1v0Y3yfA',
      ))
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          meals[meal]!,
          style: GoogleFonts.oswald(
            textStyle: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 30,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          childAspectRatio: 1,
        ),
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          return recipes[index];
        },
      ),
    );
  }
}
