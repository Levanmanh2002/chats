import 'package:chats/models/messages/files_models.dart';
import 'package:chats/utils/json_utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'media_file_model.g.dart';

extension MediaFileModelExtension on MediaFileModel {
  bool get hasNext => ((items?.length ?? 0)) < (totalCount ?? 0);
}

@JsonSerializable()
class MediaFileModel {
  @JsonKey(name: 'data')
  List<FilesModels>? items;

  @JsonKey(fromJson: parseToInt)
  int? totalPage;

  @JsonKey(fromJson: parseToInt)
  int? totalCount;

  @JsonKey(fromJson: parseToInt)
  int? page;

  @JsonKey(fromJson: parseToInt)
  int? size;

  MediaFileModel({
    this.items,
    this.totalPage,
    this.totalCount,
    this.page,
    this.size,
  });

  factory MediaFileModel.fromJson(Map<String, dynamic> json) => _$MediaFileModelFromJson(json);

  Map<String, dynamic> toJson() => _$MediaFileModelToJson(this);
}
