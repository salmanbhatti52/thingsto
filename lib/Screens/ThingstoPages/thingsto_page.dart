import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thingsto/Controllers/language_controller.dart';
import 'package:thingsto/Controllers/notifications_controller.dart';
import 'package:thingsto/Controllers/thingsto_controller.dart';
import 'package:thingsto/Resources/app_assets.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Screens/NotificationPage/notification_page.dart';
import 'package:thingsto/Screens/ThingstoPages/Categories/category_container.dart';
import 'package:thingsto/Screens/ThingstoPages/Categories/category_details.dart';
import 'package:thingsto/Screens/ThingstoPages/Things/thingsto_container.dart';
import 'package:thingsto/Screens/ThingstoPages/filter_dialog.dart';
import 'package:thingsto/Screens/ThingstoPages/member_search.dart';
import 'package:thingsto/Screens/ThingstoPages/things_search.dart';
import 'package:thingsto/Screens/ThingstoPages/things_see_all.dart';
import 'package:thingsto/Utills/const.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';
import 'package:thingsto/Widgets/TextFields.dart';
import 'package:thingsto/Widgets/app_bar.dart';
import 'package:thingsto/Widgets/large_Button.dart';
import 'package:thingsto/Widgets/row_text.dart';
import 'package:thingsto/Widgets/shimmer_effect.dart';
import 'package:thingsto/Widgets/snackbar.dart';

class ThingstoPage extends StatefulWidget {
  const ThingstoPage({super.key});

  @override
  State<ThingstoPage> createState() => _ThingstoPageState();
}

class _ThingstoPageState extends State<ThingstoPage> {
  bool isSelect = false;
  bool isShow = false;
  bool isThings = false;
  bool isMember = false;
  String selectedCategoryName = '';
  String selectedCategoryId = '';
  final TextEditingController searchController = TextEditingController();
  final ThingstoController thingstoController = Get.put(ThingstoController());
  // final LanguageController languageController = Get.put(LanguageController());
  final NotificationsController notificationsController = Get.put(NotificationsController());
  final List<Map<String, String>> categoryHistory = [];

  @override
  void initState() {
    super.initState();
    getUserThings();
    notificationsController.getNotificationsAlert();
  }

  Future<void> getUserThings() async {
    thingstoController.findingThings.clear();
    userID = (prefs.getString('users_customers_id').toString());
    debugPrint("userID $userID");
    if (thingstoController.isDataLoadedThingsto.value) {
      // Show cached data and then update in the background
      thingstoController.getThingsto(checkValue: "No");
    } else {
      // Load data from the server
      await thingstoController.getThingsto(checkValue: "No");
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
    if(selectedCategoryId != categoryId){
      setState(() {
        isSelect = true;
        selectedCategoryName = categoryName;
        selectedCategoryId = categoryId;
        thingstoController.foundedThings(
          categoriesId: categoryId.toString(),
          country: "",
          city: "",
          distances: "",
          checkValue2: "No",
          backValue: "No",
          categoryThings: "Yes",
        );
        thingstoController.getChildCategory(
          categoriesId: categoryId,
          page: 1,
        );
        thingstoController.topThingsByCategory(
          categoriesId: categoryId.toString(),
        );
        categoryHistory.add({'name': categoryName, 'id': categoryId});
      });
    }
  }

  void goBack() {
    thingstoController.hasRunFoundedThings.value = false;
    thingstoController.findingThings.clear();
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
            page: 1
          );
        }
      }
    });
  }

  void filterThings(String query) {
    thingstoController.searchMembers(search: "things", name: query);
    // final filteredThings = thingstoController.members.where((thing) {
    //   final thingName = thing['name'].toString().toLowerCase();
    //   final input = query.toLowerCase();
    //   return thingName.contains(input);
    // }).toList();
    // thingstoController.hasRunFoundedThings.value = true;
    // setState(() {
    //   thingstoController.findingThings.assignAll(filteredThings);
    // });
  }
  
  void filterMember(String query) {
    thingstoController.searchMembers(search: "members", name: query);
    // final filteredThings = thingstoController.cachedThingsto.where((thing) {
    //   final thingName = thing['name'].toString().toLowerCase();
    //   final input = query.toLowerCase();
    //   return thingName.contains(input);
    // }).toList();
    // thingstoController.hasRunFoundedThings.value = true;
    // setState(() {
    //   thingstoController.findingThings.assignAll(filteredThings);
    // });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Column(
        children: [
          isSelect
              ? BackButtonBar(
                  title: "thingsto",
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
              : Obx(() => HomeBar(
                     title: "thingsto",
                     titleTrue: true,
                     icon2: AppAssets.notify,
                     hasUnreadNotifications: notificationsController.hasUnreadNotifications.value,
                     onClick: (){
                       Get.to(
                             () => const NotificationsScreen(),
                         duration: const Duration(milliseconds: 350),
                         transition: Transition.upToDown,
                       );
                     },
          ),
          ),
          SizedBox(
            height: Get.height * 0.02,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              children: [
                CustomTextFormField(
                  controller: searchController,
                  hintText: "search",
                  // validator: validateEmail,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  suffixImage: AppAssets.filter,
                  showPrefix: true,
                  showSuffix: isMember ? false : true,
                  tap: (){
                    setState(() {
                      isShow = true;
                    });
                  },
                  onChanged: (value) {
                    if(isThings) {
                      filterThings(value);
                    } else if(isMember){
                      filterMember(value);
                    } else {
                      CustomSnackbar.show(title: "error", message: "pleaseSelectOne");
                    }
                  },
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
                if(isShow)
                Column(
                  children: [
                    SizedBox(
                      height: Get.height * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LargeButton(
                          text: "things",
                          width: Get.width * 0.3,
                          containerColor: isThings ? AppColor.primaryColor : AppColor.borderColor,
                          textColor: isThings ? AppColor.whiteColor : AppColor.blackColor,
                          onTap: (){
                            setState(() {
                              thingstoController.members.clear();
                              isThings = true;
                              isMember = false;
                            });
                          },
                        ),
                        SizedBox(
                          width: Get.width * 0.02,
                        ),
                        LargeButton(
                          text: "members",
                          width: Get.width * 0.3,
                          containerColor: isMember ? AppColor.primaryColor : AppColor.borderColor,
                          textColor: isMember ? AppColor.whiteColor : AppColor.blackColor,
                          onTap: (){
                            setState(() {
                              thingstoController.members.clear();
                              isThings = false;
                              isMember = true;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          if(!isThings && !isMember)
          Expanded(
            child: RefreshIndicator(
              color: AppColor.primaryColor,
              backgroundColor: AppColor.borderColor,
              onRefresh: getUserThings,
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
                      seeTrue: false,
                          )
                        : RowText(
                      text: "categories",
                      onTap: (){},
                      seeTrue: false,
                    ),
                    isSelect
                        ? Obx(
                            () {
                              if (thingstoController.isSubLoading.value && thingstoController.subcategories.isEmpty) {
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
                                    'subcategoriesNotFound',
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
                                selectedCategoryId: selectedCategoryId,
                                isLoading: thingstoController.isSubLoading.value,
                                fetchNextPage: (int page) {
                                  thingstoController.getChildCategory(
                                    categoriesId: selectedCategoryId,
                                    page: page,
                                  );
                                },
                              );
                            },
                          )
                        : Obx(
                            () {
                              if (thingstoController.isLoadingCategory.value && thingstoController.cachedCategories.isEmpty){
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
                                    'categoriesNotFound',
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
                      text: selectedCategoryId.isEmpty ? "things_of_the_moment" : "thingsto",
                      seeTrue: true,
                      onTap: () {
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
                      if (thingstoController.isLoading1.value) {
                        return Shimmers(
                          width: Get.width,
                          height: Get.height * 0.255,
                          width1: Get.width * 0.37,
                          height1: Get.height * 0.08,
                          length: 6,
                        );
                      }
                      if (thingstoController.hasRunFoundedThings.value) {
                        if (thingstoController.findingThings.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 28.0),
                              child: LabelField(
                                text: 'things_not_found',
                              ),
                            ),
                          );
                        } else {
                          return ThingstoContainer(
                            thingsto: thingstoController.findingThings,
                          );
                        }
                      } else {
                        if (thingstoController.isLoading.value && thingstoController.cachedThingsto.isEmpty) {
                          return Shimmers(
                            width: Get.width,
                            height:  Get.height * 0.255,
                            width1: Get.width * 0.37,
                            height1: Get.height * 0.08,
                            length: 6,
                          );
                        }
                        if (thingstoController.cachedThingsto.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 28.0),
                              child: LabelField(
                                text: 'things_not_found',
                              ),
                            ),
                          );
                        } else {
                          return ThingstoContainer(
                            thingsto: thingstoController.cachedThingsto,
                          );
                        }
                      }
                    }),
                    // Obx(() {
                    //   return thingstoController.findingThings.isEmpty
                    //       ? Obx(
                    //         () {
                    //       if (thingstoController.isLoading.value && thingstoController.cachedThingsto.isEmpty) {
                    //         return Shimmers(
                    //           width: Get.width,
                    //           height:  Get.height * 0.255,
                    //           width1: Get.width * 0.37,
                    //           height1: Get.height * 0.08,
                    //           length: 6,
                    //         );
                    //       }
                    //       // if (thingstoController.isError.value) {
                    //       //   return const Center(
                    //       //     child: Padding(
                    //       //       padding: EdgeInsets.symmetric(vertical: 40.0),
                    //       //       child: LabelField(
                    //       //         text: "Things not found",
                    //       //         fontSize: 21,
                    //       //         color: AppColor.blackColor,
                    //       //         interFont: true,
                    //       //       ),
                    //       //     ),
                    //       //   );
                    //       // }
                    //       if (thingstoController.cachedThingsto.isEmpty) {
                    //         return const Center(
                    //           child: Padding(
                    //             padding: EdgeInsets.symmetric(vertical: 28.0),
                    //             child: LabelField(
                    //               text: 'Things not found',
                    //             ),
                    //           ),
                    //         );
                    //       }
                    //       return ThingstoContainer(
                    //         thingsto: thingstoController.cachedThingsto,
                    //       );
                    //     },
                    //   )
                    //   : ThingstoContainer(
                    //         thingsto: thingstoController.findingThings,
                    //   );
                    // }),
                    SizedBox(
                      height: Get.height * 0.03,
                    ),
                    RowText(
                      text: "topThingsTo",
                      seeTrue: true,
                      onTap: () {
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
                    Obx(() {
                      if (thingstoController.isLoading1.value) {
                        return Shimmers(
                          width: Get.width,
                          height: Get.height * 0.255,
                          width1: Get.width * 0.37,
                          height1: Get.height * 0.08,
                          length: 6,
                        );
                      }
                      if (thingstoController.hasRunFoundedThings.value) {
                        if (thingstoController.topThingsByCat.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 28.0),
                              child: LabelField(
                                text: 'topThingsNotFound',
                              ),
                            ),
                          );
                        } else {
                          return ThingstoContainer(
                            thingsto: thingstoController.topThingsByCat,
                          );
                        }
                      } else {
                        if (thingstoController.isLoading.value && thingstoController.cachedTopThingsto.isEmpty) {
                          return Shimmers(
                            width: Get.width,
                            height:  Get.height * 0.255,
                            width1: Get.width * 0.37,
                            height1: Get.height * 0.08,
                            length: 6,
                          );
                        }
                        if (thingstoController.cachedTopThingsto.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 28.0),
                              child: LabelField(
                                text: 'topThingsNotFound',
                              ),
                            ),
                          );
                        } else {
                          return ThingstoContainer(
                            thingsto: thingstoController.cachedTopThingsto,
                          );
                        }
                      }
                    }),
                    SizedBox(
                      height: Get.height * 0.02,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if(isThings)
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Obx(() {
                  if (thingstoController.isLoading.value) {
                    return Column(
                      children: [
                        const SizedBox(height: 15,),
                        Shimmers2(
                          width: Get.width,
                          height: Get.height * 0.12,
                        ),
                        Shimmers2(
                          width: Get.width,
                          height: Get.height * 0.12,
                        ),
                        Shimmers2(
                          width: Get.width,
                          height: Get.height * 0.12,
                        ),
                        Shimmers2(
                          width: Get.width,
                          height: Get.height * 0.12,
                        ),
                        Shimmers2(
                          width: Get.width,
                          height: Get.height * 0.12,
                        ),
                      ],
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
                  if (thingstoController.members.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: Get.height * 0.3,),
                        child: const LabelField(
                          text: 'things_not_found',
                          fontSize: 18,
                        ),
                      ),
                    );
                  }
                  return ThingsSearch(
                    memberList: thingstoController.members,
                  );
                },
                ),
              ),
            ),
          ),
          if(isMember)
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Obx(() {
                  if (thingstoController.isLoading.value) {
                    return Column(
                      children: [
                        const SizedBox(height: 15,),
                        Shimmers2(
                          width: Get.width,
                          height: Get.height * 0.12,
                        ),
                        Shimmers2(
                          width: Get.width,
                          height: Get.height * 0.12,
                        ),
                        Shimmers2(
                          width: Get.width,
                          height: Get.height * 0.12,
                        ),
                        Shimmers2(
                          width: Get.width,
                          height: Get.height * 0.12,
                        ),
                        Shimmers2(
                          width: Get.width,
                          height: Get.height * 0.12,
                        ),
                      ],
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
                  if (thingstoController.members.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: Get.height * 0.3,),
                        child: const LabelField(
                          text: 'membersNotFound',
                          fontSize: 18,
                        ),
                      ),
                    );
                  }
                  return MemberSearch(
                    memberList: thingstoController.members,
                  );
                },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
