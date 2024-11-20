import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:thingsto/Controllers/setting_controller.dart';
import 'package:thingsto/Resources/app_assets.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Utills/const.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';
import 'package:thingsto/Widgets/TextFields.dart';
import 'package:thingsto/Widgets/app_bar.dart';
import 'package:thingsto/Widgets/large_Button.dart';
import 'package:thingsto/Widgets/shimmer_effect.dart';
import 'package:thingsto/Widgets/snackbar.dart';

class InviteReferrals extends StatefulWidget {
  Map<dynamic, dynamic> getProfile = {};
  InviteReferrals({super.key, required this.getProfile});

  @override
  State<InviteReferrals> createState() => _InviteReferralsState();
}

class _InviteReferralsState extends State<InviteReferrals> {

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final referralController = TextEditingController();
  double percentage = 0.0;
  String extractedCode = "";
  final SettingController settingController = Get.put(SettingController());

  getUrls() {
    referralBonus = prefs.getString('referral_bonus');
    referralBonusLimit = prefs.getString('referral_bonus_limit');
    if (referralBonus != null && referralBonusLimit != null) {
      debugPrint("referralBonus :: $referralBonus");
      debugPrint("referralBonusLimit :: $referralBonusLimit");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUrls();
    settingController.getReferralStats();
    String referralLink = widget.getProfile["referral_link"];
    extractedCode = referralLink.split('/').last;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Column(
        children: [
          BackButtonBar(
            title: "referral",
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
                        text: 'email_of_your_friend',
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      CustomTextFormField(
                        controller: emailController,
                        hintText: "username@gmail.com",
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        showSuffix: false,
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      const LabelField(
                        text: 'referral_link',
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      CustomTextFormField(
                        controller: referralController,
                        readOnly: true,
                        hintText: extractedCode,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        showSuffix: false,
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 25.0),
                        child: Obx(() {
                          percentage = settingController.totalReferrals.value / int.parse(referralBonusLimit.toString());
                          debugPrint("percentage $percentage");
                          int calculatedBonus = int.parse(referralBonusLimit.toString()) * int.parse(referralBonus.toString());
                          int totalReferralsBonus = settingController.totalReferrals.value * int.parse(referralBonus.toString());
                          if (settingController.isLoading1.value) {
                            return Shimmers2(
                              width: Get.width * 0.9,
                              height: Get.height * 0.4,
                            );
                          } else {
                            return Column(
                              children: [
                                const LabelField(
                                  text: "remaining_sponsorship",
                                  fontSize: 18,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                                  child: LinearPercentIndicator(
                                    center: LabelField(
                                      text: "${(percentage * 100).toStringAsFixed(0)}%",
                                      fontSize: 20,
                                    ),
                                    width: MediaQuery.of(context).size.width * 0.8,
                                    lineHeight: 40.0,
                                    percent: percentage,
                                    progressColor: AppColor.primaryColor,
                                    backgroundColor: const Color(0xffFDE0C5),
                                    barRadius: const Radius.circular(15),
                                    animation: true,
                                    animationDuration: 2000,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    LabelField(
                                      text: "${settingController.totalReferrals.value}/$referralBonusLimit",
                                      fontSize: 14,
                                    ),
                                    const LabelField(
                                      text: "sponsorship_used",
                                      fontSize: 14,
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0, bottom: 15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      LabelField(
                                        text: "$totalReferralsBonus/$calculatedBonus  ",
                                         fontSize: 14,
                                      ),
                                      SvgPicture.asset(
                                        AppAssets.logo,
                                        width: Get.width * 0.055,
                                        colorFilter: const ColorFilter.srgbToLinearGamma(),
                                      ),
                                      const LabelField(
                                        text: "win",
                                        fontSize: 14,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: Get.width * 0.6,
                                  height: Get.height * 0.24,
                                  decoration: BoxDecoration(
                                    color: Colors.pink.withOpacity(0.09),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        const LabelField(
                                          text: "refer_and_earn",
                                          fontSize: 23,
                                          fontWeight: FontWeight.w400,
                                          color: AppColor.lightBrown,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            LabelField(
                                              text: referralBonus.toString(),
                                              fontSize: 44,
                                              color: AppColor.lightBrown,
                                            ),
                                            const SizedBox(width: 10),
                                            SvgPicture.asset(
                                              AppAssets.logo,
                                              width: Get.width * 0.15,
                                              color: AppColor.primaryColor,
                                            ),
                                          ],
                                        ),
                                        const LabelField(
                                          text: "per_sponsor",
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400,
                                          color: AppColor.lightBrown,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                        }),
                      ),
                      Obx(
                        () => settingController.isLoading.value
                            ? LargeButton(
                                text: "please_wait",
                                onTap: () {},
                              )
                            : LargeButton(
                                text: "send",
                                onTap: () {
                                  if (formKey.currentState!.validate()) {
                                    if (emailController.text.isNotEmpty) {
                                      settingController.referralFriend(
                                        emailReferral: emailController.text,
                                        referralLink: extractedCode,
                                      );
                                    } else {
                                      CustomSnackbar.show(
                                        title: 'error',
                                        message: "email_required",
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
