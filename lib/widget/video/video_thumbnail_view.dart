import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';

import 'package:flutter/material.dart';

class WebVideoThumbnail extends StatefulWidget {
  final String videoUrl;
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const WebVideoThumbnail({
    super.key,
    required this.videoUrl,
    this.width = 200,
    this.height = 120,
    this.borderRadius,
  });

  @override
  State<WebVideoThumbnail> createState() => _WebVideoThumbnailState();
}

class _WebVideoThumbnailState extends State<WebVideoThumbnail> with AutomaticKeepAliveClientMixin {
  static final Map<String, Uint8List?> _thumbnailCache = {}; // 🔥 cache theo URL
  Uint8List? _thumbnailBytes;
  bool _isGenerating = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadThumbnail();
  }

  @override
  void didUpdateWidget(WebVideoThumbnail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl) {
      _loadThumbnail();
    }
  }

  Future<void> _loadThumbnail() async {
    final cached = _thumbnailCache[widget.videoUrl];
    if (cached != null) {
      setState(() {
        _thumbnailBytes = cached;
        _isGenerating = false;
      });
      return;
    }

    await _generateThumbnail();
  }

  Future<void> _generateThumbnail() async {
    setState(() => _isGenerating = true);

    try {
      final video = html.VideoElement()
        ..src = widget.videoUrl
        ..muted = true
        ..autoplay = true
        ..crossOrigin = 'anonymous'
        ..style.display = 'none';
      html.document.body?.append(video);

      await video.onLoadedMetadata.first;
      video.currentTime = 0.1;
      await video.onSeeked.first;

      final canvas = html.CanvasElement(
        width: widget.width.toInt(),
        height: widget.height.toInt(),
      );
      final ctx = canvas.context2D;
      ctx.drawImageScaled(video, 0, 0, widget.width, widget.height);

      final dataUrl = canvas.toDataUrl('image/jpeg', 0.8);
      final base64Data = dataUrl.split(',').last;
      final bytes = base64.decode(base64Data);

      video.remove();

      if (!mounted) return;
      setState(() {
        _thumbnailBytes = Uint8List.fromList(bytes);
        _isGenerating = false;
      });

      _thumbnailCache[widget.videoUrl] = _thumbnailBytes;
    } catch (e) {
      debugPrint('Thumbnail generation error: $e');
      setState(() => _isGenerating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final border = widget.borderRadius ?? BorderRadius.circular(12);

    return ClipRRect(
      borderRadius: border,
      child: Container(
        width: widget.width,
        height: widget.height,
        color: Colors.grey.shade300,
        alignment: Alignment.center,
        child: _isGenerating
            ? const CircularProgressIndicator(strokeWidth: 2)
            : (_thumbnailBytes != null
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.memory(
                        _thumbnailBytes!,
                        width: widget.width,
                        height: widget.height,
                        fit: BoxFit.cover,
                      ),
                      const Icon(
                        Icons.play_circle_fill,
                        color: Colors.white,
                        size: 48,
                      ),
                    ],
                  )
                : const Icon(Icons.videocam_off, size: 48, color: Colors.grey)),
      ),
    );
  }
}
