import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:thingsto/Screens/Authentications/login_page.dart';
import 'package:thingsto/Screens/BottomNavigationBar/bottom_nav_bar.dart';
import 'package:thingsto/Utills/apis_urls.dart';
import 'package:thingsto/Utills/const.dart';
import 'package:thingsto/Utills/global.dart';
import 'package:thingsto/Widgets/snackbar.dart';
import '../Screens/Authentications/email_verification.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  var userEmail = ''.obs;
  var userId = 0.obs;
  RxBool isPasswordVisible = true.obs;
  RxBool isConfirmPasswordVisible = true.obs;
  var geoApiKey = ''.obs;
  var oneSignalApiKey = ''.obs;
  var systemLattitudes = ''.obs;
  var systemLongitudes = ''.obs;
  var systemAndroid = ''.obs;
  var systemIos = ''.obs;
  var systemRef = ''.obs;
  var systemRefLim = ''.obs;
  var language = ''.obs;

  passwordTap() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  confirmPasswordTap() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  /* User System Setting  Function */

  fetchSystemSettings() async {
    try {
      isLoading.value = true;
      final response = await http.get(Uri.parse(systemSettingsApiUrl));

      var systemSettingData = jsonDecode(response.body);
      debugPrint("systemSettingData $systemSettingData");
      if (systemSettingData['status'] == 'success') {
        final List settings = systemSettingData['data'];
        for (var setting in settings) {
          switch (setting['type']) {
            case 'language':
              language(setting['description']);
              await prefs.setString('language', language.toString());
              // languages = prefs.getString('language') ?? '';
              // debugPrint("languages: $languages");
              break;
            case 'geo_api_key':
              geoApiKey(setting['description']);
              await prefs.setString('geo_api_key', geoApiKey.toString());
              googleApiKey = prefs.getString('geo_api_key') ?? '';
              debugPrint("googleApiKey: $googleApiKey");
              break;
            case 'onesignal_appId':
              oneSignalApiKey(setting['description']);
              await prefs.setString('onesignal_appId', oneSignalApiKey.toString());
              oneSignalId = prefs.getString('onesignal_appId') ?? '';
              debugPrint("oneSignalId: $oneSignalId");
              break;
            case 'system_lattitude':
              systemLattitudes(setting['description']);
              await prefs.setString('system_lattitude', systemLattitudes.toString());
              systemLattitude = prefs.getString('system_lattitude') ?? '';
              debugPrint("systemLattitude: $systemLattitude");
              break;
            case 'system_longitude':
              systemLongitudes(setting['description']);
              await prefs.setString('system_longitude', systemLongitudes.toString());
              systemLongitude = prefs.getString('system_longitude') ?? '';
              debugPrint("systemLongitude: $systemLongitude");
              break;
            case 'share_app_android':
              systemAndroid(setting['description']);
              await prefs.setString('share_app_android', systemAndroid.toString());
              shareAndroid = prefs.getString('share_app_android') ?? '';
              debugPrint("shareAndroid: $shareAndroid");
              break;
            case 'share_app_ios':
              systemIos(setting['description']);
              await prefs.setString('share_app_ios', systemIos.toString());
              shareIos = prefs.getString('share_app_ios') ?? '';
              debugPrint("shareIos: $shareIos");
              break;
            case 'referral_bonus':
              systemRef(setting['description']);
              await prefs.setString('referral_bonus', systemRef.toString());
              referralBonus = prefs.getString('referral_bonus') ?? '';
              debugPrint("referralBonus: $referralBonus");
              break;
            case 'referral_bonus_limit':
              systemRefLim(setting['description']);
              await prefs.setString('referral_bonus_limit', systemRefLim.toString());
              referralBonusLimit = prefs.getString('referral_bonus_limit') ?? '';
              debugPrint("referralBonusLimit: $referralBonusLimit");
              break;
            default:
              debugPrint("Unknown setting type: ${setting['type']}");
              break;
          }
        }
        // for (var setting in settings) {
        //   if (setting['type'] == 'geo_api_key') {
        //     geoApiKey(setting['description']);
        //     await prefs.setString('geo_api_key', geoApiKey.toString(),);
        //     googleApiKey = (prefs.getString('geo_api_key').toString());
        //     debugPrint("googleApiKey $googleApiKey");
        //     break;
        //   }
        // }
        // for (var setting in settings) {
        //   if (setting['type'] == 'onesignal_appId') {
        //     oneSignalApiKey(setting['description']);
        //     await prefs.setString('onesignal_appId', oneSignalApiKey.toString(),);
        //     oneSignalId = (prefs.getString('onesignal_appId').toString());
        //     debugPrint("oneSignalId $oneSignalId");
        //     break;
        //   }
        // }
        // for (var setting in settings) {
        //   if (setting['type'] == 'system_lattitude') {
        //     systemLattitudes(setting['description']);
        //     await prefs.setString('system_lattitude', systemLattitudes.toString(),);
        //     systemLattitude = (prefs.getString('system_lattitude').toString());
        //     debugPrint("systemLattitude $systemLattitude");
        //     break;
        //   }
        // }
        // for (var setting in settings) {
        //   if (setting['type'] == 'system_longitude') {
        //     systemLongitudes(setting['description']);
        //     await prefs.setString('system_longitude', systemLongitudes.toString(),);
        //     systemLongitude = (prefs.getString('system_longitude').toString());
        //     debugPrint("systemLongitude $systemLongitude");
        //     break;
        //   }
        // }
        // for (var setting in settings) {
        //   if (setting['type'] == 'share_app_android') {
        //     systemAndroid(setting['description']);
        //     await prefs.setString('share_app_android', systemAndroid.toString(),);
        //     shareAndroid = (prefs.getString('share_app_android').toString());
        //     debugPrint("shareAndroid $shareAndroid");
        //     break;
        //   }
        // }
        // for (var setting in settings) {
        //   if (setting['type'] == 'share_app_ios') {
        //     systemIos(setting['description']);
        //     await prefs.setString('share_app_ios', systemIos.toString(),);
        //     shareIos = (prefs.getString('share_app_ios').toString());
        //     debugPrint("shareIos $shareIos");
        //     break;
        //   }
        // }
      } else {
        debugPrint(systemSettingData['status']);
      }
    } catch (e) {
      debugPrint("Error $e");
    } finally {
      isLoading.value = false;
    }
  }

  /* User Referral  Function */

  checkReferrals({
    required String referralCode,
    required String surName,
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      await GlobalService.getCurrentPosition();
      double latitude1 = GlobalService.currentLocation!.latitude;
      double longitude1 = GlobalService.currentLocation!.longitude;
      debugPrint('current latitude: $latitude1');
      debugPrint('current longitude: $longitude1');
      fetchSystemSettings();
      Map<String, String> data = {
        "referral_code": referralCode,
      };
      debugPrint("data $data");
      final response = await http.post(Uri.parse(checkReferralCodeApiUrl),
          headers: {'Accept': 'application/json'}, body: data);

      var referralData = jsonDecode(response.body);
      debugPrint("referralData $referralData");
      if (referralData['status'] == 'success') {
        var referralId = referralData['data']["referral_users_customers_id"];
        // oneSignalId = (prefs.getString('onesignal_appId').toString());
        // debugPrint("oneSignalId $oneSignalId");
        String? tokenId;
          final status = await OneSignal.shared.getDeviceState();
          tokenId = status?.userId;
        debugPrint("OneSignal User ID: $tokenId ");
        register(
          referralUsersCustomersId: referralId.toString(),
          surName: firstName,
          firstName: firstName,
          lastName: lastName,
          email: email,
          password: password,
          oneSignalId: tokenId.toString(),
          currentLongitude: longitude1.toString(),
          currentLatitude: latitude1.toString(),
        );
      } else {
        debugPrint(referralData['status']);
        var errorMsg = referralData['message'];
        CustomSnackbar.show(
          title: 'error',
          message: errorMsg.toString(),
        );
      }
    } catch (e) {
      debugPrint("Error $e");
    } finally {
      isLoading.value = false;
    }
  }

  /* User Register  Function */

  register({
    required String referralUsersCustomersId,
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
        "referral_users_customers_id": referralUsersCustomersId,
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

        await prefs.setString(
            'users_customers_id', userData['users_customers_id'].toString());
        // await prefs.setString('firstName', userData['first_name']);
        // await prefs.setString('lastName', userData['last_name']);
        await prefs.setString('surName', userData['sur_name']);
        await prefs.setString('email', userData['email']);
        await prefs.setString('isLogin', 'true');

        // Get.offAll(
        //   () => const MyBottomNavigationBar(),
        //   duration: const Duration(milliseconds: 350),
        //   transition: Transition.rightToLeft,
        // );
        CustomSnackbar.show(title: "success", message: "email_sent_confirmation");
      } else {
        debugPrint(signupData['status']);
        var errorMsg = signupData['message'];
        CustomSnackbar.show(
          title: 'error',
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
  }) async {
    try {
      isLoading.value = true;
      fetchSystemSettings();
      await GlobalService.getCurrentPosition();
      double latitude1 = GlobalService.currentLocation!.latitude;
      double longitude1 = GlobalService.currentLocation!.longitude;
      debugPrint('current latitude: $latitude1');
      debugPrint('current longitude: $longitude1');
      // oneSignalId = (prefs.getString('onesignal_appId').toString());
      // debugPrint("oneSignalId $oneSignalId");
      String? tokenId;
        final status = await OneSignal.shared.getDeviceState();
        tokenId = status?.userId;
      debugPrint("OneSignal User ID: $tokenId ");
      Map<String, String> data = {
        "email": email,
        "password": password,
        "one_signal_id": tokenId.toString(),
        "current_longitude": longitude1.toString(),
        "current_lattitude": latitude1.toString(),
      };
      debugPrint("data $data");
      final response = await http.post(Uri.parse(loginApiUrl),
          headers: {'Accept': 'application/json'}, body: data);

      var loginData = jsonDecode(response.body);
      debugPrint("loginData $loginData");
      if (loginData['status'] == 'success') {
        var userData = loginData['data'][0];

        await prefs.setString(
            'users_customers_id', userData['users_customers_id'].toString());
        // await prefs.setString('firstName', userData['first_name']);
        // await prefs.setString('lastName', userData['last_name']);
        await prefs.setString('surName', userData['sur_name']);
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
          title: 'error',
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
          title: 'success',
          message: forgotData['data']["message"],
        );

        Get.to(
          () => EmailVerify(
            email: email,
            otp: forgotData['data']["otp"],
          ),
          duration: const Duration(milliseconds: 350),
          transition: Transition.rightToLeft,
        );
      } else {
        debugPrint(forgotData['status']);
        var errorMsg = forgotData['message'];
        CustomSnackbar.show(
          title: 'error',
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
          title: 'error',
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
