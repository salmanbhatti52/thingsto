import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:thingsto/Resources/app_assets.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Screens/AddPage/add_page.dart';
import 'package:thingsto/Screens/HomePages/home_page.dart';
import 'package:thingsto/Screens/ProfilePage/profile_page.dart';
import 'package:thingsto/Screens/RankingPages/rank_page.dart';
import 'package:thingsto/Screens/ThingstoPages/thingsto_page.dart';

class MyBottomNavigationBar extends StatefulWidget {
  final int initialIndex;
  const MyBottomNavigationBar({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<MyBottomNavigationBar> createState() => MyBottomNavigationBarState();
}

class MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  late List pages;
  int currentIndex = 0;

  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    pages = [
      HomePage(),
      const RankPage(),
      const ThingstoPage(),
      const AddPage(),
      const ProfilePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Container(
        child: pages[currentIndex],
      ),
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height * 0.078,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: AppColor.whiteColor,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(10),
            topLeft: Radius.circular(10),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x19000000),
              blurRadius: 20.7,
              offset: Offset(0, -4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(10),
            topLeft: Radius.circular(10),
          ),
          child: BottomNavigationBar(
            onTap: onTap,
            currentIndex: currentIndex,
            backgroundColor: AppColor.whiteColor,
            elevation: 0,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedItemColor: AppColor.primaryColor,
            type: BottomNavigationBarType.fixed,
            unselectedItemColor: AppColor.hintColor,
            items: [
              BottomNavigationBarItem(
                icon: SvgPicture.asset(AppAssets.home),
                activeIcon: SvgPicture.asset(
                  AppAssets.home,
                  color: AppColor.primaryColor,
                ),
                label: (""),
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(AppAssets.union),
                activeIcon: SvgPicture.asset(
                  AppAssets.union,
                  color: AppColor.primaryColor,
                ),
                label: (""),
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  AppAssets.tLogo,
                  width: Get.width * 0.065,
                ),
                activeIcon: SvgPicture.asset(
                  AppAssets.tLogo,
                  width: Get.width * 0.065,
                  color: AppColor.primaryColor,
                ),
                label: (""),
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(AppAssets.add),
                activeIcon: SvgPicture.asset(
                  AppAssets.add,
                  color: AppColor.primaryColor,
                ),
                label: (""),
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(AppAssets.profile),
                activeIcon: SvgPicture.asset(
                  AppAssets.profile,
                  color: AppColor.primaryColor,
                ),
                label: (""),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
