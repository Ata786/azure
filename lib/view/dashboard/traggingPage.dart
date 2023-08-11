import 'package:azure/res/base/fetch_pixels.dart';
import 'package:azure/res/colors.dart';
import 'package:azure/utils/routes/routePath.dart';
import 'package:azure/utils/widgets/appWidgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../res/images.dart';

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
                        onTap: (){
                          Get.toNamed(NEW_SHOPS);
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
              Container(
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
