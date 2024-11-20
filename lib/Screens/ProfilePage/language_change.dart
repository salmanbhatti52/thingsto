import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Screens/BottomNavigationBar/bottom_nav_bar.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';
import 'package:thingsto/Widgets/app_bar.dart';
import 'package:thingsto/Widgets/large_Button.dart';
import 'package:easy_localization/easy_localization.dart' as easy;

class LanguageChangePage extends StatefulWidget {
  Map<dynamic, dynamic> getProfile = {};
  LanguageChangePage({super.key, required this.getProfile});

  @override
  State<LanguageChangePage> createState() => _LanguageChangePageState();
}

class _LanguageChangePageState extends State<LanguageChangePage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
    if (box.read('languageCode') != null) {
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  final box = GetStorage();

  bool get isEnglishSelected =>
      box.read('languageCode') == 'en' || box.read('languageCode') == null;
  bool get isFrenchSelected => box.read('languageCode') == 'fr';

  void _changeLanguage(String languageCode) {
    _animationController.forward(from: 0);
    box.write('languageCode', languageCode);
    Locale locale = Locale(languageCode);
    context.setLocale(locale);
    Get.updateLocale(locale);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Column(
        children: [
          BackButtonBar(
            title: "language",
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: Get.height * 0.05,
                    ),
                    const LabelField(
                      text: 'select_language',
                      fontSize: 18,
                    ),
                    SizedBox(
                      height: Get.height * 0.03,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _changeLanguage('en');
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                children: [
                                  Container(
                                    width: 26,
                                    height: 23,
                                    decoration: BoxDecoration(
                                      color: AppColor.secondaryColor,
                                      border: Border.all(
                                        color: isEnglishSelected
                                            ? AppColor.primaryColor
                                            : AppColor.borderColor,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Center(
                                      child: FadeTransition(
                                        opacity: isEnglishSelected
                                            ? _animation
                                            : const AlwaysStoppedAnimation(0),
                                        child: const Icon(
                                          Icons.check_rounded,
                                          size: 20,
                                          color: AppColor.primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  LabelField(
                                    text: "English",
                                    fontSize: 16,
                                    color: isEnglishSelected
                                        ? AppColor.labelTextColor
                                        : AppColor.hintColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {
                              _changeLanguage('fr');
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                children: [
                                  Container(
                                    width: 26,
                                    height: 23,
                                    decoration: BoxDecoration(
                                      color: AppColor.secondaryColor,
                                      border: Border.all(
                                        color: isFrenchSelected
                                            ? AppColor.primaryColor
                                            : AppColor.borderColor,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Center(
                                      child: FadeTransition(
                                        opacity: isFrenchSelected
                                            ? _animation
                                            : const AlwaysStoppedAnimation(0),
                                        child: const Icon(
                                          Icons.check_rounded,
                                          size: 20,
                                          color: AppColor.primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  LabelField(
                                    text: "French",
                                    fontSize: 16,
                                    color: isFrenchSelected
                                        ? AppColor.labelTextColor
                                        : AppColor.hintColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.52,
                    ),
                    LargeButton(
                      text: "apply",
                      onTap: () {
                        Get.offAll(
                          () => const MyBottomNavigationBar(
                            initialIndex: 0,
                          ),
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
