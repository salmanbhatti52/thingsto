import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class TranslationService extends GetxController {
  static const String apiKey = "AIzaSyCl2SWUH5dWbv7VDO9wKaP335h_aIPmX5w";
  static const String url = "https://translation.googleapis.com/language/translate/v2";

  final box = GetStorage();
  RxString currentLanguage = 'en'.obs; // Reactive variable for language

  @override
  void onInit() {
    super.onInit();
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
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
    box.write('languageCode', languageCode); // Also store in GetStorage

    update(); // Notify listeners
    print("Language changed to: $languageCode");
  }

  Future<String> translateText(String text) async {
    String languageCode = box.read('languageCode') ?? 'en';
    String cacheKey = "$text-$languageCode"; // Unique key for caching

    if (box.hasData(cacheKey)) {
      return box.read(cacheKey); // Return cached translation
    }

    try {
      final response = await http.post(
        Uri.parse("$url?key=$apiKey"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "q": text,
          "target": languageCode,
        }),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        String translatedText = data["data"]["translations"][0]["translatedText"];
        box.write(cacheKey, translatedText); // Cache result
        return translatedText;
      } else {
        print("Translation API Error: ${response.body}");
        return text;
      }
    } catch (e) {
      print("Error: $e");
      return text;
    }
  }
}
