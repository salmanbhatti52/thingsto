import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:thingsto/Controllers/home_controller.dart';
import 'package:thingsto/Controllers/language_controller.dart';
import 'package:thingsto/Controllers/thingsto_controller.dart';
import 'package:thingsto/Resources/app_assets.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Screens/HomePages/find_things.dart';
import 'package:thingsto/Screens/HomePages/founded_things.dart';
import 'package:thingsto/Screens/HomePages/home_suggestions.dart';
import 'package:thingsto/Utills/const.dart';
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
  late GoogleMapController mapController;
  late LatLng _center;
  late LatLng _currentLocation;
  final ThingstoController thingstoController = Get.put(ThingstoController());
  final HomeController homeController = Get.put(HomeController());
  final LanguageController languageController = Get.put(LanguageController());

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  getName()  {
    surName = prefs.getString('surName');
    systemLattitude = prefs.getString('system_lattitude');
    systemLongitude = prefs.getString('system_longitude');
    if (surName != null && systemLattitude!= null && systemLongitude != null) {
      debugPrint("surname :: $surName");
      debugPrint("systemLattitude :: $systemLattitude");
      debugPrint("systemLongitude :: $systemLongitude");
    }
  }

  Future<void> getUserThings() async {
    userID = (prefs.getString('users_customers_id').toString());
    debugPrint("userID $userID");
    getName();

    if (thingstoController.isDataLoadedThingsto.value) {
      // Show cached data and then update in the background
      thingstoController.getThingsto(usersCustomersId: userID.toString());
    } else {
      // Load data from the server
      await thingstoController.getThingsto(usersCustomersId: userID.toString());
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserThings();
  }

  String? selectCategory;
  String? thingName;

  void handleFindThings(String thingNames, String categoryId) {
    debugPrint("Thing Name: $thingNames, Category ID: $categoryId");
    thingName = thingNames.toString();
    selectCategory = categoryId.toString();
    if (thingName!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          isFind = !isFind;
        });
        if (isFind) {
          homeController.foundedThings(
            categoriesId: selectCategory.toString(),
            name: thingName.toString(),
          );
        }
      });
    } else {
      CustomSnackbar.show(title: "Error", message: "Please select all fields");
    }
    debugPrint("Thing Name: $thingName, isFind: $isFind, Category ID: $selectCategory");
  }

  @override
  Widget build(BuildContext context) {
    double latitude = double.parse(systemLattitude.toString());
    double longitude = double.parse(systemLongitude.toString());
    _center = LatLng(latitude, longitude);
    _currentLocation = LatLng(latitude, longitude);
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Column(
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
                const HomeBar(
                  icon1: AppAssets.logoName,
                  icon2: AppAssets.notify,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0,),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const LabelField(
                          text: "Welcome",
                          fontSize: 18,
                        ),
                        LabelField(
                          text: surName.toString(),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColor.lightBrown,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 40.0,
                      right: 40.0,
                      top: 15.0,
                    ),
                    child: Obx(() => LabelField(
                      text: languageController.phrases['home_you_dont_know_what_to_do_around_you?_let_us_find_you_something_with_your_criteria_;)'] ??
                          "You don’t know what to do around you? Let us find you something with your criteria ;)",
                      fontSize: 18,
                    ),),
                  ),
                  SizedBox(
                    height: Get.height * 0.025,
                  ),
                  LargeButton(
                      text: "FIND ME A THING",
                      onTap: () {
                        setState(() {
                          isDropDownShow = true;
                        });
                      },
                      width: Get.width * 0.46,
                      height: Get.height * 0.05,
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
                                    text: "Things not found",
                                    fontSize: 18,
                                  ),
                                ),
                              );
                            }
                            return SizedBox(
                              height: Get.height * 1.07,
                              child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: homeController.findingThings.length,
                                itemBuilder: (BuildContext context, i) {
                                  final findingThings = homeController.findingThings[i];
                                  return FoundedThings(
                                    foundedThings: findingThings,
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      )
                  : const SizedBox(),
                  SizedBox(
                    height: Get.height * 0.3,
                    child: GoogleMap(
                      onMapCreated: _onMapCreated,
                      mapType: MapType.normal,

                      initialCameraPosition: CameraPosition(
                        target: _center,
                        zoom: 11.0,
                      ),
                      markers: {
                        Marker(
                          markerId: const MarkerId("Location"),
                          position: _currentLocation,
                        ),
                      },
                    ),
                  ),
                  SizedBox(
                    height: Get.height * 0.022,
                  ),
                  Obx(
                        () {
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
                              text: 'Things not found',
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
                      text: "We are now more than 50,000. Don’t hesitate to send your suggestions everyone.",
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
        ],
      ),
    );
  }
}