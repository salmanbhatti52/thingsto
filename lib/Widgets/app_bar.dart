import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:thingsto/Resources/app_assets.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';

class HomeBar extends StatefulWidget {
  final String? title;
  final String? icon1;
  final String? icon2;
  final bool titleTrue;
  final bool hasUnreadNotifications;
  final VoidCallback? onClick;
  const HomeBar({
    super.key,
    this.title,
    this.icon1,
    this.icon2,
    this.titleTrue = false,
    this.hasUnreadNotifications = false,
    this.onClick,
  });

  @override
  State<HomeBar> createState() => _HomeBarState();
}

class _HomeBarState extends State<HomeBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: widget.titleTrue ? 25 : 0),
      decoration: widget.titleTrue
          ? const BoxDecoration(
              color: AppColor.whiteColor,
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 87, 178, 0.08),
                  blurRadius: 32,
                  offset: Offset(0, -4),
                  spreadRadius: 0,
                ),
              ],
            )
          : null,
      child: Padding(
        padding: EdgeInsets.only(
          left: widget.titleTrue ? 15 : 0,
          right: 15,
          top: widget.titleTrue ? Get.height * 0.08 : Get.height * 0.06,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            widget.titleTrue
                ? LabelField(
                    text: widget.title!,
                    fontSize: 20,
                  )
                : Image.asset(
                    widget.icon1!,
                    width: Get.width * 0.46,
                  ),
            Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    if (widget.onClick != null) {
                      widget.onClick!();
                    }
                  },
                  child: SvgPicture.asset(widget.icon2!),
                ),
                if (widget.hasUnreadNotifications)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BackButtonBar extends StatefulWidget {
  final String? title;
  final dynamic Function()? onTap;
  final VoidCallback? onBack;
  final double bottomPad;
  const BackButtonBar({
    super.key,
    this.title,
    this.onTap,
    this.onBack,
    this.bottomPad = 25,
  });

  @override
  State<BackButtonBar> createState() => _BackButtonBarState();
}

class _BackButtonBarState extends State<BackButtonBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: widget.bottomPad),
      decoration: const BoxDecoration(
        color: AppColor.whiteColor,
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 87, 178, 0.08),
            blurRadius: 32,
            offset: Offset(0, -4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 15,
          right: 15,
          top: Get.height * 0.08,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                if (widget.onBack != null) {
                  widget.onBack!();
                }
              },
              child: SvgPicture.asset(
                AppAssets.arrowBack,
              ),
            ),
            LabelField(
              text: widget.title!,
              fontSize: 20,
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
    );
  }
}
