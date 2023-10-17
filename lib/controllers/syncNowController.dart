import 'dart:convert';
import 'dart:developer';

import 'package:SalesUp/model/orderCalculations.dart';
import 'package:SalesUp/model/reasonsModel.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/shopsTexModel.dart';
import '../model/syncDownModel.dart';
import 'package:http/http.dart' as http;

import '../res/base/fetch_pixels.dart';
import '../res/colors.dart';
import '../utils/routes/routePath.dart';
import '../utils/widgets/appWidgets.dart';

class SyncNowController extends GetxController{

  Rx<bool> check = false.obs;
  Rx<bool> checkSyncUp = false.obs;
  RxList<SyncDownModel> syncDownList = <SyncDownModel>[].obs;
  Rx<bool> searchCheck = false.obs;
  RxList<SyncDownModel> allList = <SyncDownModel>[].obs;
  RxList<SyncDownModel> searchList = <SyncDownModel>[].obs;
  RxList<ReasonModel> reasonModelList = <ReasonModel>[].obs;
  RxList<ReasonModel> filteredReasonList = <ReasonModel>[].obs;
  RxList<SyncDownModel> nonProductiveList = <SyncDownModel>[].obs;

  RxList<ShopsStatusModel> shopStatusList = <ShopsStatusModel>[].obs;
  RxList<ShopSectorModel> shopSectorList = <ShopSectorModel>[].obs;
  RxList<ShopTypeModel> shopTypeList = <ShopTypeModel>[].obs;

  int item = 0;

  Rx<OrderCalculationModel> orderCalculationModel = OrderCalculationModel().obs;

  
  
  Future<void> updateAttendance(Map<String,dynamic> data)async{
    
    try{

      log('>>>> response ${data}');

      final response = await http.put(
        Uri.parse('http://125.209.79.107:7700/api/Attendance'),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'},
      );

      log('>>>> response ${response.statusCode} and ${response.body}');

      if(response.statusCode == 200){
        Fluttertoast.showToast(
            msg: "Your Attendance Updated Successfully",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: themeColor,
            textColor: Colors.white,
            fontSize: 16.0
        );

       Future.delayed(Duration(seconds: 3)).then((value) {
         Get.dialog(
             AlertDialog(content: Container(
               height: FetchPixels.getPixelHeight(100),
               width: FetchPixels.width,
               color: Colors.white,
               child: Column(
                 children: [
                   textWidget(text: "Are your sure?\nYou want to logout?", fontSize: FetchPixels.getPixelHeight(20), fontWeight: FontWeight.w500,textAlign: TextAlign.center),
                   SizedBox(height: FetchPixels.getPixelHeight(25),),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                     children: [
                       InkWell(
                           onTap: (){
                             Get.back();
                           },
                           child: textWidget(text: "No", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w600,textColor: Colors.red)),
                       InkWell(
                           onTap: ()async{

                             SharedPreferences shared = await SharedPreferences.getInstance();
                             bool remove = await shared.remove("user");
                             if(remove == true){
                               Get.offAllNamed(SIGN_IN_SCREEN);
                             }
                           },
                           child: textWidget(text: "Yes", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w600,textColor: Colors.green)),
                     ],
                   )
                 ],
               ),
             ),)
         );
       });


        log('Exception ${response.statusCode} and ${response.body}');
      }else{
        log('Exception ${response.statusCode} and ${response.body}');
      }
      
    }catch(e){
      log('Exception ${e.toString()}');
    }
    
  }


}