import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thingsto/Resources/app_assets.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Utills/const.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';
import 'package:thingsto/Widgets/app_bar.dart';
import 'package:thingsto/Widgets/snackbar.dart';

class ShareApp extends StatefulWidget {
  const ShareApp({super.key});

  @override
  State<ShareApp> createState() => _ShareAppState();
}

class _ShareAppState extends State<ShareApp> {
  getUrls() {
    shareAndroid = prefs.getString('share_app_android');
    shareIos = prefs.getString('share_app_ios');
    if (shareAndroid != null && shareIos != null) {
      debugPrint("shareAndroid :: $shareAndroid");
      debugPrint("shareIos :: $shareIos");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUrls();
  }

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
                LabelField(
                  text: Platform.isAndroid
                      ? shareAndroid.toString()
                      : shareIos.toString(),
                  fontSize: 24,
                ),
                SizedBox(
                  height: Get.height * 0.05,
                ),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(
                            text: Platform.isAndroid
                                ? shareAndroid.toString()
                                : shareIos.toString()))
                        .then(
                      (_) {
                        CustomSnackbar.show(
                          title: "Share App",
                          message: "Link Copied",
                        );
                      },
                    );
                  },
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
                    ),
                  ),
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
