import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';
import 'package:thingsto/Widgets/TextFields.dart';
import 'package:thingsto/Widgets/app_bar.dart';
import 'package:thingsto/Widgets/custom_dropdown.dart';
import 'package:thingsto/Widgets/large_Button.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  List<String> itemListForAge = ["20", "25", "30",];
  String? selectAge;

  final surNameController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();

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
                      hintText: "Select Age",
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
                      height: Get.height * 0.2,
                    ),
                    LargeButton(
                      text: "Save Changes",
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
