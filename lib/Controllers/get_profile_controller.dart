import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:thingsto/Utills/apis_urls.dart';
import 'dart:convert';

import 'package:thingsto/Utills/const.dart';
import 'package:thingsto/Utills/global.dart';

class GetProfileController extends GetxController {
  var isLoading = false.obs;
  var isError = false.obs;
  var getProfile = {}.obs;
  var favorites = [].obs;
  var categoriesStats = [].obs;

  /* Get User Profile Function */

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

  /* Get Favorites Things Function */

  getFavoritesThings() async {
    try {
      isLoading.value = true;
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
      final response = await http.post(Uri.parse(thingsFavouritesApiUrl),
          headers: {'Accept': 'application/json'}, body: data);

      var favoritesData = jsonDecode(response.body);
      debugPrint("favoritesData $favoritesData");
      if (favoritesData['status'] == 'success') {
        var data = jsonDecode(response.body)['data'] as List;
        favorites.value = data;
      } else {
        debugPrint(favoritesData['status']);
        isError.value = true;
      }
    } catch (e) {
      debugPrint("Error $e");
    } finally {
      isLoading.value = false;
    }
  }

  /* Get Favorites Things Function */

  getCategoriesStats() async {
    try {
      isLoading.value = true;
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
      final response = await http.post(Uri.parse(categoriesAllStatsApiUrl),
          headers: {'Accept': 'application/json'}, body: data);

      var statsData = jsonDecode(response.body);
      debugPrint("statsData $statsData");
      if (statsData['status'] == 'success') {
        var data = jsonDecode(response.body)['data'] as List;
        categoriesStats.value = data;
      } else {
        debugPrint(statsData['status']);
        isError.value = true;
      }
    } catch (e) {
      debugPrint("Error $e");
    } finally {
      isLoading.value = false;
    }
  }

}
