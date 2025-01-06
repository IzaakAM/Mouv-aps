import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mouv_aps/models/session.dart';

import 'SessionPage.dart';

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
                steps: [
                  "Step 1",
                  "Step 2",
                  "Step 3",
                ]));
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
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
    return GestureDetector(
      onTap: () {
        if (!session.isLocked && !session.isFinished) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SessionPage(session: session),
            ),
          );
        }
        else if (session.isFinished) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              duration: Duration(seconds: 2),
              content: Text("Cette session est déjà terminée."),
            ),
          );
        }
        else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              duration: Duration(seconds: 2),
              content: Text("Cette session est verrouillée."),
            ),
          );
        }
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
          children: <Widget>[
            Stack(
            children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(9),
              child: Image.network(
                color: Colors.black.withOpacity(0.4),
                colorBlendMode: (session.isFinished || session.isLocked)
                    ? BlendMode.darken
                    : BlendMode.dst,
                session.thumbnailUrl,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: session.isLocked
                  ? const Icon(Icons.lock)
                  : session.isFinished
                      ? const Icon(Icons.check)
                      : const SizedBox(),
            ),
          ],
        ),
            const SizedBox(height: 10),
            Text(
              session.title,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "${session.duration} minutes",
            ),
          ],
        ),
      ),
    );
  }
}
