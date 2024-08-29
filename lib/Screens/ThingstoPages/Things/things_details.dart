import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:thingsto/Controllers/get_profile_controller.dart';
import 'package:thingsto/Controllers/thingsto_controller.dart';
import 'package:thingsto/Resources/app_assets.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Utills/apis_urls.dart';
import 'package:thingsto/Utills/const.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';
import 'package:thingsto/Widgets/large_Button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ThingsDetails extends StatefulWidget {
  final Map<String, dynamic>? thingsto;
  final String thingstoName;
  const ThingsDetails({super.key, this.thingsto, required this.thingstoName,});

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
  List<dynamic> listOfMedia = [];
  late GoogleMapController mapController;
  late LatLng _center;
  late LatLng _currentLocation;
  Map<int, bool> isPlayingMap = {};
  Duration? duration;
  Duration? position;
  AudioPlayer? audioPlayer;
  List<WebViewController> controllers = [];
  final ThingstoController thingstoController = Get.put(ThingstoController());

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
      var media = widget.thingsto!['images'];
      if (media is List) {
        for (var item in media) {
          if (item is Map<String, dynamic> && item.containsKey('name')) {
            String iframeHtml = item['name'];

            // Extract the URL from the src attribute in the iframe
            final urlRegExp = RegExp(r'src="([^"]+)"');
            final match = urlRegExp.firstMatch(iframeHtml);
            String? url = match?.group(1);

            // Check if a valid URL was extracted and it's a Spotify embed link
            if (url != null && url.contains('https://')) {
              var controller = WebViewController()
                ..setJavaScriptMode(JavaScriptMode.unrestricted)
                ..setNavigationDelegate(
                  NavigationDelegate(
                    onProgress: (int progress) {
                      // Update loading bar.
                    },
                    onPageStarted: (String url) {},
                    onPageFinished: (String url) {},
                    onHttpError: (HttpResponseError error) {},
                    onWebResourceError: (WebResourceError error) {},
                    onNavigationRequest: (NavigationRequest request) {
                      if (request.url.startsWith('https://')) {
                        _launchURL(request.url);
                        return NavigationDecision.prevent;
                      }
                      return NavigationDecision.navigate;
                    },
                  ),
                )
                ..loadRequest(Uri.parse(url));

              controllers.add(controller);
            }

            listOfMedia.add({
              'url': '$baseUrlImage${item['name']}',
              'type': item['media_type']
            });
          }
        }
      }
    }
  }

  Future<void> _launchURL(String urls) async {
    if (Uri.tryParse(urls)?.hasAbsolutePath ?? false) {
      final Uri url = Uri.parse(urls);
      if (!await launchUrl(url)) {
        throw Exception('Could not launch $url');
      }
    } else {
      throw Exception('Invalid URL: $urls');
    }
  }


  void _initAudioPlayer(String url) async {
    audioPlayer = AudioPlayer();

    try {
      await audioPlayer?.setSourceUrl(url);
    } catch (e) {
      debugPrint('Error setting audio source: $e');
      // Handle error
    }

    audioPlayer?.onDurationChanged.listen((Duration d) {
      setState(() {
        duration = d;
      });
    });

    audioPlayer?.onPositionChanged.listen((Duration p) {
      setState(() {
        position = p;
      });
    });
  }

  @override
  void dispose() {
    audioPlayer?.dispose();
    // Use the available method to stop or reset the WebView
    for (var controller in controllers) {
      // Example of navigating to a blank page
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.loadRequest(Uri.dataFromString('<html></html>', mimeType: 'text/html'));
      });
    }
    super.dispose();
  }

  Future<File?> downloadMp3(String url) async {
    Dio dio = Dio();
    Directory tempDir = await getTemporaryDirectory();
    String fileName = url.split('/').last;
    String savePath = '${tempDir.path}/$fileName';
    File file = File(savePath);
    if (await file.exists()) {
      return file;
    }

    try {
      EasyLoading.show(
        status: 'Downloading...',
      );
      await dio.download(
        url,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            if (kDebugMode) {
              print('${(received / total * 100).toStringAsFixed(0)}%');
            }
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error downloading file: $e');
      }
      EasyLoading.showError('Failed to download file');
      return null; // Return null to indicate failure
    } finally {
      EasyLoading.dismiss();
    }

    return File(savePath);
  }

  Future<void> playPause(String url) async {
    bool isPlaying = isPlayingMap[0] ?? false;

    if (isPlaying) {
      audioPlayer?.pause();
    } else {
      if (Platform.isAndroid) {
        await audioPlayer?.play(UrlSource(url));
      } else {
        var file = await downloadMp3(url);
        if (file != null) {
          await audioPlayer?.play(DeviceFileSource(file.path));
        }
      }
    }

    setState(() {
      isPlayingMap[0] = !isPlaying;
    });

    audioPlayer?.onPlayerComplete.listen((event) {
      setState(() {
        isPlayingMap[0] = false;
      });
    });
  }

  final GetProfileController getProfileController = Get.put(GetProfileController());

  @override
  Widget build(BuildContext context) {
    List<dynamic> tags = widget.thingsto?["tags"] ?? [];
    List<dynamic> source = widget.thingsto?["sources"] ?? [];
    double latitude = widget.thingsto?["lattitude"] != null ? double.parse(widget.thingsto?["lattitude"]) : 0;
    double longitude = widget.thingsto?["longitude"] !=null ?  double.parse(widget.thingsto?["longitude"]) : 0;
    thingstoController.totalLikes.value = int.parse(widget.thingsto!["total_likes"].toString());
    thingstoController.initializeLikes(widget.thingsto?["likes"]);
    _center = LatLng(latitude, longitude);
    _currentLocation = LatLng(latitude, longitude);
    List<Widget> mediaSliders = listOfMedia.map((item) {
      if (item['type'] == 'Image') {
        return Image.network(
          item['url'],
          width: MediaQuery.of(context).size.width,
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
        );
      } else if (item['type'] == 'Music') {
        return Padding(
          padding: const EdgeInsets.all(0.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(0),
            child: widget.thingsto?['thumbnail'] !=null
                ? Image.network(
              '$baseUrlImage${widget.thingsto?['thumbnail']}',
              width: Get.width,
              height: Get.height * 0.13,
              fit: BoxFit.fill,
              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                return Image.network(
                  AppAssets.dummyPic,
                  width: Get.width,
                  height: Get.height * 0.13,
                  fit: BoxFit.fill,
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
            )
                : Image.network(
              AppAssets.dummyPic,
              width: Get.width,
              height: Get.height * 0.13,
              fit: BoxFit.fill,
            ),
          ),
        );
        //   Center(
        //   child: Column(
        //     children: [
        //       SizedBox(height: Get.height * 0.05,),
        //       SvgPicture.asset(
        //         AppAssets.music,
        //         width: 100,
        //         height: 100,
        //       ),
        //       SizedBox(height: Get.height * 0.05,),
        //       LabelField(
        //         text: '${position?.inMinutes ?? 0}:${position?.inSeconds.remainder(60).toString().padLeft(2, '0') ?? '00'} / ${duration?.inMinutes ?? 0}:${duration?.inSeconds.remainder(60).toString().padLeft(2, '0') ?? '00'}',
        //       ),
        //       SizedBox(height: Get.height * 0.02,),
        //       GestureDetector(
        //           onTap: () {
        //             _initAudioPlayer(item['url']);
        //             playPause(item['url']);
        //           },
        //           child: isPlayingMap[0] == true
        //               ? const Icon(
        //             Icons.stop_circle_sharp,
        //             size: 55,
        //             color: AppColor.primaryColor,
        //           )
        //               : const Icon(
        //             Icons.play_arrow_rounded,
        //             size: 55,
        //             color: AppColor.primaryColor,
        //           )
        //       ),
        //     ],
        //   ),
        // );
      } else {
        return Container();
      }
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: CarouselSlider(
                items: mediaSliders,
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
              bottom: MediaQuery.of(context).size.height * 0.01,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.99),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: listOfMedia.asMap().entries.map((entry) {
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
              Expanded(
                child: LabelField(
                  text: widget.thingsto?["name"],
                  fontSize: 20,
                  align: TextAlign.left,
                ),
              ),
              GestureDetector(
                onTap: () async {
                  thingstoController.likeUnlikeUser(
                    widget.thingsto!["things_id"].toString(),
                  );
                  userID = (prefs.getString('users_customers_id').toString());
                  debugPrint("userID $userID");
                  if(widget.thingstoName == "Favorite") {
                    // if (getProfileController.isDataLoadedFavorites.value) {
                    //   getProfileController.getFavoritesThings();
                    // } else {
                    //   await getProfileController.getFavoritesThings();
                    // }
                  } else if(widget.thingstoName == "HomeSide") {

                  } else {
                    thingstoController.getThingsto(checkValue: "No");
                  }
                },
                child: Obx(() {
                  return Row(
                    children: [
                      LabelField(
                        align: TextAlign.start,
                        text: thingstoController.totalLikes.value.toString(),
                        fontWeight: FontWeight.w400,
                        color: AppColor.hintColor,
                        fontSize: 18,
                        maxLIne: 2,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      thingstoController.isLiked.value
                          ? const Icon(
                          Icons.favorite,
                          size: 25,
                          color: Colors.redAccent,
                      )
                          : SvgPicture.asset(
                        AppAssets.heart,
                        width: 23,
                        color: AppColor.hintColor,
                      ),
                    ],
                  );
                }),
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
              widget.thingsto?["location"] != null && widget.thingsto?["location"] != ""
                  ? Expanded(
                child: Row(
                  children: [
                    SvgPicture.asset(
                      AppAssets.location,
                      color: AppColor.primaryColor,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: LabelField(
                        align: TextAlign.start,
                        text: widget.thingsto?["location"] ?? "",
                        fontWeight: FontWeight.w400,
                        color: AppColor.hintColor,
                        maxLIne: 2,
                      ),
                    ),
                  ],
                ),
              )
                  : const SizedBox(),
              const SizedBox(width: 10), // Add spacing between the two rows
              Row(
                children: [
                  LabelField(
                    align: TextAlign.start,
                    text:  widget.thingsto!["earn_points"].toString(),
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: AppColor.hintColor,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  SvgPicture.asset(
                    AppAssets.logo,
                    width: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 15.0, right: 15.0, top: tags.isNotEmpty ? 15 : 0,),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              tags.isNotEmpty
                  ? SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: tags.map<Widget>((tag) {
                    final textLength = tag["name"].length;
                    final buttonWidth = textLength * 8.0 + 40;
                    return tag["name"] != ""
                        ? Padding(
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
                    ) : const SizedBox();
                  }).toList(),
                ),
              )
                  : const SizedBox(),
              SizedBox(
                height: Get.height * 0.022,
              ),
              widget.thingsto?["description"] != null
              ? LabelField(
                align: TextAlign.start,
                text: widget.thingsto?["description"],
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColor.hintColor,
                maxLIne: 10,
              )
              : const SizedBox(),
              SizedBox(
                height: Get.height * 0.015,
              ),
              source.isNotEmpty && source.any((sources) => sources["name"] != "")
                  ? const LabelField(
                text: "Sources & Links",
                fontSize: 20,
              )
                  : const SizedBox(),
              if (source.isNotEmpty && source.any((sources) => sources["name"] != "")) SizedBox(height: Get.height * 0.015),
              if (source.isNotEmpty && source.any((sources) => sources["name"] != ""))
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: source.map<Widget>((sources) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: GestureDetector(
                          onTap: () async {
                            final String urlStr = sources["name"];
                            if (Uri.tryParse(urlStr)?.hasAbsolutePath ?? false) {
                              final Uri url = Uri.parse(urlStr);
                              if (!await launchUrl(url)) {
                                throw Exception('Could not launch $url');
                              }
                            } else {
                              throw Exception('Invalid URL: $urlStr');
                            }
                          },
                          child: LabelField(
                            text: sources["name"],
                            align: TextAlign.start,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xff277CE0),
                            maxLIne: 1,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              // SingleChildScrollView(
              //   scrollDirection: Axis.vertical,
              //   child: Column(
              //     children: source.map<Widget>((sources) {
              //       final textLength = sources["name"].length;
              //       final buttonWidth = textLength * 8.0 + 40;
              //       return Padding(
              //         padding: const EdgeInsets.only(bottom: 8.0),
              //         child: LargeButton(
              //           text: sources["name"],
              //           textColor: const Color(0xff277CE0),
              //           maxLIne: 1,
              //           onTap: () {},
              //           width: buttonWidth,
              //           height: 26,
              //           fontSize: 12,
              //           radius: 20,
              //         ),
              //       );
              //     }).toList(),
              //   ),
              // ),
              if (source.isNotEmpty && source.any((sources) => sources["name"] != ""))
                   SizedBox(
                height: Get.height * 0.015,
              ),
              controllers.isNotEmpty
                  ? const LabelField(
                text: "Extract:",
                fontSize: 20,
              )
                  : const SizedBox(),
              if (controllers.isNotEmpty) SizedBox(height: Get.height * 0.015),
              for (int i = 0; i < controllers.length; i++)
                    SizedBox(
                      height: 100,
                      child: WebViewWidget(
                        controller: controllers[i],
                      ),
                    ),
              if (controllers.isNotEmpty)
                   SizedBox(
                height: Get.height * 0.015,
              ),
              widget.thingsto?["location"] != null && widget.thingsto?["location"] != ""
                  ? const LabelField(
                text: "Location",
                fontSize: 20,
              )
                  : const SizedBox(),
              widget.thingsto?["location"] != null && widget.thingsto?["location"] != ""
                  ? SizedBox(
                height: Get.height * 0.015,
              )
                  : const SizedBox(),
              widget.thingsto?["location"] != null && widget.thingsto?["location"] != ""
                  ? Container(
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
              )
                  : const SizedBox(),
            ],
          ),
        ),
      ],
    );
  }
}
