import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:thingsto/Utills/apis_urls.dart';
import 'package:thingsto/Utills/const.dart';
import 'package:thingsto/Utills/global.dart';

class HomeController extends GetxController{
  var isLoading = false.obs;
  var errorMsg = "".obs;
  var findingThings = [].obs;

  /* Get Founded Things Function */

  foundedThings({
    required String categoriesId,
    required String name,
}) async {
    try {
      isLoading.value = true;
      findingThings.clear();
      await GlobalService.getCurrentPosition();
      userID = (prefs.getString('users_customers_id').toString());
      double latitude1 = GlobalService.currentLocation!.latitude;
      double longitude1 = GlobalService.currentLocation!.longitude;
      debugPrint("userID $userID");
      debugPrint('current latitude: $latitude1');
      debugPrint('current longitude: $longitude1');
      Map<String, String> data = {
        "users_customers_id": userID.toString(),
        "current_longitude":  longitude1.toString(),
        "current_lattitude": latitude1.toString(),
        "categories_id": categoriesId.toString(),
        "name": name.toString(),
      };
      debugPrint("data $data");
      final response = await http.post(Uri.parse(thingsSearchApiUrl),
          headers: {'Accept': 'application/json'}, body: data);

      var searchThingstoData = jsonDecode(response.body);
      debugPrint("searchThingstoData $searchThingstoData");
      if (searchThingstoData['status'] == 'success') {
        var data = jsonDecode(response.body)['data'] as List;
        findingThings.value = data;
      } else {
        debugPrint(searchThingstoData['status']);
        errorMsg.value = searchThingstoData['status'];
      }
    } catch (e) {
      debugPrint("Error $e");
    } finally {
      isLoading.value = false;
    }
  }

}