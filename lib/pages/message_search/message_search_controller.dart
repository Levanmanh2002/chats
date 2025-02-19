import 'package:chats/models/messages/message_models.dart';
import 'package:chats/pages/message_search/message_search_parameter.dart';
import 'package:get/get.dart';

class MessageSearchController extends GetxController {
  final MessageSearchParameter parameter;

  MessageModels get searchMessage => parameter.searchMessage;

  MessageSearchController({required this.parameter});
}
