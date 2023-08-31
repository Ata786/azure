import 'dart:developer';

import 'package:SalesUp/controllers/UserController.dart';
import 'package:SalesUp/controllers/shopServiceController.dart';
import 'package:SalesUp/data/hiveDb.dart';
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
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../res/images.dart';

class StoreScreen extends StatefulWidget {
  StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
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
    argument = Get.arguments as Map<String,dynamic>;
    isEdit = argument['isEdit'];
    if(argument['isEdit'] == true){
      shopServiceController.checkIn.value = int.tryParse(argument['sr'])!;
      imagePath = argument['image'];
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
            Get.toNamed(ORDER_DETAIL);
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
                    storeWidget(camera,"Camera",(){
                      ImagePickerDialog.pickImageCamera(context, (p0) {
                        if(p0.path.isNotEmpty){
                          imagePath = p0.path;
                        }
                      });
                    },''),
                    storeWidget(location,"check-in",()async{
                      if(imagePath == ""){
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Image is required"),behavior: SnackBarBehavior.floating,));
                      }else{
                        if(argument['isEdit'] == false){
                          shopServiceController.checkIn.value = argument['sr'];
                          String gprs = argument['gprs'];
                          List<String> gprsLatLng = gprs.split(',');
                          double? lat = double.tryParse(gprsLatLng[0]);
                          double? lon = double.tryParse(gprsLatLng[1]);
                          double dis = Geolocator.distanceBetween(userController.latitude, userController.longitude, lat ?? 0.0, lon ?? 0.0);
                          distance = dis;
                          String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
                          List<OrderModel> orderList = await HiveDatabase.getOrderData("orderBox", "order");
                          int length = orderList.where((element) => element.shopId == argument['sr']).length;
                          orderModel = OrderModel(shopId: argument['sr'],pjpNo: "0",pjpDate: formattedDate,
                              bookerId: userController.user!.value.catagoryId,invoiceStatus: "Pending",orderNumber: length+1,
                              userId: userController.user!.value.id,replace: "0",reason: "Pending",checkIn: distance.toString(),
                              image: imagePath,orderDataModel: OrderDataModel());
                          shopServiceController.orderList.add(orderModel!);
                        }else{
                          distance = double.tryParse(argument['gprs'])!;
                          if(imagePath != ''){
                            shopServiceController.orderList[0].image = imagePath;
                          }
                          shopServiceController.orderList[0].checkIn = distance.toString();
                        }
                        setState(() {

                        });
                      }

                    }, distance == 0.0 ? "" : "${distance.toStringAsFixed(2).toString()} M"),
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
                              searchQuery = v.toLowerCase();
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
                                    searchQuery = '';
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
                Container(
                    height: FetchPixels.getPixelHeight(400),
                    width: FetchPixels.width,
                    child: shopServiceController.checkProducts.value == false ? Center(child: CircularProgressIndicator(color: themeColor,),)
                        : ListView.builder(
                        itemCount: shopServiceController.productsList.length,
                        itemBuilder: (context,index){
                          return Obx(() => InkWell(
                            onTap: ()async{
                              if(int.tryParse(shopServiceController.checkIn.value.toString())! == int.tryParse(argument['sr'].toString())!){
                                if(shopServiceController.orderList.length != 0){
                                  Get.dialog(Center(child: CircularProgressIndicator(color: themeColor,)));
                                  List<RateDetailModel> rateDetails = await HiveDatabase.getProductRateDetails("product", "productRate");
                                  Get.back();
                                  shopServiceController.radio.value = 0;
                                  shopServiceController.netRate.value = "";
                                  shopServiceController.quantity.value = 0;
                                  showStoreProductDialog(argumentSr: int.tryParse(argument['sr'].toString())!,shopServiceController: shopServiceController,sr: shopServiceController.productsList[index].sr,productName: shopServiceController.productsList[index].pname ?? "",rateDetail: rateDetails);
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
                                            textWidget(text: shopServiceController.productsList[index].pname!.trim() ?? '', fontSize: FetchPixels.getPixelHeight(16), fontWeight: FontWeight.w600,textColor: shopServiceController.productsList[index].subTotal != null ? Colors.green : primaryColor),
                                            SizedBox(height: FetchPixels.getPixelHeight(7),),
                                            textWidget(text: '${shopServiceController.productsList[index].wgm!.toString().trim()}', fontSize: FetchPixels.getPixelHeight(13), fontWeight: FontWeight.w500,textColor: shopServiceController.productsList[index].subTotal != null ? Colors.green : primaryColor),
                                            SizedBox(height: FetchPixels.getPixelHeight(7),),
                                            textWidget(text: shopServiceController.productsList[index].brandName!.trim() ?? '', fontSize: FetchPixels.getPixelHeight(13), fontWeight: FontWeight.w500,textColor: shopServiceController.productsList[index].subTotal != null ? Colors.green : primaryColor),
                                            SizedBox(height: FetchPixels.getPixelHeight(7),),
                                            textWidget(text: "${shopServiceController.productsList[index].sr.toString().trim()}", fontSize: FetchPixels.getPixelHeight(13), fontWeight: FontWeight.w500,textColor: shopServiceController.productsList[index].subTotal != null ? Colors.green : primaryColor)
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
                                                textWidget(text: "Retail", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w500,textColor: shopServiceController.productsList[index].subTotal != null ? Colors.green : primaryColor),
                                                SizedBox(width: FetchPixels.getPixelWidth(10),),
                                                textWidget(text: shopServiceController.productsList[index].retail ==  null ? "0" : "${shopServiceController.productsList[index].retail.toString().trim()}", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w500,textColor: shopServiceController.productsList[index].subTotal != null ? Colors.green : primaryColor),
                                              ],
                                            ),
                                            SizedBox(height: FetchPixels.getPixelHeight(7),),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                textWidget(text: "Net", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w500,textColor: shopServiceController.productsList[index].subTotal != null ? Colors.green : primaryColor),
                                                SizedBox(width: FetchPixels.getPixelWidth(10),),
                                                textWidget(text: shopServiceController.productsList[index].netRate == null ? "0" : "${shopServiceController.productsList[index].netRate.toString().trim()}", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w500,textColor: shopServiceController.productsList[index].subTotal != null ? Colors.green : primaryColor),
                                              ],
                                            ),
                                            SizedBox(height: FetchPixels.getPixelHeight(30),),
                                            textWidget(text: shopServiceController.productsList[index].quantity ==  null ? "0" : "${shopServiceController.productsList[index].quantity.toString().trim()}", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w500,textColor: shopServiceController.productsList[index].subTotal != null ? Colors.green : primaryColor),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                textWidget(text: "Subtotal:", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w500,textColor: shopServiceController.productsList[index].subTotal != null ? Colors.green : primaryColor),
                                                SizedBox(width: FetchPixels.getPixelWidth(10),),
                                                textWidget(text: shopServiceController.productsList[index].subTotal == null ? "0" : "${double.tryParse(shopServiceController.productsList[index].subTotal.toString())!.toStringAsFixed(6)}", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w500,textColor: shopServiceController.productsList[index].subTotal != null ? Colors.green : primaryColor),
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
                          ));
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

