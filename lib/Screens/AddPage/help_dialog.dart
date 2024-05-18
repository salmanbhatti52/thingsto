import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Widgets/Text.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';
import 'package:thingsto/Widgets/large_Button.dart';

class HelpDialog extends StatelessWidget {
  const HelpDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return  Dialog(
      backgroundColor: Colors.transparent,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: Get.width * 0.8,
            height: Get.height * 0.38,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(),
                      const MyText(
                        text: "Monetize",
                        fontSize: 18,
                        color: AppColor.whiteColor,
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: const Icon(
                          Icons.clear,
                          color: AppColor.lightBrown,
                        ),
                      ),
                    ],
                  ),
                ),
                const LabelField(
                  text:
                  "Rules for Publishing Things",
                  fontSize: 18,
                ),
                SizedBox(
                  height: Get.height * 0.025,
                ),
                const LabelField(
                  text:
                  "1. Items submitted must comply with\n   our charter and our conditions of\n   use.",
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: AppColor.lightBrown,
                  align: TextAlign.left,
                ),
                SizedBox(
                  height: Get.height * 0.003,
                ),
                const LabelField(
                  text:
                  "   2. In particular, the thing proposed\n       must not already been published\n       and must not be contrary to morality\n       or the law.",
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: AppColor.lightBrown,
                  maxLIne: 4,
                  align: TextAlign.left,
                ),
                SizedBox(
                  height: Get.height * 0.04,
                ),
                LargeButton(
                  width: Get.width * 0.2,
                  height : Get.height * 0.045,
                  text: "Ok",
                  onTap: () {
                    Get.back();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
