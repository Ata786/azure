import 'dart:io';

import 'package:azure/controllers/UserController.dart';
import 'package:azure/res/base/fetch_pixels.dart';
import 'package:azure/utils/widgets/appWidgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../utils/widgets/imagePickerDialog.dart';

class NewShops extends StatefulWidget {
  NewShops({super.key});

  @override
  State<NewShops> createState() => _NewShopsState();
}

class _NewShopsState extends State<NewShops> {
  TextEditingController shopNameCtr = TextEditingController();
  TextEditingController shopAddressCtr = TextEditingController();
  TextEditingController ownerPhoneCtr = TextEditingController();
  TextEditingController ownerNameCtr = TextEditingController();
  TextEditingController ownerCnicCtr = TextEditingController();
  TextEditingController strnCtr = TextEditingController();
  TextEditingController ntnCtr = TextEditingController();
  
  String shopImage = "";

  List<String> salesTextList = ["Select an Option","Option 1","Option 2"];
  String salesText = "Select an Option";

  List<String> sectorList = ["Select an Option","Option 1","Option 2"];
  String sector = "Select an Option";

  List<String> shopTypeList = ["Select an Option","Option 1","Option 2"];
  String shopType = "Select an Option";

  @override
  Widget build(BuildContext context) {
    UserController userController = Get.find<UserController>();
    FetchPixels(context);
    return Scaffold(
      appBar: AppBar(
        title: textWidget(
            text: "Customer Info",
            fontSize: FetchPixels.getPixelHeight(16),
            fontWeight: FontWeight.w600,
            textColor: Colors.white),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        height: FetchPixels.height,
        width: FetchPixels.width,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
            child: Column(
              children: [
                SizedBox(
                  height: FetchPixels.getPixelHeight(20),
                ),
               Container(
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     textWidget(
                         text: "Customer Info",
                         fontSize: FetchPixels.getPixelHeight(13),
                         fontWeight: FontWeight.w600,
                         textColor: Colors.black),
                     SizedBox(height: FetchPixels.getPixelHeight(5),),
                     textField(controller: shopNameCtr, hintText: "Shop Name",helperText: ""),
                   ],
                 ),
               ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textWidget(
                          text: "Customer Address",
                          fontSize: FetchPixels.getPixelHeight(13),
                          fontWeight: FontWeight.w600,
                          textColor: Colors.black),
                      SizedBox(height: FetchPixels.getPixelHeight(5),),
                      textField(controller: shopAddressCtr, hintText: "Shop Address",helperText: ""),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textWidget(
                          text: "Owner Phone",
                          fontSize: FetchPixels.getPixelHeight(13),
                          fontWeight: FontWeight.w600,
                          textColor: Colors.black),
                      SizedBox(height: FetchPixels.getPixelHeight(5),),
                      textField(controller: ownerPhoneCtr, hintText: "Owner Phone",helperText: ""),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textWidget(
                          text: "Owner Name",
                          fontSize: FetchPixels.getPixelHeight(13),
                          fontWeight: FontWeight.w600,
                          textColor: Colors.black),
                      SizedBox(height: FetchPixels.getPixelHeight(5),),
                      textField(controller: ownerNameCtr, hintText: "Owner Name",helperText: ""),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textWidget(
                          text: "Owner Cnic",
                          fontSize: FetchPixels.getPixelHeight(13),
                          fontWeight: FontWeight.w600,
                          textColor: Colors.black),
                      SizedBox(height: FetchPixels.getPixelHeight(5),),
                      textField(controller: ownerCnicCtr, hintText: "Owner Cnic",helperText: ""),
                    ],
                  ),
                ),
                SizedBox(
                  height: FetchPixels.getPixelHeight(40),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    textWidget(
                        text: "Shop Location",
                        fontSize: FetchPixels.getPixelHeight(13),
                        fontWeight: FontWeight.w500,
                        textColor: Colors.black),
                    Container(
                      height: FetchPixels.getPixelHeight(100),
                      width: FetchPixels.getPixelWidth(100),
                      child: GoogleMap(
                        zoomControlsEnabled: false,
                        initialCameraPosition: CameraPosition(
                            zoom: 12,
                            target: LatLng(userController.latitude,
                                userController.longitude)),
                        markers: _createMarkers(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: FetchPixels.getPixelHeight(20),),
                textField(controller: strnCtr, hintText: "STRN",helperText: ""),
                textField(controller: ntnCtr, hintText: "NTN",helperText: ""),
                dropDownWidget("Sales Tax Registered",salesTextList,salesText),
                dropDownWidget("Sector",sectorList,sector),
                dropDownWidget("Shop Type",shopTypeList,shopType),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    textWidget(
                        text: "Shop Image",
                        fontSize: FetchPixels.getPixelHeight(13),
                        fontWeight: FontWeight.w500,
                        textColor: Colors.black),
                    Container(
                      height: FetchPixels.getPixelHeight(100),
                      width: FetchPixels.getPixelWidth(100),
                      child: InkWell(
                          onTap: (){
                            ImagePickerDialog.imagePickerDialog(context: context,
                                myHeight: FetchPixels.height, myWidth: FetchPixels.width, setFile: (f){
                                  setState(() {
                                    shopImage = f.path;
                                  });
                                });
                          },
                          child: shopImage == "" ? Icon(Icons.camera_alt) : Container(
                            height: FetchPixels.getPixelHeight(40),
                            width: FetchPixels.getPixelWidth(40),
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            child: CircleAvatar(
                              backgroundImage: FileImage(File(shopImage)),
                              backgroundColor: Colors.transparent,
                            ),
                          )),
                    ),
                  ],
                ),
                SizedBox(height: FetchPixels.getPixelHeight(50),),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Set<Marker> _createMarkers() {
    UserController userController = Get.find<UserController>();
    // Replace the marker position with your desired coordinates
    LatLng markerPosition =
        LatLng(userController.latitude, userController.longitude);

    // Create a marker with a title and position.
    final Marker marker = Marker(
      markerId: MarkerId('marker_id_1'),
      position: markerPosition,
      infoWindow: InfoWindow(title: 'Marker Title', snippet: 'Marker Snippet'),
    );

    // Return a set containing the marker.
    return {marker};
  }

  Widget dropDownWidget(String label,List<String> list,String value){
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textWidget(
              text: label,
              fontSize: FetchPixels.getPixelHeight(13),
              fontWeight: FontWeight.w600,
              textColor: Colors.black),
          SizedBox(height: FetchPixels.getPixelHeight(5),),
          DropdownButtonFormField<String>(
            itemHeight: FetchPixels.getPixelHeight(50),
            isDense: true,
            isExpanded: true,
            decoration: InputDecoration(
              helperText: "",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(8)),
                  borderSide: BorderSide(color: Colors.black, width: 1)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(8)),
                  borderSide: BorderSide(color: Colors.black, width: 1)),
            ),
            value: value,
            onChanged: (newValue) {
              setState(() {
                value = newValue!;
              });
            },
            items: list.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value ?? ""),
              );
            }).toList(),
          )
        ],
      ),
    );
  }








}
