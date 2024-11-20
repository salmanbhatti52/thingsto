import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thingsto/Controllers/get_profile_controller.dart';
import 'package:thingsto/Resources/app_assets.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Screens/HomePages/home_suggestions.dart';
import 'package:thingsto/Screens/ProfilePage/SettingPage/setting_page.dart';
import 'package:thingsto/Screens/ProfilePage/summary_stats.dart';
import 'package:thingsto/Utills/apis_urls.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';
import 'package:thingsto/Widgets/app_bar.dart';
import 'package:thingsto/Widgets/custom_dropdown.dart';
import 'package:thingsto/Widgets/shimmer_effect.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  var itemListForTitle = <String>[];
  var itemListForBadge = <String>[];

  String? selectTitle;
  String? selectBadge;
  String? selectTitleId;
  String? selectBadgeId;

  final GetProfileController getProfileController = Get.put(GetProfileController());

  @override
  void initState() {
    super.initState();
    getUserProfile();
    getUserTB();
  }

  Future<void> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    String? userID = prefs.getString('users_customers_id');
    if (userID != null) {
      if (getProfileController.isDataLoadedGetProfile.value) {
        getProfileController.getUserProfile(usersCustomersId: userID.toString());
      } else {
        await getProfileController.getUserProfile(usersCustomersId: userID.toString());
      }
      if (getProfileController.isDataLoadedFavorites.value) {
        getProfileController.getFavoritesThings();
      } else {
        await getProfileController.getFavoritesThings();
      }
      if (getProfileController.isDataLoadedThings.value) {
        getProfileController.getThings(usersCustomersId: userID.toString());
      } else {
        await getProfileController.getThings(usersCustomersId: userID.toString());
      }
      if (getProfileController.isDataLoadedCategoriesStats.value) {
        getProfileController.getCategoriesStats(usersCustomersId: userID.toString());
      } else {
        await getProfileController.getCategoriesStats(usersCustomersId: userID.toString());
      }
    }
  }

  Future<void> getUserFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    String? userID = prefs.getString('users_customers_id');
      if(userID != null){
        if (getProfileController.isDataLoadedFavorites.value) {
          getProfileController.getFavoritesThings();
        } else {
          await getProfileController.getFavoritesThings();
        }
        if (getProfileController.isDataLoadedThings.value) {
          getProfileController.getThings(usersCustomersId: userID.toString());
        } else {
          await getProfileController.getThings(usersCustomersId: userID.toString());
        }
      }
  }

  Future<void> getUserTB() async {
      await getProfileController.getTitle();
      itemListForTitle = getProfileController.getTitles
          .map((c) => c['name'].toString())
          .toSet() // Ensure uniqueness
          .toList();
      debugPrint("itemListForTitle: $itemListForTitle");
      await getProfileController.getBadge();
      itemListForBadge = getProfileController.getBadges
          .map((c) => c['name'].toString())
          .toSet() // Ensure uniqueness
          .toList();
      debugPrint("itemListForBadge: $itemListForBadge");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Column(
        children: [
          HomeBar(
            title: "profile",
            titleTrue: true,
            icon2: AppAssets.setting,
            onClick: () {
              Get.to(
                () => SettingPage(getProfile: getProfileController.cachedGetProfile,),
                duration: const Duration(milliseconds: 350),
                transition: Transition.upToDown,
              );
            },
          ),
          Expanded(
            child: RefreshIndicator(
              color: AppColor.primaryColor,
              backgroundColor: AppColor.borderColor,
              onRefresh: getUserFavorite,
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
                      Obx(() {
                        final profile = getProfileController.cachedGetProfile;
                        final profilePictureUrl = profile['profile_picture'] ?? '';
                        final userName = "${profile['sur_name']}";
                        // final userName = "${profile['first_name']} ${profile['last_name']}";
                        final activeTitle = "${profile['active_title']}";
                        final activeBadge = "${profile['active_badge']}";
                        final totalPoints = "${profile['total_points']}";
                        return Stack(
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
                              child: getProfileController.isLoading.value && getProfileController.cachedGetProfile.isEmpty
                                  ? const Center(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(vertical: 40.0),
                                        child: LabelField(
                                          text: "",
                                          fontSize: 21,
                                          color: AppColor.blackColor,
                                          interFont: true,
                                        ),
                                      ),
                                    )
                                  : Padding(
                                padding: const EdgeInsets.only(
                                    left: 15.0, top: 10, bottom: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: getProfileController.isLoading.value && getProfileController.cachedGetProfile.isEmpty
                                          ? const Shimmers2(
                                        width: 80,
                                        height: 95,
                                      )
                                          : profilePictureUrl.isNotEmpty && profilePictureUrl != null
                                          ? Image.network(
                                        '$baseUrlImage$profilePictureUrl',
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
                                          getProfileController.isLoading.value && getProfileController.cachedGetProfile.isEmpty
                                              ? const Shimmers2(
                                            width: 80,
                                            height: 20,
                                          )
                                              : LabelField(
                                            text: userName,
                                            fontSize: 16,
                                          ),
                                          getProfileController.isLoading.value && getProfileController.cachedGetProfile.isEmpty
                                              ? const Shimmers2(
                                            width: 100,
                                            height: 20,
                                          )
                                              : LabelField(
                                            text: activeTitle,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: AppColor.lightBrown,
                                          ),
                                          getProfileController.isLoading.value && getProfileController.cachedGetProfile.isEmpty
                                              ? const Shimmers2(
                                            width: 80,
                                            height: 20,
                                          )
                                              : Row(
                                            children: [
                                              LabelField(
                                                align: TextAlign.start,
                                                text: totalPoints != "0" ? totalPoints : "0",
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
                            getProfileController.isLoading.value && getProfileController.cachedGetProfile.isEmpty
                                ? const SizedBox()
                                : activeBadge == "None" ? const SizedBox()
                                : Positioned(
                              left: Get.width * 0.2,
                              bottom: 5,
                              // child: Container(
                              //   width: 34,
                              //   height: 34,
                              //   decoration: BoxDecoration(
                              //     color: AppColor.whiteColor,
                              //     shape: BoxShape.circle,
                              //     border: Border.all(
                              //       width: 1,
                              //       color: const Color(0xffFEE400),
                              //     ),
                              //   ),
                              //   child: Center(
                                  child: activeBadge.isNotEmpty
                                      ? Image.network(
                                    '$baseUrlImage$activeBadge',
                                    fit: BoxFit.contain,
                                    width: 25,
                                    height: 25,
                                    loadingBuilder: (BuildContext context, Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress ==
                                          null) {
                                        return child;
                                      } else {
                                        return SizedBox(
                                          width: 34,
                                          height: 34,
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
                                    width: 34,
                                    height: 34,
                                  ),
                                // ),
                              // ),
                            ),
                          ],
                        );
                      }),
                      SizedBox(
                        height: Get.height * 0.02,
                      ),
                      const LabelField(
                        text: 'select_active_title',
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // itemListForTitle.isEmpty ? "No active title found.." :
                      Obx(() {
                        return getProfileController.isLoading1.value
                            ? Shimmers2(
                          width: Get.width,
                          height: 60,
                        ) : CustomDropdown(
                          itemList: itemListForTitle,
                          hintText: itemListForTitle.isEmpty ? "no_active_title" : "select_title",
                          onChanged: (value) {
                            setState(() {
                              selectTitle = value;
                              selectTitleId = getProfileController.getTitles.firstWhere((c) => c['name'] == value)
                              ['titles_id'].toString();
                              debugPrint("selectTitle: $selectTitle, selectTitleId: $selectTitleId");
                              getProfileController.updateTitle(titleId: selectTitleId.toString());
                            });
                          },
                          initialValue: selectTitle,
                        );
                      }
                       ),
                      const SizedBox(
                        height: 18,
                      ),
                      const LabelField(
                        text: 'select_badge',
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Obx(() {
                        return getProfileController.isLoading1.value
                            ? Shimmers2(
                          width: Get.width,
                          height: 60,
                        ) : CustomDropdown(
                          itemList: itemListForBadge,
                          hintText: itemListForBadge.isEmpty ? "no_active_badge" : "select_badge",
                          onChanged: (value) {
                            setState(() {
                              selectBadge = value;
                              selectBadgeId = getProfileController.getBadges.firstWhere((c) => c['name'] == value)
                              ['badges_id'].toString();
                              debugPrint("selectBadge: $selectBadge, selectBadgeId: $selectBadgeId");
                              getProfileController.updateBadge(badgeId: selectBadgeId.toString());
                            });
                          },
                          initialValue: selectBadge,
                        );
                      }),
                      SizedBox(
                        height: Get.height * 0.02,
                      ),
                      Obx(() {
                        final quote = getProfileController.cachedGetProfile;
                        return getProfileController.isLoading.value && getProfileController.cachedGetProfile.isEmpty
                            ? const Shimmers2(
                          width: 1,
                          height: 1,
                        ) :  quote["quote"] != null ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const LabelField(
                              text: 'quote',
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            LabelField(
                                text: "${quote["quote"]}",
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                color: AppColor.blackColor,
                                interFont: true,
                              ),
                            SizedBox(
                                height: Get.height * 0.02,
                              ),
                          ],
                        ) : const SizedBox();
                      }),
                      const LabelField(
                        text: 'my_favorites',
                        fontSize: 18,
                      ),
                      SizedBox(
                        height: Get.height * 0.015,
                      ),
                      Obx(() {
                          if (getProfileController.isLoading.value && getProfileController.cachedFavorites.isEmpty) {
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
                          if (getProfileController.cachedFavorites.isEmpty) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 28.0),
                                child: LabelField(
                                  text: 'favorites_not_found',
                                ),
                              ),
                            );
                          }
                          return HomeSuggestions(
                            thingsto: getProfileController.cachedFavorites,
                            thingstoName: "Favorite",
                          );
                        },
                      ),
                      SizedBox(
                        height: Get.height * 0.02,
                      ),
                      const LabelField(
                        text: 'historyOfThings',
                        fontSize: 18,
                      ),
                      SizedBox(
                        height: Get.height * 0.015,
                      ),
                      Obx(() {
                          if (getProfileController.isLoading.value && getProfileController.cachedThings.isEmpty) {
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
                                  text: 'things_not_found',
                                ),
                              ),
                            );
                          }
                          return HomeSuggestions(
                            thingsto: getProfileController.cachedThings,
                            thingstoName: "Favorite",
                          );
                        },
                      ),
                      SizedBox(
                        height: Get.height * 0.02,
                      ),
                      const LabelField(
                        text: 'summaryOfStatsForEachCategory',
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
                                'summaryStatsOfCategoriesNotAvailable',
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
          ),
        ],
      ),
    );
  }
}
