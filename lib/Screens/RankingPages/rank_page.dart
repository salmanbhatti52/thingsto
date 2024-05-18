import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thingsto/Resources/app_assets.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Screens/RankingPages/rank_list.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';
import 'package:thingsto/Widgets/app_bar.dart';
import 'package:thingsto/Widgets/custom_dropdown.dart';

class RankPage extends StatefulWidget {
  const RankPage({super.key});

  @override
  State<RankPage> createState() => _RankPageState();
}

class _RankPageState extends State<RankPage> {
  List<String> itemListForCategory = ["First", "Second", "Third"];
  String? selectCategory;

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
                const RankUserList(),
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
