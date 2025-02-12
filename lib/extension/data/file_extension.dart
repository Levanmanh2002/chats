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
    final ext = toLowerCase().split('/').last;

    const imageExts = {'png', 'jpg', 'jpeg', 'gif', 'webp', 'bmp'};
    const videoExts = {'mp4', 'mov', 'avi', 'mkv'};
    const audioExts = {'mp3', 'wav', 'aac', 'flac'};
    const docExts = {'pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx', 'txt'};
    const zipExts = {'zip', 'rar'};

    if (imageExts.contains(ext)) return FileCategory.IMAGE;
    if (videoExts.contains(ext)) return FileCategory.VIDEO;
    if (audioExts.contains(ext)) return FileCategory.AUDIO;
    if (docExts.contains(ext)) return FileCategory.DOCUMENT;
    if (zipExts.contains(ext)) return FileCategory.COMPRESSED;

    return FileCategory.UNKNOWN;
  }
}
