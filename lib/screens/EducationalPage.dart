import 'package:flutter/material.dart';
import 'package:mouv_aps/widgets/videoplayer.dart';

class EducationalPage extends StatefulWidget {
  const EducationalPage({super.key});

  @override
  State<EducationalPage> createState() => _EducationalPageState();
}

class _EducationalPageState extends State<EducationalPage> {
  // Liste des vidéos éducatives
  final List<Map<String, String>> videos = [
    {
      'title': 'Les bienfaits de l\'activité physique',
      'thumbnail':
          'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png',
      'url': 'https://www.youtube.com/watch?v=exemple1',
    },
    {
      'title': 'Gérer votre maladie au quotidien',
      'thumbnail':
          'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png',
      'url': 'https://www.youtube.com/watch?v=exemple2',
    },
    {
      'title': 'Exercices adaptés à votre condition',
      'thumbnail':
          'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png',
      'url': 'https://www.youtube.com/watch?v=exemple3',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section texte court
          const Text(
            'Comprendre votre maladie',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'La maladie chronique peut affecter votre qualité de vie. '
            'Cependant, une activité physique régulière peut aider à améliorer '
            'votre santé et réduire les symptômes.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),

          // Section vidéos
          const Text(
            'Vidéos éducatives',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          VideoPlayerWidget(videoUrl: videos[0]['url']!),
        ],
      ),
    );
  }
}
