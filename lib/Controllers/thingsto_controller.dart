import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:thingsto/Utills/apis_urls.dart';
import 'package:thingsto/Utills/const.dart';
import 'package:thingsto/Utills/global.dart';

class ThingstoController extends GetxController {
  var isLoading = false.obs;
  var isError = false.obs;
  var isSubLoading = false.obs;
  var categories = [].obs;
  var subcategories = [].obs;
  var thingsto = [].obs;
  var totalLikes = 0.obs;
  var isLiked = false.obs;
  var topThingsto = [].obs;

  /* Get Parent Category Function */

  getCategory({
    required String usersCustomersId,
  }) async {
    try {
      isLoading.value = true;
      await GlobalService.getCurrentPosition();
      double latitude1 = GlobalService.currentLocation!.latitude;
      double longitude1 = GlobalService.currentLocation!.longitude;
      debugPrint('current latitude: $latitude1');
      debugPrint('current longitude: $longitude1');
      Map<String, String> data = {
        "users_customers_id": usersCustomersId,
        "current_longitude":  longitude1.toString(),
        "current_lattitude": latitude1.toString(),
      };
      debugPrint("data $data");
      final response = await http.post(Uri.parse(categoriesApiUrl),
          headers: {'Accept': 'application/json'}, body: data);

      var categoryData = jsonDecode(response.body);
      debugPrint("categoryData $categoryData");
      if (categoryData['status'] == 'success') {
        var data = jsonDecode(response.body)['data'] as List;
        categories.value = data;
      } else {
        debugPrint(categoryData['status']);
        isError.value = true;
      }
    } catch (e) {
      debugPrint("Error $e");
    } finally {
      isLoading.value = false;
    }
  }

  /* Get Child Category Function */

  getChildCategory({
    required String categoriesId,
  }) async {
    try {
      isSubLoading.value = true;
      await GlobalService.getCurrentPosition();
      double latitude1 = GlobalService.currentLocation!.latitude;
      double longitude1 = GlobalService.currentLocation!.longitude;
      debugPrint('current latitude: $latitude1');
      debugPrint('current longitude: $longitude1');
      Map<String, String> data = {
        "categories_id": categoriesId,
        "current_longitude":  longitude1.toString(),
        "current_lattitude": latitude1.toString(),
      };
      debugPrint("data $data");
      final response = await http.post(Uri.parse(categoriesSubApiUrl),
          headers: {'Accept': 'application/json'}, body: data);

      var categoryData = jsonDecode(response.body);
      debugPrint("categoryData $categoryData");
      if (categoryData['status'] == 'success') {
        var data = jsonDecode(response.body)['data'] as List;
        subcategories.value = data;
      } else {
        debugPrint(categoryData['status']);
      }
    } catch (e) {
      debugPrint("Error $e");
    } finally {
      isSubLoading.value = false;
    }
  }

  /* Get Things To Function */

  getThingsto({
    required String usersCustomersId,
  }) async {
    try {
      isLoading.value = true;
      await GlobalService.getCurrentPosition();
      double latitude1 = GlobalService.currentLocation!.latitude;
      double longitude1 = GlobalService.currentLocation!.longitude;
      debugPrint('current latitude: $latitude1');
      debugPrint('current longitude: $longitude1');
      Map<String, String> data = {
        "users_customers_id": usersCustomersId,
        "current_longitude":  longitude1.toString(),
        "current_lattitude": latitude1.toString(),
      };
      debugPrint("data $data");
      final response = await http.post(Uri.parse(thingsGetApiUrl),
          headers: {'Accept': 'application/json'}, body: data);

      var thingstoData = jsonDecode(response.body);
      debugPrint("thingstoData $thingstoData");
      if (thingstoData['status'] == 'success') {
        var data = jsonDecode(response.body)['data'] as List;
        thingsto.value = data;
      } else {
        debugPrint(thingstoData['status']);
        isError.value = true;
      }
    } catch (e) {
      debugPrint("Error $e");
    } finally {
      isLoading.value = false;
    }
  }

  /* Get Things To Function */

  getTopThingsto({
    required String usersCustomersId,
  }) async {
    try {
      isLoading.value = true;
      await GlobalService.getCurrentPosition();
      double latitude1 = GlobalService.currentLocation!.latitude;
      double longitude1 = GlobalService.currentLocation!.longitude;
      debugPrint('current latitude: $latitude1');
      debugPrint('current longitude: $longitude1');
      Map<String, String> data = {
        "users_customers_id": usersCustomersId,
        "current_longitude":  longitude1.toString(),
        "current_lattitude": latitude1.toString(),
      };
      debugPrint("data $data");
      final response = await http.post(Uri.parse(thingsTopGetApiUrl),
          headers: {'Accept': 'application/json'}, body: data);

      var topThingstoData = jsonDecode(response.body);
      debugPrint("TopThingstoData $topThingstoData");
      if (topThingstoData['status'] == 'success') {
        var data = jsonDecode(response.body)['data'] as List;
        topThingsto.value = data;
      } else {
        debugPrint(topThingstoData['status']);
        isError.value = true;
      }
    } catch (e) {
      debugPrint("Error $e");
    } finally {
      isLoading.value = false;
    }
  }

  /* Like Unlike Things Function */

  Future<void> likeUnlikeUser(String thingId) async {
    try {
      String userID = (prefs.getString('users_customers_id').toString());
      debugPrint("userID $userID");
      Map<String, String> data = {
        "likers_id": userID.toString(),
        "things_id": thingId.toString(),
      };
      debugPrint("data $data");
      final response = await http.post(Uri.parse(thingLikeUnlikeApiUrl),
          headers: {'Accept': 'application/json'}, body: data);

      var thingstoData = jsonDecode(response.body);
      debugPrint("thingstoData $thingstoData");
      if (thingstoData['status'] == 'success') {
        totalLikes.value = thingstoData['data']['total_likes'];
        isLiked.value = !isLiked.value;
      } else {
        debugPrint(thingstoData['status']);
      }
    } catch (e) {
      debugPrint("Error $e");
    }
  }

  void initializeLikes(List<dynamic> likes) {
    String userID = (prefs.getString('users_customers_id').toString());
    debugPrint("userID $userID");
    isLiked.value = likes.any((like) => like['likers_id'] == int.parse(userID));
  }

}
