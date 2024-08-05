import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:thingsto/Controllers/thingsto_controller.dart';
import 'package:thingsto/Resources/app_assets.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Screens/ThingstoPages/TopThings/topthingsto_details.dart';
import 'package:thingsto/Utills/const.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';
import 'package:thingsto/Widgets/app_bar.dart';
import 'package:thingsto/Widgets/large_Button.dart';
import 'package:thingsto/Widgets/snackbar.dart';

class TopThingsValidate extends StatelessWidget {
  final Map<String, dynamic> topThingsto;
  const TopThingsValidate({super.key, required this.topThingsto,});

  @override
  Widget build(BuildContext context) {
    final ThingstoController thingstoController = Get.put(ThingstoController());
    thingstoController.initializeThings(topThingsto["things_validated"]);
    List thingsValidated = [];
    bool showValidateButton = false;
    bool showValidate = false;
    if (topThingsto["things_validated"] != null) {
      thingsValidated = topThingsto["things_validated"];
      if(thingsValidated.isNotEmpty) {
        String userID = (prefs.getString('users_customers_id').toString());
        debugPrint("userID $userID");
        if(thingsValidated.any((validates) => validates['validaters_id'] == int.parse(userID) && validates['status'] == "Validate")) {
          showValidate = thingsValidated.any((validation) => validation['status'] == 'Validate');
          debugPrint("showValidate $showValidate");
        } else {
          showValidateButton = thingsValidated.any((validation) => validation['status'] == 'Pending');
          debugPrint("showValidateButton $showValidateButton");
        }
      }
    }
    return WillPopScope(
      onWillPop: (){
        thingstoController.moderateCheck.value = false;
        thingstoController.imageFile.value = null;
        debugPrint("${thingstoController.moderateCheck.value}");
        debugPrint("${thingstoController.imageFile.value}");
        return Future.value(true);
      },
      child: Scaffold(
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
                    Obx(() {
                      return thingstoController.moderateCheck.value
                          ? thingstoController.imageFile.value == null
                          ? GestureDetector(
                        onTap: thingstoController.imagePick,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
                          child: DottedBorder(
                            color: AppColor.primaryColor,
                            strokeWidth: 1,
                            radius: const Radius.circular(10),
                            borderType: BorderType.RRect,
                            child: Container(
                              width: Get.width,
                              height: Get.height * 0.2,
                              color: AppColor.secondaryColor,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(AppAssets.upload),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const LabelField(
                                      text: "Add Photo/Proof of your thing",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: AppColor.hintColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                          : Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            File(thingstoController.imageFile.value!.path,),
                            fit: BoxFit.cover,
                            width: Get.width,
                            height: Get.height * 0.2,
                          ),
                        ),
                      ):  const SizedBox();
                    }),
                    topThingsto["confirm_by_moderator"] == "No"
                        ? Obx(() => LargeButton(
                      text: thingstoController.isValidate.value
                          ?  thingstoController.isLoading1.value ? "Please Wait..." : "Validated thing"
                          : thingstoController.isLoading1.value ? "Please Wait..." : "Validate this thing",
                      containerColor: thingstoController.isValidate.value ? const Color(0xffD4A373) : AppColor.primaryColor,
                      onTap: () {
                        !thingstoController.isValidate.value ?  thingstoController.validateThings(topThingsto["things_id"].toString(), "topThingsto", context) : null;
                      },
                    ),)
                        :  showValidate
                        ? LargeButton(
                      text: "Validated thing",
                      containerColor: const Color(0xffC4A484),
                      onTap: () {},
                    ) :  showValidateButton
                        ? LargeButton(
                      text: "Things being moderated",
                      containerColor: const Color(0xffC4A484),
                      onTap: () {},
                    )
                        : Obx(() => LargeButton(
                        text: thingstoController.isLoading1.value ? "Please Wait..." : "Validate thing, send to moderation",
                        onTap: () {
                          thingstoController.moderateCheck.value = true;
                          if (thingstoController.imageFile.value != null) {
                            thingstoController.validateThingsWithProof(
                              topThingsto["things_id"].toString(), "topThingsto",
                              thingstoController.base64Image.value.toString(),
                              context,
                            );
                          } else {
                            CustomSnackbar.show(title: "",
                                message: "Add Photo Proof of your thing");
                          }
                        }),),
                    SizedBox(
                      height: Get.height * 0.022,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
