import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:thingsto/Controllers/home_controller.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';
import 'package:thingsto/Widgets/TextFields.dart';
import 'package:thingsto/Widgets/large_Button.dart';
import 'package:thingsto/Widgets/snackbar.dart';

class FindThings extends StatefulWidget {
  final VoidCallback? onFind;
  final Function(String categoryId)? onFindWithData;
  const FindThings({super.key, this.onFind, this.onFindWithData});

  @override
  State<FindThings> createState() => _FindThingsState();
}

class _FindThingsState extends State<FindThings> {
  final HomeController homeController = Get.put(HomeController());
  final TextEditingController controller = TextEditingController();
  String? selectCity;
  String? selectCityId;
  final formKey = GlobalKey<FormState>();
  bool isFind = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Get.width * 0.05,
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const LabelField(
                    text: 'looking_around',
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  CustomTextFormField(
                    controller: controller,
                    hintText: "search_city",
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.done,
                    showSuffix: false,
                    onChanged: (value) {
                      setState(() {
                        selectCityId = null;
                        homeController.getAllCities(city: controller.text.toString());
                        homeController.filteredCities.value = homeController.allCities
                            .where((city) =>
                            city['name'].toLowerCase().contains(value.toLowerCase()))
                            .toList();
                      });
                    },
                  ),
                  if (controller.text.isEmpty) const SizedBox(height: 18),
                  if (selectCityId != null) const SizedBox(height: 18),
                  Obx(() {
                    if(homeController.isLoading.value && controller.text.isNotEmpty) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: Get.height * 0.04),
                          child: SpinKitThreeBounce(
                            itemBuilder: (
                                BuildContext context,
                                int i,
                                ) {
                              return DecoratedBox(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: AppColor.primaryColor,
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    } else if(controller.text.isNotEmpty && selectCityId == null) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(() {
                            return homeController.filteredCities.isEmpty
                                ? const SizedBox() // If no items, don't show anything
                                : Container(
                              constraints: const BoxConstraints(
                                maxHeight: 300, // Optional: Prevent excessive height
                              ),
                              child: ListView.builder(
                                shrinkWrap: true, // Adjust height dynamically
                                // physics: const NeverScrollableScrollPhysics(), // Prevent internal scrolling
                                itemCount: homeController.filteredCities.length,
                                itemBuilder: (context, index) {
                                  var city = homeController.filteredCities[index];
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        homeController.isLastItemShown.value = false;
                                        homeController.findingThings.clear();
                                        selectCity = city['name'];
                                        selectCityId = city['cities_id'].toString();
                                        controller.text = city['name'];
                                        FocusManager.instance.primaryFocus?.unfocus();
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                                      child: LabelField(
                                        text: city['name'],
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                        align: TextAlign.left,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }),
                        ],
                      );
                    } else {
                      return const SizedBox();
                    }
                  }),
                ],
              ),
          ),
        ),
        if (!homeController.isLastItemShown.value)
          selectCityId != null
            ? LargeButton(
          text: "find_it",
          onTap: () {
            if (formKey.currentState!.validate()) {
              if (selectCityId != null && selectCityId!.isNotEmpty) {
                setState(() {
                  isFind = !isFind;
                });
                if (widget.onFindWithData != null && widget.onFind != null) {
                  widget.onFind!();
                  widget.onFindWithData!(selectCityId!);
                  if (isFind) {
                    // controller.clear();
                    // selectCityId = null;
                    // selectCity = null;
                  }
                }
              } else {
                CustomSnackbar.show(title: "error", message: "select_all_fields");
              }
            }
          },
          width: Get.width * 0.27,
          height: Get.height * 0.05,
        )
            : const SizedBox(),
      ],
    );
  }
}

