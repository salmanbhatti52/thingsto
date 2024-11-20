import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Screens/BottomNavigationBar/bottom_nav_bar.dart';
import 'package:thingsto/Utills/apis_urls.dart';
import 'package:thingsto/Utills/const.dart';
import 'package:thingsto/Utills/global.dart';
import 'package:thingsto/Widgets/snackbar.dart';

class UpdateProfileController extends GetxController {

  Rx<CroppedFile?> imageFile = Rx<CroppedFile?>(null);
  RxString base64Image = RxString("");
  var isLoading = false.obs;

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
      await convertToBase64(croppedFile);
    }
  }

  Future<void> convertToBase64(CroppedFile croppedFile) async {
    List<int> imageBytes = await croppedFile.readAsBytes();
    String base64String = base64Encode(imageBytes);
    base64Image.value = base64String;
    debugPrint("base64Image ${base64Image.value}");
  }

  /* Update Profile Function */

  updateProfile({
    String? usersCustomersId,
    required String surName,
    required String firstName,
    required String lastName,
    required String age,
    required String quote,
    String? email,
    String? notifications,
    required String profilePicture,
  }) async {
    try {
      isLoading.value = true;
      await GlobalService.getCurrentPosition();
      double latitude1 = GlobalService.currentLocation!.latitude;
      double longitude1 = GlobalService.currentLocation!.longitude;
      debugPrint('current latitude: $latitude1');
      debugPrint('current longitude: $longitude1');
      email = (prefs.getString('email').toString());
      userID = (prefs.getString('users_customers_id').toString());
      debugPrint("email $email");
      debugPrint("userId $userID");
      Map<String, String> data = {
        "users_customers_id": userID.toString(),
        "sur_name": surName,
        "first_name": firstName,
        "last_name": lastName,
        "age": age,
        "email": email,
        "quote": quote,
        "current_longitude":  longitude1.toString(),
        "current_lattitude": latitude1.toString(),
        "notifications": "Yes",
        "profile_picture": profilePicture,
      };
      debugPrint("data $data");
      final response = await http.post(Uri.parse(updateProfileApiUrl),
          headers: {'Accept': 'application/json'}, body: data);

      var updateData = jsonDecode(response.body);
      debugPrint("updateData $updateData");
      if (updateData['status'] == 'success') {
        var userData = updateData['data'][0];
        await prefs.setString('surName', userData['sur_name']);
        CustomSnackbar.show(
          title: 'success',
          message: "profile_update_success",
        );
        Get.off(
              () => const MyBottomNavigationBar(initialIndex: 4,),
          duration: const Duration(milliseconds: 350),
          transition: Transition.downToUp,
        );
      } else {
        debugPrint(updateData['message']);
        CustomSnackbar.show(
          title: 'error',
          message: "something_wrong",
        );
      }
    } catch (e) {
      debugPrint("Error $e");
    } finally {
      isLoading.value = false;
    }
  }

  /* Update Notification Settings Function */

  updateNotifications({
    String? usersCustomersId,
    required String notifications,
    required String notificationsEmail,
    required String thingAddition,
    required String thingValidation,
  }) async {
    try {
      isLoading.value = true;
      userID = (prefs.getString('users_customers_id').toString());
      debugPrint("userId $userID");
      Map<String, String> data = {
        "users_customers_id": userID.toString(),
        "notifications":  notifications.toString(),
        "notifications_email": notificationsEmail.toString(),
        "things_approval_notifications": thingAddition.toString(),
        "things_validation_notifications": thingValidation.toString(),
      };
      debugPrint("data $data");
      final response = await http.post(Uri.parse(updateProfileNotificationsApiUrl),
          headers: {'Accept': 'application/json'}, body: data);

      var updateData = jsonDecode(response.body);
      debugPrint("updateData $updateData");
      if (updateData['status'] == 'success') {
        CustomSnackbar.show(
          title: 'success',
          message: "notifications_update_success",
        );
        Get.off(
              () => const MyBottomNavigationBar(initialIndex: 4,),
          duration: const Duration(milliseconds: 350),
          transition: Transition.downToUp,
        );
      } else {
        debugPrint(updateData['message']);
        CustomSnackbar.show(
          title: 'error',
          message: "something_wrong",
        );
      }
    } catch (e) {
      debugPrint("Error $e");
    } finally {
      isLoading.value = false;
    }
  }

  /* Update Privacy Settings Function */

  updatePrivacy({
    String? usersCustomersId,
    required String profilePrivacy,
  }) async {
    try {
      isLoading.value = true;
      userID = (prefs.getString('users_customers_id').toString());
      debugPrint("userId $userID");
      Map<String, String> data = {
        "users_customers_id": userID.toString(),
        "profile_privacy":  profilePrivacy.toString(),
      };
      debugPrint("data $data");
      final response = await http.post(Uri.parse(updateProfilePrivacyApiUrl),
          headers: {'Accept': 'application/json'}, body: data);

      var updateData = jsonDecode(response.body);
      debugPrint("updateData $updateData");
      if (updateData['status'] == 'success') {
        CustomSnackbar.show(
          title: 'success',
          message: "privacy_update_success",
        );
        Get.off(
              () => const MyBottomNavigationBar(initialIndex: 4,),
          duration: const Duration(milliseconds: 350),
          transition: Transition.downToUp,
        );
      } else {
        debugPrint(updateData['message']);
        CustomSnackbar.show(
          title: 'error',
          message: "something_wrong",
        );
      }
    } catch (e) {
      debugPrint("Error $e");
    } finally {
      isLoading.value = false;
    }
  }

}