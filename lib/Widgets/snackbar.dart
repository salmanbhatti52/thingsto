import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';

class CustomSnackbar {
  static void show({
    required String title,
    required String message,
  }) {
    Get.snackbar(
      "title",
      "message",
      snackPosition: SnackPosition.BOTTOM,
      titleText: LabelField(
        text: title,
        align: TextAlign.left,
      ),
      messageText: LabelField(
        text: message,
        fontWeight: FontWeight.w400,
        color: AppColor.lightBrown,
        align: TextAlign.left,
      ),
      backgroundColor: AppColor.borderColor,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
      overlayBlur: 0.5,
    );
  }
}
