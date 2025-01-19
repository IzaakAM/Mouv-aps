import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final VoidCallback? onVideoFinished;

  const VideoPlayerWidget({
    super.key,
    required this.videoUrl,
    this.onVideoFinished});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isVideoFinished = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {});
      });

    // Add a listener to check if the video is finished
    _controller.addListener(() {
      if (_controller.value.position == _controller.value.duration) {
        // Video is finished, pause it and update the state
        if (!_isVideoFinished) {
          _isVideoFinished = true; // Set the flag to true
          _controller.pause();
          if (widget.onVideoFinished != null) {
            widget.onVideoFinished!();
          }
          setState(() {}); // Update the UI
        }
      } else {
        // Reset the flag if the video is playing
        if (_isVideoFinished && _controller.value.isPlaying) {
          _isVideoFinished = false;
          setState(() {});
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _controller.value.isInitialized
          ? Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
          ),
          // Play/Pause Button
          Positioned(
            bottom: 10,
            left: 6,
            child: FloatingActionButton(
              // transparent
              backgroundColor: Colors.black38.withOpacity(0.3),
              foregroundColor: Colors.white.withOpacity(0.9),
              onPressed: () {
                setState(() {
                  if (_isVideoFinished) {
                    // If the video is finished, reset and play from the start
                    _controller.seekTo(Duration.zero);
                    _controller.play();
                    _isVideoFinished = false; // Reset the flag
                  } else {
                    _controller.value.isPlaying
                        ? _controller.pause()
                        : _controller.play();
                  }
                });
              },
              child: Icon(
                _isVideoFinished || !_controller.value.isPlaying
                    ? Icons.play_arrow
                    : Icons.pause,
              ),
            ),
          ),
          // Time bar
          Positioned(
            width: MediaQuery.of(context).size.width,
            bottom: 0,
            child: VideoProgressIndicator(
              _controller,
              allowScrubbing: false,
              colors: VideoProgressColors(
                playedColor: Theme.of(context).colorScheme.primary,
                bufferedColor: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                backgroundColor: Theme.of(context).colorScheme.surface,
              ),
            ),
          ),
        ],
      )
          : const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
