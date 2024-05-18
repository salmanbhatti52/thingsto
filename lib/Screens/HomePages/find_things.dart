import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';
import 'package:thingsto/Widgets/custom_dropdown.dart';
import 'package:thingsto/Widgets/large_Button.dart';

class FindThings extends StatefulWidget {
  final VoidCallback? onFind;
  const FindThings({super.key, this.onFind});

  @override
  State<FindThings> createState() => _FindThingsState();
}

class _FindThingsState extends State<FindThings> {
  List<String> itemListForCity = ["Multan", "Lahore", "Karachi"];
  List<String> itemListForThing = ["Sports", "Movies", "Concerts"];
  String? selectCity;
  String? selectThing;

  bool isFind = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const LabelField(
              text: 'I’m looking around',
            ),
            const SizedBox(
              height: 8,
            ),
            CustomDropdown(
              itemList: itemListForCity,
              hintText: "city",
              onChanged: (value) {
                selectCity = value;
                debugPrint("selectCity: $selectCity");
              },
            ),
            const SizedBox(
              height: 18,
            ),
            const LabelField(
              text: 'I’m looking for thing about',
            ),
            const SizedBox(
              height: 8,
            ),
            CustomDropdown(
              itemList: itemListForThing,
              hintText: "sports",
              onChanged: (value) {
                selectThing = value;
                debugPrint("selectThing: $selectThing");
              },
            ),
            const SizedBox(
              height: 18,
            ),
          ],
        ),
        LargeButton(
          text:  isFind ? "FIND an other one" : "FIND IT",
          onTap: () {
            setState(() {
              isFind = true;
            });
            if (widget.onFind != null) {
              widget.onFind!();
            }
          },
          width: isFind ? Get.width * 0.49 : Get.width * 0.27,
          height: Get.height * 0.05,
        ),
      ],
    );
  }
}
