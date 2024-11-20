import 'package:easy_localization/easy_localization.dart';

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'email_required'.tr(); // Translated string
  }
  final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
  if (!emailRegex.hasMatch(value)) {
    return 'invalid_email_format'.tr(); // Translated string
  }
  return null;
}

String? validateNumber(String? value) {
  if (value == null || value.isEmpty) {
    return 'number_required'.tr();
  }

  final number = double.tryParse(value);
  if (number == null || number <= 0) {
    return 'number_required'.tr();
  }

  return null;
}


String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'password_required'.tr(); // Translated string
  }
  if (value.length < 6) {
    return 'password_length'.tr(); // Translated string
  }
  return null;
}

String? validateFName(String? value) {
  if (value == null || value.isEmpty) {
    return 'firstNameRequired'.tr();
  }
  return null;
}

String? validateLName(String? value) {
  if (value == null || value.isEmpty) {
    return 'lastNameRequired'.tr();
  }
  return null;
}

String? validateRCode(String? value) {
  if (value == null || value.isEmpty) {
    return 'referralCodeRequired'.tr();
  }
  return null;
}
