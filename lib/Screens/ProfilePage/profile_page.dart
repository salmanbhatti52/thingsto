import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:thingsto/Resources/app_assets.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Screens/HomePages/home_suggestions.dart';
import 'package:thingsto/Screens/ProfilePage/SettingPage/setting_page.dart';
import 'package:thingsto/Screens/ProfilePage/summary_stats.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';
import 'package:thingsto/Widgets/app_bar.dart';
import 'package:thingsto/Widgets/custom_dropdown.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<String> itemListForTitle = ["Title1", "Title2", "Title3",];
  List<String> itemListForBadge = ["Badge1", "Badge2", "Badge3",];

  String? selectTitle;
  String? selectBadge;

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
            onClick: (){
              Get.to(
                    () => const SettingPage(),
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
                    Stack(
                      children: [
                        Container(
                          width: Get.width,
                          height:  Get.height * 0.135,
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
                            padding: const EdgeInsets.only(left: 15.0, top: 10, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    AppAssets.dummy2,
                                    fit: BoxFit.fill,
                                    width: 80,
                                    height: 95,
                                    // loadingBuilder: (BuildContext context, Widget child,
                                    //     ImageChunkEvent? loadingProgress) {
                                    //   if (loadingProgress == null) {
                                    //     return child;
                                    //   } else {
                                    //     return SizedBox(
                                    //       width: 80,
                                    //       height: 95,
                                    //       child: Center(
                                    //         child: CircularProgressIndicator(
                                    //           color: AppColor.primaryColor,
                                    //           value: loadingProgress.expectedTotalBytes !=
                                    //               null
                                    //               ? loadingProgress.cumulativeBytesLoaded /
                                    //               loadingProgress.expectedTotalBytes!
                                    //               : null,
                                    //         ),
                                    //       ),
                                    //     );
                                    //   }
                                    // },
                                  ),
                                ),
                                SizedBox(width: Get.width * 0.06,),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const LabelField(
                                        text: "Jessica Robert",
                                        fontSize: 16,
                                      ),
                                      const LabelField(
                                        text: "Sunday Traveler",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: AppColor.lightBrown,
                                      ),
                                      Row(
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
                          ),
                        ),
                        Positioned(
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
                    ),
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
                    const HomeSuggestions(pad: 0,),
                    SizedBox(
                      height: Get.height * 0.02,
                    ),
                    const LabelField(
                      text: 'Summary of stats for each category',
                      fontSize: 18,
                      align: TextAlign.left,
                    ),
                    const SummaryStats(),
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
