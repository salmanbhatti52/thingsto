import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:thingsto/Resources/app_assets.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Utills/apis_urls.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';

class CategoryDetails extends StatelessWidget {
  final Function(String, String) onSelect;
  final List subcategories;
  final String selectedCategoryId;
  const CategoryDetails({super.key, required this.subcategories, required this.onSelect, required this.selectedCategoryId,});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 10),
      height: Get.height * 0.19,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const ScrollPhysics(),
        itemCount: subcategories.length,
        itemBuilder: (BuildContext context, i) {
          final category = subcategories[i];
          var categoryId = category['categories_id'];
          return Padding(
            padding: const EdgeInsets.only(right: 10.0, top: 15),
            child: Column(
              children: [
                GestureDetector(
                  onTap: (){
                    onSelect(category['name'], categoryId.toString(),);
                  },
                  child: Container(
                    width: Get.width * 0.297,
                    height: Get.height * 0.11,
                    decoration: BoxDecoration(
                      color: AppColor.whiteColor,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        width: 1,
                        color: categoryId.toString() == selectedCategoryId
                            ? AppColor.primaryColor
                            : AppColor.thingBorder,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(178, 178, 178, 0.15),
                          blurRadius: 30,
                          offset: Offset(0, 5),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Image.network(
                          '$baseUrlImage${category['image']}',
                          // width: 50,
                          // height: 50,
                          // fit: BoxFit.fill,
                          errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                            return SvgPicture.asset(
                              AppAssets.camera,
                              width: 35,
                              height: 35,
                            );
                          },
                          loadingBuilder:
                              (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Center(
                              child:
                              CircularProgressIndicator(
                                color: AppColor.primaryColor,
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                LabelField(
                  text: category['name'],
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: AppColor.blackColor,
                  interFont: true,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
