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
  const ThingsValidate({super.key, required this.thingsto,});

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
                    child: ThingsDetails(thingsto: thingsto,),
                  ),
                  Obx(() => LargeButton(
                    text: thingstoController.isValidate.value ?  "Validated" : "Validate this Thing",
                    onTap: () {
                       thingstoController.validateThings(thingsto["things_id"].toString());
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
