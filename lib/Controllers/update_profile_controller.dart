import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thingsto/Resources/app_colors.dart';

class UpdateProfileController extends GetxController {

  Rx<CroppedFile?> imageFile = Rx<CroppedFile?>(null);
  RxString base64Image = RxString("");

  Future<void> imagePick() async {
    final picker = ImagePicker();
    XFile? pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedImage != null) {
      await cropImage(pickedImage.path);
    }
  }

  Future<void> cropImage(String imagePath) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imagePath,
      maxWidth: 1800,
      maxHeight: 1800,
      cropStyle: CropStyle.rectangle,
      uiSettings: [
        AndroidUiSettings(
          initAspectRatio: CropAspectRatioPreset.ratio4x3,
          toolbarTitle: 'Upload',
          toolbarColor: AppColor.primaryColor,
          backgroundColor: AppColor.secondaryColor,
          showCropGrid: false,
          toolbarWidgetColor: AppColor.whiteColor,
          hideBottomControls: true,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          showActivitySheetOnDone: false,
          resetAspectRatioEnabled: false,
          title: 'Cropper',
          hidesNavigationBar: true,
        ),
      ],
    );
    if (croppedFile != null) {
      imageFile.value = croppedFile;
      if (imageFile.value != null) {
        Get.back();
      }
      await convertToBase64(croppedFile);
    }
  }

  Future<void> convertToBase64(CroppedFile croppedFile) async {
    List<int> imageBytes = await croppedFile.readAsBytes();
    String base64String = base64Encode(imageBytes);
    base64Image.value = base64String;
    debugPrint("base64Image ${base64Image.value}");
  }

}