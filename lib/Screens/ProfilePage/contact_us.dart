import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';
import 'package:thingsto/Widgets/app_bar.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Column(
        children: [
          BackButtonBar(
            title: "contact_us",
            bottomPad: 15,
            onBack: () {
              Get.back();
            },
          ),
          SizedBox(
            height: Get.height * 0.28,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              children: [
                const LabelField(
                  text: "support_message",
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  maxLIne: 4,
                ),
                SizedBox(
                  height: Get.height * 0.03,
                ),
                const LabelField(
                  text: "info@thingsto.com",
                  fontSize: 24,
                ),
                SizedBox(
                  height: Get.height * 0.018,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
