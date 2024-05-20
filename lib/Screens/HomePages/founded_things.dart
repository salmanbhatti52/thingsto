import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:thingsto/Resources/app_assets.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';
import 'package:thingsto/Widgets/large_Button.dart';

class FoundedThings extends StatefulWidget {
  const FoundedThings({super.key});

  @override
  State<FoundedThings> createState() => _FoundedThingsState();
}

class _FoundedThingsState extends State<FoundedThings>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animateController = AnimationController(
    duration: const Duration(milliseconds: 200),
    vsync: this,
    value: 1.0,
  );

  @override
  void didChangeDependencies() {
    _animateController.dispose();
    super.didChangeDependencies();
  }

  List<dynamic> imgListAvatars = [
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTgi42jlN4rxyVoiuJ5iADlOsXCTBZT9nfVgV-bmM5IWw&s",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTgi42jlN4rxyVoiuJ5iADlOsXCTBZT9nfVgV-bmM5IWw&s",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTgi42jlN4rxyVoiuJ5iADlOsXCTBZT9nfVgV-bmM5IWw&s",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTgi42jlN4rxyVoiuJ5iADlOsXCTBZT9nfVgV-bmM5IWw&s",
   ];

  int _current = 0;
  final CarouselController _controller = CarouselController();
  double sheetTopPosition = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> imageSliders = [];
    for (int index = 0; index < imgListAvatars.length; index++) {
      imageSliders.add(
        Image.network(
          imgListAvatars[index],
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          fit: BoxFit.cover,
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) {
              return child;
            } else {
              return Center(
                child: CircularProgressIndicator(
                  color: AppColor.primaryColor,
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            }
          },
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            SizedBox(
              height: Get.height * 0.4,
              child: CarouselSlider(
                items: imageSliders,
                carouselController: _controller,
                options: CarouselOptions(
                    autoPlay: false,
                    scrollPhysics: const ScrollPhysics(),
                    disableCenter: false,
                    enlargeCenterPage: false,
                    viewportFraction: 0.999,
                    aspectRatio: 2,
                    animateToClosest: false,
                    enableInfiniteScroll: false,
                    height: double.infinity,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    }),
              ),
            ),
            Positioned(
              bottom: Get.height * 0.01,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  constraints: BoxConstraints(maxWidth: Get.width * 0.99),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: imgListAvatars.asMap().entries.map((entry) {
                      return GestureDetector(
                        onTap: () => _controller.animateToPage(entry.key),
                        child: Container(
                          width: 12.0,
                          height: 3.0,
                          margin: const EdgeInsets.symmetric(horizontal: 4.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: _current == entry.key
                                ? AppColor.primaryColor
                                : AppColor.hintColor,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(
              left: 15.0, right: 15.0, top: 15.0, bottom: 7),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const LabelField(
                text: "Green Park Castle",
                fontSize: 20,
              ),
              SvgPicture.asset(
                AppAssets.heart,
                color: AppColor.hintColor,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    AppAssets.location,
                    color: AppColor.primaryColor,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const LabelField(
                    align: TextAlign.start,
                    text: "244 B, 7th Ave Los Angeles",
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColor.hintColor,
                  ),
                ],
              ),
              Row(
                children: [
                  const LabelField(
                    align: TextAlign.start,
                    text: "240",
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColor.hintColor,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  SvgPicture.asset(
                    AppAssets.logo,
                    width: 15,
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LargeButton(
                text: "Museum",
                onTap: () {},
                width: 80,
                height: 26,
                containerColor: const Color(0xffF2AF70),
                fontSize: 12,
                radius: 20,
              ),
              SizedBox(
                height: Get.height * 0.022,
              ),
              const LabelField(
                  align: TextAlign.start,
                  text:
                      "Lorem ipsum dolor sit amet consectetur. Nunc vestibulum viverra integer ac justo ornare faucibus cras. Ut integer sollicitudin tellus velit sit purus turpis. Ullamcorper a id sit dui dui dictum. Semper lacus pharetra consectetur mi cursus venenatis ullamcorper. Eleifend at mattis amet amet elementum imperdiet arcu risus sem. Morbi netus donec ornare senectus et ultrices interdum integer. Ut scelerisque mi sed dictum lacus vestibulum volutpat ultrices.",
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColor.hintColor,
                  maxLIne: 10),
              SizedBox(
                height: Get.height * 0.015,
              ),
              const LabelField(
                text: "Sources & Links",
                fontSize: 20,
              ),
              SizedBox(
                height: Get.height * 0.015,
              ),
              const LabelField(
                  align: TextAlign.start,
                  text: "https://www.siteaddress.com",
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff277CE0),
                  maxLIne: 10),
              SizedBox(
                height: Get.height * 0.015,
              ),
              const LabelField(
                text: "Location",
                fontSize: 20,
              ),
              SizedBox(
                height: Get.height * 0.015,
              ),
              Container(
                height: Get.height * 0.27,
                margin: const EdgeInsets.only(right: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: const DecorationImage(
                    image: AssetImage(AppAssets.map),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
