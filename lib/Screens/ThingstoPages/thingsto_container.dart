import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:thingsto/Resources/app_assets.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Screens/ThingstoPages/thingsto_details.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';
import 'package:thingsto/Widgets/large_Button.dart';

class ThingstoContainer extends StatelessWidget {
  const ThingstoContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 10),
      height: Get.height * 0.255,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const ScrollPhysics(),
        itemCount: 6,
        itemBuilder: (BuildContext context, i) {
          return Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: GestureDetector(
              onTap: (){
                Get.to(
                      () => const ThingstoDetails(),
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
                    const SizedBox(height: 10,),
                    SvgPicture.asset(
                      AppAssets.camera,
                    ),
                    Column(
                      children: [
                        const LabelField(
                          text: "La Masson du",
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: AppColor.blackColor,
                          interFont: true,
                        ),
                        Container(
                          width: Get.width * 0.37,
                          height: 67,
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
                              const LabelField(
                                text: "Environ à 2.8 km",
                                fontWeight: FontWeight.w500,
                                fontSize: 11,
                                color: AppColor.primaryColor,
                                interFont: true,
                              ),
                              const SizedBox(height: 3,),
                              LargeButton(
                                text: "Musées",
                                fontWeight: FontWeight.w500,
                                fontSize: 9,
                                width: 51,
                                height: 20,
                                radius: 5,
                                onTap: () {},
                              ),
                            ],
                          ),
                        ),
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
