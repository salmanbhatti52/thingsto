import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thingsto/Controllers/setting_controller.dart';
import 'package:thingsto/Resources/app_assets.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';
import 'package:thingsto/Widgets/TextFieldValidation.dart';
import 'package:thingsto/Widgets/TextFields.dart';
import 'package:thingsto/Widgets/app_bar.dart';
import 'package:thingsto/Widgets/large_Button.dart';

class PasswordChangePage extends StatelessWidget {
  PasswordChangePage({super.key});

  final formKey = GlobalKey<FormState>();
  final oldPasswordController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final SettingController settingController = Get.put(SettingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Column(
        children: [
          BackButtonBar(
            title: "change_password",
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
                        text: 'old_password',
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Obx(
                        () => CustomTextFormField(
                          controller: oldPasswordController,
                          hintText: "********",
                          suffixImage:
                              settingController.isOldPasswordVisible.value
                                  ? AppAssets.eyeOpen
                                  : AppAssets.eyeOpen,
                          suffixTap: settingController.oldPasswordTap,
                          obscureText:
                              settingController.isOldPasswordVisible.value,
                          validator: validatePassword,
                          keyboardType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      const LabelField(
                        text: 'newPassword',
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Obx(
                        () => CustomTextFormField(
                          controller: passwordController,
                          hintText: "********",
                          suffixImage: settingController.isPasswordVisible.value
                              ? AppAssets.eyeOpen
                              : AppAssets.eyeOpen,
                          suffixTap: settingController.passwordTap,
                          obscureText: settingController.isPasswordVisible.value,
                          validator: validatePassword,
                          keyboardType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      const LabelField(
                        text: 'confirmNewPassword',
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Obx(
                        () => CustomTextFormField(
                          controller: confirmPasswordController,
                          hintText: "********",
                          suffixImage:
                              settingController.isConfirmPasswordVisible.value
                                  ? AppAssets.eyeOpen
                                  : AppAssets.eyeOpen,
                          suffixTap: settingController.confirmPasswordTap,
                          obscureText:
                              settingController.isConfirmPasswordVisible.value,
                          validator: validatePassword,
                          keyboardType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.done,
                        ),
                      ),
                      SizedBox(
                        height: Get.height * 0.39,
                      ),
                      Obx(
                            () => settingController.isLoading.value
                            ? LargeButton(
                          text: "please_wait",
                          onTap: () {},
                        )
                            : LargeButton(
                          text: "confirm",
                          onTap: () {
                      if (formKey.currentState!.validate()) {
                        settingController.changePassword(oldPassword: oldPasswordController.text, newPassword: passwordController.text, confirmNewPassword: confirmPasswordController.text,);

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
