import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thingsto/Controllers/update_profile_controller.dart';
import 'package:thingsto/Resources/app_assets.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Utills/apis_urls.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';
import 'package:thingsto/Widgets/TextFields.dart';
import 'package:thingsto/Widgets/app_bar.dart';
import 'package:thingsto/Widgets/large_Button.dart';
import 'package:thingsto/Widgets/snackbar.dart';

class EditProfile extends StatefulWidget {
  Map<dynamic, dynamic> getProfile = {};
  EditProfile({super.key, required this.getProfile});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  List<String> itemListForAge = List<String>.generate(89, (index) => (index + 12).toString());

  String? selectAge;

  final formKey = GlobalKey<FormState>();
  final surNameController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();

  UpdateProfileController updateProfileController =
      Get.put(UpdateProfileController());

  @override
  void initState() {
    super.initState();
    surNameController.text = widget.getProfile['sur_name'] ?? '';
    firstNameController.text = widget.getProfile['first_name'] ?? '';
    lastNameController.text = widget.getProfile['last_name'] ?? '';
    emailController.text = widget.getProfile['email'] ?? '';
    selectAge = widget.getProfile['age']?.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Column(
        children: [
          BackButtonBar(
            title: "Edit Profile",
            bottomPad: 15,
            onBack: () {
              Get.back();
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Get.width * 0.08,
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: Get.height * 0.03,
                      ),
                      Center(
                        child: Stack(
                          children: [
                            Center(
                              child: Obx(() {
                                String? profilePicUrl =
                                widget.getProfile['profile_picture'];

                                ImageProvider backgroundImage;
                                if (updateProfileController.imageFile.value !=
                                    null) {
                                  backgroundImage = FileImage(File(
                                      updateProfileController
                                          .imageFile.value!.path),);
                                } else if (profilePicUrl != null) {
                                  backgroundImage = NetworkImage(baseUrlImage+profilePicUrl);
                                } else {
                                  backgroundImage =
                                  const NetworkImage(AppAssets.dummyPic);
                                }

                                return Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        width: 2, color: AppColor.primaryColor),
                                  ),
                                  child: CircleAvatar(
                                    radius: 50,
                                    backgroundColor: Colors.transparent,
                                    backgroundImage: backgroundImage,
                                  ),
                                );
                              }),
                            ),
                            Positioned(
                              right: Get.width * 0.28,
                              bottom: 1,
                              child: GestureDetector(
                                onTap: updateProfileController.imagePick,
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    color: AppColor.whiteColor,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      width: 1,
                                      color: AppColor.primaryColor,
                                    ),
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(AppAssets.cameraPlus),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: Get.height * 0.025,
                      ),
                      const LabelField(
                        text: 'Surname',
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      CustomTextFormField(
                        controller: surNameController,
                        hintText: "Surname here",
                        // validator: validateEmail,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        showSuffix: false,
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      const LabelField(
                        text: 'First Name',
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      CustomTextFormField(
                        controller: firstNameController,
                        hintText: "First Name here",
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        showSuffix: false,
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      const LabelField(
                        text: 'Last Name',
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      CustomTextFormField(
                        controller: lastNameController,
                        hintText: "Last Name here",
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.done,
                        showSuffix: false,
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      const LabelField(
                        text: 'Age',
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      CustomDropdown(
                        itemList: itemListForAge,
                        hintText: selectAge != null ? selectAge.toString() : "Select Age",
                        onChanged: (value) {
                          selectAge = value;
                          debugPrint("selectAge: $selectAge");
                        },
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      const LabelField(
                        text: 'Email',
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      CustomTextFormField(
                        controller: emailController,
                        hintText: "username@gmail.com",
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        showSuffix: false,
                      ),
                      SizedBox(
                        height: Get.height * 0.06,
                      ),
                      Obx(
                            () => updateProfileController.isLoading.value
                            ? LargeButton(
                          text: "Please Wait...",
                          onTap: () {},
                        )
                            : LargeButton(
                          text: "Save Changes",
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              if (selectAge != null) {
                                updateProfileController.updateProfile(
                                  surName: surNameController.text,
                                  firstName: firstNameController.text,
                                  lastName: lastNameController.text,
                                  age: selectAge.toString(),
                                  profilePicture: updateProfileController
                                      .base64Image.value
                                      .toString(),
                                );
                              } else {
                                CustomSnackbar.show(
                                  title: 'Error',
                                  message: "Please Select Age",
                                );
                              }
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: Get.height * 0.02,
                      ),
                    ],
                  ),
                )
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomDropdown extends StatefulWidget {
  final List<dynamic> itemList;
  final String? initialValue;
  final String hintText;
  final Function(String?) onChanged;

  const CustomDropdown({
    super.key,
    required this.itemList,
    required this.hintText,
    this.initialValue,
    required this.onChanged,
  });

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String? _selectedItem;

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        _showAgePicker(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColor.secondaryColor,
          border: Border.all(
            color: AppColor.borderColor,
            width: 1,
          ),
        ),
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.058,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _selectedItem ?? widget.hintText,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColor.hintColor,
                fontWeight: FontWeight.w400,
              ),
            ),
            SvgPicture.asset(AppAssets.dropDown),
          ],
        ),
      ),
    );
  }

  void _showAgePicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: AppColor.whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            width: 100,
           decoration: BoxDecoration(
             color: AppColor.whiteColor,
             borderRadius: BorderRadius.circular(10),
           ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
              const SizedBox(
              height: 10,
            ),
              const LabelField(
                text: 'Select Age',
                align: TextAlign.left,
              ),
              const Divider(color: AppColor.lightBrown,),
              Container(
                color: AppColor.whiteColor,
                height: 150,
                child: ListView.builder(
                  itemCount: widget.itemList.length,
                  itemBuilder: (BuildContext context, int index) {
                    String item = widget.itemList[index];
                    return ListTile(
                      title: Center(
                        child: Text(
                          item,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _selectedItem = item;
                          widget.onChanged(_selectedItem);
                        });
                        Navigator.of(context).pop();
                        debugPrint("selectedItem: $_selectedItem");
                      },
                    );
                  },
                ),
              ),],),),);
      },
    );
  }
}
