import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:accueil/models/recipe.dart';
import 'package:accueil/widgets/recipe_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final int points = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildHomeContent(),
    );
  }

  Widget _buildHomeContent() {
    final recipes = [
      Recipe(
        id: 1,
        title: 'Recipe 1',
        videoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
        requiredPoints: 10,
        duration: 20,
        meal: 'Breakfast',
        ingredients: {'ingredient1': 1},
        steps: ['step1', 'step2'],
        thumbnailUrl: 'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png',
      ),
      Recipe(
        id: 2,
        title: 'Recipe 2',
        videoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
        requiredPoints: 15,
        duration: 20,
        meal: 'Lunch',
        ingredients: {'Vegetables': 4},
        steps: ['Step 1', 'Step 2'],
        thumbnailUrl: 'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png',
      ),
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
               Text(
                "Mon activité du jour",
                style: GoogleFonts.oswald(
                  textStyle: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 30,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/images/run.jpg',
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: const [
                        Row(
                          children: [
                            Icon(Icons.directions_run, color: Colors.blue),
                            SizedBox(width: 5),
                            Text(
                              'Course',
                              style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'ArialNovaCondensed'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Column(
                      children: const [
                        Row(
                          children: [
                            Icon(Icons.timer, color: Colors.blue),
                            SizedBox(width: 8),
                            Text(
                              '15 minutes',
                              style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'ArialNovaCondensed'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Column(
                      children: const [
                        Row(
                          children: [
                            Icon(Icons.fitness_center, color: Colors.blue),
                            SizedBox(width: 8),
                            Text(
                              '5 exercices',
                              style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'ArialNovaCondensed'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
                "Petit creux",
                style: GoogleFonts.oswald(
                  textStyle: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 30,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
          const SizedBox(height: 10),
          SizedBox(
            height: 160,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                final recipe = recipes[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: RecipeCard(recipe: recipe),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
