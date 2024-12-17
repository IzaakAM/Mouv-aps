import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mouv_aps/models/session.dart';

class TrainingPage extends StatefulWidget {
  const TrainingPage({super.key});

  @override
  State<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Cette semaine",
                style: GoogleFonts.oswald(
                  textStyle: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 30,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ClipRect(child: SessionGrid()),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class SessionGrid extends StatelessWidget {
  List<Session> sessions;

  SessionGrid({super.key, this.sessions = const []});

  @override
  Widget build(BuildContext context) {
    sessions = List.generate(
        3,
        (index) => Session(
              title: "Session $index",
              duration: 30,
              videoUrl: "",
              thumbnailUrl:
                  "https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png",
              isLocked: index == 2,
              isFinished: index == 0,
            ));
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, index) {
        return SessionPreview(session: sessions[index]);
      },
      itemCount: sessions.length,
    );
  }
}

class SessionPreview extends StatelessWidget {
  final Session session;

  const SessionPreview({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: [
              AspectRatio(
                aspectRatio: 4 / 3,
                child: Image.network(
                  colorBlendMode: (session.isFinished || session.isLocked) ? BlendMode.darken : BlendMode.dst,
                  color: Colors.black.withOpacity(0.4),
                  session.thumbnailUrl,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Icon(
                  session.isLocked
                      ? Icons.lock
                      : (session.isFinished ? Icons.check_circle : Icons.play_circle_fill),
                  color: Colors.white,
                  size: 36,
                ),
              ),
            ],
          ),
        ),

        Text(
          session.title,
          style: GoogleFonts.lato(
            textStyle: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          "${session.duration} min",
          style: GoogleFonts.lato(
            textStyle: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}