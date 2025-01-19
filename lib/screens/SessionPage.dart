import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

import '../models/session.dart';
import '../widgets/videoplayer.dart';

class SessionPage extends StatefulWidget {
  const SessionPage({super.key, required this.session});

  final Session session;

  @override
  State<SessionPage> createState() => _SessionPageState();
}

class _SessionPageState extends State<SessionPage> {
  late VideoPlayerController _controller;
  bool _isVideoFinished = false;

  @override
  void initState() {
    super.initState();
    _controller =
        VideoPlayerController.networkUrl(Uri.parse(widget.session.videoUrl))
          ..initialize().then((_) {
            setState(() {});
          });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void finishPopUp() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Félicitations'),
          content: const Text('Vous avez terminé cette session !'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.session.title,
            style: GoogleFonts.oswald(
              textStyle: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 30,
                fontWeight: FontWeight.w500,
              ),
            )),
        // Icon
        actions: [
          IconButton(
              icon: const Icon(Icons.check),
              color: _isVideoFinished
                  ? Theme.of(context).colorScheme.onSurface
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              onPressed: () {
                if (_isVideoFinished) {
                  finishPopUp();
                }
              }),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            VideoPlayerWidget(
                videoUrl: widget.session.videoUrl,
                onVideoFinished: () {
                  setState(() {
                    _isVideoFinished = true;
                  });
                }),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.checklist_rounded),
                const SizedBox(width: 10),
                Text('${widget.session.steps.length} exercices',
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    )),
                const SizedBox(width: 20),
                const Icon(Icons.hourglass_empty_rounded),
                const SizedBox(width: 10),
                Text('${widget.session.duration} minutes',
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
                  const SizedBox(height: 10),
                  Text(
                    'Étapes :',
                    style: GoogleFonts.oswald(
                      textStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  StepList(steps: widget.session.steps),
                ],
              ),
            ),
          ],
        ),
      ),
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
