import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../services/secure_storage_service.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final VoidCallback? onVideoFinished;

  const VideoPlayerWidget({
    super.key,
    required this.videoUrl,
    this.onVideoFinished,
  });

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController? _controller;
  bool _isVideoFinished = false;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  Future<void> _initController() async {
    print('Video URL: ${widget.videoUrl}');

    final token = await SecureStorageService().read('jwt_access');
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
      httpHeaders: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    // Initialize the controller
    await _controller!.initialize();

    // Add listener only after initialization
    _controller!.addListener(_checkVideoCompletion);

    if (mounted) {
      setState(() {}); // Update UI when the controller is ready
    }
  }

  void _checkVideoCompletion() {
    if (_controller == null) return;

    final position = _controller!.value.position;
    final duration = _controller!.value.duration;

    if (duration != null && position >= (duration - const Duration(milliseconds: 500))) {
      if (!_isVideoFinished) {
        _isVideoFinished = true;
        _controller!.pause();
        widget.onVideoFinished?.call();
        if (mounted) {
          setState(() {});
        }
      }
    } else if (_isVideoFinished && _controller!.value.isPlaying) {
      _isVideoFinished = false;
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_checkVideoCompletion);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _controller != null && _controller!.value.isInitialized
          ? Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: AspectRatio(
              aspectRatio: _controller!.value.aspectRatio,
              child: VideoPlayer(_controller!),
            ),
          ),
          // Play/Pause Button
          Positioned(
            bottom: 10,
            left: 6,
            child: FloatingActionButton(
              backgroundColor: Colors.black38.withOpacity(0.3),
              foregroundColor: Colors.white.withOpacity(0.9),
              onPressed: () {
                setState(() {
                  if (_isVideoFinished) {
                    _controller!.seekTo(Duration.zero);
                    _controller!.play();
                    _isVideoFinished = false;
                  } else {
                    _controller!.value.isPlaying
                        ? _controller!.pause()
                        : _controller!.play();
                  }
                });
              },
              child: Icon(
                _isVideoFinished || !_controller!.value.isPlaying
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
              _controller!,
              allowScrubbing: false,
              colors: VideoProgressColors(
                playedColor: Theme.of(context).colorScheme.primary,
                bufferedColor: Theme.of(context)
                    .colorScheme
                    .primary
                    .withOpacity(0.5),
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
