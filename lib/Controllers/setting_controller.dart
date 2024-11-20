import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:thingsto/Utills/apis_urls.dart';
import 'package:thingsto/Utills/const.dart';
import 'package:thingsto/Utills/global.dart';
import 'package:thingsto/Widgets/snackbar.dart';

class SettingController extends GetxController {
  var isLoading = false.obs;
  var isLoading1 = false.obs;
  RxInt totalReferrals = 0.obs;
  RxBool isOldPasswordVisible = true.obs;
  RxBool isPasswordVisible = true.obs;
  RxBool isConfirmPasswordVisible = true.obs;

  oldPasswordTap() {
    isOldPasswordVisible.value = !isOldPasswordVisible.value;
  }

  passwordTap() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  confirmPasswordTap() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  /* Delete Account  Function */

  deleteAccount({
    String? email,
  }) async {
    try {
      isLoading.value = true;
      email = (prefs.getString('email').toString());
      debugPrint("email $email");
      Map<String, String> data = {
        "user_email": email.toString(),
        "delete_reason": "Delete Account",
        "comments": "Hello",
      };
      debugPrint("data $data");
      final response = await http.post(Uri.parse(deleteAccountApiUrl),
          headers: {'Accept': 'application/json'}, body: data);

      var deleteData = jsonDecode(response.body);
      debugPrint("deleteData $deleteData");
      if (deleteData['status'] == 'success') {
        Get.back();
        CustomSnackbar.show(
          title: 'success',
          message: deleteData['message'],
        );
      } else {
        Get.back();
        debugPrint(deleteData['message']);
        CustomSnackbar.show(
          title: 'error',
          message: deleteData['message'],
        );
      }
    } catch (e) {
      debugPrint("Error $e");
    } finally {
      isLoading.value = false;
    }
  }

  /* Delete Account  Function */

  changePassword({
    String? email,
    required String oldPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    try {
      isLoading.value = true;
      email = (prefs.getString('email').toString());
      debugPrint("email $email");
      Map<String, String> data = {
        "email": email,
        "old_password": oldPassword,
        "password": newPassword,
        "confirm_password": confirmNewPassword,
      };
      debugPrint("data $data");
      final response = await http.post(Uri.parse(changePasswordApiUrl),
          headers: {'Accept': 'application/json'}, body: data);

      var changePasswordData = jsonDecode(response.body);
      debugPrint("changePasswordData $changePasswordData");
      if (changePasswordData['status'] == 'success') {
        CustomSnackbar.show(
          title: 'success',
          message: "password_change_success",
        );
      } else {
        debugPrint(changePasswordData['message']);
        CustomSnackbar.show(
          title: 'error',
          message: changePasswordData['message'],
        );
      }
    } catch (e) {
      debugPrint("Error $e");
    } finally {
      isLoading.value = false;
    }
  }

  /* Referral Friend  Function */

  referralFriend({
    required String emailReferral,
    required String referralLink,
  }) async {
    try {
      isLoading.value = true;
      userID = (prefs.getString('users_customers_id').toString());
      debugPrint("userID $userID");
      Map<String, String> data = {
        "users_customers_id": userID.toString(),
        "email_referral":emailReferral.toString(),
        "referral_link": referralLink.toString(),
      };
      debugPrint("data $data");
      final response = await http.post(Uri.parse(emailReferralInviteApiUrl),
          headers: {'Accept': 'application/json'}, body: data);

      var referralData = jsonDecode(response.body);
      debugPrint("referralData $referralData");
      if (referralData['status'] == 'success') {
        CustomSnackbar.show(
          title: 'success',
          message: referralData['message'],
        );
      } else {
        debugPrint(referralData['message']);
        CustomSnackbar.show(
          title: 'error',
          message: referralData['message'],
        );
      }
    } catch (e) {
      debugPrint("Error $e");
    } finally {
      isLoading.value = false;
    }
  }

  /* Get Referral Stats Function */

  getReferralStats() async {
    try {
      isLoading1.value = true;
      userID = (prefs.getString('users_customers_id').toString());
      debugPrint("userID $userID");
      await GlobalService.getCurrentPosition();
      double latitude1 = GlobalService.currentLocation!.latitude;
      double longitude1 = GlobalService.currentLocation!.longitude;
      debugPrint('current latitude: $latitude1');
      debugPrint('current longitude: $longitude1');
      Map<String, String> data = {
        "users_customers_id": userID.toString(),
        "current_longitude":  longitude1.toString(),
        "current_lattitude": latitude1.toString(),
      };
      debugPrint("data $data");
      final response = await http.post(Uri.parse(getReferralStatsApiUrl),
          headers: {'Accept': 'application/json'}, body: data);

      var referralData = jsonDecode(response.body);
      debugPrint("referralData $referralData");
      if (referralData['status'] == 'success') {
        var data = referralData['data'];
        if (data is Map) {
          totalReferrals.value = data['total_referrals'];
          debugPrint("totalReferrals $totalReferrals");
         }
      } else {
        debugPrint(referralData['status']);
      }
    } catch (e) {
      debugPrint("Error $e");
    } finally {
      isLoading1.value = false;
    }
  }


  /* Subscribe News Letter  Function */

  subscribeLetter({
    required String email,
  }) async {
    try {
      isLoading.value = true;
      Map<String, String> data = {
        "email": email.toString(),
      };
      debugPrint("data $data");
      final response = await http.post(Uri.parse(subscribeNewsletterApiUrl),
          headers: {'Accept': 'application/json'}, body: data);

      var subData = jsonDecode(response.body);
      debugPrint("subData $subData");
      if (subData['status'] == 'success') {
        CustomSnackbar.show(
          title: 'success',
          message: subData['message'],
        );
      } else {
        debugPrint(subData['message']);
        CustomSnackbar.show(
          title: 'error',
          message: subData['message'],
        );
      }
    } catch (e) {
      debugPrint("Error $e");
    } finally {
      isLoading.value = false;
    }
  }

}
