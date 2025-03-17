import 'dart:ui';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'translation_service.dart';

class LanguageController extends GetxController {
  var currentLanguage = 'en'.obs;
  final TranslationService translationService = TranslationService();
  var translatedTexts = <String, String>{}.obs;

  @override
  void onInit() {
    loadLanguage();
    super.onInit();
  }

  Future<void> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedLanguage = prefs.getString('selected_language');

    if (savedLanguage != null) {
      currentLanguage.value = savedLanguage;
      Get.updateLocale(Locale(savedLanguage));
    }
  }

  Future<void> changeLanguage(String languageCode) async {
    currentLanguage.value = languageCode; // Update reactive variable
    Get.updateLocale(Locale(languageCode)); // Update app locale

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_language', languageCode);

    update(); // Notify listeners
    print("Language changed to: $languageCode");
  }

  Future<void> translateApiText(String key, String text) async {
    if (text.isNotEmpty && !translatedTexts.containsKey(key)) {
      // String translated = await translationService.translateText(text, currentLanguage.value);
      // translatedTexts[key] = translated;
      update(); // Ensure this is called to update the state
    }
  }

  String getTranslatedText(String key, String defaultText) {
    print("Fetching translation for key: $key, language: ${currentLanguage.value}");
    print("Translated texts: $translatedTexts");
    return translatedTexts[key] ?? defaultText;
  }

}
