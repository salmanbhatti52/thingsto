import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thingsto/Resources/app_assets.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Widgets/Text.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';
import 'package:thingsto/Widgets/TextFields.dart';
import 'package:thingsto/Widgets/large_Button.dart';
import 'package:thingsto/Widgets/snackbar.dart';

class HumanVerification extends StatefulWidget {
  final Function(bool verifed)? verified;
  const HumanVerification({super.key, required this.verified});

  @override
  State<HumanVerification> createState() => _HumanVerificationState();
}

class _HumanVerificationState extends State<HumanVerification> {
  String randomString = "";
  bool isVerified = false;

  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    buildCaptcha();
  }

  void buildCaptcha() {
    const letter =
        "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    const length = 6;
    final random = Random();
    randomString = String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => letter.codeUnitAt(
          random.nextInt(letter.length),
        ),
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: Get.width * 0.8,
            height: Get.height * 0.43,
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
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                  text: "Human Verification",
                  fontSize: 18,
                ),
                SizedBox(
                  height: Get.height * 0.025,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColor.secondaryColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColor.borderColor,
                      width: 1.0,
                    ),
                  ),
                  // height: Get.height * 0.085,
                  child: LabelField(
                    text: randomString,
                    fontSize: 16,
                    color: AppColor.lightBrown,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                  child: LabelField(
                    text: "Generate New Captcha",
                    // fontWeight: FontWeight.w400,
                    // fontSize: 14,
                    color: AppColor.lightBrown,
                    align: TextAlign.center,
                  ),
                ),
                GestureDetector(
                  onTap: buildCaptcha,
                  child: Image.asset(
                    AppAssets.captcha,
                    width: 20,
                    height: 20,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 15),
                  child: CustomTextFormField(
                    controller: controller,
                    hintText: "Enter Captcha",
                    showSuffix: false,
                    onChanged: (v) {
                      setState(() {
                        isVerified = false;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.03,
                ),
                LargeButton(
                  width: Get.width * 0.28,
                  height: Get.height * 0.045,
                  text: "Submit",
                  onTap: () {
                    isVerified = controller.text == randomString;
                    if (isVerified) {
                      if (widget.verified != null) {
                        widget.verified!(isVerified);
                      }
                      Get.back();
                    } else {
                      CustomSnackbar.show(
                          title: "Error",
                          message: "Please Enter Correct Captcha",
                      );
                    }
                    setState(() {});
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
