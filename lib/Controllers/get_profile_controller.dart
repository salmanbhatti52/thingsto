import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:thingsto/Utills/apis_urls.dart';
import 'dart:convert';

class GetProfileController extends GetxController {
  var isLoading = false.obs;
  var isError = false.obs;
  var getProfile = {}.obs;

  getUserProfile({required String usersCustomersId}) async {
    try {
      isLoading.value = true;

      Map<String, String> data = {
        "users_customers_id": usersCustomersId,
      };
      debugPrint("data $data");
        final response = await http.post(Uri.parse(getProfileApiUrl),
          headers: {'Accept': 'application/json'}, body: data);

      var getProfileData = jsonDecode(response.body);
      debugPrint("getProfileData $getProfileData");
      if (getProfileData['status'] == 'success') {
        getProfile.value = getProfileData['data'];
      } else {
        debugPrint(getProfileData['status']);
        isError.value = true;
      }
    } catch (e) {
      debugPrint("Error $e");
      isError.value = true;
    } finally {
      isLoading.value = false;
    }
  }
}
