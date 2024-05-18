import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thingsto/Resources/app_colors.dart';

class LabelField extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;
  final TextAlign align;
  final int maxLIne;
  final bool interFont;
  const LabelField({
    super.key,
    required this.text,
    this.maxLIne = 3,
    this.color = AppColor.labelTextColor,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w600,
    this.align = TextAlign.center,
    this.interFont = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLIne,
      style: interFont ? GoogleFonts.inter(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ) : GoogleFonts.poppins(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
      textAlign: align,
    );
  }
}
