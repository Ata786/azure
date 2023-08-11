import 'package:azure/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

Future<Position?> getLocation(BuildContext context)async{
  bool serviceEnabled;
  LocationPermission permission;

// Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();


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
}