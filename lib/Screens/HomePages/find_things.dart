import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:thingsto/Controllers/add_things_controller.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';
import 'package:thingsto/Widgets/TextFields.dart';
import 'package:thingsto/Widgets/custom_dropdown.dart';
import 'package:thingsto/Widgets/large_Button.dart';
import 'package:thingsto/Widgets/snackbar.dart';

class FindThings extends StatefulWidget {
  final VoidCallback? onFind;
  final Function(String thingName, String categoryId)? onFindWithData;
  const FindThings({super.key, this.onFind, this.onFindWithData});

  @override
  State<FindThings> createState() => _FindThingsState();
}

class _FindThingsState extends State<FindThings> {
  // List<String> itemListForCity = ["Multan", "Lahore", "Karachi"];
  // List<String> itemListForThing = ["Sports", "Movies", "Concerts"];
  // String? selectCity;
  // String? selectThing;

  AddThingsController addThingsController = Get.put(AddThingsController());

  var itemListForCategory = <String>[];
  String? selectCategory;
  String? selectCategoryId;
  final formKey = GlobalKey<FormState>();
  final thingNameController = TextEditingController();
  bool isFind = false;

  @override
  void initState() {
    super.initState();
    addThingsController.getAllCategory().then((_) {
      itemListForCategory = addThingsController.categoriesAll
          .map((c) => c['name'].toString())
          .toSet() // Ensure uniqueness
          .toList();
      debugPrint("itemListForCategory: $itemListForCategory");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Get.width * 0.05,
            ),
            child: Obx(() {
              var itemListForCategory = addThingsController.categoriesAll
                  .map((c) => c['name'].toString())
                  .toSet()
                  .toList();
              if (addThingsController.isLoading1.value) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: Get.height * 0.04),
                    child: SpinKitThreeBounce(
                      itemBuilder: (
                          BuildContext context,
                          int i,
                          ) {
                        return DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: AppColor.primaryColor,
                          ),
                        );
                      },
                    ),
                  ),
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const LabelField(
                    text: 'I’m looking around',
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  // CustomDropdown(
                  //   itemList: itemListForCity,
                  //   hintText: "City",
                  //   onChanged: (value) {
                  //     selectCity = value;
                  //     debugPrint("selectCity: $selectCity");
                  //   },
                  // ),
                  CustomDropdown(
                      itemList: itemListForCategory,
                      hintText: "Select Category",
                      onChanged: (value) {
                        setState(() {
                          selectCategory = value;
                          selectCategoryId = addThingsController.categoriesAll
                              .firstWhere((c) => c['name'] == value)['categories_id']
                              .toString();
                          debugPrint(
                              "selectCategory: $selectCategory, selectCategoryId: $selectCategoryId");
                        });
                      },
                      initialValue: selectCategory,
                    ),
                  const SizedBox(
                    height: 18,
                  ),
                  const LabelField(
                    text: 'I’m looking for thing about',
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  // CustomDropdown(
                  //   itemList: itemListForThing,
                  //   hintText: "Sports",
                  //   onChanged: (value) {
                  //     selectThing = value;
                  //     debugPrint("selectThing: $selectThing");
                  //   },
                  // ),
                  CustomTextFormField(
                    controller: thingNameController,
                    hintText: "Thing Name",
                    // validator: validateEmail,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.done,
                    showSuffix: false,
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                ],
              );
            }),
          ),
        ),
        LargeButton(
          text: isFind ? "FIND an other one" : "FIND IT",
          onTap: () {
            if(formKey.currentState!.validate()){
              if(thingNameController.text.isNotEmpty){
                setState(() {
                  isFind = !isFind;
                });
                if (widget.onFindWithData != null && widget.onFind != null) {
                  widget.onFind!();
                  widget.onFindWithData!(thingNameController.text, selectCategoryId ?? '');
                }
              } else {
                CustomSnackbar.show(title: "Error", message: "Please select all fields");
              }
            }
          },
          width: isFind ? Get.width * 0.49 : Get.width * 0.27,
          height: Get.height * 0.05,
        ),
      ],
    );
  }
}
