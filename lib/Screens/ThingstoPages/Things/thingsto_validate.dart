import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thingsto/Controllers/thingsto_controller.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Widgets/app_bar.dart';
import 'package:thingsto/Widgets/large_Button.dart';
import 'package:thingsto/Widgets/snackbar.dart';
import 'things_details.dart';

class ThingsValidate extends StatelessWidget {
  final Map<String, dynamic> thingsto;
  final String thingstoName;
  const ThingsValidate({super.key, required this.thingsto, required this.thingstoName,});

  @override
  Widget build(BuildContext context) {
    final ThingstoController thingstoController = Get.put(ThingstoController());
    thingstoController.initializeThings(thingsto["things_validated"]);
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
                    child: ThingsDetails(thingsto: thingsto,thingstoName: thingstoName,),
                  ),
                  Obx(() => LargeButton(
                    text: thingstoController.isValidate.value ?  "Validated thing"
                        : thingsto["confirm_by_moderator"] == "Yes"
                        ? "Validate thing, send to moderator" : "Validate this thing",
                    onTap: () {
                      // thingsto["confirm_by_moderator"] == "No" ?
                      thingstoController.validateThings(thingsto["things_id"].toString(), "thingsto");
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
