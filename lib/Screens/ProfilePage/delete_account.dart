import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thingsto/Controllers/setting_controller.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';
import 'package:thingsto/Widgets/app_bar.dart';
import 'package:thingsto/Widgets/large_Button.dart';

class DeleteAccountPage extends StatelessWidget {
    DeleteAccountPage({super.key});

  final SettingController settingController = Get.put(SettingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Column(
        children: [
          BackButtonBar(
            title: "Delete Account",
            bottomPad: 15,
            onBack: () {
              Get.back();
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Get.width * 0.05,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: Get.height * 0.28,
                    ),
                    Column(
                      children: [
                        const LabelField(
                          text: "Are you sure, you want to delete your account?",
                          fontSize: 24,
                        ),
                        SizedBox(
                          height: Get.height * 0.04,
                        ),
                        const LabelField(
                          text: "If you delete your account then it won’t be recovered and all your data will be deleted.",
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          maxLIne: 4,
                        ),
                        SizedBox(
                          height: Get.height * 0.018,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Get.height * 0.25,
                    ),
                    Obx(
                          () => settingController.isLoading.value
                          ? LargeButton(
                        text: "Please Wait...",
                        onTap: () {},
                      )
                          : LargeButton(
                        text: "Confirm",
                        onTap: () {
                            settingController.deleteAccount();
                        },
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.02,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
