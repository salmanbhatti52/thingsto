import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:thingsto/Utills/apis_urls.dart';
import 'package:thingsto/Utills/const.dart';
import 'package:thingsto/Utills/global.dart';

class AddThingsController extends GetxController {
  var isLoading = false.obs;
  var isError = false.obs;
  var categoriesAll = [].obs;
  var categories = [].obs;
  var subcategories = [].obs;

  /* Get All Category  Function */

  getAllCategory() async {
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
      final response = await http.post(Uri.parse(categoriesAllApiUrl),
          headers: {'Accept': 'application/json'}, body: data);

      var allCategoryData = jsonDecode(response.body);
      debugPrint("allCategoryData $allCategoryData");
      if (allCategoryData['status'] == 'success') {
        var data = jsonDecode(response.body)['data'] as List;
        categoriesAll.value = data;
        categories.value = data.where((c) => c['parent_id'] == 0).toList();
        subcategories.value = data.where((c) => c['parent_id'] != 0).toList();
      } else {
        debugPrint(allCategoryData['status']);
        isError.value = true;
      }
    } catch (e) {
      debugPrint("Error $e");
    } finally {
      isLoading.value = false;
    }
  }

}