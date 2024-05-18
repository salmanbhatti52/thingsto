import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';

class SummaryStats extends StatelessWidget {
  const SummaryStats({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height * 0.5,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1 / 0.5,
          mainAxisSpacing: 15,
          crossAxisSpacing: 10,
        ),
        itemCount: 12,
        itemBuilder: (BuildContext context, int index) {
          return Container(
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
                  const LabelField(
                    text: '40%',
                    fontSize: 18,
                  ),
                  Stack(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xffFDE0C5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.15,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColor.primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ],
                  ),
                  const LabelField(
                    text: "Religious Sites",
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColor.lightBrown,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
