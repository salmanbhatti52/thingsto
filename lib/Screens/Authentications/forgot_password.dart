import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thingsto/Controllers/auth_controllers.dart';
import 'package:thingsto/Resources/app_assets.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Widgets/Text.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';
import 'package:thingsto/Widgets/TextFieldValidation.dart';
import 'package:thingsto/Widgets/TextFields.dart';
import 'package:thingsto/Widgets/large_Button.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({super.key});

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
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
                text: "Forgot Password",
              ),
              SizedBox(
                height: Get.height * 0.02,
              ),
              const LabelField(
                text:
                    'Confirm your email, we wil send you a verification code to verify your email.',
                color: AppColor.lightBrown,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              SizedBox(
                height: Get.height * 0.05,
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
                        text: 'Email',
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      CustomTextFormField(
                        controller: emailController,
                        hintText: "username@gmail.com",
                        validator: validateEmail,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        showSuffix: false,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: Get.height * 0.04,
              ),
              Obx(
                () => authController.isLoading.value
                    ? LargeButton(
                        width: Get.width * 0.85,
                        text: "Please Wait...",
                        onTap: () {},
                      )
                    : LargeButton(
                        width: Get.width * 0.85,
                        text: "Confirm",
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            authController.forgotPassword(
                              email: emailController.text,
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
    );
  }
}
