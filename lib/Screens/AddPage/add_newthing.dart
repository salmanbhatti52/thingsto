import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:places_service/places_service.dart';
import 'package:thingsto/Controllers/add_things_controller.dart';
import 'package:thingsto/Resources/app_assets.dart';
import 'package:thingsto/Resources/app_colors.dart';
import 'package:thingsto/Screens/AddPage/human_verification.dart';
import 'package:thingsto/Utills/const.dart';
import 'package:thingsto/Utills/global.dart';
import 'package:thingsto/Widgets/TextFieldLabel.dart';
import 'package:thingsto/Widgets/TextFields.dart';
import 'package:thingsto/Widgets/app_bar.dart';
import 'package:thingsto/Widgets/custom_dropdown.dart';
import 'package:thingsto/Widgets/large_Button.dart';
import 'package:thingsto/Widgets/shimmer_effect.dart';
import 'package:thingsto/Widgets/snackbar.dart';

class AddNewThings extends StatefulWidget {
  const AddNewThings({super.key});

  @override
  State<AddNewThings> createState() => _AddNewThingsState();
}

class _AddNewThingsState extends State<AddNewThings>
    with SingleTickerProviderStateMixin {
  AddThingsController addThingsController = Get.put(AddThingsController());

  var itemListForCategory = <String>[];
  var itemListForSubCategory = <String>[];
  var itemListForThirdCategory = <String>[];
  var itemListForCountries = <String>[];
  var itemListForStates = <String>[];
  var itemListForCities = <String>[];
  var itemListForSelection = [
    "Image",
    "Music",
  ];
  String? selectFile;
  String? selectCategory;
  String? selectSubCategory;
  String? selectThirdCategory;
  String? selectCategoryId;
  String? selectSubCategoryId;
  String? selectThirdCategoryId;
  String? selectCountry;
  String? selectStates;
  String? selectCity;
  String? selectCountryId;
  String? selectStatesId;
  String? selectCityId;
  final formKey = GlobalKey<FormState>();
  final thingNameController = TextEditingController();
  final pointsController = TextEditingController();
  late TextEditingController locationController;
  final descController = TextEditingController();
  final linkController = TextEditingController();
  final textController = TextEditingController();
  bool _isChecked = false;
  bool _isVerfied = false;
  late AnimationController _controller;
  late Animation<double> _animation;
  double latitude = 0;
  double longitude = 0;
  String country = "";
  String state = "";
  String city = "";
  String postCode = "";
  String placesId = "";

  Future<void> getUserThings() async {
    await addThingsController.getAllCategory();
        itemListForCategory = addThingsController.categoriesP0
            .map((c) => c['name'].toString())
            .toSet() // Ensure uniqueness
            .toList();
        debugPrint("itemListForCategory: $itemListForCategory");
  }


  @override
  void initState() {
    super.initState();
    googleApiKey = (prefs.getString('geo_api_key').toString());
    debugPrint("googleApiKey $googleApiKey");
    _placesService.initialize(apiKey: googleApiKey.toString());
    locationController = TextEditingController(text: "");
    getUserThings();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  void _toggleCheckbox() {
    setState(() {
      _isChecked = !_isChecked;
      if (_isChecked) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final PlacesService _placesService = PlacesService();
  List<PlacesAutoCompleteResult> _autoCompleteResult = [];
  LatLng? latitudeLongitude = const LatLng(30.183419, 71.427832);
  final TextEditingController _currentAddress1 = TextEditingController();

  humanVerification(bool verification){
    debugPrint("verification $verification");
    _isVerfied = verification;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: Column(
        children: [
          BackButtonBar(
            title: "Add New Thing",
            bottomPad: 15,
            onBack: () {
              Get.back();
            },
          ),
          SizedBox(
            height: Get.height * 0.02,
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Get.width * 0.08,
                ),
                child: Obx(() {
                  return addThingsController.isLoading1.value
                      ? Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: Get.height * 0.35),
                      child: SpinKitThreeBounce(
                        itemBuilder: (
                            BuildContext context,
                            int i,
                            ) {
                          return DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: AppColor.primaryColor,
                            ),
                          );
                        },
                      ),
                    ),
                  )
                      : Form(
                    key: formKey,
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const LabelField(
                        text: 'Category',
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      CustomDropdown(
                        itemList: itemListForCategory,
                        hintText: "Select Category",
                        onChanged: (value) {
                          setState(() {
                            selectCategory = value;
                            selectCategoryId = addThingsController.categoriesAll.firstWhere((c) => c['name'] == value)
                            ['categories_id'].toString();
                            debugPrint("selectCategory: $selectCategory, selectCategoryId: $selectCategoryId");
                            // addThingsController.getAllCountries(categoryId: selectCategoryId.toString());
                            // itemListForCountries = addThingsController.allCountries
                            //     .map((c) => c['name'].toString())
                            //     .toSet() // Ensure uniqueness
                            //     .toList();
                            // debugPrint("itemListForCountries: $itemListForCountries");
                            itemListForCountries.clear();
                            addThingsController.getAllCountries(categoryId: selectCategoryId.toString());
                            addThingsController.allCountries.addListener(() {
                              setState(() {
                                // selectStates = null;
                                selectCity = null;
                                selectCityId = null;
                                itemListForCountries = addThingsController.allCountries.value
                                    .map((c) => c['name'].toString())
                                    .toSet() // Ensure uniqueness
                                    .toList();
                                debugPrint("itemListForCountries: $itemListForCountries");
                              });
                            });
                            // Filter subcategories based on selected category
                            itemListForSubCategory = addThingsController.categoriesAll
                                .where((c) => c['parent_id'] == int.parse(selectCategoryId!))
                                .map((c) => c['name'].toString())
                                .toSet()
                                .toList();
                            selectSubCategory = null;
                            selectSubCategoryId = null;
                            selectThirdCategory = null;
                            selectThirdCategoryId = null;
                          });
                        },
                        initialValue: selectCategory,
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                     if(itemListForSubCategory.isNotEmpty)
                     Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         const LabelField(
                           text: 'Subcategory',
                         ),
                         const SizedBox(
                           height: 8,
                         ),
                         CustomDropdown(
                           itemList: itemListForSubCategory,
                           hintText: "Select Subcategory",
                           onChanged: (value) {
                             setState(() {
                               selectSubCategory = value;
                               selectSubCategoryId = addThingsController.categoriesAll.firstWhere((c) => c['name'] == value)['categories_id'].toString();
                               debugPrint("selectSubCategory: $selectSubCategory, selectSubCategoryId: $selectSubCategoryId");
                               itemListForCountries.clear();
                               addThingsController.getAllCountries(categoryId: selectSubCategoryId.toString());
                               addThingsController.allCountries.addListener(() {
                                 setState(() {
                                   // selectStates = null;
                                   selectCity = null;
                                   selectCityId = null;
                                   itemListForCountries = addThingsController.allCountries.value
                                       .map((c) => c['name'].toString())
                                       .toSet() // Ensure uniqueness
                                       .toList();
                                   debugPrint("itemListForCountries: $itemListForCountries");
                                 });
                               });
                               // Filter subcategories based on selected category
                               itemListForThirdCategory = addThingsController.categoriesAll
                                   .where((c) => c['parent_id'] == int.parse(selectSubCategoryId!))
                                   .map((c) => c['name'].toString())
                                   .toSet()
                                   .toList();
                               selectThirdCategory = null;
                               selectThirdCategoryId = null;
                             });
                           },
                           initialValue: selectSubCategory,
                         ),
                         const SizedBox(
                           height: 18,
                         ),
                       ],
                     ),
                      if(itemListForThirdCategory.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const LabelField(
                              text: 'Sub child category',
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            CustomDropdown(
                              itemList: itemListForThirdCategory,
                              hintText: "Select Sub child category",
                              onChanged: (value) {
                                setState(() {
                                  selectThirdCategory = value;
                                  selectThirdCategoryId = addThingsController.categoriesAll.firstWhere((c) => c['name'] == value)['categories_id'].toString();
                                  debugPrint("selectThirdCategory: $selectThirdCategory, selectThirdCategoryId: $selectThirdCategoryId");
                                  itemListForCountries.clear();
                                  addThingsController.getAllCountries(categoryId: selectThirdCategoryId.toString());
                                  addThingsController.allCountries.addListener(() {
                                    setState(() {
                                      // selectStates = null;
                                      selectCity = null;
                                      selectCityId = null;
                                      itemListForCountries = addThingsController.allCountries.value
                                          .map((c) => c['name'].toString())
                                          .toSet() // Ensure uniqueness
                                          .toList();
                                      debugPrint("itemListForCountries: $itemListForCountries");
                                    });
                                  });
                                });
                              },
                              initialValue: selectThirdCategory,
                            ),
                            const SizedBox(
                              height: 18,
                            ),
                          ],
                        ),
                      const LabelField(
                        text: 'Thing Name',
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      CustomTextFormField(
                        controller: thingNameController,
                        hintText: "Thing Name here",
                        // validator: validateEmail,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        showSuffix: false,
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      const LabelField(
                        text: 'No. of points the thing should earn',
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      CustomTextFormField(
                        controller: pointsController,
                        hintText: "Points here",
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        showSuffix: false,
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      if(itemListForCountries.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const LabelField(
                            text: 'Country',
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Obx(() => addThingsController.isCountryLoading.value
                              ? Shimmers2(
                            width: Get.width,
                            height: 60,
                          ) : CustomDropdown(
                            itemList: itemListForCountries,
                            hintText: "Select Country",
                            onChanged: (value) {
                              setState(() {
                                selectCountry = value;
                                selectCountryId = addThingsController.allCountries.value.firstWhere((c) => c['name'] == value)
                                ['countries_id'].toString();
                                debugPrint("selectCountry: $selectCountry, selectCountryId: $selectCountryId");
                                // Filter subcategories based on selected country
                                itemListForCities.clear();
                                selectCity = null;
                                selectCityId = null;
                                addThingsController.getAllCities(countryId: selectCountryId.toString());
                                addThingsController.allCities.addListener(() {
                                  setState(() {
                                    // selectStates = null;
                                    selectCity = null;
                                    selectCityId = null;
                                    itemListForCities = addThingsController.allCities.value
                                        .map((c) => c['name'].toString())
                                        .toSet() // Ensure uniqueness
                                        .toList();
                                    debugPrint("itemListForCities: $itemListForCities");
                                  });
                                });
                              });
                            },
                            initialValue: selectCountry,
                          )),
                          const SizedBox(
                            height: 18,
                          ),
                        ],
                      ),
                      // if(itemListForStates.isNotEmpty)
                      //   Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       const LabelField(
                      //         text: 'States',
                      //       ),
                      //       const SizedBox(
                      //         height: 8,
                      //       ),
                      //       Obx(()  {
                      //         return addThingsController.isStateLoading.value
                      //             ? Shimmers2(
                      //           width: Get.width,
                      //           height: 60,
                      //         ) : CustomDropdown(
                      //           itemList: itemListForStates,
                      //           hintText: "Select States",
                      //           onChanged: (value) {
                      //             setState(() {
                      //               selectStates = value;
                      //               selectStatesId = addThingsController.allStates.value.firstWhere((c) => c['name'] == value)
                      //               ['states_id'].toString();
                      //               debugPrint("selectStats: $selectStates, selectStataId: $selectStatesId");
                      //               // Filter subcategories based on selected states
                      //               addThingsController.getAllCities(stateId: selectStatesId.toString());
                      //               addThingsController.allCities.addListener(() {
                      //                 setState(() {
                      //                   selectCity = null;
                      //                   itemListForCities = addThingsController.allCities.value
                      //                       .map((c) => c['name'].toString())
                      //                       .toSet() // Ensure uniqueness
                      //                       .toList();
                      //                   debugPrint("itemListForCities: $itemListForCities");
                      //                 });
                      //               });
                      //             });
                      //           },
                      //           initialValue: selectStates,
                      //         );
                      //       }),
                      //       const SizedBox(
                      //         height: 18,
                      //       ),
                      //     ],
                      //   ),
                      if(itemListForCountries.isNotEmpty && itemListForCities.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const LabelField(
                              text: 'City',
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Obx(() {
                              return addThingsController.isCityLoading.value
                                  ? Shimmers2(
                                width: Get.width,
                                height: 60,
                              ) : CustomDropdown(
                                itemList: itemListForCities,
                                hintText: "Select City",
                                onChanged: (value) {
                                  setState(() {
                                    selectCity = value;
                                    selectCityId = addThingsController.allCities.value.firstWhere((c) => c['name'] == value)['cities_id'].toString();
                                    debugPrint("selectCity: $selectCity, selectCityId: $selectCityId");
                                  });
                                },
                                initialValue: selectCity,
                              );
                            }),
                            const SizedBox(
                              height: 18,
                            ),
                          ],
                        ),
                      const LabelField(
                        text: 'Location',
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Stack(
                        children: [
                          CustomTextFormField(
                            controller: locationController.text.isNotEmpty
                                ? locationController
                                : _currentAddress1,
                            hintText: "Location here",
                            suffixImage: AppAssets.location,
                            suffixColor: AppColor.blackColor,
                            suffixTap: () async {
                              await GlobalService.getCurrentPosition();
                              double latitude1 = GlobalService.currentLocation!.latitude;
                              double longitude1 = GlobalService.currentLocation!.longitude;
                              var addressDetails = await GlobalService.getAddressFromLatLng(GlobalService.currentLocation!);
                              final placeId = await GlobalService.fetchPlaceId(GlobalService.currentLocation!.latitude, GlobalService.currentLocation!.longitude);
                              if (placeId != null) {
                                debugPrint('Place ID: $placeId');
                              } else {
                                debugPrint('Failed to fetch Place ID');
                              }
                              setState(() {
                                locationController.text = addressDetails['address']!;
                                latitude = latitude1;
                                longitude = longitude1;
                                country = addressDetails['country'].toString();
                                state = addressDetails['state'].toString();
                                city = addressDetails['city'].toString();
                                postCode = addressDetails['postCode'].toString();
                                placesId = placeId.toString();
                                debugPrint('current address: ${addressDetails['address']}');
                                debugPrint('current city: ${addressDetails['city']}');
                                debugPrint('current state: ${addressDetails['state']}');
                                debugPrint('current country: ${addressDetails['country']}');
                                debugPrint('current postal code: ${addressDetails['postalCode']}');
                                debugPrint('current latitude: $latitude1');
                                debugPrint('current longitude: $longitude1');
                              });
                            },
                            showSuffix: false,
                            obscureText: false,
                            keyboardType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.next,
                            onChanged: (value) async {
                              setState(() {
                                debugPrint(value);
                              });
                              final autoCompleteSuggestions =
                              await _placesService.getAutoComplete(value);
                              _autoCompleteResult = autoCompleteSuggestions;
                            },
                          ),
                          if (_autoCompleteResult.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 90.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black,),),
                                height: 140,
                                child: ListView.builder(
                                  itemCount: _autoCompleteResult.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      visualDensity: const VisualDensity(
                                          horizontal: 0, vertical: -4),
                                      title: Text(
                                        _autoCompleteResult[index].mainText ?? "",
                                        style: const TextStyle(color: Colors.black),
                                      ),
                                      subtitle: Text(
                                        _autoCompleteResult[index].description ?? "",
                                        style: const TextStyle(color: Colors.black),
                                      ),
                                      onTap: () async {
                                        var id = _autoCompleteResult[index].placeId;
                                        final placeDetails = await _placesService.getPlaceDetails(id!);
                                        final placeId = await GlobalService.fetchPlaceId(placeDetails.lat!, placeDetails.lng!);
                                        if (placeId != null) {
                                          debugPrint('Place ID: $placeId');
                                        } else {
                                          debugPrint('Failed to fetch Place ID');
                                        }
                                        setState(() {
                                          latitudeLongitude = LatLng(latitude, longitude);
                                          locationController.text = "${_autoCompleteResult[index].mainText!} ${_autoCompleteResult[index].secondaryText ?? ""} ";
                                          _autoCompleteResult.clear();
                                        });
                                        latitude = placeDetails.lat!;
                                        longitude = placeDetails.lng!;
                                        country = placeDetails.city.toString();
                                        state = placeDetails.state.toString();
                                        city = placeDetails.city.toString();
                                        postCode = placeDetails.zip.toString();
                                        placesId = placeId.toString();
                                        debugPrint('current address: ${locationController.text}');
                                        debugPrint('current city: $city');
                                        debugPrint('current state: $state');
                                        debugPrint('current country: $country');
                                        debugPrint('current postal code: $postCode');
                                        debugPrint('current latitude: $latitude');
                                        debugPrint('current longitude: $longitude');
                                        debugPrint('current placesId: $placesId');
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      const LabelField(
                        text: 'Description of the thing',
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColor.secondaryColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColor.borderColor,
                            width: 1.0,
                          ),
                        ),
                        height: Get.height * 0.11,
                        child: TextField(
                          maxLines: null,
                          controller: descController,
                          textAlign: TextAlign.left,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: AppColor.hintColor,
                            fontWeight: FontWeight.w400,
                          ),
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          cursorColor: AppColor.hintColor,
                          decoration: InputDecoration(
                            fillColor: AppColor.secondaryColor,
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: const EdgeInsets.only(
                              top: 0.0,
                              left: 12,
                            ),
                            hintText: "Write here.....",
                            hintStyle: GoogleFonts.poppins(
                              fontSize: 14,
                              color: AppColor.hintColor,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      const LabelField(
                        text: 'Thumbnail',
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Obx(() {
                        return  addThingsController.imageFile.value == null
                            ? GestureDetector(
                          onTap: addThingsController.imagePick,
                          child: DottedBorder(
                            color: AppColor.primaryColor,
                            strokeWidth: 1,
                            radius: const Radius.circular(10),
                            borderType: BorderType.RRect,
                            child: Container(
                              width: Get.width,
                              height: Get.height * 0.163,
                              color: AppColor.secondaryColor,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(AppAssets.upload),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const LabelField(
                                      text: "Add thumbnail",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: AppColor.hintColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                            : ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                File(addThingsController.imageFile.value!.path,),
                                fit: BoxFit.cover,
                                width: Get.width,
                                height: Get.height * 0.2,
                              ),
                            );
                      }),
                      const SizedBox(
                        height: 18,
                      ),
                      const LabelField(
                        text: 'Select File',
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      CustomDropdown(
                        itemList: itemListForSelection,
                        hintText: selectFile != null ? selectFile.toString() : "Choose File",
                        onChanged: (value) {
                          setState(() {
                            selectFile = value;
                            addThingsController.base64Images.clear();
                            addThingsController.imageFiles.clear();
                            addThingsController.pickedFile.value = "";
                            debugPrint("base64Images: ${addThingsController.base64Images.length}");
                            debugPrint("pickedFile: ${addThingsController.pickedFile.value}");
                          });
                          debugPrint("select File: $selectFile");
                        },
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      if(selectFile == "Image")
                        GestureDetector(
                          onTap: addThingsController.pickImages,
                          child: DottedBorder(
                            color: AppColor.primaryColor,
                            strokeWidth: 1,
                            radius: const Radius.circular(10),
                            borderType: BorderType.RRect,
                            child: Container(
                              width: Get.width,
                              height: Get.height * 0.163,
                              color: AppColor.secondaryColor,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(AppAssets.upload),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const LabelField(
                                      text: "Upload Photos (upto 5)",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: AppColor.hintColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      if(selectFile == "Music")
                        GestureDetector(
                          onTap: addThingsController.pickAudioFile,
                          child: DottedBorder(
                            color: AppColor.primaryColor,
                            strokeWidth: 1,
                            radius: const Radius.circular(10),
                            borderType: BorderType.RRect,
                            child: Container(
                              width: Get.width,
                              height: Get.height * 0.1,
                              color: AppColor.secondaryColor,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(AppAssets.upload),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const LabelField(
                                      text: "Upload Music",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: AppColor.hintColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      Obx(() {
                        if (addThingsController.imageFiles.isEmpty) {
                          return const SizedBox();
                        }
                        int rows = (addThingsController.imageFiles.length / 3).ceil();
                        double gridHeight = (Get.width / 3) * rows + (rows - 1) * 10;
                        return SizedBox(
                          height: gridHeight,
                          child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: addThingsController.imageFiles.length,
                            itemBuilder: (context, index) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  File(addThingsController.imageFiles[index].path,),
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          ),
                        );
                      }),
                      Obx(() {
                        return addThingsController.pickedFile.value.isEmpty
                            ? const SizedBox()
                            : const Column(
                          children: [
                            SizedBox(
                              height: 18,
                            ),
                        Row(
                          children: [
                            LabelField(
                              text: 'Selected file: ',
                              align: TextAlign.left,
                            ),
                            LabelField(
                              text: 'File Attached',
                              align: TextAlign.left,
                              fontSize: 14,
                              color: AppColor.hintColor,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                          ],
                        );
                      }
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      const LabelField(
                        text: 'Other Sources/ Links',
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColor.secondaryColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColor.borderColor,
                            width: 1.0,
                          ),
                        ),
                        height: Get.height * 0.085,
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                maxLines: null,
                                controller: linkController,
                                textAlign: TextAlign.left,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: AppColor.hintColor,
                                  fontWeight: FontWeight.w400,
                                ),
                                keyboardType: TextInputType.text,
                                cursorColor: AppColor.hintColor,
                                decoration: InputDecoration(
                                  fillColor: AppColor.secondaryColor,
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  contentPadding: const EdgeInsets.only(
                                    top: 0.0,
                                    left: 12,
                                  ),
                                  hintText: "https://www.siteaddress.com",
                                  hintStyle: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: AppColor.hintColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                                  Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: GestureDetector(
                                onTap:(){
                                  String link = linkController.text.trim();
                                  if (link.isEmpty) {
                                    return CustomSnackbar.show(title: "Error", message: "Please add link before adding");
                                  } else {
                                    if (!link.startsWith('https://')) {
                                      link = 'https://$link';
                                    }
                                    addThingsController.addLink(link);
                                    linkController.clear();
                                    }
                                  },
                                child: const Icon(
                                  Icons.check_circle_outline_rounded,
                                  color: AppColor.primaryColor,
                                  size: 30,
                                ),
                              ),
                            ),
                          ],
                        )
                      ),
                      Obx(() {
                        return addThingsController.links.isNotEmpty
                            ? Column(
                          children: [
                            SizedBox(
                              height: 150,
                              child: ListView.builder(
                                itemCount: addThingsController.links.length,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 5),
                                    decoration: BoxDecoration(
                                      color: AppColor.primaryColor,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          LabelField(align: TextAlign.left, text: addThingsController.links[index], color: AppColor.whiteColor,),
                                          GestureDetector(
                                            onTap: () {
                                              addThingsController.deleteLink(index);
                                            },
                                            child: const Icon(
                                                Icons.close,
                                                color: AppColor.whiteColor,
                                              ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        )
                            :  const SizedBox();
                      }),
                      const SizedBox(
                        height: 18,
                      ),

                      // const LabelField(
                      //   text: 'Tags',
                      // ),
                      // const SizedBox(
                      //   height: 8,
                      // ),
                      // Row(
                      //   children: [
                      //     CustomTextFormField(
                      //       height: 40,
                      //       width: Get.width * 0.3,
                      //       controller: textController,
                      //       hintText: "Add Tags",
                      //       keyboardType: TextInputType.text,
                      //       textInputAction: TextInputAction.next,
                      //       showSuffix: false,
                      //     ),
                      //     Padding(
                      //       padding: const EdgeInsets.only(left: 5.0),
                      //       child: IconButton(
                      //         onPressed: (){
                      //           if (textController.text.isEmpty) {
                      //             return CustomSnackbar.show(title: "Error", message: "Please type tag before adding");
                      //           } else {
                      //             addThingsController.addTag(textController.text);
                      //             textController.clear();
                      //             // setState(() {});
                      //           }
                      //         },
                      //         icon: const Icon(
                      //           Icons.add_circle_outline_rounded,
                      //           color: AppColor.primaryColor,
                      //           size: 35,
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // Obx(() {
                      //   return addThingsController.tags.isNotEmpty
                      //       ? Column(
                      //     children: [
                      //       const SizedBox(
                      //         height: 10,
                      //       ),
                      //       SizedBox(
                      //         height: 35,
                      //         child: ListView.builder(
                      //           itemCount: addThingsController.tags.length,
                      //           scrollDirection: Axis.horizontal,
                      //           itemBuilder: (context, index) {
                      //             return Container(
                      //               margin: const EdgeInsets.only(right: 5),
                      //               decoration: BoxDecoration(
                      //                 color: AppColor.primaryColor,
                      //                 borderRadius: BorderRadius.circular(5),
                      //               ),
                      //               child: Center(
                      //                 child: Padding(
                      //                   padding: const EdgeInsets.all(8.0),
                      //                   child: Row(
                      //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //                     children: [
                      //                       LabelField(text: addThingsController.tags[index], color: AppColor.whiteColor,),
                      //                       const SizedBox(width: 10,),
                      //                       GestureDetector(
                      //                         onTap: () {
                      //                           addThingsController.deleteTag(index);
                      //                         },
                      //                         child: const Icon(
                      //                           Icons.close,
                      //                           size: 15,
                      //                           color: AppColor.whiteColor,
                      //                         ),
                      //                       ),
                      //                     ],
                      //                   ),
                      //                 ),
                      //               ),
                      //             );
                      //           },
                      //         ),
                      //       ),
                      //     ],
                      //   )
                      //       :  const SizedBox();
                      // }),
                      // const SizedBox(
                      //   height: 18,
                      // ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: _toggleCheckbox,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: AppColor.secondaryColor,
                                border: Border.all(
                                  color: _isChecked
                                      ? AppColor.primaryColor
                                      : AppColor.borderColor,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Center(
                                child: FadeTransition(
                                  opacity: _animation,
                                  child: const Icon(
                                    Icons.check_rounded,
                                    size: 15,
                                    color: AppColor.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const LabelField(
                            text: "Confirmed by a moderator",
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColor.lightBrown,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      Obx(
                            () => addThingsController.isLoading.value
                            ? LargeButton(
                          text: "Please Wait...",
                          onTap: () {},
                        )
                            : LargeButton(
                              text: "Add Thing",
                              onTap: ()  {
                                if (formKey.currentState!.validate()) {
                                  if(_isVerfied){
                                    addThingsController.addThings(
                                      categoriesId: selectThirdCategoryId != null ? selectThirdCategoryId.toString() : selectSubCategoryId != null ? selectSubCategoryId.toString() : selectCategoryId.toString(),
                                      name: thingNameController.text.toString(),
                                      earnPoints: pointsController.text.toString(),
                                      location: locationController.text.toString(),
                                      longitude: longitude.toString(),
                                      lattitude: latitude.toString(),
                                      countryId: selectCountryId.toString(),
                                      placeId: placesId.toString(),
                                      stateId: selectStatesId.toString(),
                                      cityId: selectCityId.toString(),
                                      confirmModerator: _isChecked ? "Yes" : "No",
                                      description: descController.text.toString(),
                                    );
                                  } else {
                                    showDialog(
                                      context: context,
                                      barrierColor: Colors.grey.withOpacity(0.4),
                                      barrierDismissible: true,
                                      builder: (BuildContext context) => HumanVerification(verified: humanVerification,),
                                    );
                                  }
                                }
                              },
                            ),
                      ),
                      SizedBox(
                        height: Get.height * 0.02,
                      ),
                    ],
                  ),);
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}