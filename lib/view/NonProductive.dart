import 'package:SalesUp/controllers/UserController.dart';
import 'package:SalesUp/controllers/syncNowController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../res/base/fetch_pixels.dart';
import '../../res/colors.dart';
import '../utils/widgets/appWidgets.dart';

Widget NonProductiveShops({required SyncNowController syncNowController,required UserController userController}){
  return Obx(() => syncNowController.check.value == true ? Center(child: CircularProgressIndicator(color: themeColor,),)
      : ListView.builder(
      itemCount: syncNowController.searchList.where((p0) => p0.productive == false).length,
      itemBuilder: (context, index) {
        syncNowController.nonProductiveList.value = syncNowController.searchList.where((p0) => p0.productive == false).toList();
        return Column(
          children: [
            InkWell(
              onTap: (){
              },
              child: Container(
                height: FetchPixels.getPixelHeight(80),
                width: FetchPixels.width,
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly,
                      children: [
                        textWidget(
                          textColor: Colors.black,
                          text: syncNowController.nonProductiveList[index].shopname ?? "",
                          fontSize: FetchPixels.getPixelHeight(17),
                          fontWeight: FontWeight.w600,
                        ),
                        textWidget(
                          textColor: Colors.black,
                          text: syncNowController.nonProductiveList[index].address ?? "",
                          fontSize: FetchPixels.getPixelHeight(13),
                          fontWeight: FontWeight.w500,
                        ),
                        textWidget(
                          textColor: Colors.black,
                          text: "${syncNowController.nonProductiveList[index].salesInvoiceDate ?? ""}",
                          fontSize: FetchPixels.getPixelHeight(13),
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Obx(() => Container(
                          padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(6),vertical: FetchPixels.getPixelHeight(3)),
                          decoration: BoxDecoration(
                              color: syncNowController.nonProductiveList[index].gprs == null || syncNowController.nonProductiveList[index].gprs!.isEmpty || syncNowController.nonProductiveList[index].gprs == "0"  ? Colors.red : Color(0xff97ca28),
                              borderRadius: BorderRadius.circular(
                                  FetchPixels.getPixelHeight(5))),
                          child: InkWell(
                            onTap: (){
                              String lat = userController.latitude.toString();
                              String lon = userController.longitude.toString();
                              openGoogleMap(syncNowController.nonProductiveList[index].gprs ?? "0,0","$lat,,$lon");
                            },
                            child: Icon(
                              Icons.location_on,
                              color: Colors.white,
                            ),
                          ),
                        )),
                        SizedBox(width: FetchPixels.getPixelWidth(7),),
                        InkWell(
                          onTap: (){
                            String phone = syncNowController.nonProductiveList[index].phone ?? "";
                            _launchPhoneNumber(phone);
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
