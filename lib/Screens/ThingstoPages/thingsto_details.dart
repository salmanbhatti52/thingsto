import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Screens/HomePages/founded_things.dart';
import 'package:thingsto/Screens/ThingstoPages/things_details.dart';
import 'package:thingsto/Widgets/app_bar.dart';
import 'package:thingsto/Widgets/large_Button.dart';

class ThingstoDetails extends StatelessWidget {
  final Map<String, dynamic> thingsto;
  const ThingstoDetails({super.key, required this.thingsto,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Column(
        children: [
          BackButtonBar(
            title: "Thing Details",
            bottomPad: 15,
            onBack: () {
              Get.back();
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 55.0),
                    child: ThingsDetails(thingsto: thingsto,),
                  ),
                  LargeButton(
                    text: "Validate this Thing",
                    onTap: () {
                      Get.back();
                    },
                  ),
                  SizedBox(
                    height: Get.height * 0.022,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
