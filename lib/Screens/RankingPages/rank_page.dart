import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thingsto/Controllers/ranking_controller.dart';
import 'package:thingsto/Resources/app_assets.dart';
import 'package:thingsto/Resources/app_colors.dart';
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
  List<String> itemListForCategory = ["First", "Second", "Third"];
  String? selectCategory;

  RankingController rankingController = Get.put(RankingController());

  Future<void> getRankUser() async {
    if (rankingController.isRank.value) {
      rankingController.getRankUser(filter: "all", categoryId: "",);
    } else {
      // Load data from the server
      rankingController.getRankUser(filter: "all", categoryId: "",);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRankUser();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Column(
        children: [
          const HomeBar(
            title: "Ranking",
            titleTrue: true,
            icon2: AppAssets.notify,
          ),
          SizedBox(
            height: Get.height * 0.02,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LabelField(
                  text: "Rank by",
                  fontSize: 14,
                ),
                SizedBox(
                  height: Get.height * 0.01,
                ),
                CustomDropdown(
                  itemList: itemListForCategory,
                  hintText: "All Categories",
                  onChanged: (value) {
                    selectCategory = value;
                    debugPrint("Categories: $selectCategory");
                  },
                ),
                Obx(
                      () {
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
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 28.0),
                          child: LabelField(
                            text: 'Things not found',
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
