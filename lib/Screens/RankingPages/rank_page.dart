import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thingsto/Controllers/add_things_controller.dart';
import 'package:thingsto/Controllers/notifications_controller.dart';
import 'package:thingsto/Controllers/ranking_controller.dart';
import 'package:thingsto/Resources/app_assets.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Screens/NotificationPage/notification_page.dart';
import 'package:thingsto/Screens/RankingPages/rank_list.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';
import 'package:thingsto/Widgets/app_bar.dart';
import 'package:thingsto/Widgets/custom_dropdown.dart';
import 'package:thingsto/Widgets/shimmer_effect.dart';

class RankPage extends StatefulWidget {
  const RankPage({super.key});

  @override
  State<RankPage> createState() => _RankPageState();
}

class _RankPageState extends State<RankPage> {

  RankingController rankingController = Get.put(RankingController());
  AddThingsController addThingsController = Get.put(AddThingsController());
  final NotificationsController notificationsController = Get.put(NotificationsController());

  var itemListForCategory = <String>[];

  Future<void> getRankUser() async {
    if (rankingController.isRank.value) {
      rankingController.getRankUser(filter: "all", categoryId: "",);
    } else {
      // Load data from the server
      rankingController.getRankUser(filter: "all", categoryId: "",);
    }
  }

  Future<void> fetchCategories() async {
    await addThingsController.getAllCategory(forceRefresh: true);
    if (mounted) {
      setState(() {
        itemListForCategory = ['All Categories'] +
            addThingsController.categoriesP0
                .map((c) => c['name'].toString())
                .toSet() // Ensure uniqueness
                .toList();
        debugPrint("itemListForCategory: $itemListForCategory");
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRankUser();
    // fetchCategories();
    notificationsController.getNotificationsAlert();
    debugPrint("rankingController.isLoading: ${rankingController.isLoading.value}");
    debugPrint("rankingController.cachedRankUser: ${rankingController.cachedRankUser}");
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Obx(() => HomeBar(
                  title: "ranking",
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
                ),),
                SizedBox(
                  height: Get.height * 0.02,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const LabelField(
                            text: "rankBy",
                            fontSize: 14,
                          ),
                          Obx(() {
                            if (rankingController.isFiltered.value) {
                              return GestureDetector(
                                onTap: () {
                                  // getRankUser();
                                  // selectCategory = null;
                                },
                                child: const LabelField(
                                  text: "",
                                  fontSize: 14,
                                ),
                              );
                            } else {
                              return const SizedBox();
                            }
                          })
                        ],
                      ),
                      SizedBox(
                        height: Get.height * 0.01,
                      ),
                      Obx(() {
                        return addThingsController.isLoading1.value
                            ? Shimmers2(width: Get.width, height: 50)
                            : CustomDropdown(
                          itemList: ['All Categories'] +
                              addThingsController.categoriesP0
                                  .map((c) => c['name'].toString())
                                  .toSet()
                                  .toList(),
                          hintText: "allCategories",
                          onChanged: (value) {
                            addThingsController.selectCategory.value = value.toString();
                            if (addThingsController.selectCategory.value == "All Categories") {
                              addThingsController.selectCategory.value = "";
                              rankingController.getRankUser(filter: "all", categoryId: "");
                            } else {
                              addThingsController.selectCategoryId.value = addThingsController.categoriesAll
                                  .firstWhere((c) => c['name'] == value)['categories_id']
                                  .toString();
                              rankingController.getRankUser(
                                  filter: "category", categoryId: addThingsController.selectCategoryId.value!);
                            }
                            // debugPrint("Selected: $addThingsController.selectCategory.value, ID: $addThingsController.selectCategoryId.value");
                          },
                          initialValue: addThingsController.selectCategory.value,
                        );
                      }),
                      Obx(() {
                        if (rankingController.isLoading.value && rankingController.cachedRankUser.isEmpty) {
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
                        if (rankingController.cachedRankUser.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: Get.height * 0.3,),
                              child: const LabelField(
                                text: 'rankingNotFound',
                                fontSize: 18,
                              ),
                            ),
                          );
                        }
                        return RankUserList(
                          rankUser: rankingController.cachedRankUser,
                        );
                      },
                      ),
                      SizedBox(
                        height: Get.height * 0.01,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
