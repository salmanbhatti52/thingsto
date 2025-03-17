import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:thingsto/Controllers/notifications_controller.dart';
import 'package:thingsto/Controllers/translation_service.dart';
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

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    notificationsController.getNotificationsThings();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      notificationsController.getNotificationsThings(loadMore: true);
    }
  }

  final TranslationService translationService = Get.put(TranslationService());

  Future<String> translateText(String text) async {
    return await translationService.translateText(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Column(
        children: [
          BackButtonBar(
            title: "notifications",
            bottomPad: 15,
            onBack: () {
              Get.back();
            },
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Obx(() {
                if (notificationsController.isLoading.value &&
                    notificationsController.notifications.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Column(
                      children: List.generate(5, (index) => Shimmers2(
                        width: Get.width,
                        height: Get.height * 0.12,
                      )),
                    ),
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
                if (notificationsController.notifications.isEmpty) {
                  return const Center(
                    child: LabelField(
                      text: 'notifications_not_found',
                      fontSize: 18,
                    ),
                  );
                }
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  controller: _scrollController,
                  physics: const ScrollPhysics(),
                  itemCount: notificationsController.notifications.length +
                      (notificationsController.isLoading.value ? 1 : 0),
                  itemBuilder: (BuildContext context, i) {
                    if (i == notificationsController.notifications.length) {
                      return _buildShimmerTile();
                    }
              
                    int reversedIndex = notificationsController.notifications.length - 1 - i;
                    final notification = notificationsController.notifications[reversedIndex];
                    return _buildNotificationTile(notification);
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerTile() {
    return Shimmers2(
      width: Get.width,
      height: Get.height * 0.12,
    );
  }

  Widget _buildNotificationTile(Map<String, dynamic> notification) {
    final senderData = notification["sender_data"] ?? {};
    final formattedDate = _formatDate(notification['date_added']);

    return GestureDetector(
      onTap: () {
        // Handle tap action
      },
      child: Container(
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
            children: [
              senderData["profile_picture"] != null &&
                  senderData['profile_picture'] != ""
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  '$baseUrlImage${senderData['profile_picture']}',
                  fit: BoxFit.fill,
                  width: 84,
                  height: 84,
                ),
              )
                  : ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  AppAssets.dummyPic,
                  fit: BoxFit.fill,
                  width: 84,
                  height: 84,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0, top: 7),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LabelField(
                        text: notification["sender_type"] != "Admin"
                            ? "${senderData["sur_name"]}"
                            : "Admin",
                        fontSize: 19,
                        color: const Color(0xff080C2F),
                      ),
                      FutureBuilder<String>(
                        future: translateText(notification["message"]),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return LabelField(
                              text: notification["message"],
                              fontWeight: FontWeight.w500,
                              align: TextAlign.left,
                              maxLIne: 2,
                            );
                          } else if (snapshot.hasError) {
                            return LabelField(
                              text: notification["message"],
                              fontWeight: FontWeight.w500,
                              align: TextAlign.left,
                              maxLIne: 2,
                            );
                          } else {
                            return LabelField(
                              text: snapshot.data ?? notification["message"],
                              fontWeight: FontWeight.w500,
                              align: TextAlign.left,
                              maxLIne: 2,
                            );
                          }
                        },
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