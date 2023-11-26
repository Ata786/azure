import 'dart:convert';
import 'dart:developer';
import 'package:SalesUp/controllers/distributionController.dart';
import 'package:SalesUp/data/getApis.dart';
import 'package:SalesUp/model/bookerWiseTargetModel.dart';
import 'package:SalesUp/res/base/fetch_pixels.dart';
import 'package:SalesUp/res/colors.dart';
import 'package:SalesUp/utils/widgets/appWidgets.dart';
import 'package:SalesUp/view/bookerWiseTarget.dart';
import 'package:SalesUp/view/distributerScreen.dart';
import 'package:SalesUp/view/shopWiseTarget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class TargetReport extends StatefulWidget {
  TargetReport({super.key});

  @override
  State<TargetReport> createState() => _TargetReportState();
}

class _TargetReportState extends State<TargetReport> {
  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  List<String> bookerTargetList = ['All','Consumer','Bulk'];
  String selectedTarget = 'All';

  List<String> distributionList = ["Tonnage","Pcs"];
  String selectedDistribution = "Tonnage";

  String selectedMonth = "January";
  String selectedMonth2 = "January";

  int selectedYear = DateTime.now().year;
  int selectedYear2 = DateTime.now().year;
  int bookerValue = 0;

  @override
  Widget build(BuildContext context) {
    int startYear = 2000;
    int endYear = DateTime.now().year + 10;

    List<DropdownMenuItem<int>> yearItems = [];

    for (int year = startYear; year <= endYear; year++) {
      yearItems.add(DropdownMenuItem<int>(
        value: year,
        child: Text(year.toString()),
      ));
    }
    return Scaffold(
      appBar: AppBar(
        actions: [
          InkWell(
              onTap: (){
                Get.to(DistributerScreen());
              },
              child: Icon(Icons.filter_alt_sharp,color: Colors.white,)),
          SizedBox(width: FetchPixels.getPixelWidth(20),),
        ],
        backgroundColor: themeColor,
        title:  textWidget(text: "Target Report", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w600,textColor: Colors.white),
      ),
      body: Container(
        height: FetchPixels.height,
        width: FetchPixels.width,
        child: Column(
          children: [
            SizedBox(height: 30),
            Align(
                alignment: Alignment.centerLeft,child: Padding(
                  padding: EdgeInsets.only(left: FetchPixels.getPixelWidth(20)),
                  child: textWidget(text: "Booker Wise Target", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w500,textColor: Colors.black),
                )),
            SizedBox(height: 20),
            Row(children: [
              SizedBox(width: FetchPixels.getPixelHeight(50),),
              DropdownButton<String>(
                value: selectedMonth,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedMonth = newValue!;
                  });
                },
                items: months.map((String month) {
                  return DropdownMenuItem<String>(
                    value: month,
                    child: Text(month),
                  );
                }).toList(),
              ),
              SizedBox(width: FetchPixels.getPixelHeight(50),),
              DropdownButton<int>(
                value: selectedYear,
                items: yearItems,
                onChanged: (int? newValue) {
                  setState(() {
                    selectedYear = newValue!;
                  });
                },
              ),
            ],),
            SizedBox(height: FetchPixels.getPixelHeight(20),),
            Padding(
              padding: EdgeInsets.only(left: FetchPixels.getPixelWidth(50)),
              child: Align(
                alignment: Alignment.centerLeft,
                child: DropdownButton<String>(
                  value: selectedTarget,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedTarget = newValue!;

                      if(selectedTarget == "Consumer"){
                        bookerValue = 1;
                      }else if(selectedTarget == "Bulk"){
                        bookerValue = 2;
                      }else{
                        bookerValue = 0;
                      }

                      setState(() {

                      });

                    });
                  },
                  items: bookerTargetList.map((String month) {
                    return DropdownMenuItem<String>(
                      value: month,
                      child: Text(month),
                    );
                  }).toList(),
                ),
              ),
            ),
            SizedBox(height: FetchPixels.getPixelHeight(40),),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: ()async{
                      List<BookerWiseTargetModel> list = await getBookerTarget();
                      Get.to(BookerWiseTarget(list,selectedMonth,selectedYear));
                    },
                    child: Container(
                        alignment: Alignment.center,
                        height: FetchPixels.height / 13,
                        width: FetchPixels.width/2,
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Color(0xffFFA799),
                            borderRadius: BorderRadius.circular(7)),
                        child:  Text(
                          "Target Achivement",
                          style: TextStyle(color: blackBrown,fontSize: FetchPixels.getPixelHeight(17),fontWeight: FontWeight.w600),
                        ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: FetchPixels.getPixelHeight(20),),
            Container(height: 1,width: FetchPixels.width,color: Colors.black,),
            SizedBox(height: FetchPixels.getPixelHeight(20),),
            Align(
                alignment: Alignment.centerLeft,child: Padding(
              padding: EdgeInsets.only(left: FetchPixels.getPixelWidth(20)),
              child: textWidget(text: "Shop Wise Target", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w500,textColor: Colors.black),
            )),
            SizedBox(height: 20),
            Row(children: [
              SizedBox(width: FetchPixels.getPixelHeight(50),),
              DropdownButton<String>(
                value: selectedMonth2,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedMonth2 = newValue!;
                  });
                },
                items: months.map((String month) {
                  return DropdownMenuItem<String>(
                    value: month,
                    child: Text(month),
                  );
                }).toList(),
              ),
              SizedBox(width: FetchPixels.getPixelHeight(50),),
              DropdownButton<int>(
                value: selectedYear2,
                items: yearItems,
                onChanged: (int? newValue) {
                  setState(() {
                    selectedYear2 = newValue!;
                  });
                },
              ),
            ],),
            SizedBox(height: FetchPixels.getPixelHeight(20),),
            Align(alignment: Alignment.centerLeft,
            child: Container(
              width: FetchPixels.width/2,
              padding: EdgeInsets.only(left: FetchPixels.getPixelWidth(20)),child: DropdownButton<String>(
              value: selectedDistribution,
              onChanged: (String? newValue) {
                setState(() {
                  selectedDistribution = newValue!;
                });
              },
              items: distributionList.map((String month) {
                return DropdownMenuItem<String>(
                  value: month,
                  child: Text(month),
                );
              }).toList(),
            ),),
            ),
            SizedBox(height: FetchPixels.getPixelHeight(20),),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: ()async{
                      List<ShopWiseTargetModel> list = await getShopTarget();
                      Get.to(ShopWiseTarget(list, selectedMonth2, selectedYear2,selectedDistribution));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: FetchPixels.height / 13,
                      width: FetchPixels.width/2,
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.greenAccent,
                          borderRadius: BorderRadius.circular(7)),
                      child:  Text(
                        "Target Achivement",
                        style: TextStyle(color: blackBrown,fontSize: FetchPixels.getPixelHeight(17),fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  Future<List<BookerWiseTargetModel>> getBookerTarget()async{

    DistributionController distributionController = Get.find<DistributionController>();

    List<BookerWiseTargetModel> bookerList = [];

    try{

      Map<String,dynamic> mapData = {
        "year": selectedYear.toString(),
        "month": selectedMonth,
        "categoryID": bookerValue,
        "isAllCategory": bookerValue == 0 ? true : false,
        "isAllDistributor": false,
        "distributors": distributionController.distributorIdList
      };

      Get.dialog(Center(child: CircularProgressIndicator(color: themeColor,),));

      log('>>>> data is ${mapData}');

      var res = await http.post(Uri.parse('$BASE_URL/DistributorBookerTarget'),headers: {'Content-Type': 'application/json'},
          body: jsonEncode(mapData));

      Get.back();

      if(res.statusCode == 200){
        List<dynamic> list = jsonDecode(res.body);
        log('>>> response ${list.length}');
        bookerList = list.map((e) => BookerWiseTargetModel.fromJson(e)).toList();
      }else{
        print('>>> ${res.body}');
      }

    }catch(e){
      print('>>> ${e.toString()}');
    }

    return bookerList;
  }



  Future<List<ShopWiseTargetModel>> getShopTarget()async{

    DistributionController distributionController = Get.find<DistributionController>();

    List<ShopWiseTargetModel> bookerList = [];

    try{

      Map<String,dynamic> mapData = {
        "year": selectedYear2.toString(),
        "month": selectedMonth2,
        "categoryID": 1,
        "isAllCategory": false,
        "isAllDistributor": false,
        "distributors": distributionController.distributorIdList
      };

      Get.dialog(Center(child: CircularProgressIndicator(color: themeColor,),));

      log('>>>> data is ${mapData}');

      var res = await http.post(Uri.parse('$BASE_URL/ShopWiseTarget'),headers: {'Content-Type': 'application/json'},
          body: jsonEncode(mapData));

      log('>>> ${res.statusCode} and ${res.body}');

      Get.back();

      if(res.statusCode == 200){
        List<dynamic> list = jsonDecode(res.body);
        bookerList = list.map((e) => ShopWiseTargetModel.fromJson(e)).toList();
      }else{
        print('>>> ${res.body}');
      }

    }catch(e){
      print('>>> ${e.toString()}');
    }

    return bookerList;
  }




}
