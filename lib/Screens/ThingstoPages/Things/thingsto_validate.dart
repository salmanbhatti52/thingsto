import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:thingsto/Controllers/thingsto_controller.dart';
import 'package:thingsto/Resources/app_assets.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Utills/const.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';
import 'package:thingsto/Widgets/app_bar.dart';
import 'package:thingsto/Widgets/large_Button.dart';
import 'package:thingsto/Widgets/snackbar.dart';
import 'things_details.dart';

class ThingsValidate extends StatelessWidget {
  final Map<String, dynamic> thingsto;
  final String thingstoName;
  final String? query;
  const ThingsValidate({super.key, required this.thingsto, required this.thingstoName, this.query});

  @override
  Widget build(BuildContext context) {
    final ThingstoController thingstoController = Get.put(ThingstoController());
    thingstoController.initializeThings(thingsto["things_validated"]);
    List thingsValidated = [];
    bool showValidateButton = false;
    bool showValidate = false;
    if (thingsto["things_validated"] != null) {
      thingsValidated = thingsto["things_validated"];
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
        if(query != null && query!.isNotEmpty){
          debugPrint("queryyyyy $query");
          thingstoController.searchMembers(search: "things", name: query.toString());
        }
        thingstoController.isLoadingLiked.value
            ? WidgetsBinding.instance.addPostFrameCallback((_) {
          thingstoController.getThingsto(checkValue: "No");
        }) : null;
        thingstoController.isLoadingLiked.value = false;
        debugPrint("${thingstoController.moderateCheck.value}");
        debugPrint("${thingstoController.imageFile.value}");
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: AppColor.whiteColor,
        body: Column(
          children: [
            BackButtonBar(
              title: "thingDetails",
              bottomPad: 15,
              onBack: () {
                Get.back();
                thingstoController.moderateCheck.value = false;
                thingstoController.imageFile.value = null;
                if(query != null && query!.isNotEmpty){
                  debugPrint("queryyyyy $query");
                  thingstoController.searchMembers(search: "things", name: query.toString());
                }
                thingstoController.isLoadingLiked.value
                    ? WidgetsBinding.instance.addPostFrameCallback((_) {
                  thingstoController.getThingsto(checkValue: "No");
                })  : null;
                thingstoController.isLoadingLiked.value = false;
                debugPrint("${thingstoController.moderateCheck.value}");
                debugPrint("${thingstoController.imageFile.value}");
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 25.0),
                      child: ThingsDetails(thingsto: thingsto,thingstoName: thingstoName,),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, bottom: 10),
                      child: Row(
                        children: [
                          const LabelField(
                            align: TextAlign.left,
                            text: "postedBy",
                            fontSize: 20,
                          ),
                          LabelField(
                            align: TextAlign.left,
                            text: " ${thingsto["users_customers"] is List ?
                            thingsto["users_customers"][0]["sur_name"] :
                            thingsto["users_customers"]["sur_name"]}",
                            fontSize: 20,
                          ),
                        ],
                      ),
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
                                      text: "addPhotoProof",
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
                    thingsto["confirm_by_moderator"] == "No"
                        ? Obx(() => LargeButton(
                      text: thingstoController.isValidate.value
                          ?  thingstoController.isLoading1.value ? "please_wait" : "validatedThing"
                          : thingstoController.isLoading1.value ? "please_wait" : "validateThisThing",
                      containerColor: thingstoController.isValidate.value ? const Color(0xffD4A373) : AppColor.primaryColor,
                      onTap: () {
                        !thingstoController.isValidate.value ?  thingstoController.validateThings(thingsto["things_id"].toString(), "thingsto", context) : null;
                        if(query != null && query!.isNotEmpty){
                          debugPrint("queryyyyy $query");
                          thingstoController.searchMembers(search: "things", name: query.toString());
                        }
                      },
                    ),)
                   :  showValidate
                        ? LargeButton(
                      text: "validatedThing",
                      containerColor: const Color(0xffC4A484),
                      onTap: () {},
                    ) :  showValidateButton
                        ? LargeButton(
                      text: "thingsBeingModerated",
                      containerColor: const Color(0xffC4A484),
                      onTap: () {},
                    )
                        : Obx(() => LargeButton(
                        text: thingstoController.isLoading1.value ? "please_wait" : "validateThingSendToModeration",
                        onTap: () {
                          thingstoController.moderateCheck.value = true;
                          if (thingstoController.imageFile.value != null) {
                            thingstoController.validateThingsWithProof(
                              thingsto["things_id"].toString(), "thingsto",
                              thingstoController.base64Image.value.toString(),
                              context,
                            );
                          } else {
                            CustomSnackbar.show(title: "",
                                message: "addPhotoProofOfYourThing");
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
