import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:thingsto/Resources/app_assets.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Utills/apis_urls.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';

class RankUserList extends StatelessWidget {
  final List rankUser;
  const RankUserList({
    super.key,
    required this.rankUser,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height * 0.65,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        physics: const ScrollPhysics(),
        itemCount: rankUser.length,
        itemBuilder: (BuildContext context, i) {
          final rank = rankUser[i];
          return Stack(
            children: [
              Container(
                height: Get.height * 0.12,
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: AppColor.whiteColor,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    width: 1,
                    color: AppColor.borderColor,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(178, 178, 178, 0.2),
                      blurRadius: 30,
                      offset: Offset(0, 5),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      rank['profile_picture'] != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                '$baseUrlImage${rank["profile_picture"]}',
                                fit: BoxFit.fill,
                                width: 84,
                                height: 84,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return SizedBox(
                                      width: 84,
                                      height: 84,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: AppColor.primaryColor,
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                AppAssets.dummyPic,
                                fit: BoxFit.fill,
                                width: 84,
                                height: 84,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return SizedBox(
                                      width: 84,
                                      height: 84,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: AppColor.primaryColor,
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LabelField(
                            text: "${rank['first_name']} ${rank['last_name']}",
                            fontSize: 19,
                            color: const Color(0xff080C2F),
                            interFont: true,
                          ),
                          const Row(
                            children: [
                              // SvgPicture.asset(AppAssets.star),
                              // const SizedBox(
                              //   width: 6,
                              // ),
                              LabelField(
                                text: "None",
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                interFont: true,
                                color: AppColor.primaryColor,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              LabelField(
                                text: "${rank['total_points']}",
                                fontSize: 15,
                                color: AppColor.primaryColor,
                                interFont: true,
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              SvgPicture.asset(AppAssets.logo, width: 12),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 7.0),
                        child: i == 0
                            ? SvgPicture.asset(AppAssets.award1)
                            : i == 1
                                ? SvgPicture.asset(AppAssets.award2)
                                : i == 2
                                    ? SvgPicture.asset(AppAssets.award3)
                                    : Container(
                                        width: 31,
                                        height: 31,
                                        decoration: BoxDecoration(
                                          color: const Color(0xffFAC6A5),
                                          borderRadius:
                                              BorderRadius.circular(22),
                                        ),
                                        child: Center(
                                          child: LabelField(
                                            text: '${i + 1}',
                                            fontSize: 20,
                                            color: AppColor.whiteColor,
                                          ),
                                        ),
                                      ),
                      ),
                    ],
                  ),
                ),
              ),
              // Positioned(
              //   left: Get.width * 0.21,
              //   top: 15,
              //   child: Container(
              //     width: 34,
              //     height: 34,
              //     decoration: BoxDecoration(
              //       color: AppColor.whiteColor,
              //       shape: BoxShape.circle,
              //       border: Border.all(
              //         width: 1,
              //         color: const Color(0xffFEE400),
              //       ),
              //     ),
              //     child: Center(
              //       child: SvgPicture.asset(AppAssets.cup),
              //     ),
              //   ),
              // ),
            ],
          );
        },
      ),
    );
  }
}
