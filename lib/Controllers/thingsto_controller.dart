import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Utills/apis_urls.dart';
import 'package:thingsto/Utills/const.dart';
import 'package:thingsto/Utills/global.dart';
import 'package:thingsto/Widgets/snackbar.dart';

class ThingstoController extends GetxController {
  var isLoading = false.obs;
  var isLoading1 = false.obs;
  var isError = false.obs;
  var isSubLoading = false.obs;
  var categories = [].obs;
  var subcategories = [].obs;
  var thingsto = [].obs;
  var members = [].obs;
  var totalLikes = 0.obs;
  var isLiked = false.obs;
  var isValidate = false.obs;
  var topThingsto = [].obs;
  var findingThings = [].obs;
  var hasRunFoundedThings = false.obs;
  Rx<CroppedFile?> imageFile = Rx<CroppedFile?>(null);
  RxString base64Image = RxString("");
  var moderateCheck = false.obs;

  var cachedCategories = [].obs;
  var isDataLoadedCategories = false.obs;
  var cachedThingsto = [].obs;
  var isDataLoadedThingsto = false.obs;
  var cachedTopThingsto = [].obs;
  var isDataLoadedTopThingsto = false.obs;

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
        cachedCategories.value = data;
        isDataLoadedCategories.value = true;
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
    required String checkValue,
  }) async {
    try {
      isLoading.value = true;
      hasRunFoundedThings.value = false;
      // await GlobalService.getCurrentPosition();
      // userID = (prefs.getString('users_customers_id').toString());
      // double latitude1 = GlobalService.currentLocation!.latitude;
      // double longitude1 = GlobalService.currentLocation!.longitude;
      // debugPrint("userID $userID");
      // debugPrint('current latitude: $latitude1');
      // debugPrint('current longitude: $longitude1');
      // Map<String, String> data = {
      //   "users_customers_id": userID.toString(),
      //   "current_longitude":  longitude1.toString(),
      //   "current_lattitude": latitude1.toString(),
      // };
      // debugPrint("data $data");
      final response = await http.get(Uri.parse(thingsGetApiUrl));
          // headers: {'Accept': 'application/json'}, body: data);

      var thingstoData = jsonDecode(response.body);
      debugPrint("thingstoData $thingstoData");
      if (response.statusCode == 200) {
        var thingsData = jsonDecode(response.body);
        debugPrint("thingsData $thingsData");

        if (thingsData is Map && thingsData['status'] == 'success') {
          var data = thingsData['data'];
          if (data is List) {
            List<dynamic> getThings = data.map((item) {
              if (item is Map) {
                return item['things'];
              }
              return null;
            }).where((item) => item != null).toList();
            var filteredData = getThings.where((thing) {
              var validaters = thing['things_validated'] as List;
              return !validaters.any((validator) => validator['validaters_id'].toString() == userID.toString() && validator['status'].toString() == "Validate");
            }).toList();
            if(checkValue == "Yes"){
              thingsto.value = getThings;
              findingThings.value = thingsto;
              debugPrint("findingThings $findingThings");
              debugPrint("thingsto $thingsto");
              Get.back();
            }
            cachedThingsto.value = filteredData;
            isDataLoadedThingsto.value = true;
          } else {
            throw Exception("Invalid data format for 'data'");
          }
        } else {
          debugPrint("Status not success: ${thingsData['status']}");
          isError.value = true;
        }
      } else {
        debugPrint("HTTP Error: ${response.statusCode}");
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
      // await GlobalService.getCurrentPosition();
      // double latitude1 = GlobalService.currentLocation!.latitude;
      // double longitude1 = GlobalService.currentLocation!.longitude;
      // debugPrint('current latitude: $latitude1');
      // debugPrint('current longitude: $longitude1');
      // Map<String, String> data = {
      //   "users_customers_id": usersCustomersId,
      //   "current_longitude":  longitude1.toString(),
      //   "current_lattitude": latitude1.toString(),
      // };
      // debugPrint("data $data");
      final response = await http.get(Uri.parse(thingsTopGetApiUrl));
          // headers: {'Accept': 'application/json'}, body: data);

      var topThingstoData = jsonDecode(response.body);
      debugPrint("TopThingstoData $topThingstoData");
      if (topThingstoData['status'] == 'success') {
        var data = jsonDecode(response.body)['data'] as List;
        var filteredData = data.where((thing) {
          var validaters = thing['things_validated'] as List;
          return !validaters.any((validator) => validator['validaters_id'].toString() == usersCustomersId && validator['status'].toString() == "Validate");
        }).toList();
        topThingsto.value = data;
        cachedTopThingsto.value = data;
        isDataLoadedTopThingsto.value = true;

        // topThingsto.value = data;
        // cachedTopThingsto.value = data;
        // isDataLoadedTopThingsto.value = true;
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

  /* Get Search Members Function */

  searchMembers({
    required String search,
    required String name,
  }) async {
    try {
      isLoading.value = true;
      Map<String, String> data = {
        "search": search,
        "name": name,
      };
      debugPrint("data $data");
      final response = await http.post(Uri.parse(searchMembersApiUrl),
          headers: {'Accept': 'application/json'}, body: data);

      var searchData = jsonDecode(response.body);
      debugPrint("searchData $searchData");
      if (searchData['status'] == 'success') {
        var data = jsonDecode(response.body)['data'] as List;
          members.value = data;
          debugPrint("members $members");
      } else {
        debugPrint(searchData['status']);
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

      var likeData = jsonDecode(response.body);
      debugPrint("likeData $likeData");
      if (likeData['status'] == 'success') {
        totalLikes.value = likeData['data']['total_likes'];
        isLiked.value = !isLiked.value;
      } else {
        debugPrint(likeData['status']);
        // isLiked.value = !isLiked.value;
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

  /* Get Founded Things Function */

  foundedThings({
    required String categoriesId,
    required String country,
    required String city,
    required String distances,
    required String checkValue2,
    required String backValue,
    required String categoryThings,
  }) async {
    try {
      isLoading1.value = true;
      findingThings.clear();
      if (checkValue2 == "Yes") {
        Get.back();
      } else {
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
          "city": city.toString(),
          "country": country.toString(),
          "distance": distances.toString(),
        };
        Map<String, String> categoryData = {
          "users_customers_id": userID.toString(),
          "categories_id": categoriesId.toString(),
        };
        categoryThings == "Yes" ? debugPrint("categoryData $categoryData") : debugPrint("data $data");
        final response = await http.post(Uri.parse(categoryThings == "Yes" ? thingsByCategoryApiUrl : thingsSearchApiUrl),
            headers: {'Accept': 'application/json'}, body: categoryThings == "Yes" ? categoryData : data);

        var searchThingstoData = jsonDecode(response.body);
        debugPrint("searchThingstoData $searchThingstoData");
        hasRunFoundedThings.value = true;
        if (searchThingstoData['status'] == 'success') {
          var data = jsonDecode(response.body)['data'] as List;
          findingThings.value = data;
          backValue == "Yes" ? Get.back() : null;
        } else {
          debugPrint(searchThingstoData['status']);
          var errorMsg = searchThingstoData['message'];
          CustomSnackbar.show(
            title: '',
            message: errorMsg.toString(),
          );
        }
      }
    } catch (e) {
      debugPrint("Error $e");
    } finally {
      isLoading1.value = false;
    }
  }

  /* Validate Things Function */

  Future<void> imagePick() async {
    final picker = ImagePicker();
    XFile? pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedImage != null) {
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

  Future<void> validateThings(String thingId, String things, ctx) async {
    try {
      isLoading1.value = true;
      String userID = (prefs.getString('users_customers_id').toString());
      debugPrint("userID $userID");
      Map<String, String> data = {
        "validaters_id": userID.toString(),
        "things_id": thingId.toString(),
      };
      debugPrint("data $data");
      final response = await http.post(Uri.parse(thingsValidateApiUrl),
          headers: {'Accept': 'application/json'}, body: data);

      var validateData = jsonDecode(response.body);
      debugPrint("validateData $validateData");
      if (validateData['status'] == 'success') {
        // totalLikes.value = validateData['data']['total_likes'];
        isValidate.value = !isValidate.value;
        things == "thingsto" ? getThingsto(checkValue: "No") :  getTopThingsto(usersCustomersId: userID.toString());
        Get.back();
        CustomSnackbar.show(title: "Success", message: "Things Validated");
        showSuccessAnimation(ctx);
      } else {
        debugPrint(validateData['status']);
      }
    } catch (e) {
      debugPrint("Error $e");
    } finally {
  isLoading1.value = false;
  }
  }

  Future<void> validateThingsWithProof(String thingId, String things, String proof, ctx) async {
    try {
      isLoading1.value = true;
      var headersList = {
        'Accept': '*/*',
        'Content-Type': 'application/json'
      };
      var url = Uri.parse(thingsValidateApiUrl);

      String userID = (prefs.getString('users_customers_id').toString());
      debugPrint("userID $userID");

      List<Map<String, String>> imagesList = [];

      if (proof.isNotEmpty) {
        String base64Image = proof;
        String mediaType = 'Image';
        String extension = 'jpg';
        imagesList.add({
          'base64_data': base64Image,
          'media_type': mediaType,
          'extension': extension,
        });
      }

      var data = {
        "validaters_id": userID,
        "things_id": thingId,
        "proof" : imagesList,
      };
      debugPrint("data $data");
      var req = http.Request('POST', url);
      req.headers.addAll(headersList);
      req.body = json.encode(data);
      var res = await req.send();
      final resBody = await res.stream.bytesToString();
      var validateData = jsonDecode(resBody);
      debugPrint("validateData $validateData");
      if (validateData['status'] == 'success') {
        imageFile.value = null;
        moderateCheck.value = false;
        // totalLikes.value = validateData['data']['total_likes'];
        // isValidate.value = !isValidate.value;
        things == "thingsto" ? getThingsto(checkValue: "No") :  getTopThingsto(usersCustomersId: userID.toString());
        Get.back();
        CustomSnackbar.show(title: "Success", message: "Things send to Validation");
        showSuccessAnimation(ctx);
        // Get.off(
        //       () => const MyBottomNavigationBar(initialIndex: 2,),
        //   duration: const Duration(milliseconds: 350),
        //   transition: Transition.downToUp,
        // );
      } else {
        debugPrint(validateData['status']);
      }
    } catch (e) {
      debugPrint("Error $e");
    } finally {
      isLoading1.value = false;
    }
  }

  void initializeThings(List<dynamic> validate) {
    String userID = (prefs.getString('users_customers_id').toString());
    debugPrint("userID $userID");
    isValidate.value = validate.any((validates) => validates['validaters_id'] == int.parse(userID));
  }

  void showSuccessAnimation(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Lottie.asset(
            'assets/animation/animation1.json', // your success animation file
            repeat: false,
            onLoaded: (composition) {
              Future.delayed(composition.duration, () {
                Navigator.of(context).pop(); // Dismiss the dialog
              });
            },
          ),
        );
      },
    );
  }

}
