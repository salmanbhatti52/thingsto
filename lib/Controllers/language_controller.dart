import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:thingsto/Screens/BottomNavigationBar/bottom_nav_bar.dart';
import 'package:thingsto/Utills/apis_urls.dart';
import 'package:thingsto/Utills/const.dart';
import 'package:thingsto/Widgets/snackbar.dart';

class LanguageController extends GetxController {
  var isLoading = false.obs;
  var isLoading1 = false.obs;
  var phrases = {}.obs;
  var language = <String>[].obs;
  // var updateLanguage = [].obs;

  @override
  void onInit() {
    super.onInit();
    getSystemLanguages();
  }

  /* Get Languages  Function */

  getSystemLanguages() async {
    try {
      isLoading.value = true;
      final response = await http.get(Uri.parse(languagesApiUrl));

      var data = jsonDecode(response.body);
      debugPrint("languages $data");
      if (data['status'] == 'success') {
        language.value = List<String>.from(data['data']);
      } else {
        debugPrint(data['status']);
      }
    } catch (e) {
      debugPrint("Error $e");
    } finally {
      isLoading.value = false;
    }
  }

  /* Update Languages  Function */

  updateLanguages({
    required String language,
  }) async {
    try {
      isLoading1.value = true;
      userID = (prefs.getString('users_customers_id').toString());
      debugPrint("userId $userID");
      Map<String, String> data = {
        "users_customers_id": userID.toString(),
        "language": language.toString(),
      };
      debugPrint("data $data");
      final response = await http.post(Uri.parse(updateProfileLanguageApiUrl),
          headers: {'Accept': 'application/json'}, body: data);

      var languageUpdateData = jsonDecode(response.body);
      debugPrint("languageUpdateData $languageUpdateData");
      if (languageUpdateData['status'] == 'success') {
        // var data = jsonDecode(response.body)['data'] as List;
        // updateLanguage.value = data;
        CustomSnackbar.show(
          title: 'Success',
          message: "Language Update successfully.",
        );
        Get.off(
              () => const MyBottomNavigationBar(initialIndex: 0,),
          duration: const Duration(milliseconds: 350),
          transition: Transition.downToUp,
        );
      } else {
        debugPrint(languageUpdateData['status']);
        CustomSnackbar.show(
          title: 'Error',
          message: "Something wrong",
        );
      }
    } catch (e) {
      debugPrint("Error $e");
    } finally {
      isLoading1.value = false;
    }
  }

  /* Get Language Phrases  Function */

  languagesPhrase({
    required String language,
  }) async {
    try {
      isLoading1.value = true;
      Map<String, String> data = {
        "language": language.toString(),
      };
      debugPrint("data $data");
      final response = await http.post(Uri.parse(languagesPhrasesApiUrl),
          headers: {'Accept': 'application/json'}, body: data);

      var languagePhraseData = jsonDecode(response.body);
      debugPrint("languagePhraseData $languagePhraseData");
      if (languagePhraseData['status'] == 'success') {
        phrases.value = Map<String, String>.from(languagePhraseData['data']);
        // CustomSnackbar.show(
        //   title: 'Success',
        //   message: "Language applied successfully.",
        // );
        //
        // Get.off(
        //       () => const MyBottomNavigationBar(initialIndex: 0,),
        //   duration: const Duration(milliseconds: 350),
        //   transition: Transition.downToUp,
        // );
      } else {
        debugPrint(languagePhraseData['status']);
        // CustomSnackbar.show(
        //   title: 'Error',
        //   message: "Something wrong",
        // );
      }
    } catch (e) {
      debugPrint("Error $e");
    } finally {
      isLoading1.value = false;
    }
  }

}
