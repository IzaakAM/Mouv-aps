import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/recipe_provider.dart';
import '../widgets/recipe_card.dart';

// Association of the meals in English and French
Map<String, String> meals = {
  'breakfast': 'Petit-déjeuner',
  'lunch': 'Déjeuner',
  'dinner': 'Dîner',
};

class AllRecipesPage extends StatefulWidget {
  final String meal;

  const AllRecipesPage({Key? key, required this.meal}) : super(key: key);

  @override
  State<AllRecipesPage> createState() => _AllRecipesPageState();
}

class _AllRecipesPageState extends State<AllRecipesPage> {
  @override
  void initState() {
    super.initState();
    // 1. Fetch or refresh the recipes when the page initializes.
    //    If you already fetch recipes on app startup, you may not need this.
    final recipeProvider = Provider.of<RecipeProvider>(context, listen: false);
    recipeProvider.loadRecipes();
  }

  @override
  Widget build(BuildContext context) {
    final recipeProvider = Provider.of<RecipeProvider>(context);

    // 2. Handle loading state
    if (recipeProvider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // 3. Handle error state
    if (recipeProvider.errorMessage.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            meals[widget.meal] ?? widget.meal,
            style: GoogleFonts.oswald(
              textStyle: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        body: Center(
          child: Text('Error: ${recipeProvider.errorMessage}'),
        ),
      );
    }

    // 4. Filter recipes by meal
    final recipes = recipeProvider.recipes
        .where((recipe) => recipe.meal == widget.meal)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          meals[widget.meal] ?? widget.meal,
          style: GoogleFonts.oswald(
            textStyle: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      body: recipes.isEmpty
          ? Center(
        child: Text(
          'No recipes available for ${meals[widget.meal] ?? widget.meal}',
        ),
      )
          : GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          childAspectRatio: 1,
        ),
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          return RecipeCard(recipe: recipes[index]);
        },
      ),
    );
  }
}
