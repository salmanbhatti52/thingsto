import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:thingsto/Resources/app_assets.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Utills/apis_urls.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';
import 'package:thingsto/Widgets/shimmer_effect.dart';

class CategoryDetails extends StatefulWidget {
  final Function(String, String) onSelect;
  final List subcategories;
  final String selectedCategoryId;
  final Function(int) fetchNextPage;
  final bool isLoading;
  const CategoryDetails({
    super.key,
    required this.subcategories,
    required this.fetchNextPage,
    required this.onSelect,
    required this.isLoading,
    required this.selectedCategoryId,
  });

  @override
  State<CategoryDetails> createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {
  final ScrollController _scrollController = ScrollController();
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // When scroll reaches the end, load more data (pagination)
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !widget.isLoading) {
      currentPage++;
      widget.fetchNextPage(currentPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 10),
      height: Get.height * 0.19,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const ScrollPhysics(),
        itemCount: widget.subcategories.length + (widget.isLoading ? 1 : 0),
        itemBuilder: (BuildContext context, i) {
          if (i < widget.subcategories.length) {
            final category = widget.subcategories[i];
            var categoryId = category['categories_id'];
            return Padding(
              padding: const EdgeInsets.only(right: 10.0, top: 15),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      widget.onSelect(
                        category['name'],
                        categoryId.toString(),
                      );
                    },
                    child: Container(
                      width: Get.width * 0.297,
                      height: Get.height * 0.11,
                      decoration: BoxDecoration(
                        color: AppColor.whiteColor,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          width: 1,
                          color:
                              categoryId.toString() == widget.selectedCategoryId
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
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace? stackTrace) {
                              return SvgPicture.asset(
                                AppAssets.camera,
                                width: 35,
                                height: 35,
                              );
                            },
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }
                              return Center(
                                child: CircularProgressIndicator(
                                  color: AppColor.primaryColor,
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
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
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: Get.width * 0.3,  // Match category box width
                    child: LabelField(
                      text: category['name'],
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: AppColor.blackColor,
                      interFont: true,
                      maxLIne: 2,
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Shimmers(
              width: Get.width,
              height: Get.height * 0.15,
              width1: Get.width * 0.297,
              height1: Get.height * 0.11,
              length: 3,
            );
          }
        },
      ),
    );
  }
}
