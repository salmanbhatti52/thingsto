import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:thingsto/Screens/BottomNavigationBar/bottom_nav_bar.dart';
import 'package:thingsto/Utills/apis_urls.dart';
import 'package:thingsto/Utills/const.dart';
import 'package:thingsto/Utills/global.dart';
import 'package:thingsto/Widgets/snackbar.dart';

class AddThingsController extends GetxController {
  var isLoading = false.obs;
  var isError = false.obs;
  var categoriesAll = [].obs;
  var categories = [].obs;
  var subcategories = [].obs;
  final ImagePicker _picker = ImagePicker();
  var imageFiles = <XFile>[].obs;
  var base64Images = <String>[].obs;
  RxList<String> tags = <String>[].obs;

  void addTag(String tag) {
    if (tag.isNotEmpty) {
      tags.add(tag);
    }
  }

  Future<void> pickImages() async {
    final List<XFile> pickedFiles = await _picker.pickMultiImage(
      maxWidth: 1000,
      maxHeight: 1000,
      imageQuality: 85,
    );

    if (pickedFiles.isNotEmpty) {
      if (pickedFiles.length > 5) {
        CustomSnackbar.show(title: "Error", message: "You can only select up to 5 images.");
      } else {
        imageFiles.value = pickedFiles;
        // base64Images.value = pickedFiles.map((file) {
        //   final bytes = File(file.path).readAsBytesSync();
        //   return base64Encode(bytes);
        // }).toList();
        // debugPrint("base64Images $base64Images");
        for (XFile file in pickedFiles) {
          File imageFile = File(file.path);
          List<int> imageBytes = await imageFile.readAsBytes();
          String base64String = base64Encode(imageBytes);
          base64Images.add(base64String);
          debugPrint("Base64 Image: $base64String");
        }
      }
    }
  }

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

  /* Add Things Function */

  addThings({
    required String categoriesId,
    required String name,
    required String earnPoints,
    required String location,
    required String longitude,
    required String lattitude,
    required String country,
    required String state,
    required String city,
    required String postCode,
    required String sourcesLinks,
    required String confirmModerator,
    required String description,
  }) async {
    try {
      isLoading.value = true;
      userID = (prefs.getString('users_customers_id').toString());
      googleApiKey = (prefs.getString('geo_api_key').toString());
      debugPrint("userID $userID");
      debugPrint("googleApiKey $googleApiKey");

      Map<String, String> tagsMap = {};
      for (int i = 0; i < tags.length; i++) {
        tagsMap[i.toString()] = tags[i];
      }

      Map<String, String> imagesMap = {};
      for (int i = 0; i < base64Images.length; i++) {
        imagesMap[i.toString()] = base64Images[i];
      }

      Map<String, String> data = {
        "users_customers_id": userID.toString(),
        "categories_id": categoriesId,
        "name": name,
        "earn_points": earnPoints,
        "location": location,
        "longitude":  longitude,
        "lattitude": lattitude,
        "google_place_id": googleApiKey.toString(),
        "country": country,
        "state": state,
        "city": city,
        "post_code": postCode,
        "sources_links": sourcesLinks,
        "confirm_by_moderator": confirmModerator,
        "description": description,
        "tags": jsonEncode(tagsMap),
        "images": jsonEncode(imagesMap),
      };
      debugPrint("data $data");
      final response = await http.post(Uri.parse(thingsAddApiUrl),
          headers: {'Accept': 'application/json'}, body: data);

      var addThingsData = jsonDecode(response.body);
      debugPrint("addThingsData $addThingsData");
      if (addThingsData['status'] == 'success') {
        var message = addThingsData['message'];
        CustomSnackbar.show(
          title: 'Success',
          message: message.toString(),
        );
        Get.off(
              () => const MyBottomNavigationBar(initialIndex: 4,),
          duration: const Duration(milliseconds: 350),
          transition: Transition.downToUp,
        );
      } else {
        debugPrint(addThingsData['status']);
        var errorMsg = addThingsData['message'];
        CustomSnackbar.show(
          title: 'Error',
          message: errorMsg.toString(),
        );
      }
    } catch (e) {
      debugPrint("Error $e");
    } finally {
      isLoading.value = false;
    }
  }


}