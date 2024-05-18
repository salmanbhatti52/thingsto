import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:thingsto/Resources/app_assets.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';

class HomeSuggestions extends StatelessWidget {
  final double pad;
  const HomeSuggestions({super.key, this.pad = 15,});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.21,
      padding: EdgeInsets.only(left: pad),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const ScrollPhysics(),
        itemCount: 5,
        itemBuilder: (BuildContext context, i) {
          return Container(
            width: Get.width * 0.37,
            margin: const EdgeInsets.symmetric(horizontal: 7),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              image: const DecorationImage(
                image: AssetImage(AppAssets.dummyImage),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.srgbToLinearGamma(),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                    right: 8.0,
                  ),
                  child: SvgPicture.asset(
                    AppAssets.heart,
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.082,
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                      child: Container(
                        width: Get.width * 0.37,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const LabelField(
                              text: "1st Thing",
                              fontSize: 12,
                              color: AppColor.whiteColor,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SvgPicture.asset(
                                  AppAssets.location,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                SizedBox(
                                  width: Get.width * 0.25,
                                  child: const LabelField(
                                    align: TextAlign.start,
                                    text: "244 B, 7th Ave Los Angeles",
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                    color: AppColor.secondaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
