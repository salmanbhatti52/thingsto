import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:thingsto/Resources/app_assets.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Screens/AddPage/add_newthing.dart';
import 'package:thingsto/Screens/AddPage/help_dialog.dart';
import 'package:thingsto/Screens/NotificationPage/notification_page.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';
import 'package:thingsto/Widgets/app_bar.dart';
import '../../Widgets/large_Button.dart';


class AddPage extends StatelessWidget {
  const AddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Column(
        children: [
          HomeBar(
            title: "Add Things",
            titleTrue: true,
            icon2: AppAssets.notify,
            onClick: (){
              Get.to(
                    () => const NotificationsScreen(),
                duration: const Duration(milliseconds: 350),
                transition: Transition.upToDown,
              );
            },
          ),
          SizedBox(
            height: Get.height * 0.015,
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      barrierColor: Colors.grey.withOpacity(0.4),
                      barrierDismissible: false,
                      builder: (BuildContext context) => const HelpDialog(),
                  );
                },
                child: SvgPicture.asset(
                  AppAssets.help,
                ),
              ),
            ),
          ),
          SizedBox(
            height: Get.height * 0.24,
          ),
          Column(
            children: [
              const LabelField(
                text: "A new thing to discover?\nAdd It!",
                fontSize: 18,
              ),
              SizedBox(
                height: Get.height * 0.022,
              ),
              const LabelField(
                text:
                "Complete the information and click on\n“Send”,  the new thing will be published\nsoon.",
                fontWeight: FontWeight.w400,
                color: AppColor.lightBrown,
              ),
              SizedBox(
                height: Get.height * 0.018,
              ),
              LargeButton(
                width: Get.width * 0.45,
                height : Get.height * 0.047,
                text: "Propose a Thing",
                onTap: () {
                  Get.to(
                        () => const AddNewThings(),
                    duration: const Duration(milliseconds: 350),
                    transition: Transition.rightToLeft,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
