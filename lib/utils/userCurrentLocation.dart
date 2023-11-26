import 'package:SalesUp/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

Future<Position?> getLocation(BuildContext context)async{

  try{

    bool serviceEnabled;
    LocationPermission permission;

// Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      Geolocator.openLocationSettings();
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: themeColor,content: Text('Permission denied')));
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: themeColor,content: Text('Location permissions are permanently denied, we cannot request permissions.')));
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getLastKnownPosition();

  }catch (e) {
    print('Error: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: themeColor,
        content: Text('Error getting location: $e'),
      ),
    );
    return null; // or return a default position or handle it as needed
  }

}








Future<Position?> getCurrentLocation()async{
  bool serviceEnabled;
  LocationPermission permission;

// Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();

  if (!serviceEnabled) {
    Geolocator.openLocationSettings();
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      Get.snackbar("", "'Permission denied'");
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    Get.snackbar("", "Permission denied'Location permissions are permanently denied, we cannot request permissions.");
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }
  return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
}