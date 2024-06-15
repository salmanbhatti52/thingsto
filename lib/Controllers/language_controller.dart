import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:thingsto/Screens/BottomNavigationBar/bottom_nav_bar.dart';
import 'package:thingsto/Utills/apis_urls.dart';
import 'package:thingsto/Widgets/snackbar.dart';

class LanguageController extends GetxController {
  var isLoading = false.obs;
  var isLoading1 = false.obs;
  var phrases = {}.obs;
  var language = <String>[].obs;

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
        CustomSnackbar.show(
          title: 'Success',
          message: "Language applied successfully.",
        );

        Get.off(
              () => const MyBottomNavigationBar(initialIndex: 0,),
          duration: const Duration(milliseconds: 350),
          transition: Transition.downToUp,
        );
      } else {
        debugPrint(languagePhraseData['status']);
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

}
