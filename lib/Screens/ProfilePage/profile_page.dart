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
  List<String> itemListForTitle = [
    "Title1",
    "Title2",
    "Title3",
  ];
  List<String> itemListForBadge = [
    "Badge1",
    "Badge2",
    "Badge3",
  ];

  String? selectTitle;
  String? selectBadge;

  final GetProfileController getProfileController = Get.put(GetProfileController());

  @override
  void initState() {
    super.initState();
    getUserProfile();
  }

  Future<void> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    String? userID = prefs.getString('users_customers_id');
    if (userID != null) {
      getProfileController.getUserProfile(usersCustomersId: userID).then((_){
        getProfileController.getFavoritesThings();
        getProfileController.getCategoriesStats();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Column(
        children: [
          HomeBar(
            title: "Profile",
            titleTrue: true,
            icon2: AppAssets.setting,
            onClick: () {
              Get.to(
                () => SettingPage(getProfile: getProfileController.getProfile,),
                duration: const Duration(milliseconds: 350),
                transition: Transition.upToDown,
              );
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
                    Obx(() {
                      final profile = getProfileController.getProfile;
                      final profilePictureUrl = profile['profile_picture'] ?? '';
                      final userName = "${profile['first_name']} ${profile['last_name']}";
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
                            child: getProfileController.isLoading.value || getProfileController.getProfile.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, top: 10, bottom: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: getProfileController.isLoading.value
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
                                              getProfileController.isLoading.value
                                                  ? const Shimmers2(
                                                      width: 80,
                                                      height: 20,
                                                    )
                                                  : LabelField(
                                                      text: userName,
                                                      fontSize: 16,
                                                    ),
                                              getProfileController.isLoading.value
                                                  ? const Shimmers2(
                                                      width: 100,
                                                      height: 20,
                                                    )
                                                  : const LabelField(
                                                      text: "Sunday Traveler",
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w400,
                                                      color: AppColor.lightBrown,
                                                    ),
                                              getProfileController.isLoading.value
                                                  ? const Shimmers2(
                                                      width: 80,
                                                      height: 20,
                                                    )
                                                  : Row(
                                                      children: [
                                                        const LabelField(
                                                          align: TextAlign.start,
                                                          text: "240",
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
                                  )
                                : const Center(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: 40.0),
                                      child: LabelField(
                                        text: "Something Wrong",
                                        fontSize: 21,
                                        color: AppColor.blackColor,
                                        interFont: true,
                                      ),
                                    ),
                                  ),
                          ),
                          getProfileController.isLoading.value || getProfileController.getProfile.isEmpty
                              ? const SizedBox()
                              : Positioned(
                                  left: Get.width * 0.2,
                                  bottom: 5,
                                  child: Container(
                                    width: 34,
                                    height: 34,
                                    decoration: BoxDecoration(
                                      color: AppColor.whiteColor,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        width: 1,
                                        color: const Color(0xffFEE400),
                                      ),
                                    ),
                                    child: Center(
                                      child: SvgPicture.asset(AppAssets.cup),
                                    ),
                                  ),
                                ),
                        ],
                      );
                    }),
                    SizedBox(
                      height: Get.height * 0.02,
                    ),
                    const LabelField(
                      text: 'Select Active Title',
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomDropdown(
                      itemList: itemListForTitle,
                      hintText: "Select Title",
                      onChanged: (value) {
                        selectTitle = value;
                        debugPrint("selectTitle: $selectTitle");
                      },
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    const LabelField(
                      text: 'Select Badge',
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomDropdown(
                      itemList: itemListForBadge,
                      hintText: "Select Badge",
                      onChanged: (value) {
                        selectBadge = value;
                        debugPrint("SelectBadge: $selectBadge");
                      },
                    ),
                    SizedBox(
                      height: Get.height * 0.03,
                    ),
                    const LabelField(
                      text: 'My favorites',
                      fontSize: 18,
                    ),
                    SizedBox(
                      height: Get.height * 0.015,
                    ),
                    Obx(
                          () {
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
                        if (getProfileController.favorites.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 28.0),
                              child: LabelField(
                                text: 'Favorites Things not found',
                              ),
                            ),
                          );
                        }
                        return HomeSuggestions(
                          thingsto: getProfileController.favorites,
                          thingstoName: "Favorite",
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
                        if (    getProfileController.isLoading.value) {
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
                        if (getProfileController.categoriesStats.isEmpty) {
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
                          stats: getProfileController.categoriesStats,
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
