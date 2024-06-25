import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thingsto/Controllers/setting_controller.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';
import 'package:thingsto/Widgets/TextFields.dart';
import 'package:thingsto/Widgets/app_bar.dart';
import 'package:thingsto/Widgets/large_Button.dart';
import 'package:thingsto/Widgets/snackbar.dart';

class SubscribeNewsLetter extends StatelessWidget {
   SubscribeNewsLetter({super.key});

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

   final SettingController settingController = Get.put(SettingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Column(
        children: [
          BackButtonBar(
            title: "Subscribe",
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
                        text: "Subscribe To Our Newsletter",
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        maxLIne: 4,
                      ),
                      SizedBox(
                        height: Get.height * 0.03,
                      ),
                      const LabelField(
                        text: 'Subscribe Email',
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      CustomTextFormField(
                        controller: emailController,
                        hintText: "Enter Your Email",
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        showSuffix: false,
                      ),
                      SizedBox(
                        height: Get.height * 0.55,
                      ),
                      Obx(
                            () => settingController.isLoading.value
                            ? LargeButton(
                          text: "Please Wait...",
                          onTap: () {},
                        )
                            : LargeButton(
                          text: "Subscribe",
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              if (emailController.text.isNotEmpty) {
                                settingController.subscribeLetter(
                                  email: emailController.text,
                                );
                              } else {
                                CustomSnackbar.show(
                                  title: 'Error',
                                  message: "Email is required",
                                );
                              }
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
