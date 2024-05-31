import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:thingsto/Screens/Authentications/login_page.dart';
import 'package:thingsto/Screens/BottomNavigationBar/bottom_nav_bar.dart';
import 'package:thingsto/Utills/apis_urls.dart';
import 'package:thingsto/Utills/const.dart';
import 'package:thingsto/Widgets/snackbar.dart';

import '../Screens/Authentications/email_verification.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  var userEmail = ''.obs;
  var userId = 0.obs;
  RxBool isPasswordVisible = true.obs;
  RxBool isConfirmPasswordVisible = true.obs;

  passwordTap() {
      isPasswordVisible.value = !isPasswordVisible.value;
  }

  confirmPasswordTap() {
      isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  /* User Register  Function */

  register({
    required String surName,
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String oneSignalId,
    required String currentLongitude,
    required String currentLatitude,
  }) async {
    try {
      isLoading.value = true;
      Map<String, String> data = {
        "sur_name": surName,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "password": password,
        "account_type": "SignupWithApp",
        "one_signal_id": oneSignalId,
        "current_longitude": currentLongitude,
        "current_lattitude": currentLatitude,
      };
      debugPrint("data $data");
      final response = await http.post(Uri.parse(signUpApiUrl),
          headers: {'Accept': 'application/json'}, body: data);

      var signupData = jsonDecode(response.body);
      debugPrint("signupData $signupData");
      if (signupData['status'] == 'success') {

        var userData = signupData['data'][0];

        await prefs.setString('users_customers_id', userData['users_customers_id'].toString());
        await prefs.setString('firstName', userData['first_name']);
        await prefs.setString('lastName', userData['last_name']);
        await prefs.setString('email', userData['email']);
        await prefs.setString('isLogin', 'true');

        Get.offAll(
          () => const MyBottomNavigationBar(),
          duration: const Duration(milliseconds: 350),
          transition: Transition.rightToLeft,
        );

      } else {
        debugPrint(signupData['status']);
        var errorMsg = signupData['message'];
        CustomSnackbar.show(
          title: 'Signup Response',
          message: errorMsg.toString(),
        );
      }
    } catch (e) {
      debugPrint("Error $e");
    } finally {
      isLoading.value = false;
    }
  }

  /* User Login  Function */

  login({
    required String email,
    required String password,
    required String oneSignalId,
    required String currentLongitude,
    required String currentLatitude,
  }) async {
    try {
      isLoading.value = true;
      Map<String, String> data = {
        "email": email,
        "password": password,
        "one_signal_id": oneSignalId,
        "current_longitude": currentLongitude,
        "current_lattitude": currentLatitude,
      };
      debugPrint("data $data");
      final response = await http.post(Uri.parse(loginApiUrl),
          headers: {'Accept': 'application/json'}, body: data);

      var loginData = jsonDecode(response.body);
      debugPrint("loginData $loginData");
      if (loginData['status'] == 'success') {

        var userData = loginData['data'][0];

        await prefs.setString('users_customers_id', userData['users_customers_id'].toString());
        await prefs.setString('firstName', userData['first_name']);
        await prefs.setString('lastName', userData['last_name']);
        await prefs.setString('email', userData['email']);
        await prefs.setString('isLogin', 'true');

        Get.offAll(
          () => const MyBottomNavigationBar(),
          duration: const Duration(milliseconds: 350),
          transition: Transition.rightToLeft,
        );

      } else {
        debugPrint(loginData['status']);
        var errorMsg = loginData['message'];
        CustomSnackbar.show(
          title: 'Login Response',
          message: errorMsg.toString(),
        );
      }
    } catch (e) {
      debugPrint("Error $e");
    } finally {
      isLoading.value = false;
    }
  }

  /* User Forgot Password  Function */

  forgotPassword({
    required String email,
  }) async {
    try {
      isLoading.value = true;
      Map<String, String> data = {
        "email": email,
      };
      debugPrint("data $data");
      final response = await http.post(Uri.parse(forgotPasswordApiUrl),
          headers: {'Accept': 'application/json'}, body: data);

      var forgotData = jsonDecode(response.body);
      debugPrint("forgotData $forgotData");
      if (forgotData['status'] == 'success') {

        CustomSnackbar.show(
          title: 'Forgot Password Response',
          message: forgotData['data']["message"],
        );

        Get.to(
              () => EmailVerify(email: email, otp: forgotData['data']["otp"],),
          duration: const Duration(milliseconds: 350),
          transition: Transition.rightToLeft,
        );

      } else {
        debugPrint(forgotData['status']);
        var errorMsg = forgotData['message'];
        CustomSnackbar.show(
          title: 'Forgot Password Response',
          message: errorMsg.toString(),
        );
      }
    } catch (e) {
      debugPrint("Error $e");
    } finally {
      isLoading.value = false;
    }
  }

  /* User Modify Password  Function */

  modifyPassword({
    required String email,
    required String otp,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      isLoading.value = true;
      Map<String, String> data = {
        "email": email,
        "otp": otp,
        "password": password,
        "confirm_password": confirmPassword,
      };
      debugPrint("data $data");
      final response = await http.post(Uri.parse(modifyForgotPasswordApiUrl),
          headers: {'Accept': 'application/json'}, body: data);

      var modifyData = jsonDecode(response.body);
      debugPrint("modifyData $modifyData");
      if (modifyData['status'] == 'success') {

        Get.offAll(
              () => LoginPage(),
          duration: const Duration(milliseconds: 350),
          transition: Transition.upToDown,
        );

      } else {
        debugPrint(modifyData['status']);
        var errorMsg = modifyData['message'];
        CustomSnackbar.show(
          title: 'Login Response',
          message: errorMsg.toString(),
        );
      }
    } catch (e) {
      debugPrint("Error $e");
    } finally {
      isLoading.value = false;
    }
  }
}
