import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:thingsto/Controllers/translation_service.dart';
import 'package:thingsto/Resources/app_assets.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Screens/ThingstoPages/Things/thingsto_validate.dart';
import 'package:thingsto/Utills/apis_urls.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';

class ThingsSearch extends StatelessWidget {
  final List memberList;
  final String? query;
   ThingsSearch({super.key, required this.memberList, this.query});

  final TranslationService translationService = Get.put(TranslationService());

  Future<String> translateText(String text) async {
    return await translationService.translateText(text);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height * 0.65,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        // padding: const EdgeInsets.only(bottom: 20),
        physics: const ScrollPhysics(),
        itemCount: memberList.length,
        itemBuilder: (BuildContext context, i) {
          final members = memberList[i];
          return GestureDetector(
            onTap: (){
              Get.to(
                    () => ThingsValidate(thingsto: members, thingstoName: "things", query: query,),
                duration: const Duration(milliseconds: 350),
                transition: Transition.rightToLeft,
              );
            },
            child: Container(
              width: Get.width,
              height: Get.height * 0.135,
              margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
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
                    left: 15.0, top: 10, bottom: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    members['thumbnail'] != null
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        '$baseUrlImage${members["thumbnail"]}',
                        fit: BoxFit.fill,
                        width: 80,
                        height: 95,
                        loadingBuilder: (BuildContext context,
                            Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return SizedBox(
                              width: 80,
                              height: 95,
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
                        width: 80,
                        height: 95,
                        loadingBuilder: (BuildContext context,
                            Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return SizedBox(
                              width: 80,
                              height: 95,
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
                    SizedBox(
                      width: Get.width * 0.06,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FutureBuilder<String>(
                            future: translateText("${members['name']}".length > 20
                                ? "${"${members['name']}".substring(0, 20)}..."
                                : "${members['name']}"),
                            builder: (context, snapshot) {
                              String name = snapshot.data ?? members['name'];
                              String displayName = name.length > 20 ? "${name.substring(0, 20)}..." : name;
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return LabelField(
                                  text: "${members['name']}".length > 20
                                      ? "${"${members['name']}".substring(0, 20)}..."
                                      : "${members['name']}",
                                  fontSize: 16,
                                );
                              } else if (snapshot.hasError) {
                                return LabelField(
                                  text: "${members['name']}".length > 20
                                      ? "${"${members['name']}".substring(0, 20)}..."
                                      : "${members['name']}",
                                  fontSize: 16,
                                );
                              } else {
                                return LabelField(
                              text: displayName,
                              fontSize: 16,
                                );
                              }
                            },
                          ),
                          SizedBox(
                            width: Get.width * 0.55,
                            child: LabelField(
                              text: members['location'] != null ? "${members['location']}" : "noLocations",
                              fontSize: 14,
                              maxLIne: 1,
                              fontWeight: FontWeight.w400,
                              align: TextAlign.left,
                              color: AppColor.lightBrown,
                            ),
                          ),
                          Row(
                            children: [
                              LabelField(
                                align: TextAlign.start,
                                text: "${members['earn_points']}",
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
