import 'package:chats/utils/app/file_content_type.dart';

extension FileExtension on String {
  FileContentType get fileType {
    final ext = toLowerCase();

    // Hình ảnh
    if (ext.contains('.png')) return FileContentType.PNG;
    if (ext.contains('.jpg') || ext.endsWith('.jpeg')) return FileContentType.JPG;
    if (ext.contains('.gif')) return FileContentType.GIF;
    if (ext.contains('.webp')) return FileContentType.WEBP;
    if (ext.contains('.bmp')) return FileContentType.BMP;

    // Video
    if (ext.contains('.mp4')) return FileContentType.MP4;
    if (ext.contains('.mov')) return FileContentType.MOV;
    if (ext.contains('.avi')) return FileContentType.AVI;
    if (ext.contains('.mkv')) return FileContentType.MKV;

    // Âm thanh
    if (ext.contains('.mp3')) return FileContentType.MP3;
    if (ext.contains('.wav')) return FileContentType.WAV;
    if (ext.contains('.aac')) return FileContentType.AAC;
    if (ext.contains('.flac')) return FileContentType.FLAC;

    // Tài liệu
    if (ext.contains('.pdf')) return FileContentType.PDF;
    if (ext.contains('.doc') || ext.contains('.docx')) return FileContentType.DOC;
    if (ext.contains('.xls') || ext.contains('.xlsx')) return FileContentType.XLS;
    if (ext.contains('.ppt') || ext.contains('.pptx')) return FileContentType.PPT;
    if (ext.contains('.txt')) return FileContentType.TXT;

    // File nén
    if (ext.contains('.zip')) return FileContentType.ZIP;
    if (ext.contains('.rar')) return FileContentType.RAR;

    // Mặc định nếu không khớp
    return FileContentType.UNKNOWN;
  }

  FileCategory get getFileCategory {
    final lower = toLowerCase();

    if (lower.startsWith('video/')) return FileCategory.VIDEO;
    if (lower.startsWith('audio/')) return FileCategory.AUDIO;
    if (lower.startsWith('image/')) return FileCategory.IMAGE;
    if (lower.startsWith('application/pdf') || lower.startsWith('application/msword') || lower.contains('text')) {
      return FileCategory.DOCUMENT;
    }

    if (toLowerCase().contains('pdf') ||
        toLowerCase().contains('doc') || // doc, docx
        toLowerCase().contains('xls') || // xls, xlsx
        toLowerCase().contains('ppt') || // ppt, pptx
        toLowerCase().contains('sheet') ||
        toLowerCase().contains('text')) {
      return FileCategory.DOCUMENT;
    }

    final ext = toLowerCase().split('/').last;

    const imageExts = {'png', 'jpg', 'jpeg', 'gif', 'webp', 'bmp'};
    const videoExts = {'mp4', 'mov', 'avi', 'mkv'};
    const audioExts = {'mp3', 'wav', 'aac', 'flac'};
    const docExts = {'pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx', 'txt', 'sheet'};
    const zipExts = {'zip', 'rar'};

    if (imageExts.contains(ext)) return FileCategory.IMAGE;
    if (videoExts.contains(ext)) return FileCategory.VIDEO;
    if (audioExts.contains(ext)) return FileCategory.AUDIO;
    if (docExts.contains(ext)) return FileCategory.DOCUMENT;
    if (zipExts.contains(ext)) return FileCategory.COMPRESSED;

    return FileCategory.UNKNOWN;
  }

  String get resolveMimeType {
    final extension = toLowerCase().split('.').last;

    switch (extension) {
      // 🖼 Ảnh
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'bmp':
        return 'image/bmp';
      case 'webp':
        return 'image/webp';
      case 'heic':
      case 'heif':
        return 'image/heic';

      // 🎥 Video
      case 'mp4':
        return 'video/mp4';
      case 'mov':
        return 'video/quicktime';
      case 'avi':
        return 'video/x-msvideo';
      case 'mkv':
        return 'video/x-matroska';
      case '3gp':
        return 'video/3gpp';
      case '3g2':
        return 'video/3gpp2';
      case 'm4v':
        return 'video/x-m4v';
      case 'webm':
        return 'video/webm';
      case 'flv':
        return 'video/x-flv';
      case 'ts':
      case 'm2ts':
        return 'video/mp2t';

      // 🎵 Audio
      case 'mp3':
        return 'audio/mpeg';
      case 'wav':
        return 'audio/wav';
      case 'aac':
        return 'audio/aac';
      case 'ogg':
        return 'audio/ogg';
      case 'oga':
        return 'audio/ogg';
      case 'm4a':
        return 'audio/mp4';
      case 'flac':
        return 'audio/flac';
      case 'amr':
        return 'audio/amr';

      // 📄 Tài liệu
      case 'pdf':
        return 'application/pdf';
      case 'doc':
        return 'application/msword';
      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case 'xls':
        return 'application/vnd.ms-excel';
      case 'xlsx':
        return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
      case 'ppt':
        return 'application/vnd.ms-powerpoint';
      case 'pptx':
        return 'application/vnd.openxmlformats-officedocument.presentationml.presentation';
      case 'txt':
        return 'text/plain';
      case 'csv':
        return 'text/csv';
      case 'json':
        return 'application/json';
      case 'zip':
        return 'application/zip';
      case 'rar':
        return 'application/vnd.rar';
      case '7z':
        return 'application/x-7z-compressed';

      // ❓ Mặc định
      default:
        return 'application/octet-stream';
    }
  }
}
