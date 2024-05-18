import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thingsto/Resources/app_assets.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Screens/Authentications/login_page.dart';
import 'package:thingsto/Screens/BottomNavigationBar/bottom_nav_bar.dart';
import 'package:thingsto/Widgets/Text.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';
import 'package:thingsto/Widgets/TextFieldValidation.dart';
import 'package:thingsto/Widgets/TextFields.dart';
import 'package:thingsto/Widgets/large_Button.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final formKey = GlobalKey<FormState>();
  bool isPasswordVisible = true;
  bool isConfirmPasswordVisible = true;
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

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
                  text: "Signup",
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
                          text: 'First Name',
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        CustomTextFormField(
                          controller: firstNameController,
                          hintText: "First Name here",
                          // validator: validateEmail,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          showSuffix: false,
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        const LabelField(
                          text: 'Last Name',
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        CustomTextFormField(
                          controller: lastNameController,
                          hintText: "Last Name here",
                          // validator: validateEmail,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          showSuffix: false,
                        ),
                        const SizedBox(
                          height: 18,
                        ),
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
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        const LabelField(
                          text: 'Confirm Password',
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
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.05,
                ),
                LargeButton(
                  text: "Signup",
                  onTap: () {
                    Get.to(
                      () => const MyBottomNavigationBar(),
                      duration: const Duration(milliseconds: 350),
                      transition: Transition.rightToLeft,
                    );
                  },
                ),
                SizedBox(
                  height: Get.height * 0.05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const LabelField(
                      text: "Already have an account? ",
                      fontWeight: FontWeight.w400,
                      color: AppColor.lightBrown,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(
                          () => const LoginPage(),
                          duration: const Duration(milliseconds: 350),
                          transition: Transition.downToUp,
                        );
                      },
                      child: const LabelField(
                        text: "Login",
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
