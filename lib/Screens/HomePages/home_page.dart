import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:thingsto/Controllers/add_things_controller.dart';
import 'package:thingsto/Controllers/home_controller.dart';
import 'package:thingsto/Controllers/language_controller.dart';
import 'package:thingsto/Controllers/notifications_controller.dart';
import 'package:thingsto/Controllers/thingsto_controller.dart';
import 'package:thingsto/Controllers/translation_service.dart';
import 'package:thingsto/Resources/app_assets.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Screens/HomePages/find_things.dart';
import 'package:thingsto/Screens/HomePages/founded_things.dart';
import 'package:thingsto/Screens/HomePages/home_suggestions.dart';
import 'package:thingsto/Screens/NotificationPage/notification_page.dart';
import 'package:thingsto/Utills/const.dart';
import 'package:thingsto/Utills/global.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';
import 'package:thingsto/Widgets/app_bar.dart';
import 'package:thingsto/Widgets/large_Button.dart';
import 'package:thingsto/Widgets/shimmer_effect.dart';
import 'package:thingsto/Widgets/snackbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isDropDownShow = false;
  bool isFind = false;
  final ThingstoController thingstoController = Get.put(ThingstoController());
  AddThingsController addThingsController = Get.put(AddThingsController());
  final HomeController homeController = Get.put(HomeController());
  // final LanguageController languageController = Get.put(LanguageController());
  final NotificationsController notificationsController = Get.put(NotificationsController());

  getName(){
    surName = prefs.getString('surName');
    // systemLattitude = prefs.getString('system_lattitude');
    // systemLongitude = prefs.getString('system_longitude');
    if (surName != null && systemLattitude!= null && systemLongitude != null) {
      debugPrint("surname :: $surName");
      // debugPrint("systemLattitude :: $systemLattitude");
      // debugPrint("systemLongitude :: $systemLongitude");
    }
  }

  Future<void> getUserThings() async {
    notificationsController.getNotificationsAlert();
    if (thingstoController.isDataLoadedThingsto.value) {
      // Show cached data and then update in the background
      thingstoController.getThingsto(checkValue: "No");
    } else {
      // Load data from the server
      await thingstoController.getThingsto(checkValue: "No");
    }
  }

  @override
  void initState() {
    super.initState();
    addThingsController.getAllCategory(forceRefresh: true);
    homeController.getLocation();
    homeController.fetchThings();
    getName();
    getUserThings();
  }

  String? selectCategory;
  String? thingName;

  void handleFindThings(String categoryId) {
    debugPrint("Category ID: $categoryId");
    // thingName = thingNames.toString();
    selectCategory = categoryId.toString();
    if (selectCategory!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          isFind = true;
        });
        homeController.foundedThings(categoriesId: selectCategory!);
        // if (isFind) {
        //   homeController.foundedThings(
        //     categoriesId: selectCategory.toString(),
        //     // name: thingName.toString(),
        //   );
        // }
      });
    } else {
      CustomSnackbar.show(title: "error", message: "select_all_fields");
    }
    debugPrint("Thing Name: $thingName, isFind: $isFind, Category ID: $selectCategory");
  }

  void showNextThing() {
    homeController.showNextThing();
  }

  final TranslationService translationService = Get.put(TranslationService());

  Future<String> translateText(String text) async {
    return await translationService.translateText(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 15),
              decoration: const BoxDecoration(
                color: AppColor.whiteColor,
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 87, 178, 0.08),
                    blurRadius: 32,
                    offset: Offset(0, -4),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Obx(() => HomeBar(
                    icon1: AppAssets.logoName,
                    icon2: AppAssets.notify,
                    hasUnreadNotifications: notificationsController.hasUnreadNotifications.value,
                    onClick: () {
                      Get.to(
                            () => const NotificationsScreen(),
                        duration: const Duration(milliseconds: 350),
                        transition: Transition.upToDown,
                      );
                    },
                  )),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0,),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const LabelField(
                            text: "welcome",
                            fontSize: 18,
                          ),
                          FutureBuilder<String>(
                            future: translateText(surName!),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return LabelField(
                                  text: surName.toString(),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: AppColor.lightBrown,
                                );
                              } else if (snapshot.hasError) {
                                return LabelField(
                                  text: surName.toString(),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: AppColor.lightBrown,
                                );
                              } else {
                                return LabelField(
                                  text: snapshot.data ?? surName!,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: AppColor.lightBrown,
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                color: AppColor.primaryColor,
                backgroundColor: AppColor.borderColor,
                onRefresh: getUserThings,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(
                          left: 40.0,
                          right: 40.0,
                          top: 15.0,
                        ),
                        child: LabelField(
                          text: "dont_know",
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        height: Get.height * 0.025,
                      ),
                      LargeButton(
                        text: "find_me_a_thing",
                        onTap: () {
                          setState(() {
                            isDropDownShow = true;
                          });
                        },
                        width: Get.width * 0.46,
                        height: Get.height * 0.06,
                      ),
                      SizedBox(
                        height: Get.height * 0.022,
                      ),
                      isDropDownShow
                          ? FindThings(
                        onFind: (){},
                        onFindWithData: handleFindThings,
                      ) : const SizedBox(),
                      SizedBox(
                        height: Get.height * 0.022,
                      ),
                      isFind
                          ? Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: Obx(
                              () {
                            if (homeController.isLoading.value) {
                              return Shimmers(
                                width: Get.width,
                                height:  Get.height * 0.555,
                                width1: Get.width * 0.9,
                                height1: Get.height * 0.1,
                                length: 1,
                              );
                            }
                            // if (homeController.errorMsg.value == "error") {
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
                            if (homeController.findingThings.isEmpty) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 28.0),
                                  child: LabelField(
                                    text: "things_not_found",
                                    fontSize: 18,
                                  ),
                                ),
                              );
                            }
                            // return SizedBox(
                            //   height: Get.height * 0.5,
                            //   child: ListView.builder(
                            //     scrollDirection: Axis.vertical,
                            //     itemCount: 1,
                            //     itemBuilder: (BuildContext context, i) {
                            //       final findingThings = homeController.findingThings[0];
                            //       return FoundedThings(
                            //         foundedThings: findingThings,
                            //       );
                            //     },
                            //   ),
                            // );
                            final findingThing = homeController.findingThings[homeController.currentItemIndex.value];
                            return Column(
                              children: [
                                !homeController.isLastItemShown.value
                                    ? FoundedThings(
                                  foundedThings: findingThing,
                                ) : const Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 28.0),
                                    child: LabelField(
                                      text: "no_more_things_found",
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10,),
                                if (!homeController.isLastItemShown.value)
                                  LargeButton(
                                    text: "show_more_thing",
                                    onTap: showNextThing,
                                    width: Get.width * 0.46,
                                    height: Get.height * 0.05,
                                  ),
                              ],
                            );
                          },
                        ),
                      )
                          : const SizedBox(),
                      SizedBox(
                        height: Get.height * 0.3,
                        child: Obx(
                              () {
                            if (homeController.mapLoading.value ||
                                (homeController.center.value.latitude == 0 &&
                                    homeController.center.value.longitude == 0)) {
                              return Shimmers2(
                                width: Get.width,
                                height: Get.height * 0.3,
                              );
                            }
                            return GoogleMap(
                              onMapCreated: homeController.onMapCreated,
                              mapType: MapType.normal,
                              initialCameraPosition: CameraPosition(
                                target: homeController.center.value,
                                zoom: 11.0,
                              ),
                              markers: homeController.markers,
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: Get.height * 0.022,
                      ),
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.0),
                          child: LabelField(
                            text: "things_of_the_moment",
                            fontSize: 18,
                            align: TextAlign.left,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: Get.height * 0.022,
                      ),
                      Obx(() {
                        if (thingstoController.isLoading.value && thingstoController.cachedThingsto.isEmpty) {
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
                        if (thingstoController.cachedThingsto.isEmpty) {
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
                          thingsto: thingstoController.cachedThingsto,
                          thingstoName: "HomeSide",
                        );
                      },
                      ),
                      SizedBox(
                        height: Get.height * 0.022,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15,),
                        padding: const EdgeInsets.only(
                            left: 15.0,
                            top: 10.0
                        ),
                        height: Get.height * 0.125,
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
                        child: const LabelField(
                          text: "more_than_50000",
                          fontSize: 18,
                          align: TextAlign.left,
                        ),
                      ),
                      SizedBox(
                        height: Get.height * 0.022,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}