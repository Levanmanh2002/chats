enum FileContentType {
  /// Hình ảnh

  PNG,
  JPG,
  GIF,
  WEBP,
  BMP,

  /// Video

  MP4,
  MOV,
  AVI,
  MKV,

  /// Âm thanh

  MP3,
  WAV,
  AAC,
  FLAC,

  /// Tài liệu
  PDF,
  DOC,
  XLS,
  PPT,
  TXT,

  /// File nén

  ZIP,
  RAR,

  /// Không xác định

  UNKNOWN
}

enum FileCategory { IMAGE, VIDEO, AUDIO, DOCUMENT, COMPRESSED, UNKNOWN }
