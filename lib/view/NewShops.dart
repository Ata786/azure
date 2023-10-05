import 'dart:developer';
import 'dart:io';
import 'package:SalesUp/controllers/UserController.dart';
import 'package:SalesUp/controllers/syncNowController.dart';
import 'package:SalesUp/data/hiveDb.dart';
import 'package:SalesUp/model/shopsTexModel.dart';
import 'package:SalesUp/model/syncDownModel.dart';
import 'package:SalesUp/res/base/fetch_pixels.dart';
import 'package:SalesUp/res/colors.dart';
import 'package:SalesUp/utils/widgets/appWidgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import '../model/NewShopModel.dart';
import '../utils/FieldVlidation.dart';
import '../utils/routes/routePath.dart';
import '../utils/userCurrentLocation.dart';
import '../utils/widgets/imagePickerDialog.dart';
import 'dashboard/home.dart';

class NewShops extends StatefulWidget {
  int? sr;
  bool? isEdit,todayShopEdit;
  NewShopModel? newShopModel;
  SyncDownModel? shop;
  int? sectorId,statusId,typeId;
  NewShops({super.key, this.sr,this.isEdit,this.newShopModel,this.todayShopEdit,this.shop,this.sectorId,this.statusId,this.typeId});

  @override
  State<NewShops> createState() => _NewShopsState();
}

class _NewShopsState extends State<NewShops> {
  late TextEditingController shopNameCtr;
  late TextEditingController shopAddressCtr;
  late TextEditingController ownerPhoneCtr;
  late TextEditingController ownerNameCtr;
  late TextEditingController ownerCnicCtr;
  late TextEditingController strnCtr;
  late TextEditingController ntnCtr;

  String shopImage = "";

  String salesText = "";
  String sector = "";
  String shopType = "";
  late int salesTaxSr;
  late int sectorSr;
  late int shopTypeSr;

  double lat = 0.0;
  double lon = 0.0;

  List<String> latLng = [];
  SyncDownModel syncDownModel = SyncDownModel();

  @override
  void initState() {
    super.initState();
    SyncNowController syncNowController = Get.find<SyncNowController>();
    if(widget.isEdit == false){
      if(widget.todayShopEdit == true){
        log('>>>> 111');
        shopNameCtr = TextEditingController(text: widget.newShopModel!.shopName ?? "");
        shopAddressCtr = TextEditingController(text: widget.newShopModel!.shopAddress ?? "");
        ownerPhoneCtr = TextEditingController(text: widget.newShopModel!.ownerPhone ?? "");
        ownerNameCtr = TextEditingController(text: widget.newShopModel!.ownerName ?? "");
        ownerCnicCtr = TextEditingController(text: widget.newShopModel!.ownerCnic ?? "");
        strnCtr = TextEditingController(text: widget.newShopModel!.strn ?? "");
        ntnCtr = TextEditingController(text: widget.newShopModel!.myntn ?? "");
        latLng = widget.newShopModel!.gprs!.split(',');
        lat = double.tryParse(latLng[0])!;
        lon = double.tryParse(latLng[1])!;
        shopImage = widget.newShopModel!.picture ?? '';
        salesText = widget.newShopModel!.salesTax!;
        sector = widget.newShopModel!.sector!;
        shopType = widget.newShopModel!.shopType!;
        shopTypeSr = widget.newShopModel!.shopTypeSr!;
        salesTaxSr = widget.newShopModel!.salesTaxSr!;
        sectorSr = widget.newShopModel!.sectorSr!;
      }else{
        shopNameCtr = TextEditingController();
        shopAddressCtr = TextEditingController();
        ownerPhoneCtr = TextEditingController();
        ownerNameCtr = TextEditingController();
        ownerCnicCtr = TextEditingController();
        strnCtr = TextEditingController();
        ntnCtr = TextEditingController();
        salesText = syncNowController.shopStatusList[0].name!;
        sector = syncNowController.shopSectorList[0].name!;
        shopType = syncNowController.shopTypeList[0].name!;
        salesTaxSr = syncNowController.shopStatusList[0].sr!;
        sectorSr = syncNowController.shopSectorList[0].sr!;
        shopTypeSr = syncNowController.shopTypeList[0].sr!;
      }
    }else{
      log('>>> 222');
      syncDownModel = syncNowController.searchList
          .firstWhere((element) => element.sr == widget.sr);
      shopNameCtr = TextEditingController(text: syncDownModel.shopname ?? "");
      shopAddressCtr = TextEditingController(text: syncDownModel.address ?? "");
      ownerPhoneCtr = TextEditingController(text: syncDownModel.phone ?? "");
      ownerNameCtr = TextEditingController(text: syncDownModel.owner ?? "");
      ownerCnicCtr = TextEditingController(text: syncDownModel.cnic ?? "");
      strnCtr = TextEditingController(text: syncDownModel.tax ?? "");
      ntnCtr = TextEditingController(text: syncDownModel.myntn);

      List<ShopSectorModel> shopSector = syncNowController.shopSectorList.where((p0) => p0.sr.toString() == widget.sectorId.toString()).toList();
      List<ShopTypeModel> shopTypeModel = syncNowController.shopTypeList.where((p0) => p0.sr.toString() == widget.typeId.toString()).toList();
      List<ShopsStatusModel> shopsStatusModel = syncNowController.shopStatusList.where((p0) => p0.sr.toString() == widget.statusId.toString()).toList();

      sector = shopSector[0].name!;
      sectorSr = shopSector[0].sr!;

      shopType = shopTypeModel[0].name!;
      shopTypeSr = shopTypeModel[0].sr!;

      salesText = shopsStatusModel[0].name!;
      salesTaxSr = shopsStatusModel[0].sr!;

      if(widget.shop!.picture != null || widget.shop!.picture != ''){
        shopImage = widget.shop!.picture!;
      }

     if(syncDownModel.gprs != null){
       latLng = syncDownModel.gprs!.split(',');
       lat = double.tryParse(latLng[0])!;
       lon = double.tryParse(latLng[1])!;
     }
    }



  }

  GoogleMapController? googleMapController;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    SyncNowController syncNowController = Get.find<SyncNowController>();
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
            padding:
                EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: FetchPixels.getPixelHeight(20),
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // textWidget(
                        //     text: "Customer Info",
                        //     fontSize: FetchPixels.getPixelHeight(13),
                        //     fontWeight: FontWeight.w600,
                        //     textColor: Colors.black),
                        // SizedBox(
                        //   height: FetchPixels.getPixelHeight(5),
                        // ),
                        textField(
                          validator: (value)=> FieldValidators.validateCustomerInfo(value),
                            controller: shopNameCtr,
                            hintText: "Shop Name",
                            helperText: ""),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // textWidget(
                        //     text: "Customer Address",
                        //     fontSize: FetchPixels.getPixelHeight(13),
                        //     fontWeight: FontWeight.w600,
                        //     textColor: Colors.black),
                        // SizedBox(
                        //   height: FetchPixels.getPixelHeight(5),
                        // ),
                        textField(
                            validator: (value)=> FieldValidators.validateCustomerAddress(value),
                            controller: shopAddressCtr,
                            hintText: "Shop Address",
                            helperText: ""),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // textWidget(
                        //     text: "Owner Phone",
                        //     fontSize: FetchPixels.getPixelHeight(13),
                        //     fontWeight: FontWeight.w600,
                        //     textColor: Colors.black),
                        // SizedBox(
                        //   height: FetchPixels.getPixelHeight(5),
                        // ),
                        textField(
                            validator: (value)=> FieldValidators.validatePhone(value),
                            controller: ownerPhoneCtr,
                            hintText: "Owner Phone",
                            helperText: ""),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // textWidget(
                        //     text: "Owner Name",
                        //     fontSize: FetchPixels.getPixelHeight(13),
                        //     fontWeight: FontWeight.w600,
                        //     textColor: Colors.black),
                        // SizedBox(
                        //   height: FetchPixels.getPixelHeight(5),
                        // ),
                        textField(
                            validator: (value)=> FieldValidators.validateOwnerName(value),
                            controller: ownerNameCtr,
                            hintText: "Owner Name",
                            helperText: ""),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // textWidget(
                        //     text: "Owner Cnic",
                        //     fontSize: FetchPixels.getPixelHeight(13),
                        //     fontWeight: FontWeight.w600,
                        //     textColor: Colors.black),
                        // SizedBox(
                        //   height: FetchPixels.getPixelHeight(5),
                        // ),
                        textField(
                            validator: (value)=> FieldValidators.validateOwnerCnic(value),
                            controller: ownerCnicCtr,
                            hintText: "Owner Cnic",
                            helperText: ""),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: FetchPixels.getPixelHeight(40),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(),
                      Container(
                        height: FetchPixels.getPixelHeight(150),
                        width: FetchPixels.getPixelWidth(150),
                        child: GoogleMap(
                          zoomControlsEnabled: false,
                          initialCameraPosition:
                              CameraPosition(zoom: 12, target: LatLng(lat, lon)),
                          markers: _createMarkers(),
                          onMapCreated: (controller){
                            googleMapController = controller;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: FetchPixels.getPixelHeight(10),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        getLocation(context).then((value) async {
                          setState(() {
                            if(googleMapController != null){
                              googleMapController!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(zoom: 12, target: LatLng(value!.latitude, value.longitude))));
                            }
                            lat = value!.latitude;
                            lon = value.longitude;
                          });
                        });
                      },
                      child: Container(
                        color: themeColor,
                        padding: EdgeInsets.all(3),
                        child: textWidget(
                            text: "Current Location",
                            fontSize: FetchPixels.getPixelHeight(10),
                            fontWeight: FontWeight.w500,
                            textColor: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: FetchPixels.getPixelHeight(20),
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        textField(
                            validator: (value)=> FieldValidators.validateStrn(value),
                            controller: strnCtr,
                            hintText: "STRN",
                            helperText: ""),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        textField(
                            validator: (value)=> FieldValidators.validateNtn(value),
                            controller: ntnCtr, hintText: "NTN", helperText: ""),
                      ],
                    ),
                  ),
                  dropDownWidget1("Sales Tax Registered",
                      syncNowController.shopStatusList, salesText,syncNowController),
                  dropDownWidget2(
                      "Sector", syncNowController.shopSectorList, sector,syncNowController),
                  dropDownWidget3(
                      "Shop Type", syncNowController.shopTypeList, shopType,syncNowController),
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
                            onTap: () async {
                              _showFullScreenImage(context, shopImage);
                            },
                            child: shopImage == ""
                                ? Icon(Icons.camera_alt)
                                : Container(
                                    height: FetchPixels.getPixelHeight(40),
                                    width: FetchPixels.getPixelWidth(40),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        image: DecorationImage(
                                            image: FileImage(File(shopImage)))),
                                    // child: CircleAvatar(
                                    //   backgroundImage: ,
                                    //   backgroundColor: Colors.transparent,
                                    // ),
                                  )),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: FetchPixels.getPixelHeight(10),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: (){
                        ImagePickerDialog.pickImageCamera(context, (p0) {
                          if(p0.path.isNotEmpty){
                           setState(() {
                             shopImage = p0.path;
                           });
                          }
                        });
                      },
                      child: Container(
                        width: FetchPixels.getPixelWidth(140),
                        padding: EdgeInsets.all(3),
                        color: themeColor,
                        child: Center(child: textWidget(text: "Take Image", fontSize: FetchPixels.getPixelHeight(13), fontWeight: FontWeight.w600,textColor: Colors.white),),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: FetchPixels.getPixelHeight(20),
                  ),
                  InkWell(
                    onTap: () async {

                      if(_formKey.currentState!.validate()){

                        if(shopImage == '' || lat == 0.0 || lon == 0.0 || shopType == '' || sector == '' || salesText == ''){

                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("All fields are required")));

                        }else{
                          if(widget.isEdit == false){
                            if(widget.todayShopEdit == true){

                              widget.newShopModel!.shopName = shopNameCtr.text;
                              widget.newShopModel!.shopAddress = shopAddressCtr.text;
                              widget.newShopModel!.shopType = shopType;
                              widget.newShopModel!.ownerCnic = ownerCnicCtr.text;
                              widget.newShopModel!.ownerName = ownerNameCtr.text;
                              widget.newShopModel!.ownerPhone = ownerPhoneCtr.text;
                              widget.newShopModel!.gprs = "${lat},${lon}";
                              widget.newShopModel!.sector = sector;
                              widget.newShopModel!.strn = strnCtr.text;
                              widget.newShopModel!.myntn = ntnCtr.text;
                              widget.newShopModel!.salesTax = salesText;
                              widget.newShopModel!.picture = shopImage;
                              widget.newShopModel!.sectorSr = sectorSr;
                              widget.newShopModel!.salesTaxSr = salesTaxSr;
                              widget.newShopModel!.shopTypeSr = shopTypeSr;

                              List<NewShopModel> newShopsList = await  HiveDatabase.getNewShops("NewShopsBox", "NewShops");
                              int index = newShopsList.indexWhere((element) => element.sr == widget.newShopModel!.sr);
                              newShopsList[index] = widget.newShopModel!;
                              HiveDatabase.setNewShop("NewShopsBox", "NewShops", newShopsList);
                              Get.offNamed(TODAY_NEW_SHOP);

                            }else{
                              List<NewShopModel> newShopsList = await  HiveDatabase.getNewShops("NewShopsBox", "NewShops");
                              NewShopModel newShop = NewShopModel(sr: newShopsList.length,shopCode: newShopsList.length,shopType: shopType,sector: sector,salesTax: salesText,
                                  strn: strnCtr.text,shopAddress: shopAddressCtr.text,shopName: shopNameCtr.text,ownerCnic: ownerCnicCtr.text,
                                  ownerName: ownerNameCtr.text,ownerPhone: ownerPhoneCtr.text,myntn: ntnCtr.text,picture: shopImage,gprs: '${lat},${lon}',shopTypeSr: shopTypeSr,salesTaxSr: salesTaxSr,sectorSr: sectorSr);
                              log('>>> ${newShop.toJson()}');
                              newShopsList.add(newShop);
                              HiveDatabase.setNewShop("NewShopsBox", "NewShops", newShopsList);
                              Get.offNamed(TODAY_NEW_SHOP);
                            }

                          }else{

                            Get.dialog(
                                AlertDialog(content: Container(height: FetchPixels.getPixelHeight(155),width: FetchPixels.width/1.5,color: Colors.white,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(10)),
                                    child: Column(
                                      children: [
                                        Icon(Icons.info_outline,color: Colors.black,),
                                        SizedBox(height: FetchPixels.getPixelHeight(10),),
                                        textWidget(text: "Are You Sure?", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.bold,textColor: Colors.black),
                                        SizedBox(height: FetchPixels.getPixelHeight(10),),
                                        textWidget(text: "You Want To Update?", fontSize: FetchPixels.getPixelHeight(12), fontWeight: FontWeight.w400,textColor: Colors.black),
                                        SizedBox(height: FetchPixels.getPixelHeight(10),),
                                        Container(height: FetchPixels.getPixelHeight(1),width: FetchPixels.width,color: Colors.black,),
                                        SizedBox(height: FetchPixels.getPixelHeight(10),),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            InkWell(
                                              onTap: (){
                                                Get.back();
                                              },
                                              child: Card(
                                                child: Padding(
                                                  padding: EdgeInsets.all(5.0),
                                                  child: textWidget(text: "NO", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w600,textColor: Colors.red),
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: ()async{
                                                var box = await Hive.openBox("syncDownList");
                                                SyncNowController syncNowController =
                                                Get.find<SyncNowController>();
                                                int dataIndex = syncNowController.searchList
                                                    .indexWhere((element) => element.sr == widget.sr);
                                                syncNowController.searchList[dataIndex].shopname =
                                                    shopNameCtr.text;
                                                syncNowController.searchList[dataIndex].address =
                                                    shopAddressCtr.text;
                                                syncNowController.searchList[dataIndex].cnic =
                                                    ownerCnicCtr.text;
                                                syncNowController.searchList[dataIndex].myntn = ntnCtr.text;
                                                syncNowController.searchList[dataIndex].phone =
                                                    ownerPhoneCtr.text;
                                                syncNowController.searchList[dataIndex].owner =
                                                    ownerNameCtr.text;
                                                syncNowController.searchList[dataIndex].gprs =
                                                "${lat},${lon}";
                                                syncNowController.searchList[dataIndex].tax = strnCtr.text;
                                                syncNowController.searchList[dataIndex].picture = shopImage;
                                                syncNowController.searchList[dataIndex].typeId = shopTypeSr;
                                                syncNowController.searchList[dataIndex].sectorId = sectorSr;
                                                syncNowController.searchList[dataIndex].statusId = salesTaxSr;
                                                syncNowController.searchList[dataIndex].isEdit = true;
                                                syncNowController.searchList[dataIndex].salesTax = salesText;
                                                syncNowController.searchList[dataIndex].sector = sector;
                                                syncNowController.searchList[dataIndex].shopType = shopType;

                                                box.put(
                                                    "syncDown", syncNowController.searchList);
                                                Get.back();
                                                Get.offAll(Home());
                                              },
                                              child: Card(
                                                child: Padding(
                                                  padding: EdgeInsets.all(5.0),
                                                  child: textWidget(text: "Yes", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w600,textColor: Colors.green),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),),)
                            );

                          }

                        }

                      }

                    },
                    child: Container(
                      height: FetchPixels.getPixelHeight(45),
                      width: FetchPixels.width / 1.3,
                      decoration: BoxDecoration(
                          color: themeColor,
                          borderRadius: BorderRadius.circular(
                              FetchPixels.getPixelHeight(5))),
                      child: Center(
                        child: textWidget(
                            text: "Save",
                            textColor: Colors.white,
                            fontSize: FetchPixels.getPixelHeight(18),
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: FetchPixels.getPixelHeight(50),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Set<Marker> _createMarkers() {
    UserController userController = Get.find<UserController>();
    // Replace the marker position with your desired coordinates
    LatLng markerPosition = LatLng(lat, lon);

    // Create a marker with a title and position.
    final Marker marker = Marker(
      markerId: MarkerId('marker_id_1'),
      position: markerPosition,
      infoWindow: InfoWindow(title: 'Marker Title', snippet: 'Marker Snippet'),
    );

    // Return a set containing the marker.
    return {marker};
  }

  Widget dropDownWidget1(String label, List<ShopsStatusModel> list, String value,SyncNowController syncNowController) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textWidget(
              text: label,
              fontSize: FetchPixels.getPixelHeight(13),
              fontWeight: FontWeight.w600,
              textColor: Colors.black),
          SizedBox(
            height: FetchPixels.getPixelHeight(5),
          ),
          DropdownButtonFormField<String>(
            itemHeight: FetchPixels.getPixelHeight(50),
            isDense: true,
            isExpanded: true,
            decoration: InputDecoration(
              helperText: "",
              border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(FetchPixels.getPixelHeight(8)),
                  borderSide: BorderSide(color: Colors.black, width: 1)),
              enabledBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(FetchPixels.getPixelHeight(8)),
                  borderSide: BorderSide(color: Colors.black, width: 1)),
            ),
            value: value,
            onChanged: (newValue) {
              setState(() {
                salesText = newValue ?? "";
                ShopsStatusModel salesSr = syncNowController.shopStatusList.where((p0) => p0.name == newValue).first;
                salesTaxSr = salesSr.sr ?? 1;
              });
            },
            items: list.map<DropdownMenuItem<String>>((ShopsStatusModel value) {
              return DropdownMenuItem<String>(
                value: value.name,
                child: Text(value.name ?? ""),
              );
            }).toList(),
          )
        ],
      ),
    );
  }


  Widget dropDownWidget2(String label, List<ShopSectorModel> list, String value,SyncNowController syncNowController) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textWidget(
              text: label,
              fontSize: FetchPixels.getPixelHeight(13),
              fontWeight: FontWeight.w600,
              textColor: Colors.black),
          SizedBox(
            height: FetchPixels.getPixelHeight(5),
          ),
          DropdownButtonFormField<String>(
            itemHeight: FetchPixels.getPixelHeight(50),
            isDense: true,
            isExpanded: true,
            decoration: InputDecoration(
              helperText: "",
              border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(FetchPixels.getPixelHeight(8)),
                  borderSide: BorderSide(color: Colors.black, width: 1)),
              enabledBorder: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(FetchPixels.getPixelHeight(8)),
                  borderSide: BorderSide(color: Colors.black, width: 1)),
            ),
            value: value,
            onChanged: (newValue) {
              setState(() {
                sector = newValue!;
                ShopSectorModel shopSector = syncNowController.shopSectorList.where((p0) => p0.name == newValue).first;
                sectorSr = shopSector.sr ?? 1;
              });
            },
            items: list.map<DropdownMenuItem<String>>((value) {
              return DropdownMenuItem<String>(
                value: value.name,
                child: Text(value.name ?? ""),
              );
            }).toList(),
          )
        ],
      ),
    );
  }



  Widget dropDownWidget3(String label, List<ShopTypeModel> list, String value,SyncNowController syncNowController) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textWidget(
              text: label,
              fontSize: FetchPixels.getPixelHeight(13),
              fontWeight: FontWeight.w600,
              textColor: Colors.black),
          SizedBox(
            height: FetchPixels.getPixelHeight(5),
          ),
          DropdownButtonFormField<String>(
            itemHeight: FetchPixels.getPixelHeight(50),
            isDense: true,
            isExpanded: true,
            decoration: InputDecoration(
              helperText: "",
              border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(FetchPixels.getPixelHeight(8)),
                  borderSide: BorderSide(color: Colors.black, width: 1)),
              enabledBorder: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(FetchPixels.getPixelHeight(8)),
                  borderSide: BorderSide(color: Colors.black, width: 1)),
            ),
            value: value,
            onChanged: (newValue) {
              setState(() {
                shopType = newValue!;
                ShopTypeModel shopTypeModel = syncNowController.shopTypeList.where((p0) => p0.name == newValue).first;
                shopTypeSr = shopTypeModel.sr ?? 1;
              });
            },
            items: list.map<DropdownMenuItem<String>>((value) {
              return DropdownMenuItem<String>(
                value: value.name,
                child: Text(value.name ?? ""),
              );
            }).toList(),
          )
        ],
      ),
    );
  }


  void _showFullScreenImage(BuildContext context,image) {
    Navigator.push(context, MaterialPageRoute<void>(
      builder: (BuildContext context) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: GestureDetector(
              onTap: () {
                // Pop the full-screen image viewer
                Navigator.pop(context);
              },
              child: Hero(
                tag: 'imageHero', // Same tag as in the thumbnail
                child: Image.file(File(image)),
              ),
            ),
          ),
        );
      },
    ));
  }


}
