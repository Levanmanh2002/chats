import 'package:chats/models/messages/message_models.dart';
import 'package:chats/pages/group_message_search/group_message_search_parameter.dart';
import 'package:get/get.dart';

class GroupMessageSearchController extends GetxController {
  final GroupMessageSearchParameter parameter;

  MessageModels get searchMessage => parameter.searchMessage;

  GroupMessageSearchController({required this.parameter});
}
