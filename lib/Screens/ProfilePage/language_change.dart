import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';
import 'package:thingsto/Widgets/app_bar.dart';
import 'package:thingsto/Widgets/large_Button.dart';

class LanguageChangePage extends StatefulWidget {
  const LanguageChangePage({super.key});

  @override
  State<LanguageChangePage> createState() => _LanguageChangePageState();
}

class _LanguageChangePageState extends State<LanguageChangePage> with TickerProviderStateMixin {

  bool _isEnglishChecked = false;
  bool _isFrenchChecked = false;
  late AnimationController _englishController;
  late AnimationController frenchController;
  late Animation<double> englishAnimation;
  late Animation<double> frenchAnimation;

  @override
  void initState() {
    super.initState();
    _englishController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    englishAnimation = CurvedAnimation(parent: _englishController, curve: Curves.easeInOut);

    frenchController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    frenchAnimation = CurvedAnimation(parent: frenchController, curve: Curves.easeInOut);
  }

  void _toggleEnglishCheckbox() {
    setState(() {
      _isEnglishChecked = !_isEnglishChecked;
      if (_isEnglishChecked) {
        _englishController.forward();
      } else {
        _englishController.reverse();
      }
    });
  }

  void _toggleFrenchCheckbox() {
    setState(() {
      _isFrenchChecked = !_isFrenchChecked;
      if (_isFrenchChecked) {
        frenchController.forward();
      } else {
        frenchController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _englishController.dispose();
    frenchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Column(
        children: [
          BackButtonBar(
            title: "Language",
            bottomPad: 15,
            onBack: () {
              Get.back();
            },
          ),
          SizedBox(
            width: Get.width,
            height: Get.height * 0.86,
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
                      height: Get.height * 0.07,
                    ),
                    const LabelField(
                      text: 'Select Language',
                      fontSize: 18,
                    ),
                    SizedBox(
                      height: Get.height * 0.03,
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: _toggleEnglishCheckbox,
                          child: Container(
                            width: 26,
                            height: 23,
                            decoration: BoxDecoration(
                              color: AppColor.secondaryColor,
                              border: Border.all(
                                color: _isEnglishChecked ? AppColor.primaryColor : AppColor.borderColor,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Center(
                              child: FadeTransition(
                                opacity: englishAnimation,
                                child: const Icon(
                                  Icons.check_rounded,
                                  size: 20,
                                  color: AppColor.primaryColor,
                                ),
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
                          color: _isEnglishChecked ? AppColor.labelTextColor : AppColor.hintColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Get.height * 0.03,
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: _toggleFrenchCheckbox,
                          child: Container(
                            width: 26,
                            height: 23,
                            decoration: BoxDecoration(
                              color: AppColor.secondaryColor,
                              border: Border.all(
                                color: _isFrenchChecked ? AppColor.primaryColor : AppColor.borderColor,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Center(
                              child: FadeTransition(
                                opacity: frenchAnimation,
                                child: const Icon(
                                  Icons.check_rounded,
                                  size: 20,
                                  color: AppColor.primaryColor,
                                ),
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
                          color: _isFrenchChecked ? AppColor.labelTextColor : AppColor.hintColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Get.height * 0.55,
                    ),
                    LargeButton(
                      text: "Apply",
                      onTap: () {
                        Get.back();
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
