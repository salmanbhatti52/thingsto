import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:flutter/material.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Screens/Authentications/reset_password.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';
import 'package:thingsto/Widgets/app_bar.dart';
import 'package:thingsto/Widgets/large_Button.dart';

class EmailVerify extends StatefulWidget {
  const EmailVerify({super.key});

  @override
  State<EmailVerify> createState() => _EmailVerifyState();
}

class _EmailVerifyState extends State<EmailVerify> {

  final formKey = GlobalKey<FormState>();
  final TextEditingController pinController = TextEditingController();

  final defaultPinTheme = PinTheme(
    width: 52,
    height: 46,
    textStyle: GoogleFonts.poppins(
      fontSize: 14,
      color: AppColor.hintColor,
      fontWeight: FontWeight.w400,
    ),
    decoration: BoxDecoration(
      border: Border.all(width: 1, color: AppColor.borderColor),
        borderRadius: BorderRadius.circular(10),
        color: AppColor.secondaryColor,
        ),
  );

  @override
  Widget build(BuildContext context) {
    bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Column(
        children: [
          BackButtonBar(
            title: "Email Verification",
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
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: Get.height * 0.08,
                    ),
                    const LabelField(
                      text: 'Enter a 4 digit verification code we have sent on your email!',
                      color: AppColor.lightBrown,
                      fontSize: 18,
                    ),
                    SizedBox(
                      height: Get.height * 0.08,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Get.width * 0.18),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Pinput(
                                length: 4,
                                keyboardType: TextInputType.number,
                                closeKeyboardWhenCompleted: true,
                                controller: pinController,
                                defaultPinTheme: defaultPinTheme,
                                focusedPinTheme: defaultPinTheme,
                                submittedPinTheme: defaultPinTheme,
                                textInputAction: TextInputAction.done,
                                showCursor: true,
                              ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.14,
                    ),
                    LargeButton(
                      text: "Verify",
                      onTap: () {
                        Get.to(
                              () => const PasswordChange(),
                          duration: const Duration(milliseconds: 350),
                          transition: Transition.rightToLeft,
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
