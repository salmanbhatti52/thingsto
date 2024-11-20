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

class _NotificationSettingState extends State<NotificationSetting>
    with TickerProviderStateMixin {
  bool _isNotificationChecked = false;
  bool _isEmailChecked = false;
  bool _isThingAdditionChecked = false;
  bool _isThingValidationChecked = false;

  late AnimationController _notificationController;
  late AnimationController _emailController;
  late AnimationController _thingAdditionController;
  late AnimationController _thingValidationController;

  late Animation<double> _notificationAnimation;
  late Animation<double> _emailAnimation;
  late Animation<double> _thingAdditionAnimation;
  late Animation<double> _thingValidationAnimation;

  UpdateProfileController updateProfileController =
      Get.put(UpdateProfileController());

  @override
  void initState() {
    super.initState();
    debugPrint(widget.getProfile['notifications']);
    debugPrint(widget.getProfile['notifications_email']);
    debugPrint(widget.getProfile['things_approval_notifications']);
    debugPrint(widget.getProfile['things_validation_notifications']);
    widget.getProfile['notifications'] == "Yes"
        ? _isNotificationChecked = true
        : _isNotificationChecked = false;
    widget.getProfile['notifications_email'] == "Yes"
        ? _isEmailChecked = true
        : _isEmailChecked = false;
    widget.getProfile['things_approval_notifications'] == "Yes"
        ? _isThingAdditionChecked = true
        : _isThingAdditionChecked = false;
    widget.getProfile['things_validation_notifications'] == "Yes"
        ? _isThingValidationChecked = true
        : _isThingValidationChecked = false;

    _notificationController = _createController();
    _notificationAnimation =
        _createAnimation(_notificationController, _isNotificationChecked);

    _emailController = _createController();
    _emailAnimation = _createAnimation(_emailController, _isEmailChecked);

    _thingAdditionController = _createController();
    _thingAdditionAnimation =
        _createAnimation(_thingAdditionController, _isThingAdditionChecked);

    _thingValidationController = _createController();
    _thingValidationAnimation =
        _createAnimation(_thingValidationController, _isThingValidationChecked);
  }

  AnimationController _createController() {
    return AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  Animation<double> _createAnimation(
      AnimationController controller, bool isChecked) {
    final animation =
        CurvedAnimation(parent: controller, curve: Curves.easeInOut);
    if (isChecked) {
      controller.forward();
    } else {
      controller.reverse();
    }
    return animation;
  }

  // Toggle functions
  void _toggleNotificationCheckbox() {
    setState(() {
      _isNotificationChecked = !_isNotificationChecked;
      _toggleAnimation(_notificationController, _isNotificationChecked);
    });
  }

  void _toggleEmailCheckbox() {
    setState(() {
      _isEmailChecked = !_isEmailChecked;
      _toggleAnimation(_emailController, _isEmailChecked);
    });
  }

  void _toggleThingAdditionCheckbox() {
    setState(() {
      _isThingAdditionChecked = !_isThingAdditionChecked;
      _toggleAnimation(_thingAdditionController, _isThingAdditionChecked);
    });
  }

  void _toggleThingValidationCheckbox() {
    setState(() {
      _isThingValidationChecked = !_isThingValidationChecked;
      _toggleAnimation(_thingValidationController, _isThingValidationChecked);
    });
  }

  void _toggleAnimation(AnimationController controller, bool isChecked) {
    if (isChecked) {
      controller.forward();
    } else {
      controller.reverse();
    }
  }

  @override
  void dispose() {
    _notificationController.dispose();
    _emailController.dispose();
    _thingAdditionController.dispose();
    _thingValidationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Column(
        children: [
          BackButtonBar(
            title: "notifications_settings",
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
                    SizedBox(height: Get.height * 0.07),
                    _buildCheckboxRow("enable_notification", _isNotificationChecked, _toggleNotificationCheckbox, _notificationAnimation),
                    SizedBox(height: Get.height * 0.03),
                    _buildCheckboxRow("email_alerts", _isEmailChecked, _toggleEmailCheckbox, _emailAnimation),
                    SizedBox(height: Get.height * 0.03),
                    _buildCheckboxRow("thing_addition", _isThingAdditionChecked, _toggleThingAdditionCheckbox, _thingAdditionAnimation),
                    SizedBox(height: Get.height * 0.03),
                    _buildCheckboxRow("thing_validation", _isThingValidationChecked, _toggleThingValidationCheckbox, _thingValidationAnimation),
                    SizedBox(height: Get.height * 0.5),
                    Obx(
                      () => updateProfileController.isLoading.value
                          ? LargeButton(
                              text: "please_wait",
                              onTap: () {},
                            )
                          : LargeButton(
                              text: "apply",
                              onTap: () {
                                updateProfileController.updateNotifications(
                                  notifications:
                                      _isNotificationChecked ? "Yes" : "No",
                                  notificationsEmail:
                                      _isEmailChecked ? "Yes" : "No",
                                  thingAddition: _isThingAdditionChecked ? "Yes" : "No",
                                  thingValidation: _isThingValidationChecked ? "Yes" : "No",
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
  Widget _buildCheckboxRow(String label, bool isChecked, VoidCallback onTap, Animation<double> animation) {
    return Row(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 26,
            height: 23,
            decoration: BoxDecoration(
              color: AppColor.secondaryColor,
              border: Border.all(
                color: isChecked ? AppColor.primaryColor : AppColor.borderColor,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: FadeTransition(
                opacity: animation,
                child: const Icon(
                  Icons.check_rounded,
                  size: 20,
                  color: AppColor.primaryColor,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        LabelField(
          text: label,
          fontSize: 16,
          color: isChecked ? AppColor.labelTextColor : AppColor.hintColor,
          fontWeight: FontWeight.w400,
        ),
      ],
    );
  }
}
