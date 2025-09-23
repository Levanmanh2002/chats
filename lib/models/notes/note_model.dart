import 'package:chats/utils/json_utils.dart';
import 'package:json_annotation/json_annotation.dart';

import 'note_category_model.dart';

part 'note_model.g.dart';

extension NoteModelsExtension on NoteModels {
  bool get hasNext => ((notes?.length ?? 0)) < (totalCount ?? 0);
}

@JsonSerializable()
class NoteModels {
  List<NoteItem>? notes;

  @JsonKey(fromJson: parseToInt)
  int? totalPage;

  @JsonKey(fromJson: parseToInt)
  int? totalCount;

  @JsonKey(fromJson: parseToInt)
  int? page;

  @JsonKey(fromJson: parseToInt)
  int? size;

  NoteModels({
    this.notes,
    this.totalPage,
    this.totalCount,
    this.page,
    this.size,
  });

  factory NoteModels.fromJson(Map<String, dynamic> json) => _$NoteModelsFromJson(json);

  Map<String, dynamic> toJson() => _$NoteModelsToJson(this);
}

@JsonSerializable()
class NoteItem {
  int? id;
  String title;
  String content;

  @JsonKey(name: "reminder_at")
  String reminderAt;

  String? description;

  NoteCategoryModel? category;

  @JsonKey(name: "start_date")
  String startDate;

  @JsonKey(name: "end_date")
  String endDate;

  @JsonKey(name: "created_at")
  String createdAt;

  NoteItem({
    this.id,
    this.title = '',
    this.content = '',
    this.reminderAt = '',
    this.description,
    this.category,
    this.startDate = '',
    this.endDate = '',
    this.createdAt = '',
  });

  factory NoteItem.fromJson(Map<String, dynamic> json) => _$NoteItemFromJson(json);

  Map<String, dynamic> toJson() => _$NoteItemToJson(this);
}
