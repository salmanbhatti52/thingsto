import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thingsto/Controllers/get_profile_controller.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';
import 'package:thingsto/Widgets/shimmer_effect.dart';

class SummaryStats extends StatefulWidget {
  final List stats;
  const SummaryStats({
    super.key,
    required this.stats,
  });

  @override
  State<SummaryStats> createState() => _SummaryStatsState();
}

class _SummaryStatsState extends State<SummaryStats> {

  final ScrollController _scrollController = ScrollController();
  final GetProfileController getProfileController = Get.find();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _onScroll() async {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent &&
        !getProfileController.isLoadingMore.value) {
      // Load next page
      getProfileController.currentPage.value += 1;
      final prefs = await SharedPreferences.getInstance();
      String? userID = prefs.getString('users_customers_id');
      if (userID != null) {
        getProfileController.getCategoriesStats(
          usersCustomersId: userID,
          page: getProfileController.currentPage.value,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // List sortedStats = List.from(stats)
    //   ..sort((a, b) => b['percentage'].toString().compareTo(a['percentage'].toString()));
    // List sortedStats = List.from(stats)
    //   ..sort((a, b) {
    //     int percentageA = int.tryParse(a['percentage'].toString()) ?? 0;
    //     int percentageB = int.tryParse(b['percentage'].toString()) ?? 0;
    //     return percentageB.compareTo(percentageA);
    //   });
    return SizedBox(
      height: Get.height * 0.24,
      child: Obx(() {
        return GridView.builder(
          controller: _scrollController,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1 / 0.5,
            mainAxisSpacing: 15,
            crossAxisSpacing: 10,
          ),
          itemCount: widget.stats.length + (getProfileController.isLoadingMore.value ? 1 : 0),
          itemBuilder: (BuildContext context, i) {
            if (i >= widget.stats.length) {
              return Shimmers(
                width: Get.width,
                height:  Get.height * 0.15,
                width1: Get.width * 0.4,
                height1: Get.height * 0.08,
                length: 2,
              );
            }

            final categoriesStats = widget.stats[i];
            double percentage = double.parse(categoriesStats['percentage'].toString());
            return Stack(
              children: [
                Container(
                  width: 166,
                  decoration: BoxDecoration(
                    color: const Color(0xffFFFAF5),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      width: 1,
                      color: AppColor.secondaryColor,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(0, 87, 178, 0.08),
                        blurRadius: 15,
                        offset: Offset(0, 4),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LabelField(
                          text: '${categoriesStats['percentage']}%',
                          fontSize: 18,
                        ),
                        LabelField(
                          text: categoriesStats['name'],
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColor.lightBrown,
                          align: TextAlign.left,
                          maxLIne: 1,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 45,
                  left: 8,
                  child: LinearPercentIndicator(
                    width: MediaQuery.of(context).size.width * 0.36,
                    lineHeight: 4.0,
                    percent: percentage / 100,
                    progressColor: AppColor.primaryColor,
                    backgroundColor: const Color(0xffFDE0C5),
                    barRadius: const Radius.circular(10),
                    animation: true,
                    animationDuration: 2000,
                  ),
                ),
              ],
            );
          },
        );
      }),
    );
  }
}
