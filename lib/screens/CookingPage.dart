import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mouv_aps/models/recipe.dart';
import 'package:mouv_aps/screens/AllRecipesPage.dart';
import 'package:mouv_aps/widgets/recipe_card.dart';
import 'package:provider/provider.dart';

import '../providers/recipe_provider.dart';

// Association of the meals in English and French
Map<String, String> meals = {
  'breakfast': 'Petit-déjeuner',
  'lunch': 'Déjeuner',
  'dinner': 'Dîner',
};

class CookingPage extends StatefulWidget {
  const CookingPage({super.key});

  @override
  State<CookingPage> createState() => _CookingPageState();
}

class _CookingPageState extends State<CookingPage> {
  @override
  void initState() {
    super.initState();
    final recipeProvider = Provider.of<RecipeProvider>(context, listen: false);
    recipeProvider.loadRecipes();
  }

  @override
  Widget build(BuildContext context) {
    final recipeProvider = Provider.of<RecipeProvider>(context);
    final recipes = recipeProvider.recipes;
    final breakfastRecipes = recipes.where((recipe) => recipe.meal == 'breakfast').toList();
    final lunchRecipes = recipes.where((recipe) => recipe.meal == 'lunch').toList();
    final dinnerRecipes = recipes.where((recipe) => recipe.meal == 'dinner').toList();
    return Scaffold(
      body: SingleChildScrollView(
        child: recipeProvider.isLoading
        ? const Center(child: CircularProgressIndicator())
        : recipeProvider.errorMessage.isNotEmpty
    ? Center(child: Text('Error: ${recipeProvider.errorMessage}'))
        : SingleChildScrollView(
    child:
        Column(
          children: <Widget>[
            if (breakfastRecipes.isNotEmpty)
            RecipeView(meal: 'breakfast', recipes: breakfastRecipes),
            if (lunchRecipes.isNotEmpty)
            RecipeView(meal: 'lunch', recipes: lunchRecipes),
            if (dinnerRecipes.isNotEmpty)
            RecipeView(meal: 'dinner', recipes: dinnerRecipes),
          ],
        ),
      ),
    ),
    );
  }
}

class RecipeView extends StatelessWidget {
  const RecipeView({super.key, required this.meal, required this.recipes});

  final String meal; // Breakfast, Lunch, Dinner
  final List<Recipe> recipes;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 0, 0),
      margin: const EdgeInsets.fromLTRB(8.0, 8.0, 0, 8.0),
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
                            for (final recipe in recipes)
                              RecipeCard(recipe: recipe),
                            IconButton(
                              icon: Icon(Icons.arrow_circle_right_outlined,
                                  size: 40,
                                  color: Theme.of(context).colorScheme.primary),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AllRecipesPage(meal: meal),
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
