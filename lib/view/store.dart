import 'dart:developer';
import 'dart:io';

import 'package:SalesUp/controllers/UserController.dart';
import 'package:SalesUp/controllers/shopServiceController.dart';
import 'package:SalesUp/data/hiveDb.dart';
import 'package:SalesUp/model/addProducts.dart';
import 'package:SalesUp/model/orderModel.dart';
import 'package:SalesUp/model/productsModel.dart';
import 'package:SalesUp/model/reateDetailModel.dart';
import 'package:SalesUp/res/base/fetch_pixels.dart';
import 'package:SalesUp/res/colors.dart';
import 'package:SalesUp/utils/routes/routePath.dart';
import 'package:SalesUp/utils/widgets/appWidgets.dart';
import 'package:SalesUp/utils/widgets/imagePickerDialog.dart';
import 'package:SalesUp/utils/widgets/storeProductDialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../res/images.dart';
import '../utils/userCurrentLocation.dart';

class StoreScreen extends StatefulWidget {
  StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {


  List<String> productsList = ["Hockey","Foot Ball","Snooker"];
  String selectedProduct = "Hockey";

  List<String> sizeList = ["Large","Classic","Regular","Sim"];
  String selectedSize = "Large";

  TextEditingController purchaseRate = TextEditingController();
  TextEditingController saleRate = TextEditingController();
  TextEditingController stock = TextEditingController();

  List<AddProductsModel> addProductsList = [];


  TextEditingController searchCtr = TextEditingController();

  bool search = false;
  double distance = 0.0;
  String imagePath = '';
  OrderModel? orderModel;
  Map<String,dynamic> argument = {};
  late ShopServiceController shopServiceController;
  late bool isEdit;
  String searchQuery = '';

  @override
  void initState() {
    getArgs();
    super.initState();
  }


  void getArgs(){
    shopServiceController = Get.find<ShopServiceController>();
    UserController userController = Get.find<UserController>();
    argument = Get.arguments as Map<String,dynamic>;
      isEdit = argument['isEdit'];

      if(argument['isProductive'] == true){
        imagePath = argument['image'];
        distance = double.tryParse(argument['checkIn'].toString())!;
        shopServiceController.checkIn.value = int.tryParse(argument['sr'].toString())!;

        orderModel = OrderModel(shopId: argument['sr'],pjpNo: "0",pjpDate: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
            bookerId: userController.user!.value.catagoryId,invoiceStatus: "Pending",orderNumber: shopServiceController.orderList.length+1,
            userId: userController.user!.value.id,replace: "0",reason: "Pending",checkIn: distance.toString(),
            image: imagePath,orderDataModel: OrderDataModel());
        shopServiceController.orderList.add(orderModel!);
      }

      if(argument['isEdit'] == true){
        shopServiceController.checkIn.value = int.tryParse(argument['sr'])!;
        imagePath = argument['image'];
        distance = argument['checkIn'];
      }
  }

  @override
  Widget build(BuildContext context) {
    UserController userController = Get.find<UserController>();
    FetchPixels(context);
    return Scaffold(
      bottomSheet: Padding(
        padding: EdgeInsets.all(8.0),
        child: InkWell(
          onTap: (){
            if(argument['isEdit'] == true){
              shopServiceController.orderList[0].image = imagePath;
              shopServiceController.orderList[0].checkIn = distance;
              Get.toNamed(ORDER_DETAIL);
            }else{
              Get.toNamed(ORDER_DETAIL);
            }
          },
          child: button(
              height: FetchPixels.getPixelHeight(55),
              width: FetchPixels.width,
              color: themeColor, textColor: Colors.white,
              textSize: FetchPixels.getPixelHeight(16),
              borderRadius: FetchPixels.getPixelHeight(7),
              textWeight: FontWeight.w500, text: "Proceed"),
        ),
      ),
      appBar: AppBar(title: textWidget(text: argument['shopName'] ?? "",textColor: Colors.white, fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w600),automaticallyImplyLeading: false),
      body: Container(
        height: FetchPixels.height,
        width: FetchPixels.width,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(15)),
            child: Column(
              children: [
                SizedBox(height: FetchPixels.getPixelHeight(20),),
                Row(
                  children: [
                    storeWidget(call,"call",(){
                      if(argument['phone'] != '' || argument['phone'] != null){
                        _launchPhoneNumber(argument['phone']);
                      }
                    },''),
                    storeWidget(history,"History",(){
                      Get.toNamed(SHOP_HISTORY,arguments: {"shopName": argument['shopName'],"sr": argument['sr']});
                    },''),
            Expanded(
              child: InkWell(
                onTap: (){
                  ImagePickerDialog.pickImageCamera(context, (p0) {
                    if(p0.path.isNotEmpty){
                      setState(() {
                        imagePath = p0.path;
                      });
                    }
                  });
                },
                child: Container(
                  margin: EdgeInsets.all(FetchPixels.getPixelHeight(7)),
                  height: FetchPixels.getPixelHeight(80),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(7)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 3),
                            blurRadius: 1,
                            spreadRadius: 1,
                            color: Colors.grey.withOpacity(0.3)
                        )
                      ]
                  ),
                  child: imagePath == ""
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(camera,height: FetchPixels.getPixelHeight(20),width: FetchPixels.getPixelWidth(20),),
                      SizedBox(height: FetchPixels.getPixelHeight(5),),
                      textWidget(text: "Camera",textColor: Colors.black, fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w500),
                      textWidget(text: '',textColor: Colors.black, fontSize: FetchPixels.getPixelHeight(13), fontWeight: FontWeight.w500),
                    ],
                  )
                  : Image.file(File(imagePath),fit: BoxFit.fill,),
                ),
              ),
            ),
                    storeWidget(location,"check-in",()async{
                      if(imagePath == ""){
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Image is required"),behavior: SnackBarBehavior.floating,));
                      }else{
                        if(argument['isEdit'] == false){
                          shopServiceController.checkIn.value = argument['sr'];
                          Get.dialog(Center(child: CircularProgressIndicator(color: themeColor,),));
                          Position? location = await getLocation(context);

                          if(location == null){

                            Fluttertoast.showToast(
                                msg: "Location Error",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: themeColor,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );

                          }else{

                            Get.back();
                            String gprs = argument['gprs'];
                            List<String> gprsLatLng = gprs.split(',');
                            double? lat = double.tryParse(gprsLatLng[0]);
                            double? lon = double.tryParse(gprsLatLng[1]);
                            double dis = Geolocator.distanceBetween(location!.latitude, location.longitude, lat ?? 0.0, lon ?? 0.0);
                            distance = dis+0.5;
                            String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
                            List<OrderModel> orderList = await HiveDatabase.getOrderData("orderBox", "order");
                            int length = orderList.where((element) => element.shopId == argument['sr']).length;
                            orderModel = OrderModel(shopId: argument['sr'],pjpNo: "0",pjpDate: formattedDate,
                                bookerId: userController.user!.value.catagoryId,invoiceStatus: "Pending",orderNumber: length+1,
                                userId: userController.user!.value.id,replace: "0",reason: "Pending",checkIn: distance.toString(),
                                image: imagePath,orderDataModel: OrderDataModel());
                            if(argument['isProductive'] == true){
                              shopServiceController.orderList[0] = orderModel!;
                            }else{
                              shopServiceController.orderList.add(orderModel!);
                            }

                          }

                        }else{
                          distance = double.tryParse(argument['gprs'])! + 0.5;
                          log('>>>> ${argument['gprs']}');
                          if(imagePath != ''){
                            shopServiceController.orderList[0].image = imagePath;
                          }
                          shopServiceController.orderList[0].checkIn = distance.toString();
                        }
                        setState(() {

                        });
                      }

                    }, distance == 0.0 ? "0.000 M" : "${distance.toStringAsFixed(2).toString()} M"),
                  ],
                ),
                SizedBox(height: FetchPixels.getPixelHeight(10),),
                Container(height: FetchPixels.getPixelHeight(1),color: Colors.black,width: FetchPixels.width,),
                SizedBox(height: FetchPixels.getPixelHeight(10),),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20),vertical: FetchPixels.getPixelHeight(10)),
                  height: search == false ? FetchPixels.getPixelHeight(100) : FetchPixels.getPixelHeight(140),
                  width: FetchPixels.width,
                  color: Colors.grey.withOpacity(0.2),
                  child: Column(
                    children: [
                      search == false ? Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                            onTap: (){
                              search = true;
                              setState(() {

                              });
                            },
                            child: Icon(Icons.search)),
                      )
                      : Container(
                        height: FetchPixels.getPixelHeight(50),
                        width: FetchPixels.getPixelWidth(300),
                        padding: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(7),
                          border: Border.all(color: Colors.black,width: 1)
                        ),
                        child: TextField(
                          onChanged: (v) {
                            setState(() {
                              shopServiceController.filteredProductsList.value = shopServiceController.productsList
                                  .where((item) => item.pname!.toLowerCase().contains(v.toLowerCase()))
                                  .toList();
                            });
                          },
                          controller: searchCtr,
                          decoration: InputDecoration(
                            hintText: "Search SKU",
                            suffixIcon: InkWell(
                                onTap: (){
                                  setState(() {
                                    search = false;
                                    searchCtr.text = '';
                                    shopServiceController.filteredProductsList.value = shopServiceController.productsList;
                                  });
                                },
                                child: Icon(Icons.close)),
                          ),
                        ),
                      ),
                      SizedBox(height: FetchPixels.getPixelHeight(10),),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          height: FetchPixels.getPixelHeight(40),
                          width: FetchPixels.getPixelWidth(100),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(30))
                          ),
                          child: Center(child: textWidget(text: "All SKU", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w500,textColor: Colors.black),),
                        ),
                      )
                    ],
                  ),
                ),


                ///////////////////////////////////



                Container(
                    height: FetchPixels.getPixelHeight(400),
                    width: FetchPixels.width,
                    child: shopServiceController.checkProducts.value == false ? Center(child: CircularProgressIndicator(color: themeColor,),)
                        : ListView.builder(
                        itemCount: shopServiceController.filteredProductsList.length,
                        itemBuilder: (context,index){

                          List<int> selectedIndices = [];

                          for (int i = 0; i < shopServiceController.filteredProductsList.length; i++) {
                            if (shopServiceController.filteredProductsList[i].subTotal != null && shopServiceController.filteredProductsList[i].subTotal > 0.0) {
                              selectedIndices.add(i);
                            }
                          }

                          selectedIndices.sort((a, b) {
                            final aSubTotal = shopServiceController.filteredProductsList[a].subTotal;
                            final bSubTotal = shopServiceController.filteredProductsList[b].subTotal;

                            if (aSubTotal != null && bSubTotal == null) {
                              return -1;
                            } else if (aSubTotal == null && bSubTotal != null) {
                              return 1;
                            }
                            return a - b;
                          });

                          // Create a combined list
                          List<ProductsModel> combinedList = [];

                          // Add selected items to the combined list
                          for (int selectedIndex in selectedIndices) {
                            combinedList.add(shopServiceController.filteredProductsList[selectedIndex]);
                          }

                          // Add unselected items to the combined list
                          for (int i = 0; i < shopServiceController.filteredProductsList.length; i++) {
                            if (!selectedIndices.contains(i)) {
                              combinedList.add(shopServiceController.filteredProductsList[i]);
                            }
                          }

                          return InkWell(
                            onTap: ()async{
                              if(int.tryParse(shopServiceController.checkIn.value.toString())! == int.tryParse(argument['sr'].toString())!){
                                if(shopServiceController.orderList.length != 0){
                                  Get.dialog(Center(child: CircularProgressIndicator(color: themeColor,)));
                                  List<RateDetailModel> rateDetails = await HiveDatabase.getProductRateDetails("product", "productRate");
                                  Get.back();
                                  shopServiceController.radio.value = 0;
                                  shopServiceController.netRate.value = "";
                                  shopServiceController.quantity.value = 0;
                                  showStoreProductDialog(argumentSr: int.tryParse(argument['sr'].toString())!,shopServiceController: shopServiceController,sr: combinedList[index].sr,productName: combinedList[index].pname ?? "",rateDetail: rateDetails,onDialogClosed: (v){
                                    setState(() {

                                    });
                                  });
                                }else{
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("CheckIn First"),behavior: SnackBarBehavior.floating,));
                                }
                              }else{
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please CheckIn First"),behavior: SnackBarBehavior.floating,));
                              }
                            },
                            child: Container(
                                margin: EdgeInsets.only(top: FetchPixels.getPixelHeight(10)),
                                width: FetchPixels.width,
                                height: FetchPixels.getPixelHeight(120),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            textWidget(text: combinedList[index].pname!.trim() ?? '', fontSize: FetchPixels.getPixelHeight(16), fontWeight: FontWeight.w600,textColor: combinedList[index].subTotal != null && combinedList[index].subTotal > 0.0 ? Colors.green : primaryColor),
                                            SizedBox(height: FetchPixels.getPixelHeight(7),),
                                            textWidget(text: '${combinedList[index].wgm!.toString().trim()}', fontSize: FetchPixels.getPixelHeight(13), fontWeight: FontWeight.w500,textColor: combinedList[index].subTotal != null && combinedList[index].subTotal > 0.0 ? Colors.green : primaryColor),
                                            SizedBox(height: FetchPixels.getPixelHeight(7),),
                                            textWidget(text: combinedList[index].brandName!.trim() ?? '', fontSize: FetchPixels.getPixelHeight(13), fontWeight: FontWeight.w500,textColor: combinedList[index].subTotal != null && combinedList[index].subTotal > 0.0 ? Colors.green : primaryColor),
                                            SizedBox(height: FetchPixels.getPixelHeight(7),),
                                            textWidget(text: "${combinedList[index].sr.toString().trim()}", fontSize: FetchPixels.getPixelHeight(13), fontWeight: FontWeight.w500,textColor: combinedList[index].subTotal != null && combinedList[index].subTotal > 0.0 ? Colors.green : primaryColor)
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            SizedBox(height: FetchPixels.getPixelHeight(10),),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                textWidget(text: "Retail", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w500,textColor: combinedList[index].subTotal != null && combinedList[index].subTotal > 0.0 ? Colors.green : primaryColor),
                                                SizedBox(width: FetchPixels.getPixelWidth(10),),
                                                textWidget(text: combinedList[index].retail ==  null ? "0" : "${combinedList[index].retail.toString().trim()}", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w500,textColor: combinedList[index].subTotal != null && combinedList[index].subTotal > 0.0 ? Colors.green : primaryColor),
                                              ],
                                            ),
                                            SizedBox(height: FetchPixels.getPixelHeight(7),),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                textWidget(text: "Net", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w500,textColor: combinedList[index].subTotal != null && combinedList[index].subTotal > 0.0 ? Colors.green : primaryColor),
                                                SizedBox(width: FetchPixels.getPixelWidth(10),),
                                                textWidget(text: combinedList[index].netRate == null ? "0" : "${combinedList[index].netRate.toString().trim()}", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w500,textColor: combinedList[index].subTotal != null && combinedList[index].subTotal > 0.0 ? Colors.green : primaryColor),
                                              ],
                                            ),
                                            SizedBox(height: FetchPixels.getPixelHeight(30),),
                                            textWidget(text: combinedList[index].quantity ==  null ? "0" : "${combinedList[index].quantity.toString().trim()}", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w500,textColor: combinedList[index].subTotal != null && combinedList[index].subTotal > 0.0 ? Colors.green : primaryColor),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                textWidget(text: "Subtotal:", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w500,textColor: combinedList[index].subTotal != null && combinedList[index].subTotal > 0.0 ? Colors.green : primaryColor),
                                                SizedBox(width: FetchPixels.getPixelWidth(10),),
                                                textWidget(text: combinedList[index].subTotal == null ? "0" : "${double.tryParse(combinedList[index].subTotal.toString())!.toStringAsFixed(6)}", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w500,textColor: combinedList[index].subTotal != null && combinedList[index].subTotal > 0.0 ? Colors.green : primaryColor),
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    Container(
                                      height: FetchPixels.getPixelHeight(1),
                                      color: Colors.black,
                                      width: FetchPixels.width,
                                    )
                                  ],
                                )
                            ),
                          );
                        }),
                ),
                SizedBox(height: FetchPixels.getPixelHeight(55),)
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget storeWidget(String image,String name,onTap,dis){
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.all(FetchPixels.getPixelHeight(7)),
          height: FetchPixels.getPixelHeight(80),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(7)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, 3),
                    blurRadius: 1,
                    spreadRadius: 1,
                    color: Colors.grey.withOpacity(0.3)
                )
              ]
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(image,height: FetchPixels.getPixelHeight(20),width: FetchPixels.getPixelWidth(20),),
              SizedBox(height: FetchPixels.getPixelHeight(5),),
              textWidget(text: name,textColor: Colors.black, fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w500),
              textWidget(text: dis,textColor: Colors.black, fontSize: FetchPixels.getPixelHeight(13), fontWeight: FontWeight.w500),
            ],
          ),
        ),
      ),
    );
  }


  void _launchPhoneNumber(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

}

