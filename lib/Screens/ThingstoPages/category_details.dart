import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:thingsto/Resources/app_assets.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';

class CategoryDetails extends StatelessWidget {
  const CategoryDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 10),
      height: Get.height * 0.19,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const ScrollPhysics(),
        itemCount: 6,
        itemBuilder: (BuildContext context, i) {
          return Padding(
            padding: const EdgeInsets.only(right: 10.0, top: 15),
            child: Column(
              children: [
                GestureDetector(
                  onTap: (){},
                  child: Container(
                    width: Get.width * 0.297,
                    height: Get.height * 0.11,
                    decoration: BoxDecoration(
                      color: AppColor.whiteColor,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        width: 1,
                        color: AppColor.thingBorder,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(178, 178, 178, 0.15),
                          blurRadius: 30,
                          offset: Offset(0, 5),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        AppAssets.camera,
                        width: 35,
                        height: 35,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                const LabelField(
                  text: "Chateaux\nDU 95",
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: AppColor.blackColor,
                  interFont: true,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
