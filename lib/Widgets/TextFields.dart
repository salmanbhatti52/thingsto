import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thingsto/Resources/app_assets.dart';
import 'package:thingsto/Resources/app_colors.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String suffixImage;
  final bool showSuffix;
  final Color? suffixColor;
  final double? width;
  final double? height;
  final bool obscureText;
  final String prefixImage;
  final bool showPrefix;
  final Color? prefixColor;
  final dynamic Function()? prefixTap;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;
  final dynamic Function()? suffixTap;
  final Function(String)? onChanged;
  const CustomTextFormField({
    super.key,
    required this.controller,
    this.suffixImage = AppAssets.eyeOpen,
    this.prefixImage = AppAssets.search,
    required this.hintText,
    this.obscureText = false,
    this.suffixColor,
    this.prefixColor,
    this.height,
    this.width,
    this.validator,
    this.suffixTap,
    this.prefixTap,
    this.onChanged,
    this.showSuffix = true,
    this.showPrefix = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextFormField(
        style:  GoogleFonts.poppins(
        fontSize: 14,
        color: AppColor.hintColor,
        fontWeight: FontWeight.w400,
      ),
        obscureText: obscureText,
        textAlign: TextAlign.left,
        validator: validator,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        onChanged: onChanged ?? (val) {},
        cursorColor: AppColor.hintColor,
        controller: controller,
        decoration: InputDecoration(
          fillColor: AppColor.secondaryColor,
          filled: true,
          contentPadding:  EdgeInsets.symmetric(horizontal: Get.width * 0.05, vertical: 10),
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(
            fontSize: 14,
            color: AppColor.hintColor,
            fontWeight: FontWeight.w400,
          ),
          suffixIcon: showSuffix ? IconButton(
              onPressed: suffixTap,
              icon: SvgPicture.asset(
                suffixImage,
                color: suffixColor,
              ),
          ) : null,
          prefixIcon: showPrefix ? IconButton(
              onPressed: prefixTap,
              icon: Icon(Icons.search, color: prefixColor, size: 25,),
          ) : null,
          enabledBorder:  OutlineInputBorder(
            borderSide: const BorderSide(width: 1, color: AppColor.borderColor),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder:  OutlineInputBorder(
            borderSide: const BorderSide(width: 1, color: AppColor.borderColor),
            borderRadius: BorderRadius.circular(10),
          ),
          errorStyle: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.red,
            fontWeight: FontWeight.w400,
          ),
          errorBorder:  OutlineInputBorder(
            borderSide: const BorderSide(width: 1, color: Colors.red),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedErrorBorder:  OutlineInputBorder(
            borderSide: const BorderSide(width: 1, color: AppColor.borderColor),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}