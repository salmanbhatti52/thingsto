import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:thingsto/Controllers/get_profile_controller.dart';
import 'package:thingsto/Resources/app_assets.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Screens/HomePages/home_suggestions.dart';
import 'package:thingsto/Screens/ProfilePage/summary_stats.dart';
import 'package:thingsto/Utills/apis_urls.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';
import 'package:thingsto/Widgets/app_bar.dart';
import 'package:thingsto/Widgets/shimmer_effect.dart';

class RankDetails extends StatefulWidget {
  Map<dynamic, dynamic> getProfile = {};
   RankDetails({super.key, required this.getProfile});

  @override
  State<RankDetails> createState() => _RankDetailsState();
}

class _RankDetailsState extends State<RankDetails> {
  final GetProfileController getProfileController = Get.put(GetProfileController());

  @override
  void initState() {
    super.initState();
    getUserProfile();
  }

  Future<void> getUserProfile() async {
    debugPrint("users_customers_id ${widget.getProfile["users_customers_id"].toString()}");
      if (getProfileController.isDataLoadedThings.value) {
        getProfileController.getThings(usersCustomersId: widget.getProfile["users_customers_id"].toString());
      } else {
        await getProfileController.getThings(usersCustomersId: widget.getProfile["users_customers_id"].toString());
      }
      if (getProfileController.isDataLoadedCategoriesStats.value) {
        getProfileController.getCategoriesStats(usersCustomersId: widget.getProfile["users_customers_id"].toString());
      } else {
        await getProfileController.getCategoriesStats(usersCustomersId: widget.getProfile["users_customers_id"].toString());
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Column(
        children: [
          BackButtonBar(
            title: "User Details",
            bottomPad: 15,
            onBack: () {
              Get.back();
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: Get.height * 0.02,
                    ),
                    Stack(
                        children: [
                          Container(
                            width: Get.width,
                            height: Get.height * 0.135,
                            decoration: BoxDecoration(
                              color: AppColor.whiteColor,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.16),
                                  blurRadius: 4,
                                  offset: Offset(0, 0),
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0, top: 10, bottom: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: widget.getProfile["profile_picture"] != null
                                        ? Image.network(
                                      '$baseUrlImage${widget.getProfile["profile_picture"]}',
                                      fit: BoxFit.cover,
                                      width: 80,
                                      height: 95,
                                      loadingBuilder: (BuildContext context, Widget child,
                                          ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress ==
                                            null) {
                                          return child;
                                        } else {
                                          return SizedBox(
                                            width: 80,
                                            height: 95,
                                            child: Center(
                                              child:
                                              CircularProgressIndicator(
                                                color: AppColor.primaryColor,
                                                value: loadingProgress.expectedTotalBytes !=
                                                    null
                                                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                                    : null,
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    )
                                        : Image.network(
                                      AppAssets.dummyPic,
                                      fit: BoxFit.fill,
                                      width: 80,
                                      height: 95,
                                    ),
                                  ),
                                  SizedBox(
                                    width: Get.width * 0.06,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        LabelField(
                                          text: "${widget.getProfile['sur_name']}",
                                          fontSize: 16,
                                        ),
                                        LabelField(
                                          text: "${widget.getProfile['active_title'] ?? "None"}",
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: AppColor.lightBrown,
                                        ),
                                        Row(
                                          children: [
                                            LabelField(
                                              align: TextAlign.start,
                                              text: "${widget.getProfile['total_points']}",
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400,
                                              color: AppColor.lightBrown,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            SvgPicture.asset(
                                              AppAssets.logo,
                                              width: 20,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          // widget.getProfile['active_badge'] == "None" ? const SizedBox() : Positioned(
                          //   left: Get.width * 0.2,
                          //   bottom: 5,
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
                          //       child: widget.getProfile['active_badge']
                          //           ? Image.network(
                          //         '$baseUrlImage${widget.getProfile['active_badge']}',
                          //         fit: BoxFit.contain,
                          //         width: 25,
                          //         height: 25,
                          //         loadingBuilder: (BuildContext context, Widget child,
                          //             ImageChunkEvent? loadingProgress) {
                          //           if (loadingProgress ==
                          //               null) {
                          //             return child;
                          //           } else {
                          //             return SizedBox(
                          //               width: 34,
                          //               height: 34,
                          //               child: Center(
                          //                 child:
                          //                 CircularProgressIndicator(
                          //                   color: AppColor.primaryColor,
                          //                   value: loadingProgress.expectedTotalBytes !=
                          //                       null
                          //                       ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                          //                       : null,
                          //                 ),
                          //               ),
                          //             );
                          //           }
                          //         },
                          //       )
                          //           : Image.network(
                          //         AppAssets.dummyPic,
                          //         fit: BoxFit.fill,
                          //         width: 34,
                          //         height: 34,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    SizedBox(
                      height: Get.height * 0.02,
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const LabelField(
                            text: 'Quote',
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          LabelField(
                            text: "${widget.getProfile["quote"]}",
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: AppColor.blackColor,
                            interFont: true,
                          ),
                          SizedBox(
                            height: Get.height * 0.02,
                          ),
                        ],
                      ),
                    SizedBox(
                      height: Get.height * 0.02,
                    ),
                    const LabelField(
                      text: 'History of Things',
                      fontSize: 18,
                    ),
                    SizedBox(
                      height: Get.height * 0.015,
                    ),
                    Obx(() {
                      if (getProfileController.isLoading.value) {
                        return Shimmers(
                          width: Get.width,
                          height:  Get.height * 0.255,
                          width1: Get.width * 0.37,
                          height1: Get.height * 0.08,
                          length: 6,
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
                      if (getProfileController.cachedThings.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 28.0),
                            child: LabelField(
                              text: 'Things not found',
                            ),
                          ),
                        );
                      }
                      return HomeSuggestions(
                        thingsto: getProfileController.cachedThings,
                        thingstoName: "Rank",
                        id: widget.getProfile["users_customers_id"].toString(),
                      );
                    },
                    ),
                    SizedBox(
                      height: Get.height * 0.02,
                    ),
                    const LabelField(
                      text: 'Summary of stats for each category',
                      fontSize: 18,
                      align: TextAlign.left,
                    ),
                    Obx(
                          () {
                        if (getProfileController.isLoading.value && getProfileController.cachedCategoriesStats.isEmpty) {
                          return Shimmers(
                            width: Get.width,
                            height:  Get.height * 0.15,
                            width1: Get.width * 0.4,
                            height1: Get.height * 0.08,
                            length: 2,
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
                        if (getProfileController.cachedCategoriesStats.isEmpty) {
                          return const Center(
                            child: Text(
                              'Summary Stats of Categories not available',
                              style: TextStyle(
                                color: AppColor.blackColor,
                                fontSize: 16,
                              ),
                            ),
                          );
                        }
                        return SummaryStats(
                          stats: getProfileController.cachedCategoriesStats,
                        );
                      },
                    ),
                    SizedBox(
                      height: Get.height * 0.015,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
