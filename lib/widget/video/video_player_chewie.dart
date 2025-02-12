import 'package:chats/widget/reponsive/extension.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerChewie extends StatelessWidget {
  final String videoUrl;

  const VideoPlayerChewie({super.key, required this.videoUrl});

  @override
  Widget build(BuildContext context) {
    final videoPlayerController = VideoPlayerController.network(videoUrl);
    final chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      looping: false,
      showControls: false,
    );

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Chewie(controller: chewieController),
        VideoProgressIndicator(
          videoPlayerController,
          allowScrubbing: true,
          padding: padding(bottom: 10),
        ),
      ],
    );
  }
}
