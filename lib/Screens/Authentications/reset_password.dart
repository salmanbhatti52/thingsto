import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thingsto/Controllers/auth_controllers.dart';
import 'package:thingsto/Resources/app_assets.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Widgets/Text.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';
import 'package:thingsto/Widgets/TextFieldValidation.dart';
import 'package:thingsto/Widgets/TextFields.dart';
import 'package:thingsto/Widgets/app_bar.dart';
import 'package:thingsto/Widgets/large_Button.dart';

class PasswordChange extends StatelessWidget {
  final String email;
  final int otp;
  PasswordChange({super.key, required this.email, required this.otp});

  final formKey = GlobalKey<FormState>();

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                height: Get.height * 0.06,
              ),
              Image.asset(
                AppAssets.logoName,
                width: Get.width * 0.66,
              ),
              SizedBox(
                height: Get.height * 0.05,
              ),
              const MyText(
                text: "Reset Password",
              ),
              SizedBox(
                height: Get.height * 0.02,
              ),
              const LabelField(
                text:
                'Create a new password now.',
                color: AppColor.lightBrown,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              SizedBox(
                height: Get.height * 0.04,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Get.width * 0.08,
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const LabelField(
                        text: 'New Password',
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Obx(
                            () => CustomTextFormField(
                          controller: passwordController,
                          hintText: "********",
                          suffixImage: authController.isPasswordVisible.value
                              ? AppAssets.eyeOpen
                              : AppAssets.eyeOpen,
                          suffixTap: authController.passwordTap,
                          obscureText: authController.isPasswordVisible.value,
                          validator: validatePassword,
                          keyboardType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      const SizedBox(height: 18,),
                      const LabelField(
                        text: 'Confirm New Password',
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Obx(
                            () => CustomTextFormField(
                          controller: confirmPasswordController,
                          hintText: "********",
                          suffixImage:
                          authController.isConfirmPasswordVisible.value
                              ? AppAssets.eyeOpen
                              : AppAssets.eyeOpen,
                          suffixTap: authController.confirmPasswordTap,
                          obscureText:
                          authController.isConfirmPasswordVisible.value,
                          validator: validatePassword,
                          keyboardType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.done,
                        ),
                      ),
                      SizedBox(
                        height: Get.height * 0.04,
                      ),
                      Obx(
                            () => authController.isLoading.value
                            ? LargeButton(
                          text: "Please Wait...",
                          onTap: () {},
                        )
                            : LargeButton(
                          text: "Save",
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                                authController.modifyPassword(
                                  email: email,
                                  otp: otp.toString(),
                                  password: passwordController.text,
                                  confirmPassword: confirmPasswordController.text,
                                );
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
            ],
          ),
        ),
      ),
    );
  }
}
