import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thingsto/Resources/app_assets.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Screens/HomePages/find_things.dart';
import 'package:thingsto/Screens/HomePages/founded_things.dart';
import 'package:thingsto/Screens/HomePages/home_suggestions.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';
import 'package:thingsto/Widgets/app_bar.dart';
import 'package:thingsto/Widgets/large_Button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isDropDownShow = false;
  bool isFind = false;

  @override
  Widget build(BuildContext context) {
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
            child: const Column(
              children: [
                HomeBar(
                  icon1: AppAssets.logoName,
                  icon2: AppAssets.notify,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 35.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LabelField(
                          text: "Welcome",
                          fontSize: 18,
                        ),
                        LabelField(
                          text: "John",
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
          SizedBox(
            width: Get.width,
            height: Get.height * 0.72,
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
                      text:
                          "You don’t know what to do around you? Let us find you something with your criteria ;)",
                      fontSize: 18,
                    ),
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
                    onFind: (){
                      setState(() {
                        isFind = true;
                      });
                    },
                  ) : const SizedBox(),
                  SizedBox(
                    height: Get.height * 0.022,
                  ),
                  isFind
                      ? const Padding(
                        padding: EdgeInsets.only(bottom: 15.0),
                        child: FoundedThings(),
                      )
                  : const SizedBox(),
                  Image.asset(
                    AppAssets.map,
                  ),
                  SizedBox(
                    height: Get.height * 0.022,
                  ),
                  const HomeSuggestions(),
                  const Padding(
                    padding: EdgeInsets.only(
                      left: 30.0,
                      right: 10.0,
                      top: 25.0,
                    ),
                    child: LabelField(
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