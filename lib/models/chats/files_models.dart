import 'package:json_annotation/json_annotation.dart';

part 'files_models.g.dart';

@JsonSerializable()
class FilesModels {
  int? id;

  @JsonKey(name: 'file_url')
  String? fileUrl;

  @JsonKey(name: 'file_type')
  String? fileType;

  FilesModels({
    this.id,
    this.fileUrl,
    this.fileType,
  });

  factory FilesModels.fromJson(Map<String, dynamic> json) => _$FilesModelsFromJson(json);
  Map<String, dynamic> toJson() => _$FilesModelsToJson(this);
}
