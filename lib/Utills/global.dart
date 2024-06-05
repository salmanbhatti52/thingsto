import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:thingsto/Widgets/snackbar.dart';

class GlobalService {
  static String? _currentAddress;
  static Position? _currentPosition;

  static Future<bool> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      CustomSnackbar.show(title: "Error", message: "Location services are disabled. Please enable the services.",);
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        CustomSnackbar.show(title: "Error", message: "Location permissions are denied.",);
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      CustomSnackbar.show(title: "Error", message: "Location permissions are permanently denied, we cannot request permissions.",);
      return false;
    }
    return true;
  }

  static Future<void> getCurrentPosition() async {
    final hasPermission = await handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      _currentPosition = position;
      getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  static Future<Map<String, String?>> getAddressFromLatLng(Position position) async {
    String? address, city, state, country, postalCode;
    await placemarkFromCoordinates(position.latitude, position.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      address = '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}';
      city = place.locality;
      state = place.administrativeArea;
      country = place.country;
      postalCode = place.postalCode;
      _currentAddress = address!;
    }).catchError((e) {
      debugPrint(e);
      return e;
    });
    return {
      'address': address,
      'city': city,
      'state': state,
      'country': country,
      'postalCode': postalCode,
    };
  }

  // Getter for _currentPosition
  static Position? get currentLocation => _currentPosition;

  // Getter for _currentAddress
  static String? get currentAddress => _currentAddress;
}
