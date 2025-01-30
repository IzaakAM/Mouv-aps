import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mouv_aps/services/api_service.dart';
import 'package:video_player/video_player.dart';

import '../models/recipe.dart';
import '../widgets/videoplayer.dart';

class RecipePage extends StatefulWidget {
  const RecipePage({super.key, required this.recipe});

  final Recipe recipe;

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  late VideoPlayerController _controller;
  String videoUrl = '';

  @override
  void initState() {
    super.initState();
    _fetchVideoUrl();
  }

  Future<void> _fetchVideoUrl() async {
    final url = await ApiService.getVideoURL(widget.recipe.videoId);
    setState(() {
      videoUrl = url;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe.title,
            style: GoogleFonts.oswald(
              textStyle: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 30,
                fontWeight: FontWeight.w500,
              ),
            )),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            VideoPlayerWidget(videoUrl: videoUrl),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.hourglass_empty_rounded),
                const SizedBox(width: 10),
                Text('${widget.recipe.duration} minutes',
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    )),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(indent: 10, endIndent: 10),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ingrédients:',
                    style: GoogleFonts.oswald(
                      textStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  IngredientList(ingredients: widget.recipe.ingredients),
                  const SizedBox(height: 10),
                  Text(
                    'Instructions:',
                    style: GoogleFonts.oswald(
                      textStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  StepList(steps: widget.recipe.steps),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IngredientList extends StatelessWidget {
  const IngredientList({Key? key, required this.ingredients}) : super(key: key);

  final Map<String, String> ingredients;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: ingredients.entries
          .map((entry) => ListTile(
                title: Text(entry.key),
                trailing: Text(entry.value.toString()),
              ))
          .toList(),
    );
  }
}

class StepList extends StatelessWidget {
  const StepList({super.key, required this.steps});

  final List<String> steps;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: steps
          .map((step) => ListTile(
                title: Text("Step ${steps.indexOf(step) + 1}"),
                subtitle: Text(step),
              ))
          .toList(),
    );
  }
}
