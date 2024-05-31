import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thingsto/Resources/app_assets.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';
import 'package:thingsto/Widgets/app_bar.dart';

class ShareApp extends StatelessWidget {
  const ShareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Column(
        children: [
          BackButtonBar(
            title: "Share App",
            bottomPad: 15,
            onBack: () {
              Get.back();
            },
          ),
          SizedBox(
            height: Get.height * 0.25,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              children: [
                const LabelField(
                  text:
                      "Copy the link below and share it with\nyour friends to earn a referral bonus.",
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  maxLIne: 4,
                ),
                SizedBox(
                  height: Get.height * 0.03,
                ),
                const LabelField(
                  text: "https://thingsto.com/register?ref=1424vvd",
                  fontSize: 24,
                ),
                SizedBox(
                  height: Get.height * 0.05,
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                      width: Get.width * 0.5,
                      height: 52,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColor.primaryColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Copy Link",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColor.whiteColor,
                              ),
                            ),
                            SvgPicture.asset(
                              AppAssets.copyLink,
                            ),
                          ],
                        ),
                      )),
                ),
                SizedBox(
                  height: Get.height * 0.018,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
