import 'dart:convert';
import 'dart:developer';

import 'package:SalesUp/controllers/UserController.dart';
import 'package:SalesUp/data/getApis.dart';
import 'package:SalesUp/data/hiveDb.dart';
import 'package:SalesUp/model/SetUserLocationModel.dart';
import 'package:SalesUp/res/base/fetch_pixels.dart';
import 'package:SalesUp/utils/toast.dart';
import 'package:SalesUp/utils/userCurrentLocation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../res/colors.dart';
import 'package:http/http.dart' as http;

class UpdateLocationScreen extends StatelessWidget {
  UpdateLocationScreen({super.key});

  List<Marker> marker = [];
  late GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    UserController userController = Get.find<UserController>();
    marker.add(Marker(markerId: MarkerId("0"),position: LatLng(userController.latitude ?? 0.0, userController.longitude ?? 0.0)));
    FetchPixels(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
        title: Text(
          "Set User Location",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        height: FetchPixels.height,
        width: FetchPixels.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: FetchPixels.getPixelHeight(30),),
            Padding(
              padding: EdgeInsets.only(left: FetchPixels.getPixelWidth(20)),
              child: Text(
                "Name:- ${userController.user!.value.fullName}",
                style: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(height: FetchPixels.getPixelHeight(30),),
            Container(
              margin: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
              height: FetchPixels.getPixelHeight(200),
              width: FetchPixels.width,
              child: GoogleMap(
                zoomControlsEnabled: false,
                markers: Set.of(marker),
                initialCameraPosition: CameraPosition(zoom: 13,target: LatLng(userController.latitude ?? 0.0, userController.longitude ?? 0.0)
                ),
                onMapCreated: (controller){
                  mapController = controller;
                },
              ),
            ),
            SizedBox(height: FetchPixels.getPixelHeight(30),),
            InkWell(
              onTap: ()async{
                // final placemarks = await placemarkFromCoordinates(userController.latitude, userController.longitude);
                // String locationName = "";
                //
                // if (placemarks.isNotEmpty) {
                //   final placemark = placemarks[0];
                //   locationName = "${placemark.thoroughfare}, ${placemark.locality}, ${placemark.administrativeArea}";
                // }
                // SetUserLocationModel setUserLocationModel = SetUserLocationModel(name: userController.user!.value.fullName,latitude: userController.latitude,longitude: userController.longitude,location: locationName);
                // HiveDatabase.setUserLocation("userLocation", "userLocationBox", setUserLocationModel);
                if(userController.isOnline.value == true){
                  setLocation();
                }else{
                  showToast(context, "Check Internet Service and try again");
                }

              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
                height: FetchPixels.getPixelHeight(50),
                width: FetchPixels.width,
                color: themeColor,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(left: FetchPixels.getPixelWidth(20)),
                    child: Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }


  void setLocation()async{

    try{

      Get.dialog(
          Center(child: CircularProgressIndicator(color: themeColor),)
      );
      UserController userController = Get.find<UserController>();
      Position? location = await getLocation(Get.context!);
      String lat = "0.0";
      String lon = "0.0";

      if(location != null){
        lat = location.latitude.toString();
        lon = location.longitude.toString();
      }

      var res = await http.post(
          Uri.parse("${BASE_URL}/UserLocation"),
          body: {"UserId": userController.user!.value.id,"Longitude": lon,"Latitude": lat}
      );

      log('>>>> ${res.body} and ${res.statusCode}');

      if(res.statusCode == 200){
        Get.back();
        Get.back();
        Fluttertoast.showToast(
            msg: "Location is set Successfully",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: themeColor,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }else{
        Get.back();
        Fluttertoast.showToast(
            msg: "Location is not set",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: themeColor,
            textColor: Colors.white,
            fontSize: 16.0
        );
        print('>>> ${res.body}');
      }

    }catch(e){
      Get.back();
      print('>>>> ${e.toString()}');
    }

  }



}
