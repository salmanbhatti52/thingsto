import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thingsto/Utills/apis_urls.dart';
import 'package:thingsto/Utills/const.dart';
import 'package:http/http.dart' as http;

class NotificationsController extends GetxController {
  var isLoading = false.obs;
  var isError = false.obs;
  var notifications = [].obs;

  var cachedNotifications = [].obs;
  var isDataLoadedNotifications = false.obs;

  /* Get Notifications Function */

  getNotificationsThings() async {
    try {
      isLoading.value = true;
      userID = (prefs.getString('users_customers_id').toString());
      debugPrint("userID $userID");
      Map<String, String> data = {
        "users_customers_id": userID.toString(),
      };
      debugPrint("data $data");
      final response = await http.post(Uri.parse(notificationsApiUrl),
          headers: {'Accept': 'application/json'}, body: data);

      var notificationsData = jsonDecode(response.body);
      debugPrint("notificationsData $notificationsData");
      if (notificationsData['status'] == 'success') {
        var data = jsonDecode(response.body)['data'] as List;
        notifications.value = data;
        cachedNotifications.value = data;
        isDataLoadedNotifications.value = true;
      } else {
        debugPrint(notificationsData['status']);
        isError.value = true;
      }
    } catch (e) {
      debugPrint("Error $e");
    } finally {
      isLoading.value = false;
    }
  }

}