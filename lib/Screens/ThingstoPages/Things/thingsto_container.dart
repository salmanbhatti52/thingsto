import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:thingsto/Controllers/translation_service.dart';
import 'package:thingsto/Resources/app_assets.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Screens/ThingstoPages/Things/thingsto_validate.dart';
import 'package:thingsto/Utills/apis_urls.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';
import 'package:thingsto/Widgets/large_Button.dart';

class ThingstoContainer extends StatelessWidget {
  final List thingsto;
  ThingstoContainer({super.key, required this.thingsto,});

  final TranslationService translationService = Get.put(TranslationService());

  Future<String> translateText(String text) async {
    return await translationService.translateText(text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 10),
      height: Get.height * 0.255,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const ScrollPhysics(),
        itemCount: thingsto.length,
        itemBuilder: (BuildContext context, i) {
          final things = thingsto[i];
          return Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: GestureDetector(
              onTap: (){
                Get.to(
                      () => ThingsValidate(thingsto: things, thingstoName: "things",),
                  duration: const Duration(milliseconds: 350),
                  transition: Transition.rightToLeft,
                );
              },
              child: Container(
                width: Get.width * 0.37,
                height: Get.height * 0.255,
                decoration: BoxDecoration(
                  color: AppColor.whiteColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    width: 1,
                    color: AppColor.thingBorder,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // const SizedBox(height: 10,),
                    // SvgPicture.asset(
                    //   AppAssets.camera,
                    // ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: things['thumbnail'] !=null
                            ? Image.network(
                              '$baseUrlImage${things['thumbnail']}',
                              width: Get.width,
                              height: Get.height * 0.13,
                              fit: BoxFit.fill,
                              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                return Image.network(
                                  AppAssets.dummyPic,
                                  width: Get.width,
                                  height: Get.height * 0.13,
                                  fit: BoxFit.fill,
                                );
                              },
                              loadingBuilder:
                                  (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                }
                                return Center(
                                  child:
                                  CircularProgressIndicator(
                                    color: AppColor.primaryColor,
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                            )
                            : Column(
                          children: [
                            SizedBox(height: Get.height * 0.05,),
                            SvgPicture.asset(
                              AppAssets.music,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FutureBuilder<String>(
                          future: translateText(things['name']),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return LabelField(
                                text: things['name'],
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                color: AppColor.blackColor,
                                interFont: true,
                                maxLIne: 1,
                              );
                            } else if (snapshot.hasError) {
                              return LabelField(
                                text: things['name'],
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                color: AppColor.blackColor,
                                interFont: true,
                                maxLIne: 1,
                              );
                            } else {
                              return LabelField(
                                text: snapshot.data ?? things['name'],
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                color: AppColor.blackColor,
                                interFont: true,
                                maxLIne: 1,
                              );
                            }
                          },
                        ),
                        things['tags'] != null && things['tags'].isNotEmpty && things['tags'][0]["name"] != "" || things['location'] != null ? Container(
                          width: Get.width * 0.37,
                          height: 55,
                          padding: const EdgeInsets.only(left: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color.fromRGBO(255, 255, 255, 1),
                                Color.fromRGBO(253, 119, 34, 0.31),
                              ],
                            ),
                          ),
                          child:  Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              LabelField(
                                text: things['location'] ?? "",
                                fontWeight: FontWeight.w500,
                                fontSize: 11,
                                color: AppColor.primaryColor,
                                interFont: true,
                                maxLIne: things['tags'] != null && things['tags'].isNotEmpty ? 1 : 2,
                                align: TextAlign.left,
                              ),
                              const SizedBox(height: 3,),
                              things['tags'] != null &&
                                  things['tags'].isNotEmpty
                                  ? LargeButton(
                                text: things['tags'][0]['name'],
                                fontWeight: FontWeight.w500,
                                fontSize: 9,
                                width: 51,
                                height: 20,
                                radius: 5,
                                onTap: () {},
                              )
                                  : const SizedBox(),
                            ],
                          ),
                        ) : SizedBox(height: Get.height * 0.05,),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
