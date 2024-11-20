import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thingsto/Resources/app_assets.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Screens/Authentications/login_page.dart';
import 'package:thingsto/Screens/ProfilePage/SettingPage/setting_container.dart';
import 'package:thingsto/Screens/ProfilePage/contact_us.dart';
import 'package:thingsto/Screens/ProfilePage/delete_account.dart';
import 'package:thingsto/Screens/ProfilePage/edit_profile.dart';
import 'package:thingsto/Screens/ProfilePage/email_referrals.dart';
import 'package:thingsto/Screens/ProfilePage/language_change.dart';
import 'package:thingsto/Screens/ProfilePage/notification_setting.dart';
import 'package:thingsto/Screens/ProfilePage/privacy_settings.dart';
import 'package:thingsto/Screens/ProfilePage/share_app.dart';
import 'package:thingsto/Screens/ProfilePage/subscribe_newsletter.dart';
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
            title: "settings",
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
                        text: "edit_profile",
                        text1: "edit_personal_details",
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
                        text: "notifications_settings",
                        text1: "change_notifications_settings",
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
                        image: AppAssets.privacy,
                        text: "privacy_settings",
                        text1: "change_privacy_settings",
                        onBack: (){
                          Get.to(
                                () => PrivacySetting(getProfile: getProfile,),
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
                        text: "language",
                        text1: "english",
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
                        text: "change_password",
                        text1: "reset_password",
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
                        text: "contact_us",
                        text1: "contact_for_help",
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
                        image: AppAssets.subscribe,
                        text: "referral",
                        text1: "invite_email_referral",
                        onBack: (){
                          Get.to(
                                () => InviteReferrals(getProfile: getProfile,),
                            duration: const Duration(milliseconds: 350),
                            transition: Transition.rightToLeft,
                          );
                        },
                      ),
                      SizedBox(
                        height: Get.height * 0.015,
                      ),
                      SettingContainer(
                        image: AppAssets.referral,
                        text: "subscribe_newsletter",
                        text1: "subscribe_to_newsletter",
                        onBack: (){
                          Get.to(
                                () => SubscribeNewsLetter(),
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
                        text: "delete_account",
                        text1: "delete_account_details",
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
                        text: "sign_out",
                        text1: "sign_out_details",
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
                        text: "share_app",
                        text1: "share_app_details",
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
                        text: "rate_app",
                        text1: "rate_experience",
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
