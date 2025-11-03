import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class VideoPreview extends StatefulWidget {
  final String videoUrl;
  final bool isLocal;

  const VideoPreview({
    super.key,
    required this.videoUrl,
    this.isLocal = false,
  });

  @override
  State<VideoPreview> createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<VideoPreview> with AutomaticKeepAliveClientMixin {
  static final Map<String, Uint8List?> _thumbnailCache = {};
  Uint8List? _thumbnail;
  bool _isGenerating = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadThumbnail();
  }

  @override
  void didUpdateWidget(VideoPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl) {
      _loadThumbnail();
    }
  }

  Future<void> _loadThumbnail() async {
    final cached = _thumbnailCache[widget.videoUrl];
    if (cached != null) {
      setState(() => _thumbnail = cached);
      return;
    }

    setState(() => _isGenerating = true);

    try {
      final thumb = await VideoThumbnail.thumbnailData(
        video: widget.videoUrl,
        imageFormat: ImageFormat.JPEG,
        maxHeight: 200,
        quality: 75,
      );

      if (!mounted) return;
      setState(() {
        _thumbnail = thumb;
        _isGenerating = false;
      });

      _thumbnailCache[widget.videoUrl] = thumb;
    } catch (e) {
      debugPrint('Thumbnail error: $e');
      setState(() => _isGenerating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (_isGenerating && _thumbnail == null) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: _thumbnail != null
              ? Image.memory(_thumbnail!, fit: BoxFit.cover)
              : Container(
                  color: Colors.grey.shade300,
                  width: double.infinity,
                  height: 200,
                  child: const Icon(Icons.play_circle_fill, size: 48, color: Colors.grey),
                ),
        ),
        const Icon(Icons.play_circle_fill, color: Colors.white, size: 48),
      ],
    );
  }
}
