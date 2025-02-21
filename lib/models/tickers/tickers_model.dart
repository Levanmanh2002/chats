import 'package:json_annotation/json_annotation.dart';

part 'tickers_model.g.dart';

@JsonSerializable()
class TickersModel {
  int? id;
  String? name;
  String? url;

  TickersModel({
    this.id,
    this.name,
    this.url,
  });

  factory TickersModel.fromJson(Map<String, dynamic> json) => _$TickersModelFromJson(json);

  Map<String, dynamic> toJson() => _$TickersModelToJson(this);

  static List<TickersModel> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => TickersModel.fromJson(json)).toList();
  }
}
