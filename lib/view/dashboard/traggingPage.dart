import 'package:SalesUp/controllers/syncNowController.dart';
import 'package:SalesUp/res/base/fetch_pixels.dart';
import 'package:SalesUp/res/colors.dart';
import 'package:SalesUp/utils/routes/routePath.dart';
import 'package:SalesUp/utils/widgets/appWidgets.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../data/hiveDb.dart';
import '../../res/images.dart';
import '../NewShops.dart';

class NewShop extends StatelessWidget {
  NewShop({super.key});

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
      height: FetchPixels.height,
      width: FetchPixels.width,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(30)),
          child: Column(
            children: [
              Container(
                height: FetchPixels.getPixelHeight(60),
                width: FetchPixels.width,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(shop,height: FetchPixels.getPixelHeight(60),width: FetchPixels.getPixelWidth(60),),
                    SizedBox(width: FetchPixels.getPixelWidth(20),),
                    textWidget(text: "Add New Shops", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w600),
                    Spacer(),
                    InkWell(
                        onTap: ()async{
                          SyncNowController syncNowController = Get.find<SyncNowController>();
                          if(syncNowController.searchList.isEmpty){
                            Fluttertoast.showToast(
                                msg: "Please Sync Down",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: themeColor,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                          }else{
                            await HiveDatabase.getShopType("shopTypeBox", "shopType");
                            await HiveDatabase.getShopSector("shopSectorBox", "shopSector");
                            await HiveDatabase.getShopStatus('shopStatusBox', "shopStatus");
                            Get.to(NewShops(isEdit: false));
                          }
                        },
                        child: Icon(Icons.add,color: themeColor,size: FetchPixels.getPixelHeight(30),))
                  ],
                )
              ),
              SizedBox(height: FetchPixels.getPixelHeight(10),),
              Container(
                height: FetchPixels.getPixelHeight(1),
                color: Colors.black,
              ),
              SizedBox(height: FetchPixels.getPixelHeight(10),),
              InkWell(
                onTap: (){
                  Get.toNamed(TODAY_NEW_SHOP);
                },
                child: Container(
                    height: FetchPixels.getPixelHeight(60),
                    width: FetchPixels.width,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(shop,height: FetchPixels.getPixelHeight(60),width: FetchPixels.getPixelWidth(60),),
                        SizedBox(width: FetchPixels.getPixelWidth(20),),
                        textWidget(text: "Today New Shops", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w600),
                      ],
                    )
                ),
              ),
              SizedBox(height: FetchPixels.getPixelHeight(10),),
              Container(
                height: FetchPixels.getPixelHeight(1),
                color: Colors.black,
              ),
              SizedBox(height: FetchPixels.getPixelHeight(10),),
            ],
          ),
        ),
    ),);
  }
}
