import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:thingsto/Utills/apis_urls.dart';
import 'package:thingsto/Utills/const.dart';
import 'package:thingsto/Utills/global.dart';

class HomeController extends GetxController {
  var isLoading = false.obs;
  var errorMsg = "".obs;
  var findingThings = [].obs;
  var allCities = <Map<String, dynamic>>[].obs;
  var filteredCities = <Map<String, dynamic>>[].obs;

  /* Get All Cities Function */

  getAllCities({
    required String city,
}) async {
    try {
      isLoading.value = true;
      Map<String, String> data = {
        "name": city.toString(),
      };
      debugPrint("data $data");
      final response = await http.post(Uri.parse(citiesAllApiUrl),
          headers: {'Accept': 'application/json'}, body: data);

      var searchThingstoData = jsonDecode(response.body);
      debugPrint("searchThingstoData $searchThingstoData");
      var getAllCitiesData = jsonDecode(response.body);
      debugPrint("getAllCitiesData $getAllCitiesData");
      if (getAllCitiesData['status'] == 'success') {
        final List cities = getAllCitiesData['data'];

        // Extract only the required fields: cities_id and name
        List<Map<String, dynamic>> filteredCities = cities.map((city) {
          return {
            'cities_id': city['cities_id'],
            'name': city['name']
          };
        }).toList();

        // Now you can use filteredCities as needed
        debugPrint("filteredCities: $filteredCities");

        // Example: Saving to shared preferences or another variable
        allCities.value = filteredCities;
        // await prefs.setString('filteredCities', jsonEncode(filteredCities));
        // var storedCities = jsonDecode(prefs.getString('filteredCities') ?? '[]');
        // debugPrint("storedCities: $storedCities");
      } else {
        debugPrint(getAllCitiesData['status']);
      }
    } catch (e) {
      debugPrint("Error $e");
    } finally {
      isLoading.value = false;
    }
  }

  /* Get Founded Things Function */

  foundedThings({
    required String categoriesId,
    // required String name,
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
        "cities_id": categoriesId.toString(),
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