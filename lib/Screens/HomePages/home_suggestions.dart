import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thingsto/Controllers/get_profile_controller.dart';
import 'package:thingsto/Controllers/thingsto_controller.dart';
import 'package:thingsto/Controllers/translation_service.dart';
import 'package:thingsto/Resources/app_assets.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Screens/ThingstoPages/Things/thingsto_validate.dart';
import 'package:thingsto/Utills/apis_urls.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';

class HomeSuggestions extends StatefulWidget {
  final double pad;
  final List thingsto;
  final String thingstoName;
  final String? id;
  const HomeSuggestions({
    super.key,
    this.pad = 15,
    required this.thingsto,
    required this.thingstoName,
    this.id
  });

  @override
  State<HomeSuggestions> createState() => _HomeSuggestionsState();
}

class _HomeSuggestionsState extends State<HomeSuggestions> {

  final ThingstoController thingstoController = Get.put(ThingstoController());
  final GetProfileController getProfileController = Get.put(GetProfileController());
  final TranslationService translationService = Get.put(TranslationService());
  late List thingsto;
  late List<bool> isLoading;

  @override
  void initState() {
    super.initState();
    thingsto = widget.thingsto;
    isLoading = List.filled(thingsto.length, false);
  }

  Future<String> translateText(String text) async {
    return await translationService.translateText(text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.21,
      padding: EdgeInsets.only(left: widget.pad),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const ScrollPhysics(),
        itemCount: thingsto.length,
        itemBuilder: (BuildContext context, i) {
          final things = thingsto[i];
          thingstoController.initializeLikes(thingsto[i]["likes"]);
          return GestureDetector(
            onTap: () {
              Get.to(
                () => ThingsValidate(
                  thingsto: things,
                  thingstoName: widget.thingstoName,
                ),
                duration: const Duration(milliseconds: 350),
                transition: Transition.rightToLeft,
              );
            },
            child: Container(
              width: Get.width * 0.37,
              margin: const EdgeInsets.symmetric(horizontal: 7),
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(6),
              // image: DecorationImage(
              //   image:  NetworkImage('$baseUrlImage${things['images'][0]['name']}'),
              //   fit: BoxFit.cover,
              // colorFilter: const ColorFilter.srgbToLinearGamma(),
              // ),
              // ),
              child: Stack(
                children: [
                  things['thumbnail'] !=null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.network(
                            width: Get.width * 0.37,
                            height: Get.height * 0.21,
                            '$baseUrlImage${things['thumbnail']}',
                            fit: BoxFit.cover,
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace? stackTrace) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 25.0),
                                  child: Image.network(
                                    AppAssets.dummyPic,
                                    width: Get.width * 0.37,
                                    height: Get.height * 0.21,
                                    fit: BoxFit.cover,
                                    ),
                                ),
                              );
                            },
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }
                              return SizedBox(
                                width: Get.width * 0.37,
                                height: Get.height * 0.21,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: AppColor.primaryColor,
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : Center(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 25.0),
                            child: SvgPicture.asset(
                              AppAssets.music,
                            ),
                          ),
                        ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () async {
                        if(widget.thingstoName == "HomeSide"){
                          setState(() {
                            isLoading[i] = true;
                          });
                        }
                        await thingstoController.likeUnlikeUser(
                          thingsto[i]["things_id"].toString(),
                        );
                        if(widget.thingstoName == "Favorite"){
                            setState(() {
                              thingsto.removeAt(i);
                            });
                        }
                        if(widget.thingstoName == "HomeSide"){
                          if (thingstoController.isDataLoadedThingsto.value) {
                            await thingstoController.getThingsto(checkValue: "No");
                          } else {
                            await thingstoController.getThingsto(checkValue: "No");
                          }
                        } else if(widget.thingstoName == "Favorite") {
                          if (getProfileController.isDataLoadedFavorites.value) {
                            await getProfileController.getFavoritesThings();
                          } else {
                            await getProfileController.getFavoritesThings();
                          }
                          final prefs = await SharedPreferences.getInstance();
                          String? userID = prefs.getString('users_customers_id');
                          if (getProfileController.isDataLoadedThings.value) {
                            await getProfileController.getThings(usersCustomersId: userID.toString());
                          } else {
                            await getProfileController.getThings(usersCustomersId: userID.toString());
                          }
                        } else {
                          if (getProfileController.isDataLoadedThings.value) {
                            await getProfileController.getThings(usersCustomersId: widget.id.toString());
                          } else {
                            await getProfileController.getThings(usersCustomersId: widget.id.toString());
                          }
                        }
                        setState(() {
                          isLoading[i] = false;
                        });
                      },
                      child: isLoading[i]
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: AppColor.primaryColor, strokeWidth: 2,))
                          : thingstoController.isLiked.value
                          ? const Icon(Icons.favorite, size: 25, color: Colors.redAccent)
                          : SvgPicture.asset(
                        AppAssets.heart,
                        width: 23,
                        color: AppColor.hintColor,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: Get.height * 0.082,
                          child: ClipRect(
                            child: BackdropFilter(
                              filter:
                                  ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                              child: Container(
                                width: Get.width * 0.37,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 7,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FutureBuilder<String>(
                                      future: translateText(things['name']),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                          return LabelField(
                                            text: things['name'],
                                            fontSize: 12,
                                            maxLIne: 1,
                                            color: AppColor.whiteColor,
                                          );
                                        } else if (snapshot.hasError) {
                                          return LabelField(
                                            text: things['name'],
                                            fontSize: 12,
                                            maxLIne: 1,
                                            color: AppColor.whiteColor,
                                          );
                                        } else {
                                          return LabelField(
                                            text: snapshot.data ?? things['name'],
                                            fontSize: 12,
                                            maxLIne: 1,
                                            color: AppColor.whiteColor,
                                          );
                                        }
                                      },
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    things["location"] != null && things["location"] != ""
                                    ? Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SvgPicture.asset(
                                          AppAssets.location,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        SizedBox(
                                          width: Get.width * 0.25,
                                          child: LabelField(
                                            align: TextAlign.start,
                                            text: things['location'] ?? "",
                                            fontSize: 10,
                                            fontWeight: FontWeight.w400,
                                            color: AppColor.secondaryColor,
                                            maxLIne: 2,
                                          ),
                                        ),
                                      ],
                                    ) : const SizedBox(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
