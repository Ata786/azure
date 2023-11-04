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
  List<Marker> markers = [];

  List<Polyline> polylines = [];

  @override
  void initState() {
    super.initState();

    for(int i=0; i<widget.userTrackingLocation.length; i++){
      markers.add(Marker(markerId: MarkerId("${i.toString()}"),position: LatLng(widget.userTrackingLocation[i].latitude ?? 0.0, widget.userTrackingLocation[i].longitude ?? 0.0),infoWindow: InfoWindow(title: "${widget.userTrackingLocation[i].email}")));

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
            target: LatLng(userController.latitude ?? 0.0, userController.longitude ?? 0.0),zoom: 12),
          markers: Set<Marker>.from(markers),
          onMapCreated: (controller){
            googleMapController = controller;
          },),
      ),
    );
  }
}
