import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thingsto/Controllers/get_profile_controller.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';
import 'package:thingsto/Widgets/shimmer_effect.dart';

class SummaryStats extends StatelessWidget {
  final List stats;
  const SummaryStats({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint("categoriesStats ${stats.toString()}");
    // List sortedStats = List.from(stats)
    //   ..sort((a, b) => b['percentage'].toString().compareTo(a['percentage'].toString()));
    // List sortedStats = List.from(stats)
    //   ..sort((a, b) {
    //     int percentageA = int.tryParse(a['percentage'].toString()) ?? 0;
    //     int percentageB = int.tryParse(b['percentage'].toString()) ?? 0;
    //     return percentageB.compareTo(percentageA);
    //   });
    return SizedBox(
      height: Get.height * 0.5,
      child: Obx(() {
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1 / 0.5,
            mainAxisSpacing: 15,
            crossAxisSpacing: 10,
          ),
          itemCount: stats.length,
          itemBuilder: (BuildContext context, i) {
            final categoriesStats = stats[i];
            debugPrint("UI rebuilt with latest categoriesStats: $categoriesStats");

            // Ensure the percentage is a valid double
            double percentage = (categoriesStats['percentage'] ?? 0.0).toDouble();
            bool isLoading = categoriesStats['isLoading'] ?? false;
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
                          text: isLoading ? "..." : '${categoriesStats['percentage']}%',
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
                  top: isLoading ? 35 : 45,
                  left: isLoading ? 35 : 8,
                  child: isLoading
                      ? const Center(
                    child: SizedBox(
                      height: 20.0, // Adjust the size of the loader
                      width: 20.0, // Adjust the size of the loader
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(AppColor.primaryColor), // Primary color
                        strokeWidth: 3.0, // Make it thinner for a sleek look
                      ),
                    ),
                  ) // ✅ Show loader
                      : LinearPercentIndicator(
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
