import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thingsto/Resources/app_assets.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Screens/ThingstoPages/category_details.dart';
import 'package:thingsto/Screens/ThingstoPages/thingsto_container.dart';
import 'package:thingsto/Widgets/TextFields.dart';
import 'package:thingsto/Widgets/app_bar.dart';
import 'package:thingsto/Widgets/row_text.dart';
import 'category_container.dart';
import 'topthingsto_container.dart';

class ThingstoPage extends StatefulWidget {
  const ThingstoPage({super.key});

  @override
  State<ThingstoPage> createState() => _ThingstoPageState();
}

class _ThingstoPageState extends State<ThingstoPage> {
  bool isSelect = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Column(
        children: [
          isSelect
              ? BackButtonBar(
                  title: "Thingsto",
                  onBack: () {
                    setState(() {
                      isSelect = false;
                    });
                  },
                )
              : const HomeBar(
                  title: "Thingsto",
                  titleTrue: true,
                  icon2: AppAssets.notify,
                ),
          SizedBox(
            height: Get.height * 0.02,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              children: [
                CustomTextFormField(
                  controller: TextEditingController(),
                  hintText: "Search for a thing on a",
                  // validator: validateEmail,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  suffixImage: AppAssets.search,
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(
                    height: Get.height * 0.02,
                  ),
                  isSelect
                      ? const RowText(
                          text: "Museums",
                        )
                      : const RowText(
                          text: "Categories",
                        ),
                  isSelect
                      ? const CategoryDetails()
                      : CategoryContainer(
                          onSelect: () {
                            setState(() {
                              isSelect = true;
                            });
                          },
                        ),
                  SizedBox(
                    height: Get.height * 0.01,
                  ),
                  const RowText(
                    text: "Things to",
                  ),
                  SizedBox(
                    height: Get.height * 0.02,
                  ),
                  const ThingstoContainer(),
                  SizedBox(
                    height: Get.height * 0.03,
                  ),
                  const RowText(
                    text: "Top Things to",
                  ),
                  SizedBox(
                    height: Get.height * 0.02,
                  ),
                  const TopThingstoContainer(),
                  SizedBox(
                    height: Get.height * 0.02,
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
