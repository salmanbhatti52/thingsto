import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
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
  var isLoading1 = false.obs;
  var isLoading = false.obs;
  var isStateLoading = false.obs;
  var isCityLoading = false.obs;
  var isError = false.obs;
  var categoriesAll = [].obs;
  var allCountries = [].obs;
  // var allStates = [].obs;
  // var allCities = [].obs;
  final ImagePicker _picker = ImagePicker();
  var imageFiles = <XFile>[].obs;
  var base64Images = <String>[].obs;
  var pickedFile = ''.obs;
  RxList<String> tags = <String>[].obs;
  RxList<String> links = <String>[].obs;
  ValueNotifier<List<Map<String, dynamic>>> allStates = ValueNotifier([]);
  ValueNotifier<List<Map<String, dynamic>>> allCities = ValueNotifier([]);

  /* Add Tags  Function */

  void addTag(String tag) {
    if (tag.isNotEmpty) {
      tags.add(tag);
    }
  }

  /* Add Links  Function */

  void addLink(String link) {
    if (link.isNotEmpty) {
      links.add(link);
    }
  }

  /* Get Image  Function */

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
        imageFiles.assignAll(pickedFiles);
        _convertImagesToBase64();
      }
    }
  }

  Future<void> _convertImagesToBase64() async {
    try {
      base64Images.clear();
      List<Future<void>> conversions = [];
      for (var imageFile in imageFiles) {
        conversions.add(_convertImageToBase64(imageFile));
      }
      await Future.wait(conversions);
      debugPrint('Base64 Images: $base64Images');
    } catch (e) {
      debugPrint("Error converting images to base64: $e");
    }
  }

  Future<void> _convertImageToBase64(XFile imageFile) async {
    try {
      Uint8List bytes = await imageFile.readAsBytes();
      String base64Image = base64Encode(bytes);
      debugPrint('Image: $base64Image');
      base64Images.add(base64Image);
    } catch (e) {
      debugPrint("Error converting image to base64: $e");
    }
  }

  /* Get Audio  Function */

  Future<void> pickAudioFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );

    if (result != null) {
      pickedFile.value = result.files.single.path!;
    } else {
      CustomSnackbar.show(title: "Error", message: "Something Wrong");
    }
  }

  /* Get All Category  Function */

  getAllCategory() async {
    try {
      isLoading1.value = true;
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
      } else {
        debugPrint(allCategoryData['status']);
        isError.value = true;
      }
    } catch (e) {
      debugPrint("Error $e");
    } finally {
      isLoading1.value = false;
    }
  }

  /* Get All Countries  Function */

  getAllCountries() async {
    try {
      isLoading1.value = true;
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
      final response = await http.post(Uri.parse(countriesApiUrl),
          headers: {'Accept': 'application/json'}, body: data);

      var allCountriesData = jsonDecode(response.body);
      debugPrint("allCountriesData $allCountriesData");
      if (allCountriesData['status'] == 'success') {
        var data = jsonDecode(response.body)['data'] as List;
        allCountries.value = data;
      } else {
        debugPrint(allCountriesData['status']);
        isError.value = true;
      }
    } catch (e) {
      debugPrint("Error $e");
    } finally {
      isLoading1.value = false;
    }
  }

  /* Get All States  Function */

  Future<void> getAllStates({
    required String countryId,
  }) async {
    try {
      isStateLoading.value = true;
      await GlobalService.getCurrentPosition();
      double latitude1 = GlobalService.currentLocation!.latitude;
      double longitude1 = GlobalService.currentLocation!.longitude;
      debugPrint('current latitude: $latitude1');
      debugPrint('current longitude: $longitude1');
      Map<String, String> data = {
        "countries_id": countryId.toString(),
        "current_longitude":  longitude1.toString(),
        "current_lattitude": latitude1.toString(),
      };
      debugPrint("data $data");
      final response = await http.post(Uri.parse(statesApiUrl),
          headers: {'Accept': 'application/json'}, body: data);

      var allStatesData = jsonDecode(response.body);
      debugPrint("allStatesData $allStatesData");
      if (allStatesData['status'] == 'success') {
        var data = (allStatesData['data'] as List)
            .map((item) => Map<String, dynamic>.from(item))
            .toList();
        allStates.value = data;
      } else {
        debugPrint(allStatesData['status']);
        isError.value = true;
      }
    } catch (e) {
      debugPrint("Error $e");
    } finally {
      isStateLoading.value = false;
    }
  }

  /* Get All Cities  Function */

  getAllCities({
    required String stateId,
}) async {
    try {
      isCityLoading.value = true;
      await GlobalService.getCurrentPosition();
      double latitude1 = GlobalService.currentLocation!.latitude;
      double longitude1 = GlobalService.currentLocation!.longitude;
      debugPrint('current latitude: $latitude1');
      debugPrint('current longitude: $longitude1');
      Map<String, String> data = {
        "states_id": stateId.toString(),
        "current_longitude":  longitude1.toString(),
        "current_lattitude": latitude1.toString(),
      };
      debugPrint("data $data");
      final response = await http.post(Uri.parse(citiesApiUrl),
          headers: {'Accept': 'application/json'}, body: data);

      var allCitiesData = jsonDecode(response.body);
      debugPrint("allCitiesData $allCitiesData");
      if (allCitiesData['status'] == 'success') {
        var data = (allCitiesData['data'] as List)
            .map((item) => Map<String, dynamic>.from(item))
            .toList();
        allCities.value = data;
      } else {
        debugPrint(allCitiesData['status']);
        isError.value = true;
      }
    } catch (e) {
      debugPrint("Error $e");
    } finally {
      isCityLoading.value = false;
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
    required String countryId,
    required String stateId,
    required String cityId,
    required String placeId,
    required String confirmModerator,
    required String description,
  }) async {
    try {
      isLoading.value = true;

      var headersList = {
        'Accept': '*/*',
        'Content-Type': 'application/json'
      };
      var url = Uri.parse(thingsAddApiUrl);


      userID = (prefs.getString('users_customers_id').toString());
      debugPrint("userID $userID");

      // Map<String, String> imagesMap = {};
      // for (int i = 0; i < base64Images.length; i++) {
      //   imagesMap[i.toString()] = base64Images[i];
      // }

      List<Map<String, String>> imagesList = [];

      String base64Audio = '';
      if(base64Images.isNotEmpty) {
        for (int i = 0; i < base64Images.length; i++) {
          String base64Image = base64Images[i];
          String mediaType = 'Image';
          String extension = 'jpg';
          imagesList.add({
            'base64_data': base64Image,
            'media_type': mediaType,
            'extension': extension,
          });
        }
      } else {
        if (pickedFile.value.isNotEmpty) {
          File audioFile = File(pickedFile.value);
          if (await audioFile.exists()) {
            List<int> audioBytes = await audioFile.readAsBytes();
            base64Audio = base64Encode(audioBytes);
            debugPrint("base64Audio $base64Audio");
          } else {
            debugPrint("Error: Audio file does not exist at ${pickedFile.value}");
          }
        }
        String base64Image = base64Audio;
        String mediaType = 'Music';
        String extension = 'mp3';
        imagesList.add({
          'base64_data': base64Image,
          'media_type': mediaType,
          'extension': extension,
        });
      }


      var data = {
        "users_customers_id": userID,
        "categories_id": categoriesId.toString(),
        "name": name.toString(),
        "earn_points": earnPoints.toString(),
        "location": location.toString(),
        "longitude": longitude.toString(),
        "lattitude": lattitude.toString(),
        "google_place_id": placeId.toString(),
        "countries_id": countryId.toString(),
        "states_id": stateId.toString(),
        "cities_id": cityId.toString(),
        "sources_links": links,
        "confirm_by_moderator": confirmModerator.toString(),
        "description": description.toString(),
        "tags": tags,
        "images": imagesList,
      };

      debugPrint("data $data");
      var req = http.Request('POST', url);
      req.headers.addAll(headersList);
      req.body = json.encode(data);
      var res = await req.send();
      final resBody = await res.stream.bytesToString();
      var addThingsData = jsonDecode(resBody);
      debugPrint("addThingsData $addThingsData");
      if (addThingsData['status'] == 'success') {
        var message = addThingsData['message'];
        CustomSnackbar.show(
          title: 'Success',
          message: message.toString(),
        );
        Get.off(
              () => const MyBottomNavigationBar(initialIndex: 3,),
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