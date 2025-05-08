import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:thingsto/Utills/apis_urls.dart';
import 'package:thingsto/Utills/const.dart';
import 'package:thingsto/Utills/global.dart';

class HomeController extends GetxController {
  var isLoading = false.obs;
  var mapLoading = false.obs;
  var errorMsg = "".obs;
  var findingThings = <dynamic>[].obs;
  var currentItemIndex = 0.obs;
  var isLastItemShown = false.obs;
  var allCities = <Map<String, dynamic>>[].obs;
  var filteredCities = <Map<String, dynamic>>[].obs;
  Rx<LatLng> center = const LatLng(0, 0).obs; // Reactive center for current location
  Rx<LatLng> currentLocation = const LatLng(0, 0).obs; // Reactive current location
  RxSet<Marker> markers = <Marker>{}.obs; // Reactive set for all markers

  late GoogleMapController mapController;

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  // Fetch current location
  Future<void> getLocation() async {
    await GlobalService.getCurrentPosition();
    double latitude1 = GlobalService.currentLocation!.latitude;
    double longitude1 = GlobalService.currentLocation!.longitude;
    debugPrint('current latitude: $latitude1');
    debugPrint('current longitude: $longitude1');
    center.value = LatLng(latitude1, longitude1);
    currentLocation.value = LatLng(latitude1, longitude1);
  }

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

  Future<void> foundedThings({
    required String categoriesId,
    // required String name,
}) async {
    try {
      isLoading.value = true;
      findingThings.clear();
      resetIndex();
      isLastItemShown.value = false;
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

  // Resets the index for a new search
  void resetIndex() {
    currentItemIndex.value = 0;
  }

  // Function to move to the next item in the list
  void showNextThing() {
    if (currentItemIndex.value < findingThings.length - 1) {
      currentItemIndex.value++;
    } else {
      // currentItemIndex.value = 0; // Optionally reset to start again
      isLastItemShown.value = true;
    }
  }

  Future<void> fetchThings() async {
    try {
      mapLoading.value = true;
      await GlobalService.getCurrentPosition();
      userID = (prefs.getString('users_customers_id').toString());
      double latitude1 = GlobalService.currentLocation!.latitude;
      double longitude1 = GlobalService.currentLocation!.longitude;
      debugPrint("userID $userID");
      debugPrint('current latitude: $latitude1');
      debugPrint('current longitude: $longitude1');
      Map<String, String> data = {
        "users_customers_id": userID.toString(),
        "current_longitude": longitude1.toString(),
        "current_lattitude": latitude1.toString(),
      };
      debugPrint("data $data");
      final response = await http.post(
        Uri.parse(thingsApiUrl),
        headers: {'Accept': 'application/json'},
        body: data,
      );

      var thingsData = jsonDecode(response.body);
      debugPrint("thingsData $thingsData");
      if (thingsData['status'] == 'success') {
        markers.clear();
        // Add current location marker
        markers.add(
          Marker(
            markerId: const MarkerId("CurrentLocation"),
            position: currentLocation.value,
            infoWindow: const InfoWindow(title: "My Location"),
          ),
        );
        // Add markers for things
        for (var thing in thingsData['data']) {
          if (thing['lattitude'] != null && thing['longitude'] != null) {
            double lat = double.tryParse(thing['lattitude'].toString()) ?? 0.0;
            double lng = double.tryParse(thing['longitude'].toString()) ?? 0.0;
            // Check if user_distance is available and <= 5 km
            double? userDistance = double.tryParse(thing['user_distance'].toString()) ?? double.infinity;
            String? radiusStr = prefs.getString('radius');
            double radius = radiusStr != null ? double.tryParse(radiusStr) ?? 5.0 : 5.0;
            debugPrint("radius :: $radius");

            if (lat != 0.0 && lng != 0.0 && userDistance <= radius) {
              markers.add(
                Marker(
                  markerId: MarkerId(thing['things_id'].toString()),
                  position: LatLng(lat, lng),
                  infoWindow: InfoWindow(
                    title: thing['name'],
                  ),
                ),
              );
            }
          }
        }
      } else {
        debugPrint("Failed to fetch things");
      }
    } catch (e) {
      debugPrint("Error $e");
    } finally {
      mapLoading.value = false;
    }
  }

}