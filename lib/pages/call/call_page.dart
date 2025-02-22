import 'package:chats/pages/call/call_controller.dart';
import 'package:chats/widget/under_dev_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CallPage extends GetWidget<CallController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UnderDevWidget(title: ''.tr),
    );
  }
}
