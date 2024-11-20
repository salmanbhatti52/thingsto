import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';

class SettingContainer extends StatelessWidget {
  final String image;
  final String text;
  final String text1;
  final VoidCallback onBack;
  const SettingContainer(
      {super.key,
      required this.image,
      required this.text,
      required this.onBack,
      required this.text1,
      });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        onBack();
            },
      child: Container(
        height: 60,
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
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    image,
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LabelField(
                        text: text,
                        fontSize: 14,
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Container(
                        width: Get.width * 0.63,
                        child: LabelField(
                          text: text1,
                          maxLIne: 1,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppColor.lightBrown,
                          align: TextAlign.left,
                        ),
                      )
                    ],
                  ),
                ],
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColor.primaryColor,
                size: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
