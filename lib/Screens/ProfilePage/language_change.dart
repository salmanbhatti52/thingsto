import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:thingsto/Controllers/language_controller.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';
import 'package:thingsto/Widgets/app_bar.dart';
import 'package:thingsto/Widgets/large_Button.dart';
import 'package:thingsto/Widgets/snackbar.dart';

class LanguageChangePage extends StatefulWidget {
  Map<dynamic, dynamic> getProfile = {};
  LanguageChangePage({super.key, required this.getProfile});

  @override
  State<LanguageChangePage> createState() => _LanguageChangePageState();
}

class _LanguageChangePageState extends State<LanguageChangePage> with TickerProviderStateMixin {

  late AnimationController _animationController;
  late Animation<double> _animation;
  String? _selectedLanguage;
  final LanguageController languageController = Get.put(LanguageController());
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
  }

  void _toggleLanguageCheckbox(String language) {
    setState(() {
      _selectedLanguage = language;
      _animationController.forward(from: 0);
      debugPrint("_selectedLanguage $_selectedLanguage");
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
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
                      text: 'Select Language',
                      fontSize: 18,
                    ),
                    SizedBox(
                      height: Get.height * 0.03,
                    ),
                    Obx(() {
                      if (languageController.isLoading.value) {
                        return  Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: Get.height * 0.1),
                            child: SpinKitThreeBounce(
                              itemBuilder: (
                                  BuildContext context,
                                  int i,
                                  ) {
                                return DecoratedBox(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: AppColor.primaryColor,
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      }
                      return Column(
                        children: languageController.language.map((language) {
                          bool isSelected = _selectedLanguage == language;
                          return GestureDetector(
                            onTap: () => _toggleLanguageCheckbox(language),
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
                                        color: isSelected ? AppColor.primaryColor : AppColor.borderColor,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Center(
                                      child: FadeTransition(
                                        opacity: isSelected ? _animation : const AlwaysStoppedAnimation(0),
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
                                    text: language.capitalizeFirst!,
                                    fontSize: 16,
                                    color: isSelected ? AppColor.labelTextColor : AppColor.hintColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }),
                    SizedBox(
                      height: Get.height * 0.52,
                    ),
                    Obx(
                          () => languageController.isLoading1.value
                          ? LargeButton(
                        text: "Please Wait...",
                        onTap: () {},
                      )
                          : LargeButton(
                            text: "Apply",
                            onTap: () async {
                              if (_selectedLanguage != null) {
                                await languageController.updateLanguages(language: _selectedLanguage!.toString());
                              } else {
                                CustomSnackbar.show(
                                  title: 'Error',
                                  message: "Please select the language",
                                );
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
        ],
      ),
    );
  }
}
