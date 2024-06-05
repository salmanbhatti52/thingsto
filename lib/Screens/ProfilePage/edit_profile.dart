import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:thingsto/Controllers/update_profile_controller.dart';
import 'package:thingsto/Resources/app_assets.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Utills/apis_urls.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';
import 'package:thingsto/Widgets/TextFields.dart';
import 'package:thingsto/Widgets/app_bar.dart';
import 'package:thingsto/Widgets/custom_dropdown.dart';
import 'package:thingsto/Widgets/large_Button.dart';
import 'package:thingsto/Widgets/snackbar.dart';

class EditProfile extends StatefulWidget {
  Map<dynamic, dynamic> getProfile = {};
  EditProfile({super.key, required this.getProfile});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  List<String> itemListForAge = [
    "20",
    "25",
    "30",
  ];
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
