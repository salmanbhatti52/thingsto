import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thingsto/Controllers/auth_controllers.dart';
import 'package:thingsto/Controllers/language_controller.dart';
import 'package:thingsto/Resources/app_assets.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Screens/Authentications/login_page.dart';
import 'package:thingsto/Screens/BottomNavigationBar/bottom_nav_bar.dart';
import 'package:thingsto/Utills/const.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  String isLogin = 'false';

  final AuthController authController = Get.put(AuthController());
  // final LanguageController languageController = Get.put(LanguageController());

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    prefs = await SharedPreferences.getInstance();
    isLogin = (prefs.getString('isLogin')) ?? 'false';
    // languages = prefs.getString('language') ?? '';
    // debugPrint("languages: $languages");
    if (isLogin == "false") {
      await authController.fetchSystemSettings();
      // await languageController.languagesPhrase(language: languages.toString());
    }
    Future.delayed(const Duration(seconds: 1), () async {
      Get.offAll(
            () => isLogin == "true" ? const MyBottomNavigationBar() : LoginPage(),
        duration: const Duration(milliseconds: 350),
        transition: Transition.rightToLeft,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              SvgPicture.asset(
                AppAssets.logo,
              ),
              SvgPicture.asset(
                AppAssets.name,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
