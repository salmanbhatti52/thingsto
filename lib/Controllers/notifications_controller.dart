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
  var hasUnreadNotifications = false.obs;

  var cachedNotifications = [].obs;
  var isDataLoadedNotifications = false.obs;

  var currentPage = 1.obs;
  var isLastPage = false.obs;

  /* Get Notifications Function */

  Future<void> getNotificationsThings({bool loadMore = false}) async {
    if (isLoading.value || isLastPage.value) return;
    try {
      isLoading.value = true;
      userID = (prefs.getString('users_customers_id').toString());
      debugPrint("userID $userID");
      Map<String, String> data = {
        "users_customers_id": userID.toString(),
        "page": currentPage.value.toString(),
      };
      debugPrint("data $data");
      final response = await http.post(Uri.parse(notificationsApiUrl),
          headers: {'Accept': 'application/json'}, body: data);

      var notificationsData = jsonDecode(response.body);
      debugPrint("notificationsData $notificationsData");
      if (notificationsData['status'] == 'success') {
        var data = jsonDecode(response.body)['data'] as List;
        // notifications.value = data;
        // cachedNotifications.value = data;
        // isDataLoadedNotifications.value = true;
        if (data.isEmpty) {
          isLastPage.value = true;
        } else {
          if (loadMore) {
            notifications.addAll(data);
          } else {
            notifications.value = data;
          }
          currentPage.value += 1;
        }
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

  /* Get Notifications Read or Unread Function */

  getNotificationsAlert() async {
    try {
      isLoading.value = true;
      userID = (prefs.getString('users_customers_id').toString());
      debugPrint("userID $userID");
      Map<String, String> data = {
        "users_customers_id": userID.toString(),
      };
      debugPrint("data $data");
      final response = await http.post(Uri.parse(notificationsUnreadApiUrl),
          headers: {'Accept': 'application/json'}, body: data);

      var notificationsData = jsonDecode(response.body);
      debugPrint("notificationsData $notificationsData");
      if (notificationsData['status'] == 'success') {
        var data = notificationsData['data'] as Map<String, dynamic>;
        hasUnreadNotifications.value = int.parse(data['notifications_unread'].toString()) != 0;
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