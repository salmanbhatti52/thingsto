import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thingsto/Controllers/update_profile_controller.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';
import 'package:thingsto/Widgets/app_bar.dart';
import 'package:thingsto/Widgets/large_Button.dart';

class PrivacySetting extends StatefulWidget {
  Map<dynamic, dynamic> getProfile = {};
  PrivacySetting({super.key, required this.getProfile});

  @override
  State<PrivacySetting> createState() => _PrivacySettingState();
}

class _PrivacySettingState extends State<PrivacySetting> with TickerProviderStateMixin {
  bool _isPublicChecked = false;
  bool _isSecretChecked = false;
  late AnimationController _publicController;
  late AnimationController _secretController;
  late Animation<double> _publicAnimation;
  late Animation<double> _secretAnimation;
  UpdateProfileController updateProfileController = Get.put(UpdateProfileController());

  @override
  void initState() {
    super.initState();
    debugPrint(widget.getProfile['notifications']);
    _isPublicChecked = widget.getProfile['profile_privacy'] == "Public";
    _isSecretChecked = widget.getProfile['profile_privacy'] == "Private";
    _publicController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _publicAnimation = CurvedAnimation(parent: _publicController, curve: Curves.easeInOut);

    _secretController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _secretAnimation = CurvedAnimation(parent: _secretController, curve: Curves.easeInOut);
    if (_isPublicChecked) {
      _publicController.forward();
    } else {
      _publicController.reverse();
    }
    if (_isSecretChecked) {
      _secretController.forward();
    } else {
      _secretController.reverse();
    }
  }

  void _togglePublicCheckbox() {
    setState(() {
      _isPublicChecked = true;
      _isSecretChecked = false;
      _publicController.forward();
      _secretController.reverse();
    });
  }

  void _togglePrivateCheckbox() {
    setState(() {
      _isSecretChecked = true;
      _isPublicChecked = false;
      _secretController.forward();
      _publicController.reverse();
    });
  }

  @override
  void dispose() {
    _publicController.dispose();
    _secretController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Column(
        children: [
          BackButtonBar(
            title: "Privacy Settings",
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
                      height: Get.height * 0.07,
                    ),
                    const LabelField(
                      text: 'Enable Profile Privacy',
                      fontSize: 18,
                    ),
                    SizedBox(
                      height: Get.height * 0.03,
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: _togglePublicCheckbox,
                          child: Container(
                            width: 26,
                            height: 23,
                            decoration: BoxDecoration(
                              color: AppColor.secondaryColor,
                              border: Border.all(
                                color: _isPublicChecked ? AppColor.primaryColor : AppColor.borderColor,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Center(
                              child: FadeTransition(
                                opacity: _publicAnimation,
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
                          text: "Public",
                          fontSize: 16,
                          color: _isPublicChecked ? AppColor.labelTextColor : AppColor.hintColor,
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
                          onTap: _togglePrivateCheckbox,
                          child: Container(
                            width: 26,
                            height: 23,
                            decoration: BoxDecoration(
                              color: AppColor.secondaryColor,
                              border: Border.all(
                                color: _isSecretChecked ? AppColor.primaryColor : AppColor.borderColor,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Center(
                              child: FadeTransition(
                                opacity: _secretAnimation,
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
                          text: "Private",
                          fontSize: 16,
                          color: _isSecretChecked ? AppColor.labelTextColor : AppColor.hintColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Get.height * 0.55,
                    ),
                    Obx(
                          () => updateProfileController.isLoading.value
                          ? LargeButton(
                        text: "Please Wait...",
                        onTap: () {},
                      )
                          : LargeButton(
                        text: "Apply",
                        onTap: () {
                          updateProfileController.updatePrivacy(
                            profilePrivacy: _isPublicChecked ? "Public" : "Private",
                          );
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
