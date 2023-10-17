import 'dart:convert';
import 'dart:developer';
import 'package:SalesUp/controllers/UserController.dart';
import 'package:SalesUp/controllers/distributionController.dart';
import 'package:SalesUp/data/getApis.dart';
import 'package:SalesUp/model/dayCloseModel.dart';
import 'package:SalesUp/utils/toast.dart';
import 'package:SalesUp/view/distributerScreen.dart';
import 'package:http/http.dart' as http;
import 'package:SalesUp/res/base/fetch_pixels.dart';
import 'package:SalesUp/res/colors.dart';
import 'package:SalesUp/utils/widgets/appWidgets.dart';
import 'package:SalesUp/view/todayCloseStatus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DayCloseStatusScreen extends StatelessWidget {
   DayCloseStatusScreen({super.key});


  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return Scaffold(
      appBar: AppBar(
        title: textWidget(
          textColor: Colors.white,
          text: "Day Close Status",
          fontSize: FetchPixels.getPixelHeight(17),
          fontWeight: FontWeight.w600,
        ),
        actions: [
          InkWell(
              onTap: (){
                Get.to(DistributerScreen());
              },
              child: Icon(Icons.filter_alt_sharp,color: Colors.white,)),
          SizedBox(width: FetchPixels.getPixelWidth(20),),
        ],
      ),
      body: Container(
        height: FetchPixels.height,
        width: FetchPixels.width,
        child: Column(
          children: [
            SizedBox(height: FetchPixels.getPixelHeight(50),),
            InkWell(
              onTap: (){
                UserController userController = Get.find<UserController>();
                DistributionController distributionCtr = Get.find<DistributionController>();
                if(userController.isOnline.value == true){
                  getCloseDayApi(distributionCtr.distributorIdList,0);
                }else{
                  showToast(context, "");
                }
              },
              child: Container(
                height: FetchPixels.getPixelHeight(70),
                width: FetchPixels.width,
                color: Colors.deepOrange.withOpacity(0.5),
                margin: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(50)),
                child: Center(child: textWidget(
                  textColor: blackBrown,
                  text: "Today Not Close",
                  fontSize: FetchPixels.getPixelHeight(17),
                  fontWeight: FontWeight.w600,
                ),),
              ),
            ),
            SizedBox(height: FetchPixels.getPixelHeight(30),),
            InkWell(
              onTap: (){
    UserController userController = Get.find<UserController>();
    DistributionController distributionCtr = Get.find<DistributionController>();
    if(userController.isOnline.value == true){
      getCloseDayApi(distributionCtr.distributorIdList,1);
    }else{
      showToast(context, "");
    }

              },
              child: Container(
                height: FetchPixels.getPixelHeight(70),
                width: FetchPixels.width,
                color: Colors.blue.withOpacity(0.5),
                margin: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(50)),
                child: Center(child: textWidget(
                  textColor: blackBrown,
                  text: "Distribution List",
                  fontSize: FetchPixels.getPixelHeight(17),
                  fontWeight: FontWeight.w600,
                ),),
              ),
            ),
          ],
        ),
      ),
    );
  }


  void getCloseDayApi(data,value)async{

    Get.dialog(Center(child: CircularProgressIndicator(color: themeColor,),));
    try{

      var res = await http.post(Uri.parse('$BASE_URL/DayCloseDistributor'),headers: {'Content-Type': 'application/json'},body: jsonEncode(data));

      log('>>>> ${res.statusCode} and ${res.body}');
      Get.back();
      if(res.statusCode == 200){
        List<dynamic> d = jsonDecode(res.body);
        List<DayCloseModel> l = d.map((e) => DayCloseModel.fromJson(e)).toList();

        if(value == 0){
          String currentDate = DateFormat("yyyy-MM-dd'T'00:00:00").format(DateTime.now());
          List<DayCloseModel> filteredList = l.where((item) => item.dcdate != currentDate).toList();
          Get.to(TodayNotCloseScreen(value: value,list: filteredList));
        }else{
          Get.to(TodayNotCloseScreen(value: value,list: l));
        }

      }else{
        log('>>>> ${res.body}');
      }

    }catch(e){
      log('>>>> ${e.toString()}');
    }
  }


}
