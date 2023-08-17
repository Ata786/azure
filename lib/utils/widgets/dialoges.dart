import 'package:SalesUp/res/base/fetch_pixels.dart';
import 'package:SalesUp/utils/widgets/appWidgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showSyncDownDialog({required onTap}){
  Get.dialog(
    AlertDialog(content: Container(height: FetchPixels.getPixelHeight(155),width: FetchPixels.width/1.5,color: Colors.white,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(10)),
      child: Column(
        children: [
          Icon(Icons.info_outline,color: Colors.black,),
          SizedBox(height: FetchPixels.getPixelHeight(10),),
          textWidget(text: "Confirm Sync Down", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.bold,textColor: Colors.black),
          SizedBox(height: FetchPixels.getPixelHeight(10),),
          textWidget(text: "Are you sure you want to Sync Down the data?", fontSize: FetchPixels.getPixelHeight(12), fontWeight: FontWeight.w400,textColor: Colors.black),
          SizedBox(height: FetchPixels.getPixelHeight(10),),
          Container(height: FetchPixels.getPixelHeight(1),width: FetchPixels.width,color: Colors.black,),
          SizedBox(height: FetchPixels.getPixelHeight(10),),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                onTap: onTap,
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: textWidget(text: "Yes, I am sure", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w600,textColor: Colors.green),
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



// visit plan dialog
void showVisitPlanDialog({required onTap,required noTap}){
  Get.dialog(
      AlertDialog(content: Container(height: FetchPixels.getPixelHeight(120),width: FetchPixels.width/1.5,color: Colors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(10)),
          child: Column(
            children: [
              SizedBox(height: FetchPixels.getPixelHeight(10),),
              textWidget(text: "Do You Want To Service This Shop ?", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w400,textColor: Colors.black),
              SizedBox(height: FetchPixels.getPixelHeight(10),),
              Container(height: FetchPixels.getPixelHeight(1),width: FetchPixels.width,color: Colors.black,),
              SizedBox(height: FetchPixels.getPixelHeight(20),),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: noTap,
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: FetchPixels.getPixelHeight(5),horizontal: FetchPixels.getPixelWidth(8)),
                        child: textWidget(text: "NO", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w600,textColor: Colors.red),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: onTap,
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: FetchPixels.getPixelHeight(5),horizontal: FetchPixels.getPixelWidth(10)),
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