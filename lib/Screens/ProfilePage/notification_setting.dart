import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thingsto/Controllers/update_profile_controller.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';
import 'package:thingsto/Widgets/app_bar.dart';
import 'package:thingsto/Widgets/large_Button.dart';

class NotificationSetting extends StatefulWidget {
  Map<dynamic, dynamic> getProfile = {};
  NotificationSetting({super.key, required this.getProfile});

  @override
  State<NotificationSetting> createState() => _NotificationSettingState();
}

class _NotificationSettingState extends State<NotificationSetting> with TickerProviderStateMixin {

  bool _isNotificationChecked = false;
  bool _isEmailChecked = false;
  late AnimationController _notificationController;
  late AnimationController _emailController;
  late Animation<double> _notificationAnimation;
  late Animation<double> _emailAnimation;
  UpdateProfileController updateProfileController =
  Get.put(UpdateProfileController());

  @override
  void initState() {
    super.initState();
    debugPrint(widget.getProfile['notifications']);
    debugPrint(widget.getProfile['notifications_email']);
    widget.getProfile['notifications'] == "Yes" ?  _isNotificationChecked = true : _isNotificationChecked = false;
    widget.getProfile['notifications_email'] == "Yes" ?  _isEmailChecked = true : _isEmailChecked = false;
    _notificationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _notificationAnimation = CurvedAnimation(parent: _notificationController, curve: Curves.easeInOut);

    _emailController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _emailAnimation = CurvedAnimation(parent: _emailController, curve: Curves.easeInOut);
    if (_isNotificationChecked) {
      _notificationController.forward();
    } else {
      _notificationController.reverse();
    }
    if (_isEmailChecked) {
      _emailController.forward();
    } else {
      _emailController.reverse();
    }
  }

  void _toggleNotificationCheckbox() {
    setState(() {
      _isNotificationChecked = !_isNotificationChecked;
      if (_isNotificationChecked) {
        _notificationController.forward();
      } else {
        _notificationController.reverse();
      }
    });
  }

  void _toggleEmailCheckbox() {
    setState(() {
      _isEmailChecked = !_isEmailChecked;
      if (_isEmailChecked) {
        _emailController.forward();
      } else {
        _emailController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _notificationController.dispose();
    _emailController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Column(
        children: [
          BackButtonBar(
            title: "Notifications Settings",
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
                      text: 'Enable Notification',
                      fontSize: 18,
                    ),
                    SizedBox(
                      height: Get.height * 0.03,
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: _toggleNotificationCheckbox,
                          child: Container(
                            width: 26,
                            height: 23,
                            decoration: BoxDecoration(
                              color: AppColor.secondaryColor,
                              border: Border.all(
                                color: _isNotificationChecked ? AppColor.primaryColor : AppColor.borderColor,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Center(
                              child: FadeTransition(
                                opacity: _notificationAnimation,
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
                          text: "Notification",
                          fontSize: 16,
                          color: _isNotificationChecked ? AppColor.labelTextColor : AppColor.hintColor,
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
                          onTap: _toggleEmailCheckbox,
                          child: Container(
                            width: 26,
                            height: 23,
                            decoration: BoxDecoration(
                              color: AppColor.secondaryColor,
                              border: Border.all(
                                color: _isEmailChecked ? AppColor.primaryColor : AppColor.borderColor,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Center(
                              child: FadeTransition(
                                opacity: _emailAnimation,
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
                          text: "Email Alerts",
                          fontSize: 16,
                          color: _isEmailChecked ? AppColor.labelTextColor : AppColor.hintColor,
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
                              updateProfileController.updateNotifications(
                                notifications: _isNotificationChecked ? "Yes" : "No",
                                notificationsEmail: _isEmailChecked ? "Yes" : "No",
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
