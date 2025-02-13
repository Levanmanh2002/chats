import 'dart:io';

import 'package:chats/main.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerChewie extends StatefulWidget {
  final String videoPath;
  final bool isLocal;

  const VideoPlayerChewie({super.key, required this.videoPath, this.isLocal = false});

  @override
  State<VideoPlayerChewie> createState() => _VideoPlayerChewieState();
}

class _VideoPlayerChewieState extends State<VideoPlayerChewie> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() async {
    _videoController = widget.isLocal
        ? VideoPlayerController.file(File(widget.videoPath))
        : VideoPlayerController.networkUrl(Uri.parse(widget.videoPath));

    await _videoController.initialize();

    setState(() {
      _chewieController = ChewieController(
        videoPlayerController: _videoController,
        autoPlay: true,
        looping: false,
        showControls: false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_chewieController == null || !_videoController.value.isInitialized) {
      return Center(child: CircularProgressIndicator(color: appTheme.appColor));
    }

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Chewie(controller: _chewieController!),
        VideoProgressIndicator(
          _videoController,
          allowScrubbing: true,
          padding: padding(bottom: 10),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController?.dispose();
    _videoController.pause();
    _chewieController?.pause();
    super.dispose();
  }
}
