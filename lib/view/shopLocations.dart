import 'package:SalesUp/model/syncDownModel.dart';
import 'package:SalesUp/res/base/fetch_pixels.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ShopLocations extends StatefulWidget {
  List<SyncDownModel>  syncDownList = [];
  ShopLocations({super.key,required this.syncDownList});

  @override
  State<ShopLocations> createState() => _ShopLocationsState();
}

class _ShopLocationsState extends State<ShopLocations> {

  late GoogleMapController googleMapController;
  List<Marker> markers = [];

  @override
  void initState() {
    super.initState();

    for(int i=0; i<widget.syncDownList.length; i++){
      String gprs = widget.syncDownList[i].gprs ?? "0.0,0.0";
      List<String> location = gprs.split(",");
      markers.add(Marker(markerId: MarkerId("${i.toString()}"),position: LatLng(double.tryParse(location[0]) ?? 0.0, double.tryParse(location[1]) ?? 00.0),infoWindow: InfoWindow(title: "${widget.syncDownList[i].shopname}")));
    }
  }

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);

    double minLat = double.infinity;
    double maxLat = double.negativeInfinity;
    double minLng = double.infinity;
    double maxLng = double.negativeInfinity;

    for (final marker in markers) {
      final lat = marker.position.latitude;
      final lng = marker.position.longitude;

      minLat = lat < minLat ? lat : minLat;
      maxLat = lat > maxLat ? lat : maxLat;
      minLng = lng < minLng ? lng : minLng;
      maxLng = lng > maxLng ? lng : maxLng;
    }

    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    return Scaffold(
      body: Container(
        height: FetchPixels.height,
        width: FetchPixels.width,
        child: GoogleMap(
          markers: Set<Marker>.from(markers),
          zoomControlsEnabled: false,
          initialCameraPosition: CameraPosition(zoom: 12,target: bounds.northeast
          ),
          onMapCreated: (controller){
            googleMapController = controller;
          },
        ),
      ),
    );
  }
}
