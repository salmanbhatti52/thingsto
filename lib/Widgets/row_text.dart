import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';

class RowText extends StatelessWidget {
  final String text;
  final Function onTap;
  bool seeTrue = true;
  RowText({super.key, required this.text, required this.onTap, required this.seeTrue});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          LabelField(
            text: text,
            fontSize: 21,
            color: AppColor.blackColor,
            interFont: true,
          ),
          GestureDetector(
            onTap: () {
              onTap();
            },
            child: seeTrue ? const LabelField(
              text: "seeAll",
              fontWeight: FontWeight.w500,
              fontSize: 15,
              color: AppColor.primaryColor,
              interFont: true,
            ) : const SizedBox(),
          ),
        ],
      ),
    );
  }
}
