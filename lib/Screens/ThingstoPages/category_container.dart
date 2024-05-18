import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:thingsto/Resources/app_assets.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';

class CategoryContainer extends StatefulWidget {
  final VoidCallback? onSelect;
  const CategoryContainer({super.key, this.onSelect});

  @override
  State<CategoryContainer> createState() => _CategoryContainerState();
}

class _CategoryContainerState extends State<CategoryContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 10),
      height: Get.height * 0.15,
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
                  onTap: (){
                    if (widget.onSelect != null) {
                      widget.onSelect!();
                    }
                  },
                  child: Container(
                    width: Get.width * 0.18,
                    height: Get.height * 0.08,
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
                        AppAssets.museums,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                const LabelField(
                  text: "Museums",
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
