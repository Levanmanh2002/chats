import 'package:chats/models/profile/user_model.dart';
import 'package:chats/utils/json_utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sync_contact_model.g.dart';

extension SyncContactModelExtension on SyncContactModel {
  bool get hasNext => ((contacts?.length ?? 0)) < (totalPage ?? 0);
}

@JsonSerializable()
class SyncContactModel {
  @JsonKey(name: 'data')
  List<SyncContact>? contacts;

  @JsonKey(fromJson: parseToInt)
  int? totalPage;

  @JsonKey(fromJson: parseToInt)
  int? totalCount;

  @JsonKey(fromJson: parseToInt)
  int? page;

  @JsonKey(fromJson: parseToInt)
  int? size;

  SyncContactModel({
    this.contacts,
    this.totalPage,
    this.totalCount,
    this.page,
    this.size,
  });

  factory SyncContactModel.fromJson(Map<String, dynamic> json) => _$SyncContactModelFromJson(json);

  Map<String, dynamic> toJson() => _$SyncContactModelToJson(this);
}

@JsonSerializable()
class SyncContact {
  int? id;

  @JsonKey(name: 'contact_name')
  String? contactName;

  String? phone;
  UserModel? userContact;

  @JsonKey(name: 'created_at')
  String? createdAt;

  SyncContact({
    this.id,
    this.contactName,
    this.phone,
    this.userContact,
    this.createdAt,
  });

  factory SyncContact.fromJson(Map<String, dynamic> json) => _$SyncContactFromJson(json);

  Map<String, dynamic> toJson() => _$SyncContactToJson(this);
}
