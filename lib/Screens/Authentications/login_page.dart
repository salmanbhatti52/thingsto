import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thingsto/Controllers/auth_controllers.dart';
import 'package:thingsto/Resources/app_assets.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Screens/Authentications/forgot_password.dart';
import 'package:thingsto/Screens/Authentications/signup_page.dart';
import 'package:thingsto/Widgets/Text.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';
import 'package:thingsto/Widgets/TextFieldValidation.dart';
import 'package:thingsto/Widgets/TextFields.dart';
import 'package:thingsto/Widgets/large_Button.dart';

class LoginPage extends StatelessWidget {
     LoginPage({super.key});

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: SafeArea(
        child: SizedBox(
          height: double.infinity,
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
                  text: "login_title",
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
                          text: "email",
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        CustomTextFormField(
                          controller: emailController,
                          hintText: "username@gmail.com",
                          validator: validateEmail,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          showSuffix: false,
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        const LabelField(
                          text: "password",
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
                            textInputAction: TextInputAction.done,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: Get.height * 0.02,
                              bottom: Get.height * 0.00),
                          child: GestureDetector(
                            onTap: () {
                              Get.to(
                                    () => ForgotPassword(),
                                duration: const Duration(milliseconds: 350),
                                transition: Transition.rightToLeft,
                              );
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                LabelField(
                                  text: "forgot_password",
                                  fontWeight: FontWeight.w400,
                                  color: AppColor.lightBrown,
                                ),
                                LabelField(
                                  text: "?",
                                  fontWeight: FontWeight.w400,
                                  color: AppColor.lightBrown,
                                ),
                                LabelField(
                                  text: " ",
                                  color: AppColor.primaryColor,
                                ),
                                LabelField(
                                  text: "reset",
                                  color: AppColor.primaryColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.05,
                ),
                Obx(
                      () => authController.isLoading.value
                      ? LargeButton(
                    text: "please_wait",
                    onTap: () {},
                  )
                      : LargeButton(
                    text: "login_title",
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        authController.login(
                            email: emailController.text,
                            password: passwordController.text,
                          );
                        }
                    },
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.24,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const LabelField(
                      text: "dont_have_account",
                      fontWeight: FontWeight.w400,
                      color: AppColor.lightBrown,
                    ),
                    const LabelField(
                      text: " ",
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(
                          () => SignupPage(),
                          duration: const Duration(milliseconds: 350),
                          transition: Transition.downToUp,
                        );
                      },
                      child: const LabelField(
                        text: "signup",
                        color: AppColor.primaryColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: Get.height * 0.02,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
