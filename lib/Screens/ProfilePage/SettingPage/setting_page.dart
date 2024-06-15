import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thingsto/Resources/app_assets.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Screens/Authentications/login_page.dart';
import 'package:thingsto/Screens/ProfilePage/SettingPage/setting_container.dart';
import 'package:thingsto/Screens/ProfilePage/contact_us.dart';
import 'package:thingsto/Screens/ProfilePage/delete_account.dart';
import 'package:thingsto/Screens/ProfilePage/edit_profile.dart';
import 'package:thingsto/Screens/ProfilePage/language_change.dart';
import 'package:thingsto/Screens/ProfilePage/notification_setting.dart';
import 'package:thingsto/Screens/ProfilePage/share_app.dart';
import 'package:thingsto/Utills/const.dart';
import 'package:thingsto/Widgets/app_bar.dart';

import '../password_change.dart';

class SettingPage extends StatelessWidget {
  Map<dynamic, dynamic> getProfile = {};
   SettingPage({super.key, required this.getProfile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Column(
        children: [
          BackButtonBar(
            title: "Settings",
            bottomPad: 15,
            onBack: () {
              Get.back();
            },
          ),
          SizedBox(
            height: Get.height * 0.02,
          ),
          Expanded(
            child: SizedBox(
              width: Get.width,
              height: Get.height * 0.83,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SettingContainer(
                        image: AppAssets.editProfile,
                        text: "Edit Profile",
                        text1: "Edit your personal details",
                        onBack: (){
                          Get.to(
                                () => EditProfile(getProfile: getProfile,),
                            duration: const Duration(milliseconds: 350),
                            transition: Transition.rightToLeft,
                          );
                        },
                      ),
                      SizedBox(
                        height: Get.height * 0.015,
                      ),
                      SettingContainer(
                        image: AppAssets.notification,
                        text: "Notifications Settings",
                        text1: "Change notifications settings",
                        onBack: (){
                          Get.to(
                                () => NotificationSetting(getProfile: getProfile,),
                            duration: const Duration(milliseconds: 350),
                            transition: Transition.rightToLeft,
                          );
                        },
                      ),
                      SizedBox(
                        height: Get.height * 0.015,
                      ),
                      SettingContainer(
                        image: AppAssets.lang,
                        text: "Language",
                        text1: getProfile["language"] ?? "English",
                        onBack: (){
                          Get.to(
                                () => LanguageChangePage(getProfile: getProfile,),
                            duration: const Duration(milliseconds: 350),
                            transition: Transition.rightToLeft,
                          );
                        },
                      ),
                      SizedBox(
                        height: Get.height * 0.015,
                      ),
                      SettingContainer(
                        image: AppAssets.password,
                        text: "Change Password",
                        text1: "Reset your password here",
                        onBack: (){
                          Get.to(
                                () => PasswordChangePage(),
                            duration: const Duration(milliseconds: 350),
                            transition: Transition.rightToLeft,
                          );
                        },
                      ),
                      SizedBox(
                        height: Get.height * 0.015,
                      ),
                      SettingContainer(
                        image: AppAssets.contact,
                        text: "Contact Us",
                        text1: "Contact for any query or help",
                        onBack: (){
                          Get.to(
                                () => const ContactPage(),
                            duration: const Duration(milliseconds: 350),
                            transition: Transition.rightToLeft,
                          );
                        },
                      ),
                      SizedBox(
                        height: Get.height * 0.015,
                      ),
                      SettingContainer(
                        image: AppAssets.del,
                        text: "Delete Account",
                        text1: "Delete your account and all the data",
                        onBack: (){
                          Get.to(
                                () => DeleteAccountPage(),
                            duration: const Duration(milliseconds: 350),
                            transition: Transition.rightToLeft,
                          );
                        },
                      ),
                      SizedBox(
                        height: Get.height * 0.015,
                      ),
                      SettingContainer(
                        image: AppAssets.out,
                        text: "Sign Out",
                        text1: "SIgn out from the app",
                        onBack: () async {
                          await prefs.clear();
                          Get.offAll(
                                () => LoginPage(),
                            duration: const Duration(milliseconds: 350),
                            transition: Transition.rightToLeft,
                          );
                        },
                      ),
                      SizedBox(
                        height: Get.height * 0.015,
                      ),
                      SettingContainer(
                        image: AppAssets.share,
                        text: "Share App",
                        text1: "Share app with your friends",
                        onBack: (){
                          Get.to(
                                () => const ShareApp(),
                            duration: const Duration(milliseconds: 350),
                            transition: Transition.rightToLeft,
                          );
                        },
                      ),
                      SizedBox(
                        height: Get.height * 0.015,
                      ),
                      SettingContainer(
                        image: AppAssets.rate,
                        text: "Rate App",
                        text1: "Rate how was your experience",
                        onBack: (){
                          // Get.to(
                          //       () => const EditProfile(),
                          //   duration: const Duration(milliseconds: 350),
                          //   transition: Transition.rightToLeft,
                          // );
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
          ),
        ],
      ),
    );
  }
}
