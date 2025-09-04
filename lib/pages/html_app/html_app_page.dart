import 'package:chats/main.dart';
import 'package:chats/pages/html_app/html_app_controller.dart';
import 'package:chats/widget/default_app_bar.dart';
import 'package:chats/widget/reponsive/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:universal_html/html.dart' as html;

class HtmlAppPage extends GetWidget<HtmlAppController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteColor,
      appBar: DefaultAppBar(title: 'privacy_policy'.tr),
      body: Obx(
        () => controller.htmlText.value.isNotEmpty
            ? SingleChildScrollView(
                child: Ink(
                  width: Get.size.width,
                  color: appTheme.whiteColor,
                  padding: padding(all: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SelectionArea(
                        focusNode: FocusNode(),
                        key: Key(controller.htmlText.value),
                        child: Html(
                          data: controller.htmlText.value,
                          key: Key(controller.htmlText.value),
                          shrinkWrap: true,
                          onLinkTap: (url, attributes, element) {
                            if (url!.startsWith('www.')) {
                              url = 'https://$url';
                            }

                            html.window.open(url, "_blank");
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Center(child: CircularProgressIndicator(color: appTheme.appColor)),
      ),
    );
  }
}
