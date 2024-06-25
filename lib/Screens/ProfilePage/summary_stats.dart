import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';

class SummaryStats extends StatelessWidget {
  final List stats;
  const SummaryStats({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    List sortedStats = List.from(stats)
      ..sort((a, b) => b['percentage'].compareTo(a['percentage']));
    return SizedBox(
      height: Get.height * 0.5,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1 / 0.5,
          mainAxisSpacing: 15,
          crossAxisSpacing: 10,
        ),
        itemCount: sortedStats.length,
        itemBuilder: (BuildContext context, i) {
          final categoriesStats = sortedStats[i];
          double percentage = double.parse(categoriesStats['percentage'].toString());
          return  Stack(
            children: [
              Container(
                width: 166,
                decoration: BoxDecoration(
                  color: const Color(0xffFFFAF5),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1, color: AppColor.secondaryColor,),
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
      ),
    );
  }
}
