import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:thingsto/Utills/apis_urls.dart';
import 'dart:convert';
import 'package:thingsto/Utills/const.dart';

class RankingController extends GetxController {
  var isLoading = false.obs;
  var isError = false.obs;
  var rankUser = [].obs;

  var cachedRankUser = [].obs;
  var isRank = false.obs;
  var isFiltered = false.obs;

  /* Get Rank User Function */

  getRankUser({
    required String filter,
    String? categoryId,
  }) async {
    try {
      isLoading.value = true;
      cachedRankUser.clear();
      isFiltered.value = filter == "category";
      userID = (prefs.getString('users_customers_id').toString());
      debugPrint("userId $userID");
      Map<String, String> data = {
        "users_customers_id":  userID.toString(),
        "filter": filter.toString(),
      };
      if (categoryId != null && categoryId.isNotEmpty) {
        data["categories_id"] = categoryId;
      }
      debugPrint("data $data");
      final response = await http.post(Uri.parse(getRankUsersApiUrl),
          headers: {'Accept': 'application/json'}, body: data);

      var getRankUserData = jsonDecode(response.body);
      debugPrint("getRankUserData $getRankUserData");
      if (getRankUserData['status'] == 'success') {
        List<dynamic> sortedData = getRankUserData['data'];
        sortedData.sort((a, b) => b['total_points'].compareTo(a['total_points']));
        rankUser.value = sortedData;
        cachedRankUser.value = sortedData;
        isRank.value = true;
      } else {
        debugPrint(getRankUserData['status']);
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
