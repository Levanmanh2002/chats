import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chats/main.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoPath;
  final bool isLocal;

  const VideoPlayerWidget({
    super.key,
    required this.videoPath,
    this.isLocal = false,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget>
    with AutomaticKeepAliveClientMixin {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  String? _currentPath;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _initController(widget.videoPath);
  }

  Future<void> _initController(String path) async {
    if (_currentPath == path && _controller != null) return;

    _currentPath = path;
    _controller?.dispose();

    final controller = kIsWeb
        ? VideoPlayerController.networkUrl(Uri.parse(path))
        : (widget.isLocal
            ? VideoPlayerController.file(File(path))
            : VideoPlayerController.networkUrl(Uri.parse(path)));

    setState(() => _isInitialized = false);

    try {
      await controller.initialize();
      setState(() {
        _controller = controller;
        _isInitialized = true;
      });
    } catch (e) {
      debugPrint('Video init error: $e');
    }
  }

  @override
  void didUpdateWidget(VideoPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoPath != widget.videoPath) {
      _initController(widget.videoPath);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (!_isInitialized || _controller == null) {
      return Container(
        alignment: Alignment.center,
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: appTheme.grayColor.withOpacity(0.2),
        ),
        child: CircularProgressIndicator(color: appTheme.appColor, strokeWidth: 2),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: AspectRatio(
        aspectRatio: _controller!.value.aspectRatio,
        child: Stack(
          alignment: Alignment.center,
          children: [
            VideoPlayer(_controller!),
            if (!_controller!.value.isPlaying)
              const Icon(Icons.play_circle_fill, color: Colors.white70, size: 48),
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  if (_controller!.value.isPlaying) {
                    _controller!.pause();
                  } else {
                    _controller!.play();
                  }
                  setState(() {});
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
