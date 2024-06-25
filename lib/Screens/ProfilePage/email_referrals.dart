import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thingsto/Controllers/setting_controller.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';
import 'package:thingsto/Widgets/TextFields.dart';
import 'package:thingsto/Widgets/app_bar.dart';
import 'package:thingsto/Widgets/large_Button.dart';
import 'package:thingsto/Widgets/snackbar.dart';

class InviteReferrals extends StatelessWidget {
  Map<dynamic, dynamic> getProfile = {};
  InviteReferrals({super.key, required this.getProfile});

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final referralController = TextEditingController();

  final SettingController settingController = Get.put(SettingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Column(
        children: [
          BackButtonBar(
            title: "Referral",
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
                    horizontal: Get.width * 0.08,
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: Get.height * 0.07,
                        ),
                        const LabelField(
                          text: 'Email Of Your Friend',
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        CustomTextFormField(
                          controller: emailController,
                          hintText: "username@gmail.com",
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          showSuffix: false,
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        const LabelField(
                          text: 'Referral link',
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        CustomTextFormField(
                          controller: referralController,
                          readOnly: true,
                          hintText: "Mg==",
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          showSuffix: false,
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        SizedBox(
                          height: Get.height * 0.48,
                        ),
                        Obx(
                              () => settingController.isLoading.value
                              ? LargeButton(
                            text: "Please Wait...",
                            onTap: () {},
                          )
                              : LargeButton(
                            text: "Send",
                            onTap: () {
                              if (formKey.currentState!.validate()) {
                                if (emailController.text.isNotEmpty) {
                                  referralController.text = "Mg==";
                                  settingController.referralFriend(
                                    emailReferral: emailController.text,
                                    referralLink: referralController.text,
                                  );
                                } else {
                                  CustomSnackbar.show(
                                    title: 'Error',
                                    message: "Email is required",
                                  );
                                }
                              }
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
          ),
        ],
      ),
    );
  }
}
