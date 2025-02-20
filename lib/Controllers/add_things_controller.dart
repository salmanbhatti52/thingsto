import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Screens/BottomNavigationBar/bottom_nav_bar.dart';
import 'package:thingsto/Utills/apis_urls.dart';
import 'package:thingsto/Utills/const.dart';
import 'package:thingsto/Utills/global.dart';
import 'package:thingsto/Widgets/snackbar.dart';

class AddThingsController extends GetxController {
  var isLoading1 = false.obs;
  var selectCategory = 'All Categories'.obs;
  var selectCategoryId = ''.obs;
  var isLoading = false.obs;
  var isCountryLoading = false.obs;
  var isStateLoading = false.obs;
  var isCityLoading = false.obs;
  var isError = false.obs;
  var categoriesAll = <Map<String, dynamic>>[].obs;
  var categoriesP0 = <Map<String, dynamic>>[].obs;
  // var allCountries = [].obs;
  // var allStates = [].obs;
  // var allCities = [].obs;
  final ImagePicker _picker = ImagePicker();
  var imageFiles = <XFile>[].obs;
  var base64Images = <String>[].obs;
  var pickedFile = ''.obs;
  RxList<String> tags = <String>[].obs;
  RxList<String> links = <String>[].obs;
  RxList<Map<String, String>> audio = <Map<String, String>>[].obs;
  ValueNotifier<List<Map<String, dynamic>>> allCountries = ValueNotifier([]);
  // ValueNotifier<List<Map<String, dynamic>>> allStates = ValueNotifier([]);
  ValueNotifier<List<Map<String, dynamic>>> allCities = ValueNotifier([]);
  Rx<CroppedFile?> imageFile = Rx<CroppedFile?>(null);
  RxString base64Image = RxString("");

  /* Add and Delete Tags  Function */

  void addTag(String tag) {
    if (tag.isNotEmpty) {
      tags.add(tag);
    }
  }

  void deleteTag(int index) {
    if (index >= 0 && index < tags.length) {
      tags.removeAt(index);
    }
  }

  /* Add and Delete Links  Function */

  void addLink(String link) {
    if (link.isNotEmpty) {
      links.add(link);
    }
  }

  void deleteLink(int index) {
    if (index >= 0 && index < links.length) {
      links.removeAt(index);
    }
  }

  /* Add and Delete audio  Function */

  void addAudio(String link, String platform) {
    if (link.isNotEmpty) {
      audio.add({
        'link': link,
        'platform': platform,
      });
    }
  }

  void deleteAudio(int index) {
    if (index >= 0 && index < audio.length) {
      audio.removeAt(index);
    }
  }

  String processSpotifyUrl(String url) {
    // Regex for Spotify track URL (handles optional parameters after the track ID)
    final spotifyRegex = RegExp(r'spotify\.com/(?:intl-[a-z]{2}/)?track/([a-zA-Z0-9]+)');

    // Check if it's a Spotify URL
    if (spotifyRegex.hasMatch(url)) {
      // Extract the track ID using regex
      final match = spotifyRegex.firstMatch(url);
      String? trackId = match?.group(1);
      return trackId != null ? "https://open.spotify.com/embed/track/$trackId" : url;
    }

    // Regex for YouTube URLs (both youtu.be and youtube.com variations)
    final youtubeRegex = RegExp(
      r'(youtu\.be/|youtube\.com/watch\?v=|youtube\.com/embed/|youtube\.com/shorts/)([a-zA-Z0-9_-]+)',
    );

    // Check if it's a YouTube URL
    if (youtubeRegex.hasMatch(url)) {
      final match = youtubeRegex.firstMatch(url);
      String? videoId = match?.group(2);
      return videoId != null ? "https://www.youtube.com/embed/$videoId" : url;
    }

    // Show an error if the URL is not valid
    CustomSnackbar.show(
      title: "error",
      message: "valid_spotify_youtube_link",
    );

    return "";
  }




  /* Get thumbnail  Function */

  Future<void> imagePick() async {
    final picker = ImagePicker();
    XFile? pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedImage != null) {
      int imageSize = await pickedImage.length();
      if (imageSize > 10 * 1024 * 1024) { // 10 MB size limit
        CustomSnackbar.show(title: "error", message: "max_image_size");
        return;
      }
      await cropImage(pickedImage.path);
    }
  }

  Future<void> cropImage(String imagePath) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imagePath,
      maxWidth: 1800,
      maxHeight: 1800,
      cropStyle: CropStyle.rectangle,
      uiSettings: [
        AndroidUiSettings(
          initAspectRatio: CropAspectRatioPreset.ratio4x3,
          toolbarTitle: 'Upload',
          toolbarColor: AppColor.primaryColor,
          backgroundColor: AppColor.secondaryColor,
          showCropGrid: false,
          toolbarWidgetColor: AppColor.whiteColor,
          hideBottomControls: true,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          showActivitySheetOnDone: false,
          resetAspectRatioEnabled: false,
          title: 'Cropper',
          hidesNavigationBar: true,
        ),
      ],
    );
    if (croppedFile != null) {
      imageFile.value = croppedFile;
      await convertToBase64(croppedFile);
    }
  }

  Future<void> convertToBase64(CroppedFile croppedFile) async {
    List<int> imageBytes = await croppedFile.readAsBytes();
    String base64String = base64Encode(imageBytes);
    base64Image.value = base64String;
    debugPrint("base64Image ${base64Image.value}");
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
        CustomSnackbar.show(title: "error", message: "select_images_limit");
      } else {
        bool allFilesValid = true;
        for (var pickedFile in pickedFiles) {
          int imageSize = await pickedFile.length();
          if (imageSize > 10 * 1024 * 1024) {
            allFilesValid = false;
            CustomSnackbar.show(title: "error", message: "image_size_exceed");
            break;
          }
        }

        if (allFilesValid) {
          imageFiles.assignAll(pickedFiles);
          _convertImagesToBase64();
        }
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
      CustomSnackbar.show(title: "error", message: "something_wrong");
    }
  }

  /* Get All Category  Function */

  Future<void> getAllCategory({bool forceRefresh = false}) async {

    if (categoriesAll.isNotEmpty && !forceRefresh) {
      return;
    }

    try {
      isLoading1.value = categoriesAll.isNotEmpty ? false : true;
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
        var filteredData = data.where((category) => category['parent_id'] == 0).toList();
        categoriesP0.assignAll(filteredData.cast<Map<String, dynamic>>());
        categoriesAll.assignAll(data.cast<Map<String, dynamic>>());
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

  // getAllCountries() async {
  //   try {
  //     isLoading1.value = true;
  //     userID = (prefs.getString('users_customers_id').toString());
  //     debugPrint("userID $userID");
  //     await GlobalService.getCurrentPosition();
  //     double latitude1 = GlobalService.currentLocation!.latitude;
  //     double longitude1 = GlobalService.currentLocation!.longitude;
  //     debugPrint('current latitude: $latitude1');
  //     debugPrint('current longitude: $longitude1');
  //     Map<String, String> data = {
  //       "users_customers_id": userID.toString(),
  //       "current_longitude":  longitude1.toString(),
  //       "current_lattitude": latitude1.toString(),
  //     };
  //     debugPrint("data $data");
  //     final response = await http.post(Uri.parse(countriesApiUrl),
  //         headers: {'Accept': 'application/json'}, body: data);
  //
  //     var allCountriesData = jsonDecode(response.body);
  //     debugPrint("allCountriesData $allCountriesData");
  //     if (allCountriesData['status'] == 'success') {
  //       var data = jsonDecode(response.body)['data'] as List;
  //       allCountries.value = data;
  //     } else {
  //       debugPrint(allCountriesData['status']);
  //       isError.value = true;
  //     }
  //   } catch (e) {
  //     debugPrint("Error $e");
  //   } finally {
  //     isLoading1.value = false;
  //   }
  // }

  getAllCountries({
    required String categoryId,
  }) async {
    try {
      isCountryLoading.value = true;
      // userID = (prefs.getString('users_customers_id').toString());
      // debugPrint("userID $userID");
      // await GlobalService.getCurrentPosition();
      // double latitude1 = GlobalService.currentLocation!.latitude;
      // double longitude1 = GlobalService.currentLocation!.longitude;
      // debugPrint('current latitude: $latitude1');
      // debugPrint('current longitude: $longitude1');
      Map<String, String> data = {
        "categories_id": categoryId.toString(),
        // "current_longitude":  longitude1.toString(),
        // "current_lattitude": latitude1.toString(),
      };
      debugPrint("data $data");
      final response = await http.post(Uri.parse(countriesApiUrl),
          headers: {'Accept': 'application/json'}, body: data);

      var allCountriesData = jsonDecode(response.body);
      debugPrint("allCountriesData $allCountriesData");
      if (allCountriesData['status'] == 'success') {
        var dataMap = allCountriesData['data'];

        if (dataMap is Map && dataMap.containsKey('countries')) {
          var countries = dataMap['countries'] as List;
          allCountries.value = countries.map((item) => Map<String, dynamic>.from(item)).toList();
        } else {
          debugPrint('Countries field is missing or not a list: ${dataMap['countries']}');
          isError.value = true;
        }
      } else {
        debugPrint(allCountriesData['status']);
        isError.value = true;
      }
    } catch (e) {
      debugPrint("Error $e");
    } finally {
      isCountryLoading.value = false;
    }
  }

  /* Get All States  Function */

  // Future<void> getAllStates({
  //   required String countryId,
  // }) async {
  //   try {
  //     isStateLoading.value = true;
  //     await GlobalService.getCurrentPosition();
  //     double latitude1 = GlobalService.currentLocation!.latitude;
  //     double longitude1 = GlobalService.currentLocation!.longitude;
  //     debugPrint('current latitude: $latitude1');
  //     debugPrint('current longitude: $longitude1');
  //     Map<String, String> data = {
  //       "countries_id": countryId.toString(),
  //       "current_longitude":  longitude1.toString(),
  //       "current_lattitude": latitude1.toString(),
  //     };
  //     debugPrint("data $data");
  //     final response = await http.post(Uri.parse(statesApiUrl),
  //         headers: {'Accept': 'application/json'}, body: data);
  //
  //     var allStatesData = jsonDecode(response.body);
  //     debugPrint("allStatesData $allStatesData");
  //     if (allStatesData['status'] == 'success') {
  //       var data = (allStatesData['data'] as List)
  //           .map((item) => Map<String, dynamic>.from(item))
  //           .toList();
  //       allStates.value = data;
  //     } else {
  //       debugPrint(allStatesData['status']);
  //       isError.value = true;
  //     }
  //   } catch (e) {
  //     debugPrint("Error $e");
  //   } finally {
  //     isStateLoading.value = false;
  //   }
  // }

  /* Get All Cities  Function */

//   getAllCities({
//     required String stateId,
// }) async {
//     try {
//       isCityLoading.value = true;
//       await GlobalService.getCurrentPosition();
//       double latitude1 = GlobalService.currentLocation!.latitude;
//       double longitude1 = GlobalService.currentLocation!.longitude;
//       debugPrint('current latitude: $latitude1');
//       debugPrint('current longitude: $longitude1');
//       Map<String, String> data = {
//         "states_id": stateId.toString(),
//         "current_longitude":  longitude1.toString(),
//         "current_lattitude": latitude1.toString(),
//       };
//       debugPrint("data $data");
//       final response = await http.post(Uri.parse(citiesApiUrl),
//           headers: {'Accept': 'application/json'}, body: data);
//
//       var allCitiesData = jsonDecode(response.body);
//       debugPrint("allCitiesData $allCitiesData");
//       if (allCitiesData['status'] == 'success') {
//         var data = (allCitiesData['data'] as List)
//             .map((item) => Map<String, dynamic>.from(item))
//             .toList();
//         allCities.value = data;
//       } else {
//         debugPrint(allCitiesData['status']);
//         isError.value = true;
//       }
//     } catch (e) {
//       debugPrint("Error $e");
//     } finally {
//       isCityLoading.value = false;
//     }
//   }

  getAllCities({
    required String countryId,
}) async {
    try {
      isCityLoading.value = true;
      // await GlobalService.getCurrentPosition();
      // double latitude1 = GlobalService.currentLocation!.latitude;
      // double longitude1 = GlobalService.currentLocation!.longitude;
      // debugPrint('current latitude: $latitude1');
      // debugPrint('current longitude: $longitude1');
      Map<String, String> data = {
        "countries_id": countryId.toString(),
        // "current_longitude":  longitude1.toString(),
        // "current_lattitude": latitude1.toString(),
      };
      debugPrint("data $data");
      final response = await http.post(Uri.parse(citiesApiUrl),
          headers: {'Accept': 'application/json'}, body: data);

      var allCitiesData = jsonDecode(response.body);
      debugPrint("allCitiesData $allCitiesData");
      if (allCitiesData['status'] == 'success') {
        var dataMap = allCitiesData['data'];

        if (dataMap is Map && dataMap.containsKey('cities')) {
          var cities = dataMap['cities'] as List;
          allCities.value = cities.map((item) => Map<String, dynamic>.from(item)).toList();
        } else {
          debugPrint('Countries field is missing or not a list: ${dataMap['cities']}');
          isError.value = true;
        }
        // var data = (allCitiesData['data'] as List)
        //     .map((item) => Map<String, dynamic>.from(item))
        //     .toList();
        // allCities.value = data;
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

  void resetState() {
    var data2 = {
      imageFiles.clear(),
      base64Images.clear(),
      base64Image.value = '',
      imageFile.value = null,
      tags.clear(),
      links.clear(),
      audio.clear(),
      pickedFile.value == '',
    };
    debugPrint(" data $data2");
  }

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

      List<Map<String, String>> singleImagesList = [];

      if (base64Image.isNotEmpty) {
        String base64Img = base64Image.toString();
        String mediaType = 'Image';
        String extension = 'jpg';
        singleImagesList.add({
          'base64_data': base64Img,
          'media_type': mediaType,
          'extension': extension,
        });
      }

      List<Map<String, String>> imagesList = [];
      List<Map<String, String>> audioList = [];

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
      }
      if (audio.isNotEmpty){
        // for (int i = 0; i < audio.length; i++) {
        //   String base64Image = audio[i];
        //   // String mediaType = 'Image';
        //   // String extension = 'jpg';
        //   audioList.add({
        //     'link': base64Image,
        //     'media_platform ':
        //     // 'media_type': mediaType,
        //     // 'extension': extension,
        //   });
        // }
        for (var item in audio) {
          audioList.add({
            'link': item['link']!,
            'media_platform': item['platform']!,
          });
        }
        // if (pickedFile.value.isNotEmpty) {
        //   File audioFile = File(pickedFile.value);
        //   if (await audioFile.exists()) {
        //     List<int> audioBytes = await audioFile.readAsBytes();
        //     base64Audio = base64Encode(audioBytes);
        //     debugPrint("base64Audio $base64Audio");
        //   } else {
        //     debugPrint("Error: Audio file does not exist at ${pickedFile.value}");
        //   }
        // }
        // String base64Image = base64Audio;
        // String mediaType = 'Music';
        // String extension = 'mp3';
        // imagesList.add({
        //   'base64_data': base64Image,
        //   'media_type': mediaType,
        //   'extension': extension,
        // });

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
        "countries_id": countryId != null ? countryId.toString() : "",
        "states_id": "",
        "cities_id": cityId != null ? cityId.toString() : "",
        "sources": links,
        "confirm_by_moderator": confirmModerator.toString(),
        "description": description.toString(),
        "tags": tags,
        "images": imagesList,
        "musics": audioList,
        "thumbnail_images": singleImagesList,
      };

      debugPrint("Request Data: ${jsonEncode(data)}");
      var req = http.Request('POST', url);
      req.headers.addAll(headersList);
      req.body = json.encode(data);
      var res = await req.send();
      final resBody = await res.stream.bytesToString();
      var addThingsData = jsonDecode(resBody);
      debugPrint("addThingsData $addThingsData");
      debugPrint("resBody $resBody");
      if (addThingsData['status'] == 'success') {
        resetState();
        var message = addThingsData['message'];
        CustomSnackbar.show(
          title: 'success',
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
          title: 'error',
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