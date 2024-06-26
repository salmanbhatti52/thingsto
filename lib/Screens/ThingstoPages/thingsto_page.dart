import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thingsto/Controllers/language_controller.dart';
import 'package:thingsto/Controllers/thingsto_controller.dart';
import 'package:thingsto/Resources/app_assets.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Screens/ThingstoPages/Categories/category_container.dart';
import 'package:thingsto/Screens/ThingstoPages/Categories/category_details.dart';
import 'package:thingsto/Screens/ThingstoPages/Things/thingsto_container.dart';
import 'package:thingsto/Screens/ThingstoPages/TopThings/topthingsto_container.dart';
import 'package:thingsto/Screens/ThingstoPages/filter_dialog.dart';
import 'package:thingsto/Screens/ThingstoPages/things_see_all.dart';
import 'package:thingsto/Utills/const.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';
import 'package:thingsto/Widgets/TextFields.dart';
import 'package:thingsto/Widgets/app_bar.dart';
import 'package:thingsto/Widgets/row_text.dart';
import 'package:thingsto/Widgets/shimmer_effect.dart';

class ThingstoPage extends StatefulWidget {
  const ThingstoPage({super.key});

  @override
  State<ThingstoPage> createState() => _ThingstoPageState();
}

class _ThingstoPageState extends State<ThingstoPage> {
  bool isSelect = false;
  String selectedCategoryName = '';
  String selectedCategoryId = '';
  final ThingstoController thingstoController = Get.put(ThingstoController());
  final LanguageController languageController = Get.put(LanguageController());
  final List<Map<String, String>> categoryHistory = [];

  @override
  void initState() {
    super.initState();
    getUserThings();
  }

  Future<void> getUserThings() async {
    thingstoController.findingThings.clear();
    userID = (prefs.getString('users_customers_id').toString());
    debugPrint("userID $userID");
    if (thingstoController.isDataLoadedThingsto.value) {
      // Show cached data and then update in the background
      thingstoController.getThingsto(usersCustomersId: userID.toString());
    } else {
      // Load data from the server
      await thingstoController.getThingsto(usersCustomersId: userID.toString());
    }
    if (thingstoController.isDataLoadedCategories.value) {
      thingstoController.getCategory(usersCustomersId: userID.toString());
    } else {
      await thingstoController.getCategory(usersCustomersId: userID.toString());
    }
    if (thingstoController.isDataLoadedTopThingsto.value) {
      thingstoController.getTopThingsto(usersCustomersId: userID.toString());
    } else {
      await thingstoController.getTopThingsto(usersCustomersId: userID.toString());
    }
  }

  void selectCategory(String categoryName, String categoryId) {
    setState(() {
      isSelect = true;
      selectedCategoryName = categoryName;
      selectedCategoryId = categoryId;
      thingstoController.foundedThings(
        categoriesId: categoryId.toString(),
        country: "",
        city: "",
        distances: "",
        checkValue1: "No",
        checkValue2: "No",
      );
      thingstoController.getChildCategory(
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
          thingstoController.subcategories.clear();
        } else {
          final previousCategory = categoryHistory.last;
          selectedCategoryName = previousCategory['name']!;
          selectedCategoryId = previousCategory['id']!;
          thingstoController.getChildCategory(
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
                  showPrefix: true,
                  prefixColor: AppColor.labelTextColor,
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
                    onTap: (){},
                        )
                      : Obx(() => RowText(
                    text: languageController.phrases['categories'] ??
                        "Categories",
                    onTap: (){},
                  ),),
                  isSelect
                      ? Obx(
                          () {
                            if (thingstoController.isSubLoading.value) {
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
                            if (thingstoController.subcategories.isEmpty) {
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
                              subcategories: thingstoController.subcategories,
                              onSelect: selectCategory,
                            );
                          },
                        )
                      : Obx(
                          () {
                            if (thingstoController.isLoading.value && thingstoController.cachedCategories.isEmpty) {
                              return Shimmers(
                                width: Get.width,
                                height: Get.height * 0.15,
                                width1: Get.width * 0.18,
                                height1: Get.height * 0.08,
                                length: 6,
                              );
                            }
                            // if (thingstoController.isError.value) {
                            //   return const Center(
                            //     child: Padding(
                            //       padding: EdgeInsets.symmetric(vertical: 40.0),
                            //       child: LabelField(
                            //         text: "Categories not found",
                            //         fontSize: 21,
                            //         color: AppColor.blackColor,
                            //         interFont: true,
                            //       ),
                            //     ),
                            //   );
                            // }
                            if (thingstoController.cachedCategories.isEmpty) {
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
                              categories: thingstoController.cachedCategories,
                              onSelect: selectCategory,
                            );
                          },
                        ),
                  SizedBox(
                    height: Get.height * 0.01,
                  ),
                  RowText(
                    text: "Things to",
                    onTap: (){
                      Get.to(
                            () => ThingsSeeAll(thingsto: thingstoController.cachedThingsto,),
                        duration: const Duration(milliseconds: 350),
                        transition: Transition.rightToLeft,
                      );
                    },
                  ),
                  SizedBox(
                    height: Get.height * 0.02,
                  ),
                  Obx(() {
                    return thingstoController.findingThings.isEmpty
                        ? Obx(
                          () {
                        if (thingstoController.isLoading.value && thingstoController.cachedThingsto.isEmpty) {
                          return Shimmers(
                            width: Get.width,
                            height:  Get.height * 0.255,
                            width1: Get.width * 0.37,
                            height1: Get.height * 0.08,
                            length: 6,
                          );
                        }
                        // if (thingstoController.isError.value) {
                        //   return const Center(
                        //     child: Padding(
                        //       padding: EdgeInsets.symmetric(vertical: 40.0),
                        //       child: LabelField(
                        //         text: "Things not found",
                        //         fontSize: 21,
                        //         color: AppColor.blackColor,
                        //         interFont: true,
                        //       ),
                        //     ),
                        //   );
                        // }
                        if (thingstoController.cachedThingsto.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 28.0),
                              child: LabelField(
                                text: 'Things not found',
                              ),
                            ),
                          );
                        }
                        return ThingstoContainer(
                          thingsto: thingstoController.cachedThingsto,
                        );
                      },
                    )
                    : ThingstoContainer(
                          thingsto: thingstoController.findingThings,
                    );
                  }),
                  SizedBox(
                    height: Get.height * 0.03,
                  ),
                  RowText(
                    text: "Top Things to",
                    onTap: (){
                      Get.to(
                            () => ThingsSeeAll(thingsto: thingstoController.cachedTopThingsto,),
                        duration: const Duration(milliseconds: 350),
                        transition: Transition.rightToLeft,
                      );
                    },
                  ),
                  SizedBox(
                    height: Get.height * 0.02,
                  ),
                  Obx(
                        () {
                      if (thingstoController.isLoading.value && thingstoController.cachedTopThingsto.isEmpty) {
                        return Shimmers(
                          width: Get.width,
                          height:  Get.height * 0.255,
                          width1: Get.width * 0.37,
                          height1: Get.height * 0.08,
                          length: 6,
                        );
                      }
                      // if (thingstoController.isError.value) {
                      //   return const Center(
                      //     child: Padding(
                      //       padding: EdgeInsets.symmetric(vertical: 40.0),
                      //       child: LabelField(
                      //         text: "Things not found",
                      //         fontSize: 21,
                      //         color: AppColor.blackColor,
                      //         interFont: true,
                      //       ),
                      //     ),
                      //   );
                      // }
                      if (thingstoController.cachedTopThingsto.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 28.0),
                            child: LabelField(
                              text: 'Top Things not found',
                            ),
                          ),
                        );
                      }
                      return TopThingstoContainer(
                        topThingsto: thingstoController.cachedTopThingsto,
                      );
                    },
                  ),
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
