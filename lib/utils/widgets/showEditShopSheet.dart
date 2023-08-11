import 'package:azure/controllers/shopServiceController.dart';
import 'package:azure/res/base/fetch_pixels.dart';
import 'package:azure/res/colors.dart';
import 'package:azure/utils/widgets/appWidgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/routePath.dart';

void showShopEditSheet({required BuildContext context,required shopName,required address,required shopCode,required phone,required owner,required sr,required channel,required gprs}){
  showModalBottomSheet(
      context: context,
      builder: (context){
        return Container(
          height: FetchPixels.height/2.5,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20),vertical: FetchPixels.getPixelHeight(20)),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerRight,
                  child: button(height: FetchPixels.getPixelHeight(35),
                      width: FetchPixels.getPixelWidth(100),
                      color: themeColor, textColor: Colors.white,
                      textSize: FetchPixels.getPixelHeight(13),
                      borderRadius: FetchPixels.getPixelHeight(8), textWeight: FontWeight.w500, text: "EDIT SHOP"),
                ),
                SizedBox(height: FetchPixels.getPixelHeight(15),),
                Container(
                  padding: EdgeInsets.all(FetchPixels.getPixelHeight(20)),
                  height: FetchPixels.getPixelHeight(150),
                  width: FetchPixels.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(5)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 0,
                        blurRadius: 3,
                        offset: Offset(0, 2), // changes the shadow direction
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textWidget(
                        textColor: primaryColor,
                        text: shopName,
                        fontSize: FetchPixels.getPixelHeight(16),
                        fontWeight: FontWeight.w600,),
                      SizedBox(height: FetchPixels.getPixelHeight(10),),
                      textWidget(
                        textColor: primaryColor,
                        text: address,
                        fontSize: FetchPixels.getPixelHeight(16),
                        fontWeight: FontWeight.w600,),
                      SizedBox(height: FetchPixels.getPixelHeight(10),),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              textWidget(
                                textColor: Colors.black,
                                text: "Store Code:",
                                fontSize: FetchPixels.getPixelHeight(13),
                                fontWeight: FontWeight.w500,),
                              SizedBox(width: FetchPixels.getPixelWidth(20),),
                              textWidget(
                                textColor: Colors.black,
                                text: '${shopCode}',
                                fontSize: FetchPixels.getPixelHeight(13),
                                fontWeight: FontWeight.w500,),
                            ],
                          ),
                          SizedBox(width: FetchPixels.getPixelWidth(80),),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              textWidget(
                                textColor: Colors.black,
                                text: "Owner",
                                fontSize: FetchPixels.getPixelHeight(13),
                                fontWeight: FontWeight.w500,),
                              SizedBox(width: FetchPixels.getPixelWidth(20),),
                              textWidget(
                                maxLines: 2,
                                textColor: Colors.black,
                                text: owner ?? "",
                                fontSize: FetchPixels.getPixelHeight(13),
                                fontWeight: FontWeight.w500,),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: FetchPixels.getPixelHeight(10),),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              textWidget(
                                textColor: Colors.black,
                                text: "Contact:",
                                fontSize: FetchPixels.getPixelHeight(13),
                                fontWeight: FontWeight.w500,),
                              SizedBox(width: FetchPixels.getPixelWidth(20),),
                              textWidget(
                                textColor: Colors.black,
                                text: phone ?? "",
                                fontSize: FetchPixels.getPixelHeight(13),
                                fontWeight: FontWeight.w500,),
                            ],
                          ),
                          SizedBox(width: FetchPixels.getPixelWidth(30),),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              textWidget(
                                textColor: Colors.black,
                                text: "Category",
                                fontSize: FetchPixels.getPixelHeight(13),
                                fontWeight: FontWeight.w500,),
                              SizedBox(width: FetchPixels.getPixelWidth(20),),
                              textWidget(
                                textColor: Colors.black,
                                text: channel ?? "",
                                fontSize: FetchPixels.getPixelHeight(13),
                                fontWeight: FontWeight.w500,),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              SizedBox(height: FetchPixels.getPixelHeight(20),),
                InkWell(
                  onTap: (){
                    ShopServiceController shopCtr = Get.find<ShopServiceController>();
                    shopCtr.orderList = [];
                    Get.back();
                    Get.toNamed(STORE,arguments: {"shopName": shopName,"sr": sr,"gprs": gprs});
                  },
                  child: button(height: FetchPixels.getPixelHeight(50),
                      width: FetchPixels.width,
                      color: themeColor, textColor: Colors.white,
                      textSize: FetchPixels.getPixelHeight(15),
                      borderRadius: FetchPixels.getPixelHeight(8), textWeight: FontWeight.w600, text: "ENTER STORE"),
                ),
              ],
            ),
          ),
        );
      }
  );
}