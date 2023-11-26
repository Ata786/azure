import 'dart:developer';

import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:label_marker/label_marker.dart';
import 'package:SalesUp/controllers/UserController.dart';
import 'package:SalesUp/model/userTrackLocationModel.dart';
import 'package:SalesUp/res/base/fetch_pixels.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrackMap extends StatefulWidget {
  List<UserTrackLocationModel> userTrackingLocation = [];
  TrackMap(this.userTrackingLocation, {super.key});

  @override
  State<TrackMap> createState() => _TrackMapState();
}

class _TrackMapState extends State<TrackMap> {


  late GoogleMapController googleMapController;
  Set<Marker> markers = {};

  Set<Polyline> polylines = {};

  List<LatLng> coordinates = [];

  @override
  void initState() {
    super.initState();
    track();
  }


  void track()async{

    widget.userTrackingLocation.sort((a, b) {
      DateTime dateTimeA = DateTime.parse(a.datetime!);
      DateTime dateTimeB = DateTime.parse(b.datetime!);

      return dateTimeA.compareTo(dateTimeB);
    });

    for(int i=0; i<widget.userTrackingLocation.length; i++){

      List<Placemark> placemarks = await placemarkFromCoordinates(widget.userTrackingLocation[i].latitude ?? 0.0, widget.userTrackingLocation[i].longitude ?? 0.0);
      Placemark firstPlacemark = placemarks.first;
      String address = " ${firstPlacemark.administrativeArea} ${firstPlacemark.locality} ${firstPlacemark.subLocality}";

      DateTime dateTime = DateTime.parse(widget.userTrackingLocation[i].datetime!);
      String formattedTime = DateFormat('HH:mm').format(dateTime);


      LatLng position = LatLng(widget.userTrackingLocation[i].latitude ?? 0.0, widget.userTrackingLocation[i].longitude ?? 0.0);


      coordinates.add(position);

      markers.addLabelMarker(LabelMarker(backgroundColor: Colors.red,label: "${i}", markerId: MarkerId("${i}"), position: position,
          infoWindow: InfoWindow(title: "${address}",snippet: "${formattedTime}"))).then((value) {
        setState(() {

        });
      });


      polylines.add(
        Polyline(
          polylineId: PolylineId("${i}"),
          color: Colors.blue,
          points: coordinates,  // Use the same coordinate list for the polyline
          width: 5,
        ),
      );


    }

  }




  @override
  Widget build(BuildContext context) {
    UserController userController = Get.find<UserController>();
    FetchPixels(context);
    return Scaffold(
      body: Container(
        height: FetchPixels.height,
        width: FetchPixels.width,
        child: GoogleMap(initialCameraPosition: CameraPosition(
            target: LatLng(widget.userTrackingLocation[0].latitude ?? 0.0, widget.userTrackingLocation[0].longitude ?? 0.0),zoom: 13),
          markers: Set<Marker>.of(markers),
          polylines: polylines,
          onMapCreated: (controller){
            googleMapController = controller;
          },),
      ),
    );
  }




}
