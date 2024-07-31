import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:thingsto/Utills/apis_urls.dart';
import 'dart:convert';

import 'package:thingsto/Utills/const.dart';
import 'package:thingsto/Utills/global.dart';
import 'package:thingsto/Widgets/snackbar.dart';

class GetProfileController extends GetxController {
  var isLoading = false.obs;
  var isLoading1 = false.obs;
  var isError = false.obs;
  var getProfile = {}.obs;
  var favorites = [].obs;
  var things = [].obs;
  var categoriesStats = [].obs;
  var getTitles = [].obs;
  var getBadges = [].obs;

  var cachedGetProfile = {}.obs;
  var isDataLoadedGetProfile = false.obs;
  var cachedFavorites = [].obs;
  var isDataLoadedFavorites = false.obs;
  var cachedThings = [].obs;
  var isDataLoadedThings = false.obs;
  var cachedCategoriesStats = [].obs;
  var isDataLoadedCategoriesStats = false.obs;

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
        cachedGetProfile.value = getProfileData['data'];
        isDataLoadedGetProfile.value = true;
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
        cachedFavorites.value = data;
        isDataLoadedFavorites.value = true;
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

  /* Get Things Function */

  getThings({required String usersCustomersId}) async {
    try {
      cachedThings.clear();
      isLoading.value = true;
      Map<String, String> data = {
        "users_customers_id": usersCustomersId.toString(),
      };
      debugPrint("data $data");
      final response = await http.post(Uri.parse(getUserThingsApiUrl),
          headers: {'Accept': 'application/json'}, body: data);

      var thingsData = jsonDecode(response.body);
      debugPrint("thingsData $thingsData");
      if (thingsData['status'] == 'success') {
        var data = jsonDecode(response.body)['data'] as List;
        things.value = data;
        cachedThings.value = data;
        isDataLoadedThings.value = true;
      } else {
        debugPrint(thingsData['status']);
        isError.value = true;
      }
    } catch (e) {
      debugPrint("Error $e");
    } finally {
      isLoading.value = false;
    }
  }

  /* Get Favorites Things Function */

  getCategoriesStats({required String usersCustomersId}) async {
    try {
      isLoading.value = true;
      await GlobalService.getCurrentPosition();
      double latitude1 = GlobalService.currentLocation!.latitude;
      double longitude1 = GlobalService.currentLocation!.longitude;
      debugPrint('current latitude: $latitude1');
      debugPrint('current longitude: $longitude1');
      Map<String, String> data = {
        "users_customers_id": usersCustomersId.toString(),
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
        cachedCategoriesStats.value = data;
        isDataLoadedCategoriesStats.value = true;
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

  /* Get Title Function */

  getTitle() async {
    try {
      isLoading1.value = true;
      userID = (prefs.getString('users_customers_id').toString());
      debugPrint("userID $userID");
      Map<String, String> data = {
        "users_customers_id": userID.toString(),
      };
      debugPrint("data $data");
      final response = await http.post(Uri.parse(getUserTitlesApiUrl),
          headers: {'Accept': 'application/json'}, body: data);

      var titleData = jsonDecode(response.body);
      debugPrint("titleData $titleData");
      if (titleData['status'] == 'success') {
        var data = jsonDecode(response.body)['data'] as List;
        getTitles.value = data.map((item) => item['titles'] as Map<String, dynamic>).toList();
      } else {
        debugPrint(titleData['status']);
        isError.value = true;
      }
    } catch (e) {
      debugPrint("Error $e");
    } finally {
      isLoading1.value = false;
    }
  }

  /* Get Badges Function */

  getBadge() async {
    try {
      isLoading1.value = true;
      userID = (prefs.getString('users_customers_id').toString());
      debugPrint("userID $userID");
      Map<String, String> data = {
        "users_customers_id": userID.toString(),
      };
      debugPrint("data $data");
      final response = await http.post(Uri.parse(getUserBadgesApiUrl),
          headers: {'Accept': 'application/json'}, body: data);

      var badgesData = jsonDecode(response.body);
      debugPrint("badgesData $badgesData");
      if (badgesData['status'] == 'success') {
        var data = jsonDecode(response.body)['data'] as List;
        getBadges.value = data.map((item) => item['badges'] as Map<String, dynamic>).toList();
      } else {
        debugPrint(badgesData['status']);
        isError.value = true;
      }
    } catch (e) {
      debugPrint("Error $e");
    } finally {
      isLoading1.value = false;
    }
  }

  /* Update Title Function */

  updateTitle({
    required String titleId,
}) async {
    try {
      userID = (prefs.getString('users_customers_id').toString());
      debugPrint("userID $userID");
      Map<String, String> data = {
        "users_customers_id": userID.toString(),
        "titles_id": titleId.toString(),
      };
      debugPrint("data $data");
      final response = await http.post(Uri.parse(updateTitleApiUrl),
          headers: {'Accept': 'application/json'}, body: data);

      var titleData = jsonDecode(response.body);
      debugPrint("titleData $titleData");
      if (titleData['status'] == 'success') {
        getUserProfile(usersCustomersId: userID.toString());
        CustomSnackbar.show(
          title: 'Success',
          message: "Title update successfully",
        );
        // var data = jsonDecode(response.body)['data'] as List;
        // getTitles.value = data.map((item) => item['titles'] as Map<String, dynamic>).toList();
      } else {
        debugPrint(titleData['status']);
        CustomSnackbar.show(
          title: 'Error',
          message: "This title is already active.",
        );
        isError.value = true;
      }
    } catch (e) {
      debugPrint("Error $e");
    } finally {
      // isLoading1.value = false;
    }
  }

  /* Update Badges Function */

  updateBadge({
    required String badgeId,
  }) async {
    try {
      userID = (prefs.getString('users_customers_id').toString());
      debugPrint("userID $userID");
      Map<String, String> data = {
        "users_customers_id": userID.toString(),
        "badges_id": badgeId.toString(),
      };
      debugPrint("data $data");
      final response = await http.post(Uri.parse(updateBadgeApiUrl),
          headers: {'Accept': 'application/json'}, body: data);

      var titleData = jsonDecode(response.body);
      debugPrint("titleData $titleData");
      if (titleData['status'] == 'success') {
        getUserProfile(usersCustomersId: userID.toString());
        CustomSnackbar.show(
          title: 'Success',
          message: " Badge update successfully",
        );
        // var data = jsonDecode(response.body)['data'] as List;
        // getTitles.value = data.map((item) => item['titles'] as Map<String, dynamic>).toList();
      } else {
        debugPrint(titleData['status']);
        CustomSnackbar.show(
          title: 'Error',
          message: "This badge is already active.",
        );
        isError.value = true;
      }
    } catch (e) {
      debugPrint("Error $e");
    } finally {
      // isLoading1.value = false;
    }
  }

}
