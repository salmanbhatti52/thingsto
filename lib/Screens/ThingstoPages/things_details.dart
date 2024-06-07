import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:thingsto/Resources/app_assets.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Utills/apis_urls.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';
import 'package:thingsto/Widgets/large_Button.dart';

class ThingsDetails extends StatefulWidget {
  final Map<String, dynamic>? thingsto;
  const ThingsDetails({super.key, this.thingsto,});

  @override
  State<ThingsDetails> createState() => _ThingsDetailsState();
}

class _ThingsDetailsState extends State<ThingsDetails>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animateController = AnimationController(
    duration: const Duration(milliseconds: 200),
    vsync: this,
    value: 1.0,
  );

  int _current = 0;
  final CarouselController _controller = CarouselController();
  double sheetTopPosition = 0;
  List<dynamic> listOfImages = [];
  late GoogleMapController mapController;
  late LatLng _center;
  late LatLng _currentLocation;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void didChangeDependencies() {
    _animateController.dispose();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    if (widget.thingsto != null && widget.thingsto!.containsKey('images')) {
      var images = widget.thingsto!['images'];
      if (images is List) {
        for (var image in images) {
          if (image is Map<String, dynamic> && image.containsKey('name')) {
            listOfImages.add('$baseUrlImage${image['name']}');
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> tags = widget.thingsto?["tags"] ?? [];
    double latitude  = double.parse(widget.thingsto?["lattitude"]);
    double longitude  = double.parse(widget.thingsto?["longitude"]);
    _center = LatLng(latitude, longitude);
    _currentLocation = LatLng(latitude, longitude);
    List<Widget> imageSliders = listOfImages.map((item) => Image.network(
      item,
      width: Get.width,
      // height: MediaQuery.sizeOf(context).height,
      height: 272,
      fit: BoxFit.fill,
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
    )).toList();

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
                    children: listOfImages.asMap().entries.map((entry) {
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
              LabelField(
                text: widget.thingsto?["name"],
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
                  LabelField(
                    align: TextAlign.start,
                    text: widget.thingsto?["location"],
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColor.hintColor,
                    maxLIne: 2,
                  ),
                ],
              ),
              Row(
                children: [
                  LabelField(
                    align: TextAlign.start,
                    text: widget.thingsto?["earn_points"],
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
          padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: tags.map<Widget>((tag) {
                    final textLength = tag["name"].length;
                    final buttonWidth = textLength * 8.0 + 40;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: LargeButton(
                        text: tag["name"],
                        maxLIne: 1,
                        onTap: () {},
                        width: buttonWidth,
                        height: 26,
                        containerColor: const Color(0xffF2AF70),
                        fontSize: 12,
                        radius: 20,
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(
                height: Get.height * 0.022,
              ),
              LabelField(
                align: TextAlign.start,
                text: widget.thingsto?["description"],
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColor.hintColor,
                maxLIne: 10,
              ),
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
              LabelField(
                align: TextAlign.start,
                text: widget.thingsto?["sources_links"],
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: const Color(0xff277CE0),
                maxLIne: 1,
              ),
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
                  // image: const DecorationImage(
                  //   image: AssetImage(AppAssets.map),
                  //   fit: BoxFit.cover,
                  // ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    mapType: MapType.normal,

                    initialCameraPosition: CameraPosition(
                      target: _center,
                      zoom: 11.0,
                    ),
                    markers: {
                      Marker(
                        markerId: const MarkerId("Location"),
                        position: _currentLocation,
                      ),
                    },
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
