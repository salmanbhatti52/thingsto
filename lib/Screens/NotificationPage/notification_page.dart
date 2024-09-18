import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:thingsto/Controllers/notifications_controller.dart';
import 'package:thingsto/Resources/app_assets.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Utills/apis_urls.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';
import 'package:thingsto/Widgets/app_bar.dart';
import 'package:thingsto/Widgets/shimmer_effect.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {

  NotificationsController notificationsController = Get.put(
      NotificationsController());

  Future<void> getUser() async {
    if (notificationsController.isDataLoadedNotifications.value) {
      notificationsController.getNotificationsThings();
    } else {
      // Load data from the server
      notificationsController.getNotificationsThings();
    }
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Column(
        children: [
          BackButtonBar(
            title: "Notifications",
            bottomPad: 15,
            onBack: () {
              Get.back();
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: SizedBox(
              height: Get.height * 0.85,
              child: Obx(() {
                if (notificationsController.isLoading.value &&
                    notificationsController.cachedNotifications.isEmpty) {
                  return Column(
                    children: [
                      const SizedBox(height: 15,),
                      Shimmers2(
                        width: Get.width,
                        height: Get.height * 0.12,
                      ),
                      Shimmers2(
                        width: Get.width,
                        height: Get.height * 0.12,
                      ),
                      Shimmers2(
                        width: Get.width,
                        height: Get.height * 0.12,
                      ),
                      Shimmers2(
                        width: Get.width,
                        height: Get.height * 0.12,
                      ),
                      Shimmers2(
                        width: Get.width,
                        height: Get.height * 0.12,
                      ),
                    ],
                  );
                }
                // if (thingstoController.isError.value) {
                //   return const Center(
                //     child: Padding(
                //       padding: EdgeInsets.symmetric(vertical: 40.0),
                //       child: LabelField(
                //         text: "Things not found",
                //         fontSize: 21,
                //         color: AppColor.blackColor,
                //         interFont: true,
                //       ),
                //     ),
                //   );
                // }
                if (notificationsController.cachedNotifications.isEmpty) {
                  return const Center(
                    child: LabelField(
                      text: 'Notifications not found',
                      fontSize: 18,
                    ),
                  );
                }
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  physics: const ScrollPhysics(),
                  itemCount: notificationsController.cachedNotifications.length,
                  itemBuilder: (BuildContext context, i) {
                    final notifications = notificationsController.cachedNotifications[i];
                    Map<String, dynamic> senderData = notifications["sender_data"];
                    final dateAdded = notifications['date_added'];
                    final formattedDate = _formatDate(dateAdded);
                    return Container(
                      height: Get.height * 0.12,
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: AppColor.whiteColor,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          width: 1,
                          color: AppColor.borderColor,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(178, 178, 178, 0.2),
                            blurRadius: 30,
                            offset: Offset(0, 5),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            senderData["profile_picture"] != null && senderData['profile_picture'] != ""
                                ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                '$baseUrlImage${senderData['profile_picture']}',
                                fit: BoxFit.fill,
                                width: 84,
                                height: 84,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return SizedBox(
                                      width: 84,
                                      height: 84,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: AppColor.primaryColor,
                                          value: loadingProgress
                                              .expectedTotalBytes !=
                                              null
                                              ? loadingProgress
                                              .cumulativeBytesLoaded /
                                              loadingProgress
                                                  .expectedTotalBytes!
                                              : null,
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            )
                                : ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                AppAssets.dummyPic,
                                fit: BoxFit.fill,
                                width: 84,
                                height: 84,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return SizedBox(
                                      width: 84,
                                      height: 84,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: AppColor.primaryColor,
                                          value: loadingProgress
                                              .expectedTotalBytes !=
                                              null
                                              ? loadingProgress
                                              .cumulativeBytesLoaded /
                                              loadingProgress
                                                  .expectedTotalBytes!
                                              : null,
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 15.0, top: 7),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    LabelField(
                                      text: notifications["sender_type"] != "Admin"
                                          ? "${senderData["sur_name"]}"
                                          : "Admin",
                                      fontSize: 19,
                                      color: const Color(0xff080C2F),
                                    ),
                                    LabelField(
                                      text: notifications["message"],
                                      fontWeight: FontWeight.w500,
                                      align: TextAlign.left,
                                    ),
                                    LabelField(
                                      text: formattedDate,
                                      fontSize: 12,
                                      color: const Color(0xff080C2F),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
          SizedBox(
            height: Get.height * 0.01,
          ),
        ],
      ),
    );
  }
  String _formatDate(String dateStr) {
    final DateTime date = DateTime.parse(dateStr);
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime yesterday = today.subtract(const Duration(days: 1));

    if (date.isAfter(today)) {
      return 'Today';
    } else if (date.isAfter(yesterday)) {
      return 'Yesterday';
    } else {
      return DateFormat('dd MMM yyyy').format(date);
    }
  }
}