import 'package:json_annotation/json_annotation.dart';

part 'files_models.g.dart';

@JsonSerializable()
class FilesModels {
  int? id;

  @JsonKey(name: 'file_url')
  String? fileUrl;

  @JsonKey(name: 'file_type')
  String? fileType;

  bool isLocal;

  FilesModels({
    this.id,
    this.fileUrl,
    this.fileType,
    this.isLocal = false,
  });

  factory FilesModels.fromJson(Map<String, dynamic> json) => _$FilesModelsFromJson(json);
  Map<String, dynamic> toJson() => _$FilesModelsToJson(this);
}
