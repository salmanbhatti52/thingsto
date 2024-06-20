import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thingsto/Controllers/thingsto_controller.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Screens/ThingstoPages/TopThings/topthingsto_details.dart';
import 'package:thingsto/Widgets/app_bar.dart';
import 'package:thingsto/Widgets/large_Button.dart';

class TopThingsValidate extends StatelessWidget {
  final Map<String, dynamic> topThingsto;
  const TopThingsValidate({super.key, required this.topThingsto,});

  @override
  Widget build(BuildContext context) {
    final ThingstoController thingstoController = Get.put(ThingstoController());
    thingstoController.initializeThings(topThingsto["things_validated"]);
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
                    child: TopThingsDetails(topThingsto: topThingsto,),
                  ),
                  Obx(() => LargeButton(
                    text: thingstoController.isValidate.value ?  "Validated" : "Validate this Thing",
                    onTap: () {
                      thingstoController.validateThings(topThingsto["things_id"].toString(), "topThingsto");
                      // : CustomSnackbar.show(title: "Error", message: "Already Validated");
                    },
                  ),),
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
