import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thingsto/Resources/app_assets.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Screens/Authentications/login_page.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';
import 'package:thingsto/Widgets/TextFieldValidation.dart';
import 'package:thingsto/Widgets/TextFields.dart';
import 'package:thingsto/Widgets/app_bar.dart';
import 'package:thingsto/Widgets/large_Button.dart';

class PasswordChange extends StatefulWidget {
  const PasswordChange({super.key});

  @override
  State<PasswordChange> createState() => _PasswordChangeState();
}

class _PasswordChangeState extends State<PasswordChange> {

  final passwordController = TextEditingController();
  bool isPasswordVisible = true;
  final confirmPasswordController = TextEditingController();
  bool isConfirmPasswordVisible = true;

  passwordTap() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  confirmPasswordTap() {
    setState(() {
      isConfirmPasswordVisible = !isConfirmPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Column(
        children: [
          BackButtonBar(
            title: "Reset Password",
            bottomPad: 15,
            onBack: () {
              Get.back();
            },
          ),
          SizedBox(
            width: Get.width,
            height: isKeyboardVisible ? Get.height * 0.43 : Get.height * 0.86,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Get.width * 0.08,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: Get.height * 0.2,
                    ),
                    const LabelField(
                      text: 'New Password',
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    CustomTextFormField(
                      controller: passwordController,
                      hintText: "********",
                      suffixImage: isPasswordVisible
                          ? AppAssets.eyeOpen
                          : AppAssets.eyeOpen,
                      suffixTap: () {
                        passwordTap();
                      },
                      obscureText: isPasswordVisible,
                      validator: validatePassword,
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 18,),
                    const LabelField(
                      text: 'Confirm New Password',
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    CustomTextFormField(
                      controller: confirmPasswordController,
                      hintText: "********",
                      suffixImage: isConfirmPasswordVisible
                          ? AppAssets.eyeOpen
                          : AppAssets.eyeOpen,
                      suffixTap: () {
                        confirmPasswordTap();
                      },
                      obscureText: isConfirmPasswordVisible,
                      validator: validatePassword,
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                    ),
                    SizedBox(
                      height: Get.height * 0.2,
                    ),
                    LargeButton(
                      text: "Reset",
                      onTap: () {
                        Get.to(
                              () => const LoginPage(),
                          duration: const Duration(milliseconds: 350),
                          transition: Transition.upToDown,
                        );
                      },
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
