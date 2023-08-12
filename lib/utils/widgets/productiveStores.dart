import 'package:azure/controllers/syncNowController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../../res/base/fetch_pixels.dart';
import '../../res/colors.dart';
import '../../res/images.dart';
import 'appWidgets.dart';

Widget productiveStore({required SyncNowController syncNowController}){
  return Obx(()=> syncNowController.check.value == true ? Center(child: CircularProgressIndicator(color: themeColor,),)
  : ListView.builder(
        itemCount: syncNowController.reasonModelList.length,
        itemBuilder: (context,index){
      return Container(
        height: FetchPixels.getPixelHeight(40),
        width: FetchPixels.width,
        margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                textWidget(
                  textColor: Colors.black,
                  text: syncNowController.reasonModelList[index].shopName ?? "",
                  fontSize: FetchPixels.getPixelHeight(17),
                  fontWeight: FontWeight.w600,
                ),
                Row(
                  children: [
                    syncNowController.reasonModelList[index].reason == "Invoice" ? Image.asset(checked,height: FetchPixels.getPixelHeight(20),width: FetchPixels.getPixelWidth(20),) : Image.asset(remove,height: FetchPixels.getPixelHeight(20),width: FetchPixels.getPixelWidth(20),),
                    SizedBox(width: FetchPixels.getPixelWidth(25),),
                    Image.asset(editing,height: FetchPixels.getPixelHeight(20),width: FetchPixels.getPixelWidth(20),),
                    SizedBox(width: FetchPixels.getPixelWidth(25),),
                    InkWell(
                        onTap: (){
                          Get.dialog(
                            AlertDialog(
                              content: Container(
                                height: FetchPixels.getPixelHeight(100),
                                width: FetchPixels.width,
                                child: Column(
                                  children: [
                                    textWidget(
                                      textColor: Colors.black,
                                      text: "Do you want to delete this record?",
                                      fontSize: FetchPixels.getPixelHeight(16),
                                      fontWeight: FontWeight.w600,
                                    ),
                                    SizedBox(height: FetchPixels.getPixelHeight(20),),
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
                                              child: textWidget(text: "No", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w600,textColor: Colors.red),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: ()async{
                                             var box = await Hive.openBox("reasonNo");
                                            box.deleteAt(index);
                                            syncNowController.reasonModelList.removeAt(index);
                                            Get.back();
                                          },
                                          child: Card(
                                            child: Padding(
                                              padding: EdgeInsets.all(5.0),
                                              child: textWidget(text: "Yes", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w600,textColor: Colors.green),
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                          );
                        },
                        child: Image.asset(bin,height: FetchPixels.getPixelHeight(20),width: FetchPixels.getPixelWidth(20),)),
                  ],
                )
              ],
            ),
            Spacer(),
            Container(height: FetchPixels.getPixelHeight(1),color: Colors.black,),
            SizedBox(height: FetchPixels.getPixelHeight(5),)
          ],
        )
      );
    }),
  );
}