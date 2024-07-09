import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:thingsto/Controllers/add_things_controller.dart';
import 'package:thingsto/Controllers/thingsto_controller.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Widgets/Text.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';
import 'package:thingsto/Widgets/TextFields.dart';
import 'package:thingsto/Widgets/custom_dropdown.dart';
import 'package:thingsto/Widgets/large_Button.dart';
import 'package:thingsto/Widgets/snackbar.dart';

class FilterDialog extends StatefulWidget {
  const FilterDialog({super.key});

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  bool showAllItems = true;
  bool showOnlyNotDone = true;
  String? selectedCountry;
  String? selectedCity;
  int selectedDistance = 10;
  bool checkBoxValue1 = false;
  bool checkBoxValue2 = false;
  bool isSelected = false;
  String? selectedValue;

  AddThingsController addThingsController = Get.put(AddThingsController());
  final ThingstoController thingstoController = Get.put(ThingstoController());
  var itemListForCategory = <String>[];
  var itemListForSubCategory = <String>[];
  var itemListForThirdCategory = <String>[];
  String? selectFile;
  String? selectCategory;
  String? selectSubCategory;
  String? selectThirdCategory;
  String? selectCategoryId;
  String? selectSubCategoryId;
  String? selectThirdCategoryId;
  final formKey = GlobalKey<FormState>();
  final countryController = TextEditingController();
  final cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    addThingsController.getAllCategory().then((_) {
      itemListForCategory = addThingsController.categoriesP0
          .map((c) => c['name'].toString())
          .toSet() // Ensure uniqueness
          .toList();
      debugPrint("itemListForCategory: $itemListForCategory");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      alignment: Alignment.center,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: Get.width * 0.8,
              height: itemListForSubCategory.isNotEmpty ? Get.height * 0.9 : Get.height * 0.8,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: Get.height * 0.015,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(),
                              const MyText(
                                text: "Filter",
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.back();
                                },
                                child: const Icon(
                                  Icons.clear,
                                  color: AppColor.labelTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: Get.height * 0.022,
                        ),
                        const LabelField(
                          text: "Filter your results with following parameters",
                          fontWeight: FontWeight.w400,
                          color: AppColor.lightBrown,
                        ),
                        Obx(() {
                          return addThingsController.isLoading1.value
                              ? Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: Get.height * 0.25),
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
                          )
                              : Column(
                            children: [
                              const SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const LabelField(
                                      text: 'Country',
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    CustomTextFormField(
                                      controller: countryController,
                                      hintText: "Select Country",
                                      // validator: validateEmail,
                                      keyboardType: TextInputType.name,
                                      textInputAction: TextInputAction.done,
                                      showSuffix: false,
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    const LabelField(
                                      text: 'City',
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    CustomTextFormField(
                                      controller: cityController,
                                      hintText: "Select City",
                                      // validator: validateEmail,
                                      keyboardType: TextInputType.name,
                                      textInputAction: TextInputAction.done,
                                      showSuffix: false,
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    const LabelField(
                                      text: 'Category',
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    CustomDropdown(
                                      itemList: itemListForCategory,
                                      hintText: "Select Category",
                                      onChanged: (value) {
                                        setState(() {
                                          selectCategory = value;
                                          selectCategoryId = addThingsController.categoriesAll.firstWhere((c) => c['name'] == value)
                                          ['categories_id'].toString();
                                          debugPrint("selectCategory: $selectCategory, selectCategoryId: $selectCategoryId");
                                          // Filter subcategories based on selected category
                                          itemListForSubCategory = addThingsController.categoriesAll
                                              .where((c) => c['parent_id'] == int.parse(selectCategoryId!))
                                              .map((c) => c['name'].toString())
                                              .toSet()
                                              .toList();
                                          selectSubCategory = null;
                                        });
                                      },
                                      initialValue: selectCategory,
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    if(itemListForSubCategory.isNotEmpty)
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const LabelField(
                                            text: 'Subcategory',
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          CustomDropdown(
                                            itemList: itemListForSubCategory,
                                            hintText: "Select Subcategory",
                                            onChanged: (value) {
                                              setState(() {
                                                selectSubCategory = value;
                                                selectSubCategoryId = addThingsController.categoriesAll.firstWhere((c) => c['name'] == value)['categories_id'].toString();
                                                debugPrint("selectSubCategory: $selectSubCategory, selectSubCategoryId: $selectSubCategoryId");
                                                // Filter subcategories based on selected category
                                                itemListForThirdCategory = addThingsController.categoriesAll
                                                    .where((c) => c['parent_id'] == int.parse(selectSubCategoryId!))
                                                    .map((c) => c['name'].toString())
                                                    .toSet()
                                                    .toList();
                                                selectThirdCategory = null;
                                              });
                                            },
                                            initialValue: selectSubCategory,
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                        ],
                                      ),
                                    if(itemListForThirdCategory.isNotEmpty)
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const LabelField(
                                            text: 'Sub child category',
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          CustomDropdown(
                                            itemList: itemListForThirdCategory,
                                            hintText: "Select Sub child category",
                                            onChanged: (value) {
                                              setState(() {
                                                selectThirdCategory = value;
                                                selectThirdCategoryId = addThingsController.categoriesAll.firstWhere((c) => c['name'] == value)['categories_id'].toString();
                                                debugPrint("selectThirdCategory: $selectThirdCategory, selectThirdCategoryId: $selectThirdCategoryId");
                                              });
                                            },
                                            initialValue: selectThirdCategory,
                                          ),
                                          const SizedBox(
                                            height: 18,
                                          ),
                                        ],
                                      ),
                                    const LabelField(
                                      text: 'Distance',
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              isSelected = !isSelected;
                                              selectedValue = "10";
                                              debugPrint(selectedValue.toString());
                                            });
                                          },
                                          child: Container(
                                            width: 20,
                                            height: 20,
                                            decoration: BoxDecoration(
                                              color: selectedValue == "10" ? AppColor.primaryColor : Colors.transparent,
                                              border: Border.all(
                                                color: AppColor.primaryColor,
                                                width: 2,
                                              ),
                                              borderRadius: BorderRadius.circular(30),
                                            ),
                                            child: selectedValue == "10" ? const Center(
                                              child: Icon(
                                                Icons.check_rounded,
                                                size: 15,
                                                color: AppColor.whiteColor,
                                              ),
                                            ) : null,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const LabelField(
                                          text: '10 Km',
                                          color: AppColor.lightBrown,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              isSelected = !isSelected;
                                              selectedValue = "20";
                                              debugPrint(selectedValue.toString());
                                            });
                                          },
                                          child: Container(
                                            width: 20,
                                            height: 20,
                                            decoration: BoxDecoration(
                                              color: selectedValue == "20" ? AppColor.primaryColor : Colors.transparent,
                                              border: Border.all(
                                                color: AppColor.primaryColor,
                                                width: 2,
                                              ),
                                              borderRadius: BorderRadius.circular(30),
                                            ),
                                            child: selectedValue == "20" ? const Center(
                                              child: Icon(
                                                Icons.check_rounded,
                                                size: 15,
                                                color: AppColor.whiteColor,
                                              ),
                                            ) : null,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const LabelField(
                                          text: '30 Km',
                                          color: AppColor.lightBrown,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              isSelected = !isSelected;
                                              selectedValue = "30";
                                              debugPrint(selectedValue.toString());
                                            });
                                          },
                                          child: Container(
                                            width: 20,
                                            height: 20,
                                            decoration: BoxDecoration(
                                              color: selectedValue == "30" ? AppColor.primaryColor : Colors.transparent,
                                              border: Border.all(
                                                color: AppColor.primaryColor,
                                                width: 2,
                                              ),
                                              borderRadius: BorderRadius.circular(30),
                                            ),
                                            child: selectedValue == "30" ? const Center(
                                              child: Icon(
                                                Icons.check_rounded,
                                                size: 15,
                                                color: AppColor.whiteColor,
                                              ),
                                            ) : null,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const LabelField(
                                          text: '50 Km',
                                          color: AppColor.lightBrown,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: Get.height * 0.015,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Checkbox(
                                    side: const BorderSide(color: AppColor.primaryColor, width: 2,),
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    activeColor: AppColor.primaryColor,
                                    checkColor: AppColor.whiteColor,
                                    value: checkBoxValue1,
                                    onChanged: (bool? value) {
                                      checkBoxValue1 = value!;
                                      checkBoxValue2 = !value;
                                      setState(() {});
                                    },
                                  ),
                                  const LabelField(
                                    text: 'Show All Items',
                                    align: TextAlign.left,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Theme(
                                    data: ThemeData(
                                        unselectedWidgetColor: AppColor.primaryColor),
                                    child: Checkbox(
                                      side: const BorderSide(color: AppColor.primaryColor, width: 2,),
                                      materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                      activeColor: AppColor.primaryColor,
                                      checkColor: AppColor.whiteColor,
                                      value: checkBoxValue2,
                                      onChanged: (bool? value) {
                                        checkBoxValue2 = value!;
                                        checkBoxValue1 = !value;
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                  const LabelField(
                                    text: 'Show only which are not done',
                                    align: TextAlign.left,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: Get.height * 0.02,
                              ),
                            ],
                          );
                        }),
                        Obx(
                              () => thingstoController.isLoading1.value || thingstoController.isLoading.value
                              ? LargeButton(
                                width: Get.width * 0.25,
                                height : Get.height * 0.05,
                            text: "Wait...",
                            onTap: () {},
                          )
                              : LargeButton(
                                width: Get.width * 0.25,
                                height : Get.height * 0.05,
                                text: "Save",
                                onTap: () {
                                  if (formKey.currentState!.validate()) {
                                    if(checkBoxValue1){
                                      thingstoController.getThingsto(
                                        checkValue: checkBoxValue1 ? "Yes" : "No",
                                      );
                                    } else {
                                      thingstoController.foundedThings(
                                        categoriesId: selectThirdCategoryId !=
                                            null ? selectThirdCategoryId
                                            .toString() : selectSubCategoryId !=
                                            null ? selectSubCategoryId
                                            .toString() : selectCategoryId
                                            .toString(),
                                        country: countryController.text
                                            .toString(),
                                        city: cityController.text.toString(),
                                        distances: selectedValue.toString(),
                                        checkValue2: checkBoxValue2
                                            ? "Yes"
                                            : "No",
                                        backValue: "Yes",
                                      );
                                    }
                                    // } else {
                                    //   Get.back();
                                      // CustomSnackbar.show(title: "Error", message: "Please select all fields");
                                    // }
                                  }
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
            ),
          ],
        ),
      ),
    );
  }
}
