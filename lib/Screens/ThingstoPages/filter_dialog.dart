import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Widgets/Text.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';
import 'package:thingsto/Widgets/custom_dropdown.dart';
import 'package:thingsto/Widgets/large_Button.dart';

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

  List<String> itemListForCountry = [
    "Pakistan",
    "America",
    "Iran",
  ];
  List<String> itemListForCity = [
    "Multan",
    "Lahore",
    "Karachi",
  ];

  var itemListForCategory = [
    "Category",
    "Category",
    "Category",
  ];

  var itemListForSubCategory = [
    "SubCategory",
    "SubCategory",
    "SubCategory",
  ];

  String? selectCategory;
  String? selectSubCategory;
  String? selectCountry;
  String? selectCity;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: Get.width * 0.8,
            height: Get.height * 0.9,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
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
                        CustomDropdown(
                          itemList: itemListForCountry,
                          hintText: "Select Country",
                          onChanged: (value) {
                            selectCountry = value;
                            debugPrint("selectCountry: $selectCountry");
                          },
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
                        CustomDropdown(
                          itemList: itemListForCity,
                          hintText: "Select City",
                          onChanged: (value) {
                            selectCity = value;
                            debugPrint("SelectCity: $selectCity");
                          },
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
                            selectCategory = value;
                            debugPrint("selectCategory: $selectCategory");
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const LabelField(
                          text: 'Subcategory',
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        CustomDropdown(
                          itemList: itemListForSubCategory,
                          hintText: "Select SubCategory",
                          onChanged: (value) {
                            selectSubCategory = value;
                            debugPrint("selectSubCategory: $selectSubCategory");
                          },
                        ),
                        const SizedBox(
                          height: 15,
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
                                  selectedValue = "1";
                                  debugPrint(selectedValue.toString());
                                });
                              },
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: selectedValue == "1" ? AppColor.primaryColor : Colors.transparent,
                                  border: Border.all(
                                    color: AppColor.primaryColor,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: selectedValue == "1" ? const Center(
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
                                  selectedValue = "2";
                                  debugPrint(selectedValue.toString());
                                });
                              },
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: selectedValue == "2" ? AppColor.primaryColor : Colors.transparent,
                                  border: Border.all(
                                    color: AppColor.primaryColor,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: selectedValue == "2" ? const Center(
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
                                  selectedValue = "3";
                                  debugPrint(selectedValue.toString());
                                });
                              },
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: selectedValue == "3" ? AppColor.primaryColor : Colors.transparent,
                                  border: Border.all(
                                    color: AppColor.primaryColor,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: selectedValue == "3" ? const Center(
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
                    height: Get.height * 0.02,
                  ),
                  LargeButton(
                    width: Get.width * 0.25,
                    height : Get.height * 0.05,
                    text: "Save",
                    onTap: () {
                      Get.back();
                    },
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
