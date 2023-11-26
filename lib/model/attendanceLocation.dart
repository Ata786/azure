import 'package:SalesUp/res/base/fetch_pixels.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AttendanceLocation extends StatelessWidget {
  double lat = 0.0,lon = 0.0;
  AttendanceLocation(this.lat,this.lon,{super.key});

  late GoogleMapController googleMapController;
  List<Marker> markers = [];

  @override
  Widget build(BuildContext context) {
    markers.add(Marker(markerId: MarkerId("0"),position: LatLng(lat, lon)));
    FetchPixels(context);
    return Container(
      height: FetchPixels.height,
      width: FetchPixels.width,
      child: GoogleMap(
        markers: Set<Marker>.from(markers),
        zoomControlsEnabled: false,
        initialCameraPosition: CameraPosition(zoom: 12,target: LatLng(lat, lon)
        ),
        onMapCreated: (controller){
          googleMapController = controller;
        },
      ),
    );
  }
}
