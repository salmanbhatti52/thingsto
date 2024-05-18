import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thingsto/Resources/app_assets.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Screens/Authentications/signup_page.dart';
import 'package:thingsto/Screens/BottomNavigationBar/bottom_nav_bar.dart';
import 'package:thingsto/Widgets/Text.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';
import 'package:thingsto/Widgets/TextFieldValidation.dart';
import 'package:thingsto/Widgets/TextFields.dart';
import 'package:thingsto/Widgets/large_Button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  bool isPasswordVisible = true;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  passwordTap() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

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
                  text: "Login",
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
                          textInputAction: TextInputAction.next,
                          showSuffix: false,
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        const LabelField(
                          text: 'Password',
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
                          textInputAction: TextInputAction.done,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: Get.height * 0.02,
                              bottom: Get.height * 0.00),
                          child: GestureDetector(
                            onTap: () {
                              // Get.to(
                              //       () => const ForgotPassword(),
                              //   duration: const Duration(milliseconds: 350),
                              //   transition: Transition.rightToLeft,
                              // );
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                LabelField(
                                  text: 'Forgot Password?',
                                  fontWeight: FontWeight.w400,
                                  color: AppColor.lightBrown,
                                ),
                                LabelField(
                                  text: ' Reset',
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
                LargeButton(
                  text: "Login",
                  onTap: () {
                    Get.to(
                      () => const MyBottomNavigationBar(),
                      duration: const Duration(milliseconds: 350),
                      transition: Transition.rightToLeft,
                    );
                  },
                ),
                SizedBox(
                  height: Get.height * 0.24,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const LabelField(
                      text: "Don't have an account? ",
                      fontWeight: FontWeight.w400,
                      color: AppColor.lightBrown,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(
                          () => const SignupPage(),
                          duration: const Duration(milliseconds: 350),
                          transition: Transition.downToUp,
                        );
                      },
                      child: const LabelField(
                        text: "Signup",
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
