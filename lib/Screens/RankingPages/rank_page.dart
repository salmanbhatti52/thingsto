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
  String? selectCategory;
  String? selectCategoryId;

  Future<void> getRankUser() async {
    if (rankingController.isRank.value) {
      rankingController.getRankUser(filter: "all", categoryId: "",);
    } else {
      // Load data from the server
      rankingController.getRankUser(filter: "all", categoryId: "",);
    }
  }

  Future<void> fetchCategories() async {
    await addThingsController.getAllCategory();
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
    fetchCategories();
    notificationsController.getNotificationsAlert();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Column(
        children: [
          Obx(() => HomeBar(
            title: "Ranking",
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
                      text: "Rank by",
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
                      ? Shimmers2(
                    width: Get.width,
                    height: 50,
                  ) : CustomDropdown(
                    itemList: itemListForCategory,
                    hintText: "Select Category",
                    onChanged: (value) {
                      setState(() {
                        selectCategory = value;
                        if (selectCategory == "All Categories") {
                          selectCategoryId = "";
                          rankingController.getRankUser(filter: "all", categoryId: "");
                        } else {
                          selectCategoryId = addThingsController.categoriesAll
                              .firstWhere((c) => c['name'] == value)['categories_id']
                              .toString();
                          rankingController.getRankUser(
                              filter: "category", categoryId: selectCategoryId.toString());
                        }
                        debugPrint("selectCategory: $selectCategory, selectCategoryId: $selectCategoryId");
                      });
                    },
                    initialValue: selectCategory ?? null,
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
                            text: 'Ranking not found',
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
    );
  }
}
