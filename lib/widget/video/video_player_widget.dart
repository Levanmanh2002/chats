import 'package:chats/main.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget({super.key, required this.videoUrl});
  final String videoUrl;

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  final ValueNotifier<bool> _isPlayingNotifier = ValueNotifier(false);
  final ValueNotifier<bool> _isInitializedNotifier = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        _isInitializedNotifier.value = true;
        _isPlayingNotifier.value = _controller.value.isPlaying;
      });

    _controller.addListener(() {
      _isPlayingNotifier.value = _controller.value.isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ValueListenableBuilder<bool>(
        valueListenable: _isInitializedNotifier,
        builder: (context, isInitialized, child) {
          if (!isInitialized) {
            return Center(child: CircularProgressIndicator(color: appTheme.appColor));
          }
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _isPlayingNotifier.dispose();
    _isInitializedNotifier.dispose();
    super.dispose();
  }
}
