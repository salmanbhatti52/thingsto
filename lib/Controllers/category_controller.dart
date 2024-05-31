import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:thingsto/Utills/apis_urls.dart';
import 'package:thingsto/Utills/const.dart';

class CategoryController extends GetxController {
  var isLoading = false.obs;
  var isError = false.obs;
  var categories = [].obs;

  getCategory({
    required String usersCustomersId,
    required String currentLongitude,
    required String currentLattitude,
  }) async {
    try {
      isLoading.value = true;

      Map<String, String> data = {
        "users_customers_id": usersCustomersId,
        "current_longitude": currentLongitude,
        "current_lattitude": currentLattitude,
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

}