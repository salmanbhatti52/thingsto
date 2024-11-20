import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:thingsto/Controllers/auth_controllers.dart';
import 'package:thingsto/Utills/global.dart';
import 'package:thingsto/Widgets/Text.dart';
import 'package:thingsto/Widgets/TextFields.dart';
import 'package:thingsto/Widgets/large_Button.dart';
import 'package:thingsto/Resources/app_assets.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';
import 'package:thingsto/Widgets/TextFieldValidation.dart';
import 'package:thingsto/Screens/Authentications/login_page.dart';
import 'package:thingsto/Widgets/snackbar.dart';

class SignupPage extends StatelessWidget {
  SignupPage({super.key});

  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final referralCodeController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
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
                  height: Get.height * 0.03,
                ),
                const MyText(
                  text: "signup",
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
                          text: 'firstName',
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        CustomTextFormField(
                          controller: firstNameController,
                          hintText: "first_name_here",
                          validator: validateFName,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          showSuffix: false,
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        const LabelField(
                          text: 'lastName',
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        CustomTextFormField(
                          controller: lastNameController,
                          hintText: "last_name_here",
                          validator: validateLName,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          showSuffix: false,
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        const LabelField(
                          text: 'email',
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
                          text: 'referralCode',
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        CustomTextFormField(
                          controller: referralCodeController,
                          hintText: "referral_code_here",
                          validator: validateRCode,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          showSuffix: false,
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        const LabelField(
                          text: 'password',
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
                        const SizedBox(
                          height: 18,
                        ),
                        const LabelField(
                          text: 'confirmPassword',
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
                          text: "signup",
                          onTap: () async {
                            if (formKey.currentState!.validate()) {
                              if (passwordController.text == confirmPasswordController.text) {
                                authController.checkReferrals(
                                    referralCode: referralCodeController.text,
                                    surName: firstNameController.text,
                                    firstName: firstNameController.text,
                                    lastName: lastNameController.text,
                                    email: emailController.text,
                                    password: passwordController.text,
                                );
                              } else {
                                CustomSnackbar.show(
                                  title: 'error',
                                  message: "passwordNotMatched",
                                );
                              }
                            }
                          },
                        ),
                ),
                SizedBox(
                  height: Get.height * 0.05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const LabelField(
                      text: "alreadyHaveAccount",
                      fontWeight: FontWeight.w400,
                      color: AppColor.lightBrown,
                    ),
                    const LabelField(
                      text: " ",
                     ),
                    GestureDetector(
                      onTap: () {
                        Get.to(
                          () => LoginPage(),
                          duration: const Duration(milliseconds: 350),
                          transition: Transition.downToUp,
                        );
                      },
                      child: const LabelField(
                        text: "login_title",
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
