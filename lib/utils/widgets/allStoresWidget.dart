import 'package:SalesUp/controllers/UserController.dart';
import 'package:SalesUp/controllers/syncNowController.dart';
import 'package:SalesUp/data/hiveDb.dart';
import 'package:SalesUp/utils/widgets/dialoges.dart';
import 'package:SalesUp/utils/widgets/showEditShopSheet.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../model/categoryName.dart';
import '../../model/reasonName.dart';
import '../../res/base/fetch_pixels.dart';
import '../../res/colors.dart';
import '../routes/routePath.dart';
import 'appWidgets.dart';

Widget allStores({required SyncNowController syncNowController,required UserController userController}){
  return Obx(() => syncNowController.check.value == true ? Center(child: CircularProgressIndicator(color: themeColor,),)
      : ListView.builder(
      itemCount: syncNowController.searchList.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            InkWell(
              onTap: (){
                if(syncNowController.searchList[index].gprs == null || syncNowController.searchList[index].gprs!.isEmpty || syncNowController.searchList[index].gprs == "0" ){
                  Fluttertoast.showToast(
                      msg: "Location is not define",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: themeColor,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
                }else{
                  if(syncNowController.searchList[index].productive == true){
                    Fluttertoast.showToast(
                        msg: "This Shop is already Productive",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: themeColor,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  }else{
                    showVisitPlanDialog(onTap: ()async{
                      Get.back();
                      Get.dialog(Center(child: CircularProgressIndicator(color: themeColor,),));
                      List<CategoryNameModel> categoriesName = await HiveDatabase.getCategoryName("category", "categoryName");
                      List<CategoryNameModel> categories = categoriesName.where((element) => element.sr == syncNowController.searchList[index].catagoryId).toList();
                      Get.back();
                      showShopEditSheet(context: context,shopName: syncNowController.searchList[index].shopname,address: syncNowController.searchList[index].address,shopCode: syncNowController.searchList[index].shopCode,phone: syncNowController.searchList[index].phone,owner: syncNowController.searchList[index].owner,sr: syncNowController.searchList[index].sr,channel: categories.first.name,gprs: syncNowController.searchList[index].gprs);
                    },noTap: ()async{
                      Get.back();
                      Get.dialog(Center(child: CircularProgressIndicator(color: themeColor,),));
                      List<ReasonsModel> reasons = await HiveDatabase.getReasons("reasonsName", "reason");
                      Get.back();
                      Get.toNamed(SHOP_SERVICE,arguments: {"shopName": syncNowController.searchList[index].shopname,"reasons": reasons,"gprs": syncNowController.searchList[index].gprs,"shopId": syncNowController.searchList[index].sr});
                    });
                  }
                }

              },
              child: Container(
                height: FetchPixels.getPixelHeight(80),
                width: FetchPixels.width,
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                   Container(
                     width: FetchPixels.width/1.8,
                     child: Row(
                       children: [
                         Expanded(
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             mainAxisAlignment:
                             MainAxisAlignment.spaceEvenly,
                             children: [
                               textWidget(
                                 textColor: Colors.black,
                                 text: syncNowController.searchList[index].shopname ?? "",
                                 fontSize: FetchPixels.getPixelHeight(17),
                                 fontWeight: FontWeight.w600,
                               ),
                               textWidget(
                                 textColor: Colors.black,
                                 text: syncNowController.searchList[index].address ?? "",
                                 fontSize: FetchPixels.getPixelHeight(13),
                                 fontWeight: FontWeight.w500,
                               ),
                               textWidget(
                                 textColor: Colors.black,
                                 text: "${syncNowController.searchList[index].salesInvoiceDate ?? ""}",
                                 fontSize: FetchPixels.getPixelHeight(13),
                                 fontWeight: FontWeight.w500,
                               ),
                             ],
                           ),
                         ),
                       ],
                     ),
                   ),
                    Row(
                      children: [
                        Obx(() => Container(
                          padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(6),vertical: FetchPixels.getPixelHeight(3)),
                          decoration: BoxDecoration(
                              color: syncNowController.searchList[index].gprs == null || syncNowController.searchList[index].gprs!.isEmpty || syncNowController.searchList[index].gprs == "0"  ? Colors.red : Color(0xff97ca28),
                              borderRadius: BorderRadius.circular(
                                  FetchPixels.getPixelHeight(5))),
                          child: InkWell(
                            onTap: (){
                              if(syncNowController.searchList[index].gprs == null || syncNowController.searchList[index].gprs!.isEmpty || syncNowController.searchList[index].gprs == "0" ){
                                Fluttertoast.showToast(
                                    msg: "Location is not define",
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: themeColor,
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                );
                              }else{
                                String lat = userController.latitude.toString();
                                String lon = userController.longitude.toString();
                                openGoogleMap(syncNowController.searchList[index].gprs ?? "0,0","$lat,$lon");
                              }
                            },
                            child: Icon(
                              Icons.location_on,
                              color: Colors.white,
                            ),
                          ),
                        )),
                        SizedBox(width: FetchPixels.getPixelWidth(7),),
                        InkWell(
                          onTap: (){if(syncNowController.searchList[index].gprs == null || syncNowController.searchList[index].gprs!.isEmpty || syncNowController.searchList[index].gprs == "0" ){
                            Fluttertoast.showToast(
                                msg: "Location is not define",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: themeColor,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                          }else{
                            String phone = syncNowController.searchList[index].phone ?? "";
                            _launchPhoneNumber(phone);
                          }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(6),vertical: FetchPixels.getPixelHeight(2)),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  FetchPixels.getPixelHeight(5)),
                              border: Border.all(color: Color(0xffd2d2d2)),
                            ),
                            child: Icon(
                              Icons.call,
                              color: Color(0xffd2d2d2),
                            ),
                          ),
                        ),
                        SizedBox(width: FetchPixels.getPixelWidth(7),),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(6),vertical: FetchPixels.getPixelHeight(2)),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                FetchPixels.getPixelHeight(5)),
                            border: Border.all(color: Color(0xffd2d2d2)),
                          ),
                          child: Icon(
                            Icons.info_outline,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: FetchPixels.getPixelHeight(5),
            ),
            Container(
              height: FetchPixels.getPixelHeight(1),
              width: FetchPixels.width,
              color: primaryColor,
            )
          ],
        );
      }));
}

void openGoogleMap(String d,String s)async{
  String source = s;
  String destination = d;
  String url = "https://www.google.com/maps/dir/?api=1&origin=$source&destination=$destination";
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not open Google Maps.';
  }
}

void _launchPhoneNumber(String phoneNumber) async {
  final url = 'tel:$phoneNumber';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
