import 'package:chats/main.dart';
import 'package:chats/pages/message/message_controller.dart';
import 'package:chats/pages/message/view/bottom_send_mess_view.dart';
import 'package:chats/pages/message/view/chast_list_view.dart';
import 'package:chats/pages/message/view/message_header_view.dart';
import 'package:chats/pages/message/widget/info_contact_widget.dart';
import 'package:chats/widget/custom_file_view.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessagePage extends GetWidget<MessageController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.blueFFColor,
      body: Column(
        children: [
          MessageHeaderView(),
          InfoContactWidget(contact: controller.parameter.contact),
          Expanded(child: ChastListView(controller: controller)),
          Obx(
            () => Align(
              alignment: Alignment.centerLeft,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: controller.imageFile
                      .asMap()
                      .entries
                      .map(
                        (entry) => Padding(
                          padding: padding(bottom: 4),
                          child: Stack(
                            children: [
                              Padding(
                                padding: padding(top: 10, horizontal: 6),
                                child: CustomFileImage(
                                  file: entry.value,
                                  size: 50.w,
                                  boxFit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: InkWell(
                                  onTap: () {
                                    controller.imageFile.removeAt(entry.key);
                                  },
                                  child: Container(
                                    padding: padding(all: 4),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: appTheme.redColor,
                                    ),
                                    child: Icon(Icons.clear, color: appTheme.whiteColor, size: 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
          BottomSendMessView(),
        ],
      ),
    );
  }
}
