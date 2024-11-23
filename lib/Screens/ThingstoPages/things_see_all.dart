import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:thingsto/Controllers/thingsto_controller.dart';
import 'package:thingsto/Resources/app_assets.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Screens/ThingstoPages/Things/thingsto_validate.dart';
import 'package:thingsto/Screens/ThingstoPages/filter_dialog.dart';
import 'package:thingsto/Utills/apis_urls.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';
import 'package:thingsto/Widgets/TextFields.dart';
import 'package:thingsto/Widgets/app_bar.dart';
import 'package:thingsto/Widgets/large_Button.dart';

class ThingsSeeAll extends StatefulWidget {
  final List thingsto;
  const ThingsSeeAll({super.key, required this.thingsto,});

  @override
  State<ThingsSeeAll> createState() => _ThingsSeeAllState();
}

class _ThingsSeeAllState extends State<ThingsSeeAll> {

  final ThingstoController thingstoController = Get.put(ThingstoController());
  final TextEditingController searchController = TextEditingController();

  void filterThings(String query) {
    final filteredThings = widget.thingsto.where((thing) {
      final thingName = thing['name'].toString().toLowerCase();
      final input = query.toLowerCase();
      return thingName.contains(input);
    }).toList();
    thingstoController.hasRunFoundedThings.value = true;
    setState(() {
      thingstoController.findingThings.assignAll(filteredThings);
    });
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        thingstoController.hasRunFoundedThings.value = false;
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: AppColor.whiteColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              BackButtonBar(
                title: "thingsto",
                onBack: (){
                  Get.back();
                  thingstoController.hasRunFoundedThings.value = false;
                },
              ),
              SizedBox(
                height: Get.height * 0.02,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextFormField(
                      controller: searchController,
                      hintText: "search_for_a_thing",
                      // validator: validateEmail,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      suffixImage: AppAssets.filter,
                      showPrefix: true,
                      prefixColor: AppColor.labelTextColor,
                      onChanged: (value) {
                        filterThings(value);
                      },
                      suffixTap: () {
                        showDialog(
                          context: context,
                          barrierColor: Colors.grey.withOpacity(0.4),
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return const FilterDialog();
                          },
                        );
                      },
                    ),
                    SizedBox(
                      height: Get.height * 0.02,
                    ),
                    const LabelField(
                      text: "thingsto",
                      fontSize: 21,
                      color: AppColor.blackColor,
                      interFont: true,
                    ),
                    SizedBox(
                      height: Get.height * 0.71,
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1 / 1.3,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                        ),
                        itemCount: thingstoController.findingThings.isNotEmpty ? thingstoController.findingThings.length : widget.thingsto.length,
                        itemBuilder: (BuildContext context, int i) {
                          final things = thingstoController.findingThings.isNotEmpty ? thingstoController.findingThings[i] : widget.thingsto[i];
                          return Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: (){
                                    Get.to(
                                          () => ThingsValidate(thingsto: things, thingstoName: "seeAll",),
                                      duration: const Duration(milliseconds: 350),
                                      transition: Transition.rightToLeft,
                                    );
                                  },
                                  child: Container(
                                    width: Get.width * 0.45,
                                    height: Get.height * 0.26,
                                    decoration: BoxDecoration(
                                      color: AppColor.whiteColor,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        width: 1,
                                        color: AppColor.thingBorder,
                                      ),
                                    ),
                                    child:Column(
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
                                        // Padding(
                                        //   padding: const EdgeInsets.all(8.0),
                                        //   child: ClipRRect(
                                        //     borderRadius: BorderRadius.circular(5),
                                        //     child: Image.network(
                                        //       '$baseUrlImage${things['images'][0]['name']}',
                                        //       width: Get.width,
                                        //       height: Get.height * 0.13,
                                        //       fit: BoxFit.fill,
                                        //       errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                        //         return SvgPicture.asset(
                                        //           AppAssets.camera,
                                        //         );
                                        //       },
                                        //       loadingBuilder:
                                        //           (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                        //         if (loadingProgress == null) {
                                        //           return child;
                                        //         }
                                        //         return Center(
                                        //           child:
                                        //           CircularProgressIndicator(
                                        //             color: AppColor.primaryColor,
                                        //             value: loadingProgress.expectedTotalBytes != null
                                        //                 ? loadingProgress.cumulativeBytesLoaded /
                                        //                 loadingProgress.expectedTotalBytes!
                                        //                 : null,
                                        //           ),
                                        //         );
                                        //       },
                                        //     ),
                                        //   ),
                                        // ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(left: 20.0),
                                              child: LabelField(
                                                text: things['name'],
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15,
                                                color: AppColor.blackColor,
                                                interFont: true,
                                                maxLIne: 1,
                                              ),
                                            ),
                                            things['tags'] != null && things['tags'].isNotEmpty && things['tags'][0]["name"] != "" ||  things['location'] != null
                                                ? Container(
                                              width: Get.width,
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
                                                      ?  LargeButton(
                                                    text: things['tags'][0]['name'],
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 9,
                                                    width: 51,
                                                    height: 20,
                                                    radius: 5,
                                                    onTap: () {},
                                                  ) : const SizedBox(),
                                                ],
                                              ),
                                            )
                                                : SizedBox(height: Get.height * 0.05,),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
