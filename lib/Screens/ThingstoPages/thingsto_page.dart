import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thingsto/Controllers/category_controller.dart';
import 'package:thingsto/Resources/app_assets.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Screens/ThingstoPages/category_details.dart';
import 'package:thingsto/Screens/ThingstoPages/filter_dialog.dart';
import 'package:thingsto/Screens/ThingstoPages/thingsto_container.dart';
import 'package:thingsto/Utills/const.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';
import 'package:thingsto/Widgets/TextFields.dart';
import 'package:thingsto/Widgets/app_bar.dart';
import 'package:thingsto/Widgets/row_text.dart';
import 'package:thingsto/Widgets/shimmer_effect.dart';
import 'category_container.dart';
import 'topthingsto_container.dart';

class ThingstoPage extends StatefulWidget {
  const ThingstoPage({super.key});

  @override
  State<ThingstoPage> createState() => _ThingstoPageState();
}

class _ThingstoPageState extends State<ThingstoPage> {
  bool isSelect = false;
  String selectedCategoryName = '';
  String selectedCategoryId = '';
  final CategoryController categoryController = Get.put(CategoryController());
  final List<Map<String, String>> categoryHistory = [];

  @override
  void initState() {
    super.initState();
    userID = (prefs.getString('users_customers_id').toString());
    debugPrint("userID $userID");
    categoryController.getCategory(
      usersCustomersId: userID.toString(),
    );
  }

  void selectCategory(String categoryName, String categoryId) {
    setState(() {
      isSelect = true;
      selectedCategoryName = categoryName;
      selectedCategoryId = categoryId;
      categoryController.getChildCategory(
        categoriesId: categoryId,
      );
      categoryHistory.add({'name': categoryName, 'id': categoryId});
    });
  }

  void goBack() {
    setState(() {
      if (categoryHistory.isNotEmpty) {
        categoryHistory.removeLast();
        if (categoryHistory.isEmpty) {
          isSelect = false;
          selectedCategoryName = '';
          selectedCategoryId = '';
          categoryController.subcategories.clear();
        } else {
          final previousCategory = categoryHistory.last;
          selectedCategoryName = previousCategory['name']!;
          selectedCategoryId = previousCategory['id']!;
          categoryController.getChildCategory(
            categoriesId: selectedCategoryId,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Column(
        children: [
          isSelect
              ? BackButtonBar(
                  title: "Thingsto",
            onBack: goBack,
                  // onBack: () {
                  //   setState(() {
                  //     isSelect = false;
                  //     selectedCategoryName = '';
                  //     selectedCategoryId = '';
                  //     categoryController.subcategories.clear();
                  //   });
                  // },
                )
              : const HomeBar(
                  title: "Thingsto",
                  titleTrue: true,
                  icon2: AppAssets.notify,
                ),
          SizedBox(
            height: Get.height * 0.02,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              children: [
                CustomTextFormField(
                  controller: TextEditingController(),
                  hintText: "Search for a thing on a",
                  // validator: validateEmail,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  suffixImage: AppAssets.filter,
                  suffixTap: () {
                    showDialog(
                      context: context,
                      barrierColor: Colors.grey.withOpacity(0.4),
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return const FilterDialog();
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(
                    height: Get.height * 0.02,
                  ),
                  isSelect
                      ? RowText(
                          text: selectedCategoryName,
                        )
                      : const RowText(
                          text: "Categories",
                        ),
                  isSelect
                      ? Obx(
                          () {
                            if (categoryController.isSubLoading.value) {
                              return Shimmers(
                                width: Get.width,
                                height: Get.height * 0.15,
                                width1: Get.width * 0.18,
                                height1: Get.height * 0.08,
                                length: 6,
                              );
                            }
                            // if (categoryController.isSubError.value) {
                            //   return const Center(
                            //     child: Padding(
                            //       padding: EdgeInsets.symmetric(vertical: 40.0),
                            //       child: LabelField(
                            //         text: "Subcategories not found",
                            //         fontSize: 21,
                            //         color: AppColor.blackColor,
                            //         interFont: true,
                            //       ),
                            //     ),
                            //   );
                            // }
                            if (categoryController.subcategories.isEmpty) {
                              return const Center(
                                child: Text(
                                  'Subcategories not found',
                                  style: TextStyle(
                                    color: AppColor.blackColor,
                                    fontSize: 16,
                                  ),
                                ),
                              );
                            }
                            return CategoryDetails(
                              subcategories: categoryController.subcategories,
                              onSelect: selectCategory,
                            );
                          },
                        )
                      : Obx(
                          () {
                            if (categoryController.isLoading.value) {
                              return Shimmers(
                                width: Get.width,
                                height: Get.height * 0.15,
                                width1: Get.width * 0.18,
                                height1: Get.height * 0.08,
                                length: 6,
                              );
                            }
                            if (categoryController.isError.value) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 40.0),
                                  child: LabelField(
                                    text: "Categories not found",
                                    fontSize: 21,
                                    color: AppColor.blackColor,
                                    interFont: true,
                                  ),
                                ),
                              );
                            }
                            if (categoryController.categories.isEmpty) {
                              return const Center(
                                child: Text(
                                  'Categories not found',
                                  style: TextStyle(
                                    color: AppColor.blackColor,
                                    fontSize: 16,
                                  ),
                                ),
                              );
                            }
                            return CategoryContainer(
                              categories: categoryController.categories,
                              onSelect: selectCategory,
                            );
                          },
                        ),
                  SizedBox(
                    height: Get.height * 0.01,
                  ),
                  const RowText(
                    text: "Things to",
                  ),
                  SizedBox(
                    height: Get.height * 0.02,
                  ),
                  const ThingstoContainer(),
                  SizedBox(
                    height: Get.height * 0.03,
                  ),
                  const RowText(
                    text: "Top Things to",
                  ),
                  SizedBox(
                    height: Get.height * 0.02,
                  ),
                  const TopThingstoContainer(),
                  SizedBox(
                    height: Get.height * 0.02,
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
