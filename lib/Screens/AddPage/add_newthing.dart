import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thingsto/Resources/app_assets.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';
import 'package:thingsto/Widgets/TextFields.dart';
import 'package:thingsto/Widgets/app_bar.dart';
import 'package:thingsto/Widgets/custom_dropdown.dart';
import 'package:thingsto/Widgets/large_Button.dart';

class AddNewThings extends StatefulWidget {
  const AddNewThings({super.key});

  @override
  State<AddNewThings> createState() => _AddNewThingsState();
}

class _AddNewThingsState extends State<AddNewThings>
    with SingleTickerProviderStateMixin {
  List<String> itemListForCategory = [
    "Category1",
    "Category2",
    "Category3",
  ];

  List<String> itemListForSubCategory = [
    "SubCategory1",
    "SubCategory2",
    "SubCategory3",
  ];

  String? selectCategory;
  String? selectSubCategory;

  final thingNameController = TextEditingController();
  final pointsController = TextEditingController();
  final locationController = TextEditingController();
  final descController = TextEditingController();
  final linkController = TextEditingController();

  bool _isChecked = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  void _toggleCheckbox() {
    setState(() {
      _isChecked = !_isChecked;
      if (_isChecked) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Column(
        children: [
          BackButtonBar(
            title: "Add New Thing",
            bottomPad: 15,
            onBack: () {
              Get.back();
            },
          ),
          SizedBox(
            height: Get.height * 0.02,
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Get.width * 0.08,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const LabelField(
                      text: 'Category',
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    CustomDropdown(
                      itemList: itemListForCategory,
                      hintText: "Select Category",
                      onChanged: (value) {
                        selectCategory = value;
                        debugPrint("selectCategory: $selectCategory");
                      },
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    const LabelField(
                      text: 'Subcategory',
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    CustomDropdown(
                      itemList: itemListForSubCategory,
                      hintText: "Select Subcategory",
                      onChanged: (value) {
                        selectSubCategory = value;
                        debugPrint("selectSubCategory: $selectSubCategory");
                      },
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    const LabelField(
                      text: 'Thing Name',
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    CustomTextFormField(
                      controller: thingNameController,
                      hintText: "Thing Name here",
                      // validator: validateEmail,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      showSuffix: false,
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    const LabelField(
                      text: 'No. of points the thing should earn',
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    CustomTextFormField(
                      controller: pointsController,
                      hintText: "Points here",
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      showSuffix: false,
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    const LabelField(
                      text: 'Location',
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    CustomTextFormField(
                      controller: locationController,
                      hintText: "Location here",
                      suffixImage: AppAssets.location,
                      suffixColor: AppColor.blackColor,
                      suffixTap: () {},
                      obscureText: false,
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    const LabelField(
                      text: 'Description of the thing',
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColor.secondaryColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColor.borderColor,
                          width: 1.0,
                        ),
                      ),
                      height: Get.height * 0.11,
                      child: TextField(
                        maxLines: null,
                        controller: descController,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: AppColor.hintColor,
                          fontWeight: FontWeight.w400,
                        ),
                        keyboardType: TextInputType.text,
                        cursorColor: AppColor.hintColor,
                        decoration: InputDecoration(
                          fillColor: AppColor.secondaryColor,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: const EdgeInsets.only(
                            top: 0.0,
                            left: 12,
                          ),
                          hintText: "Write here.....",
                          hintStyle: GoogleFonts.poppins(
                            fontSize: 14,
                            color: AppColor.hintColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    DottedBorder(
                      color: AppColor.primaryColor,
                      strokeWidth: 1,
                      radius: const Radius.circular(10),
                      borderType: BorderType.RRect,
                      child: Container(
                        width: Get.width,
                        height: Get.height * 0.163,
                        color: AppColor.secondaryColor,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(AppAssets.upload),
                              const SizedBox(
                                height: 10,
                              ),
                              const LabelField(
                                text: "Upload Photos (upto 5)",
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AppColor.hintColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    const LabelField(
                      text: 'Other Sources/ Links',
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColor.secondaryColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColor.borderColor,
                          width: 1.0,
                        ),
                      ),
                      height: Get.height * 0.085,
                      child: TextField(
                        maxLines: null,
                        controller: linkController,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: AppColor.hintColor,
                          fontWeight: FontWeight.w400,
                        ),
                        keyboardType: TextInputType.text,
                        cursorColor: AppColor.hintColor,
                        decoration: InputDecoration(
                          fillColor: AppColor.secondaryColor,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: const EdgeInsets.only(
                            top: 0.0,
                            left: 12,
                          ),
                          hintText: "https://www.siteaddress.com",
                          hintStyle: GoogleFonts.poppins(
                            fontSize: 14,
                            color: AppColor.hintColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: _toggleCheckbox,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: AppColor.secondaryColor,
                              border: Border.all(
                                color: _isChecked
                                    ? AppColor.primaryColor
                                    : AppColor.borderColor,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Center(
                              child: FadeTransition(
                                opacity: _animation,
                                child: const Icon(
                                  Icons.check_rounded,
                                  size: 15,
                                  color: AppColor.primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const LabelField(
                          text: "Confirmed by a moderator",
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColor.lightBrown,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    LargeButton(
                      text: "Add Thing",
                      onTap: () {
                        Get.back();
                      },
                    ),
                    SizedBox(
                      height: Get.height * 0.02,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
