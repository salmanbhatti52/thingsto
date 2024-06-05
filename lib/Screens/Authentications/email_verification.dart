import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:flutter/material.dart';
import 'package:thingsto/Controllers/verify_email_controller.dart';
import 'package:thingsto/Resources/app_assets.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Screens/Authentications/reset_password.dart';
import 'package:thingsto/Widgets/Text.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';
import 'package:thingsto/Widgets/large_Button.dart';
import 'package:thingsto/Widgets/snackbar.dart';

class EmailVerify extends StatelessWidget {
  final String email;
  final int otp;
   EmailVerify({super.key, required this.email, required this.otp});

  final formKey = GlobalKey<FormState>();

  final TextEditingController pinController = TextEditingController();
  final TimerController authController = Get.put(TimerController());

  final defaultPinTheme = PinTheme(
    width: 52,
    height: 56,
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
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Center(
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
                  text: "Verify Email",
                ),
                SizedBox(
                  height: Get.height * 0.02,
                ),
                const LabelField(
                  text:
                  'Enter code we have sent to your email address.',
                  color: AppColor.lightBrown,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                SizedBox(
                  height: Get.height * 0.05,
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
                  height: Get.height * 0.06,
                ),
                LargeButton(
                  text: "Verify",
                  onTap: () {
                    if (pinController.text.toString() == otp.toString()) {
                      Get.to(
                            () => PasswordChange(email: email.toString(), otp: otp,),
                        duration: const Duration(milliseconds: 350),
                        transition: Transition.rightToLeft,
                      );
                    } else {
                      CustomSnackbar.show(
                        title: 'Error',
                        message: "Otp do not match.",
                      );
                    }
                  },
                ),
                SizedBox(
                  height: Get.height * 0.02,
                ),
                Obx(() => LabelField(
                  text:
                  authController.getTimerText(),
                  color: AppColor.primaryColor,
                  fontSize: 14,
                ),),
                SizedBox(
                  height: Get.height * 0.24,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const LabelField(
                      text: "Didn't Receive? ",
                      fontWeight: FontWeight.w400,
                      color: AppColor.lightBrown,
                    ),
                   Obx(() =>  authController.secondsRemaining.value == 0 ? GestureDetector(
                     onTap: () {
                       authController.resetTimer();
                       authController.resendOtp();
                     },
                     child: const LabelField(
                       text: "Resend",
                       color: AppColor.primaryColor,
                     ),
                   ) : const LabelField(
                     text: "Resend",
                   ),),
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
