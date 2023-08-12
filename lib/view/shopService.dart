import 'dart:io';
import 'package:azure/controllers/UserController.dart';
import 'package:azure/controllers/shopServiceController.dart';
import 'package:azure/data/hiveDb.dart';
import 'package:azure/res/base/fetch_pixels.dart';
import 'package:azure/res/colors.dart';
import 'package:azure/utils/widgets/appWidgets.dart';
import 'package:azure/utils/widgets/imagePickerDialog.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../model/reasonName.dart';
import '../model/reasonsModel.dart';
import '../res/images.dart';

class ShopService extends StatefulWidget {
  const ShopService({super.key});

  @override
  State<ShopService> createState() => _ShopServiceState();
}

class _ShopServiceState extends State<ShopService> {
  late Map<String, dynamic> arguments;


  List<ReasonsModel> reasons = [];
  late String selectedItem;
  double distance = 0.0;

  @override
  void initState() {
    super.initState();
    arguments = Get.arguments;
    reasons = arguments['reasons'] as  List<ReasonsModel>;
    selectedItem = reasons[0].reasonName ?? "";
  }

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    UserController userController = Get.find<UserController>();
    ShopServiceController shopServiceController = Get.find<ShopServiceController>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0.5,
        title: textWidget(
            text: arguments['shopName'],
            fontSize: FetchPixels.getPixelHeight(16),
            fontWeight: FontWeight.w600,
            textColor: Colors.black),
      ),
      body: Container(
        height: FetchPixels.height,
        width: FetchPixels.width,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(10)),
          child: Column(
            children: [
              SizedBox(
                height: FetchPixels.getPixelHeight(50),
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: FetchPixels.getPixelWidth(20)),
                    child: textWidget(
                        text: "Take Image",
                        fontSize: FetchPixels.getPixelHeight(16),
                        fontWeight: FontWeight.w600,
                        textColor: Colors.black),
                  ),
                ),
               Expanded(
                 child: Stack(
                   children: [
                     Center(
                       child: InkWell(
                         onTap: (){
                           ImagePickerDialog.imagePickerDialog(context: context,
                               myHeight: FetchPixels.height, myWidth: FetchPixels.width, setFile: (f){
                             if(f.path.isNotEmpty){
                               shopServiceController.image.value = f.path;
                             }
                               });
                         },
                         child: Container(
                           height: FetchPixels.getPixelHeight(80),
                           width: FetchPixels.getPixelWidth(80),
                           decoration: BoxDecoration(
                               color: themeColor,
                               shape: BoxShape.circle,
                           ),
                           child: Obx(() => shopServiceController.image.value == "" ? Container(
                             margin: EdgeInsets.all(3),
                             decoration: BoxDecoration(
                                 color: Colors.white,
                                 shape: BoxShape.circle,
                             ),
                             child: Image.asset(pic),
                           ) : Container(
                             margin: EdgeInsets.all(3),
                             decoration: BoxDecoration(
                                 color: Colors.white,
                                 shape: BoxShape.circle,
                             ),
                             child: CircleAvatar(
                                 backgroundImage: FileImage(File(shopServiceController.image.value)),
                                 backgroundColor: Colors.transparent,
                               ),
                           ),)
                         ),
                       ),
                     ),
                     Positioned(
                         right: FetchPixels.getPixelWidth(15),
                         bottom: FetchPixels.getPixelHeight(6),
                         child: Icon(Icons.camera_alt,color: themeColor,))
                   ],
                 )
               ),
                Expanded(child: SizedBox())
              ]),
              SizedBox(height: FetchPixels.getPixelHeight(20),),
              Container(height: FetchPixels.getPixelHeight(1),width: FetchPixels.width,color: Colors.black,),
              SizedBox(height: FetchPixels.getPixelHeight(10),),
              Align(alignment: Alignment.centerLeft,child: textWidget(text: "Reason for not servicing the store", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w600),),
              SizedBox(height: FetchPixels.getPixelHeight(10),),
        Padding(
          padding: EdgeInsets.symmetric(vertical: FetchPixels.getPixelHeight(15)),
          child: DropdownButtonFormField<String>(
            isExpanded: true,
            decoration: InputDecoration(
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
            value: selectedItem,
            onChanged: (newValue) {
              setState(() {
                selectedItem = newValue!;
              });
            },
            items: reasons.map<DropdownMenuItem<String>>((ReasonsModel value) {
              return DropdownMenuItem<String>(
                value: value.reasonName,
                child: Text(value.reasonName ?? ""),
              );
            }).toList(),
          ),
        ),
              SizedBox(height: FetchPixels.getPixelHeight(20),),
              Container(
                height: FetchPixels.getPixelHeight(200),
                width: FetchPixels.width,
                child: GoogleMap(
                    initialCameraPosition: CameraPosition(zoom: 12,target: LatLng(userController.latitude, userController.longitude)
                    ),
                  markers: _createMarkers(),
                ),
              ),
              SizedBox(height: FetchPixels.getPixelHeight(7),),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  textWidget(text: "${distance.toStringAsFixed(3)}m from shop", fontSize: FetchPixels.getPixelHeight(12), fontWeight: FontWeight.w600,textColor: primaryColor),
                  SizedBox(width: FetchPixels.getPixelWidth(5),),
                  Icon(Icons.info_outline,size: FetchPixels.getPixelHeight(18),)
                ],
              ),
              SizedBox(height: FetchPixels.getPixelHeight(10),),
              Align(alignment: Alignment.centerRight,child: InkWell(
                onTap: (){
                  String gprs = arguments['gprs'];
                  List<String> gprsLatLng = gprs.split(',');
                  double? lat = double.tryParse(gprsLatLng[0]);
                  double? lon = double.tryParse(gprsLatLng[1]);
                  double dis = Geolocator.distanceBetween(userController.latitude, userController.longitude, lat ?? 0.0, lon ?? 0.0);
                  distance = dis;
                  setState(() {
                    
                  });
                },
                child: button(
                    height: FetchPixels.getPixelHeight(35),
                    width: FetchPixels.getPixelWidth(90),
                    color: themeColor,
                    textColor: Colors.white,
                    textSize: FetchPixels.getPixelHeight(10), borderRadius: FetchPixels.getPixelHeight(20),
                    textWeight: FontWeight.w500, text: "Update GPS"),
              ),),
              SizedBox(height: FetchPixels.getPixelHeight(20),),
              Container(height: FetchPixels.getPixelHeight(1),width: FetchPixels.width,color: Colors.black,),
              SizedBox(height: FetchPixels.getPixelHeight(10),),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: ()async{
                      if(shopServiceController.image.value == '' || distance == 0.0){
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Image and Distance is required"),behavior: SnackBarBehavior.floating,));
                      }else{
                        String formattedDateTime = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());
                        ReasonModel reasonModel = ReasonModel(shopName: arguments['shopName'],shopId: arguments['sr'],bookerId: userController.user!.value.catagoryId,checkIn: distance.toString(),createdOn: formattedDateTime,image: shopServiceController.image.value,payment: "Nun",reason: selectedItem ?? '',pjpnumber: "0");
                        var box = await Hive.openBox("reasonNo");
                        List<dynamic> data = box.get("reason") ?? [];
                         List<ReasonModel> reasonModelList = data.map((e) => ReasonModel(shopName: e.shopName,shopId: e.shopId,bookerId: e.bookerId,
                              checkIn: e.checkIn,createdOn: e.createdOn,reason: e.reason,image: e.image,payment: "payment",pjpnumber: e.pjpnumber)).toList();
                        reasonModelList.add(reasonModel);
                          HiveDatabase.setReasonData("reasonNo", "reason", reasonModelList);
                        Get.back();
                      }
                    },
                    child: button(
                        height: FetchPixels.getPixelHeight(35),
                        width: FetchPixels.getPixelWidth(100),
                        color: themeColor,
                        textColor: Colors.white,
                        textSize: FetchPixels.getPixelHeight(10), borderRadius: FetchPixels.getPixelHeight(20),
                        textWeight: FontWeight.w500, text: "Okay"),
                  ),
                  SizedBox(width: FetchPixels.getPixelWidth(10),),
                  InkWell(
                    onTap: (){
                      Get.back();
                    },
                    child: button(
                        height: FetchPixels.getPixelHeight(35),
                        width: FetchPixels.getPixelWidth(100),
                        color: themeColor,
                        textColor: Colors.white,
                        textSize: FetchPixels.getPixelHeight(10), borderRadius: FetchPixels.getPixelHeight(20),
                        textWeight: FontWeight.w500, text: "Cancel"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Set<Marker> _createMarkers() {
    UserController userController = Get.find<UserController>();
    // Replace the marker position with your desired coordinates
    LatLng markerPosition = LatLng(userController.latitude, userController.longitude);

    // Create a marker with a title and position.
    final Marker marker = Marker(
      markerId: MarkerId('marker_id_1'),
      position: markerPosition,
      infoWindow: InfoWindow(title: 'Marker Title', snippet: 'Marker Snippet'),
    );

    // Return a set containing the marker.
    return {marker};
  }

}
