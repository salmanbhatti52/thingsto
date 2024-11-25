import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thingsto/Resources/app_colors.dart';

class LargeButton extends StatelessWidget {
  final double width;
  final double radius;
  final double height;
  final Color containerColor;
  final String text;
  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;
  final TextAlign align;
  final Function onTap;
  final int maxLine;
  const LargeButton({
    super.key,
    this.width = 346,
    this.radius = 10,
    this.height = 52,
    this.containerColor = AppColor.primaryColor,
    required this.text,
    this.textColor = AppColor.whiteColor,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w600,
    this.align = TextAlign.center,
    this.maxLine = 1,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        width: width,
        height: height,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: containerColor,
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Text(
              maxLines: maxLine,
              overflow: TextOverflow.ellipsis,
              text.tr(),
              textAlign: align,
              style: GoogleFonts.poppins(
                fontSize: fontSize,
                fontWeight: fontWeight,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
