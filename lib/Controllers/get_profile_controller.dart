import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:thingsto/Utills/apis_urls.dart';
import 'dart:convert';

import 'package:thingsto/Utills/const.dart';
import 'package:thingsto/Utills/global.dart';
import 'package:thingsto/Widgets/snackbar.dart';

class GetProfileController extends GetxController {
  var isLoadingProfile = false.obs;
  var isLoadingFavorite = false.obs;
  var isLoadingHistory = false.obs;
  var isLoadingTB = false.obs;
  var isError = false.obs;
  var getProfile = {}.obs;
  var favorites = [].obs;
  var things = [].obs;
  var getTitles = [].obs;
  var getBadges = [].obs;
  RxInt currentPage = 1.obs;
  RxBool isLoadingMore = false.obs;
  var cachedGetProfile = {}.obs;
  var isDataLoadedGetProfile = false.obs;
  var cachedFavorites = [].obs;
  var isDataLoadedFavorites = false.obs;
  var cachedThings = [].obs;
  var isDataLoadedThings = false.obs;
  RxBool isLoadingStats = false.obs;
  RxBool isDataLoadedCategoriesStats = false.obs;
  RxList<Map<String, dynamic>> categoriesStats = <Map<String, dynamic>>[].obs;
  RxList cachedCategoriesStats = [].obs;

  /* Get User Profile Function */

  getUserProfile({required String usersCustomersId}) async {
    try {
      isLoadingProfile.value = true;
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
      isLoadingProfile.value = false;
    }
  }

  /* Get Favorites Things Function */

  getFavoritesThings() async {
    try {
      isLoadingFavorite.value = true;
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
      isLoadingFavorite.value = false;
    }
  }

  /* Get Things Function */

  getThings({required String usersCustomersId}) async {
    try {
      debugPrint("usersCustomersIdss $usersCustomersId");
      cachedThings.clear();
      isLoadingHistory.value = true;
      Map<String, String> data = {
        "users_customers_id": usersCustomersId,
      };
      debugPrint("data $data");
      final response = await http.post(Uri.parse(getUserThingsApiUrl),
          headers: {'Accept': 'application/json'}, body: data);

      if (response.statusCode == 200) {
        var thingsData = jsonDecode(response.body);
        debugPrint("thingsData $thingsData");

        if (thingsData is Map && thingsData['status'] == 'success') {
          var data = thingsData['data'];
          if (data is List) {
            List<dynamic> getThings = data.map((item) {
              if (item is Map) {
                return item['things'];
              }
              return null;
            }).where((item) => item != null).toList();

            things.value = getThings;
            cachedThings.value = getThings;
            debugPrint("cachedThings $cachedThings");
            isDataLoadedThings.value = true;
          } else {
            throw Exception("Invalid data format for 'data'");
          }
        } else {
          debugPrint("Status not success: ${thingsData['status']}");
          isError.value = true;
        }
      } else {
        debugPrint("HTTP Error: ${response.statusCode}");
        isError.value = true;
      }
    } catch (e) {
      debugPrint("Errorsss $e");
    } finally {
      isLoadingHistory.value = false;
    }
  }

  /* Get Favorites Things Function */

  Future<void> _fetchCategoryPercentage(String usersCustomersId, int categoryId) async {
    try {
      const String url = "https://thingsto.fr/portal/api/get_category_stats";
      Map<String, String> data = {
        "users_customers_id": usersCustomersId.toString(),
        "categories_id": categoryId.toString(),
      };

      final response = await http.post(Uri.parse(url),
          headers: {'Accept': 'application/json'}, body: data);

      var categoryData = jsonDecode(response.body);
      debugPrint("Category response data: $categoryData");

      if (categoryData['status'] == 'success') {
        var categoryDataResponse = categoryData['data'];
        var percentage = categoryDataResponse['percentage'];
        var categoryIdFromResponse = categoryDataResponse['categories_id'];

        debugPrint("Category ID: $categoryIdFromResponse, Percentage: $percentage");

        // Safely parse percentage and categoryId
        double parsedPercentage = double.tryParse(percentage.toString()) ?? 0.0;
        int parsedCategoryId = int.tryParse(categoryIdFromResponse.toString()) ?? -1;

        // Update category stats with new percentage
        for (int i = 0; i < categoriesStats.length; i++) {
          if (categoriesStats[i]['categories_id'] == parsedCategoryId) {
            categoriesStats[i] = {
              ...categoriesStats[i], // Keep existing values
              'percentage': parsedPercentage, // Update the percentage
              'isLoading': false, // Set loading to false after percentage update
            };
          }
        }

        for (int i = 0; i < cachedCategoriesStats.length; i++) {
          if (cachedCategoriesStats[i]['categories_id'] == parsedCategoryId) {
            cachedCategoriesStats[i] = {
              ...cachedCategoriesStats[i], // Keep existing values
              'percentage': parsedPercentage, // Update the percentage
              'isLoading': false, // Set loading to false after percentage update
            };
          }
        }

        categoriesStats.refresh();
        cachedCategoriesStats.refresh();

        debugPrint("Updated category stats for ID $parsedCategoryId");
      } else {
        debugPrint("Error fetching percentage for category $categoryId");
      }
    } catch (e) {
      debugPrint("Error fetching percentage for category $categoryId: $e");
    }
  }

  Future<void> getCategoriesStats({required String usersCustomersId}) async {
    try {
      isLoadingStats.value = true;

      // Get current location for coordinates
      await GlobalService.getCurrentPosition();
      double latitude1 = GlobalService.currentLocation!.latitude;
      double longitude1 = GlobalService.currentLocation!.longitude;
      debugPrint('Current latitude: $latitude1');
      debugPrint('Current longitude: $longitude1');

      // Prepare data for API call
      Map<String, String> data = {
        "users_customers_id": usersCustomersId.toString(),
        "current_longitude": longitude1.toString(),
        "current_lattitude": latitude1.toString(),
      };

      debugPrint("Sending data: $data");

      // Fetch categories stats
      final response = await http.post(Uri.parse(categoriesAllStatsApiUrl),
          headers: {'Accept': 'application/json'}, body: data);

      var categoriesData = jsonDecode(response.body);
      debugPrint("Response data: $categoriesData");

      if (categoriesData['status'] == 'success') {
        categoriesStats.clear();
        cachedCategoriesStats.clear();
        var categoryList = categoriesData['data'] as List;

        // Loop through each category and initialize its stats with default values
        for (var category in categoryList) {
          var categoryId = category['categories_id'];

          categoriesStats.add({
            'name': category['name'],
            'categories_id': categoryId,
            'percentage': 0.0,
            'isLoading': true, // Set loading true while fetching percentage
          });
        }

        // Cache the initial stats for quick reference
        cachedCategoriesStats.addAll(categoriesStats);

        // Fetch the percentage for each category
        for (var category in categoryList) {
          var categoryId = category['categories_id'];
          await _fetchCategoryPercentage(usersCustomersId, categoryId);
        }

        // Set the flag that data is loaded after processing all categories
        isDataLoadedCategoriesStats.value = true;
      } else {
        debugPrint("Error fetching categories stats: ${categoriesData['status']}");
        isError.value = true;
      }
    } catch (e) {
      debugPrint("Error fetching categories stats: $e");
      isError.value = true;
    } finally {
      isLoadingStats.value = false; // Stop loading indicator
    }
  }



  /* Get Title Function */

  getTitle() async {
    try {
      isLoadingTB.value = true;
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
      isLoadingTB.value = false;
    }
  }

  /* Get Badges Function */

  getBadge() async {
    try {
      isLoadingTB.value = true;
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
      isLoadingTB.value = false;
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
          title: 'success',
          message: "title_update_success",
        );
        // var data = jsonDecode(response.body)['data'] as List;
        // getTitles.value = data.map((item) => item['titles'] as Map<String, dynamic>).toList();
      } else {
        debugPrint(titleData['status']);
        CustomSnackbar.show(
          title: 'error',
          message: "title_already_active",
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
          title: 'success',
          message: " badge_update_success",
        );
        // var data = jsonDecode(response.body)['data'] as List;
        // getTitles.value = data.map((item) => item['titles'] as Map<String, dynamic>).toList();
      } else {
        debugPrint(titleData['status']);
        CustomSnackbar.show(
          title: 'error',
          message: "badge_already_active",
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
