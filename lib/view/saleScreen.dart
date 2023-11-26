import 'dart:convert';
import 'dart:developer';

import 'package:SalesUp/controllers/UserController.dart';
import 'package:SalesUp/data/hiveDb.dart';
import 'package:SalesUp/model/daysModel.dart';
import 'package:SalesUp/model/financialYearModel.dart';
import 'package:SalesUp/model/saleDistributionModel.dart';
import 'package:SalesUp/res/base/fetch_pixels.dart';
import 'package:SalesUp/res/colors.dart';
import 'package:http/http.dart' as http;
import 'package:SalesUp/utils/toast.dart';
import 'package:SalesUp/view/brandWiseSale.dart';
import 'package:SalesUp/view/categoryWiseSale.dart';
import 'package:SalesUp/view/distributionWiseSale.dart';
import 'package:SalesUp/view/regionWiseSale.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/distributionController.dart';
import '../data/getApis.dart';
import '../model/assignUserModel.dart';
import '../model/distributionModel.dart';

class SaleScreen extends StatefulWidget {
   SaleScreen({super.key});

  @override
  State<SaleScreen> createState() => _SaleScreenState();
}

class _SaleScreenState extends State<SaleScreen> {

  String typeValue1 = '';

  List<String> typeDropDown2 = ["Value","Pcs","Tonnage"];
  String typeValue2 = "Value";
  int pcsValue = 0;

  List<String> typeDropDown3 = ["Value","Pcs","Tonnage"];
  String typeValue3 = "Value";
  int typeValue3value = 0;

  String today = "0.0000";
  String thisWeek = '0.0000';
  String thisMonth = '0.0000';
  String thisYear = '0.0000';
  List<BrandSale> brandWiseList = [];
  List<RegionSale> regionWiseList = [];
  List<CategorySale> categoryWiseList = [];
  List<Distributors> distributorWiseList = [];
  bool loading = false;
  bool distributorLoading = false;

  List<UserAssignModel> userAssignList = [];


  String typeValue = "Select Person";
  TextEditingController fromDateCtr = TextEditingController();
  TextEditingController toDateCtr = TextEditingController();
  DateTime now = DateTime.now();

  SaleDistributionModel saleDistributionModel = SaleDistributionModel();

  @override
  void initState() {
    super.initState();
    getDistributors();
  }

  void getDistributors()async{
    DistributionController distributionController = Get.find<DistributionController>();
    UserController userController = Get.find<UserController>();

    fromDateCtr.text = DateFormat("dd-MM-yyyy").format(now);
    toDateCtr.text = DateFormat("dd-MM-yyyy").format(now);

    List<DistributionModel> list = await HiveDatabase.getDistributionList("distribution", "distributionBox");
    distributionController.distributionList.value = list;
    distributionController.distributorIdList.clear();
    List<int> distributorIds = list.map((e) => e.distributorId ?? 0).toList();
    distributionController.distributorIdList.addAll(distributorIds);

    distributionController.selectedItems.clear();
    distributionController.selectedItems.addAll(list);

    DateTime currentDate = DateTime.now();
    int selectedYear = int.tryParse(typeValue1) ?? currentDate.year;
    DateTime customDate = DateTime(selectedYear, currentDate.month, currentDate.day, currentDate.hour, currentDate.minute, currentDate.second, currentDate.millisecond);
    String formattedDate = customDate.toUtc().toIso8601String();

    Map<String,dynamic> body = {
      "date": formattedDate,
      "type": pcsValue,
      "distributors": distributionController.distributorIdList
    };

    if(userController.isOnline.value == false){
      showToast(context, "");
    }else{
      days(body);
    }


    DateTime fromInputDate = DateFormat("dd-MM-yyyy").parse(fromDateCtr.text);
    String s = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(fromInputDate);

    DateTime eInputDate = DateFormat("dd-MM-yyyy").parse(toDateCtr.text);
    String e = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(eInputDate);

    Map<String,dynamic> saleByDay = {
      "startDate": s,
      "endDate": e,
      "type": typeValue3value,
      "distributors": distributionController.distributorIdList
    };

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if(userController.isOnline.value == false){
        showToast(context, "");
      }else{
        getSaleDistributionByDate(saleByDay);
        getAssignedUsersApi(userController.user!.value.id!, context);
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    DistributionController distributionController = Get.find<DistributionController>();
    FetchPixels(context);
    return Scaffold(
      body: Container(
        height: FetchPixels.height,
        width: FetchPixels.width,
        child: Column(
          children: [
            SizedBox(height: FetchPixels.getPixelHeight(30),),
            Row(
              children: [
                Expanded(child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(10)),
                  child: FutureBuilder(
                    future: HiveDatabase.getFinancialYearList("financialYear", "financialYearBox"),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<FinancialYearModel> financialList = snapshot.data ?? [];
                        typeValue1 = financialList[0].value.toString();
                        return DropdownButtonFormField<String>(
                          items: financialList.map<DropdownMenuItem<String>>((FinancialYearModel value) {
                            return DropdownMenuItem<String>(
                              value: value.value.toString(),
                              child: Text(value.value.toString() ?? ""),
                            );
                          }).toList(),
                          value: typeValue1,
                          onChanged: (String? value) {
                            typeValue1 = value ?? "";
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      } else {
                        return SizedBox();
                      }
                    },
                  ),
                ),),
                Expanded(child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(10)),
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                    value: typeValue2,
                    onChanged: (newValue) {

                        typeValue2 = newValue!;
                        if(typeValue2 == "Value"){
                          pcsValue = 0;
                        }else if(typeValue2 == "Pcs"){
                          pcsValue = 1;
                        }else{
                          pcsValue = 2;
                        }

                        DateTime currentDate = DateTime.now();
                        int selectedYear = int.tryParse(typeValue1) ?? currentDate.year;
                        DateTime customDate = DateTime(selectedYear, currentDate.month, currentDate.day, currentDate.hour, currentDate.minute, currentDate.second, currentDate.millisecond);
                        String formattedDate = customDate.toUtc().toIso8601String();

                        Map<String,dynamic> body = {
                          "date": formattedDate,
                          "type": pcsValue,
                          "distributors": distributionController.distributorIdList
                        };

                        log('>>>> ${body}');

                        UserController userCtr = Get.find<UserController>();

                        if(userCtr.isOnline.value == true){
                          days(body);
                        }else{
                           showToast(context, "");
                        }
                    },
                    items: typeDropDown2.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value ?? ""),
                      );
                    }).toList(),
                  ),
                ),),
              ],
            ),
            SizedBox(height: FetchPixels.getPixelHeight(30),),
            Row(
              children: [
                Expanded(
                  child: Container(
                      alignment: Alignment.center,
                      height: FetchPixels.height / 13,
                      width: FetchPixels.width/2,
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Color(0xffADD8E6),
                          borderRadius: BorderRadius.circular(7)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Today",
                            style: TextStyle(color: blackBrown,fontSize: FetchPixels.getPixelHeight(17),fontWeight: FontWeight.w600),
                          ),
                          loading == true ? SizedBox(height:(FetchPixels.getPixelHeight(20)),width: FetchPixels.getPixelWidth(20),child: Center(child: CircularProgressIndicator(color: blackBrown,),),)
                          : Text(
                            "${today}",
                            style: TextStyle(color: blackBrown,fontSize: FetchPixels.getPixelHeight(17),fontWeight: FontWeight.w600),
                          ),
                        ],
                      )
                  ),
                ),
                Expanded(
                  child: Container(
                      alignment: Alignment.center,
                      height: FetchPixels.height / 13,
                      width: FetchPixels.width/2,
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Color(0xfff7d8ba),
                          borderRadius: BorderRadius.circular(7)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "This Week",
                            style: TextStyle(color: blackBrown,fontSize: FetchPixels.getPixelHeight(17),fontWeight: FontWeight.w600),
                          ),
                          loading == true ? SizedBox(height:(FetchPixels.getPixelHeight(20)),width: FetchPixels.getPixelWidth(20),child: Center(child: CircularProgressIndicator(color: blackBrown,),),)
                              : Text(
                            "${thisWeek}",
                            style: TextStyle(color: blackBrown,fontSize: FetchPixels.getPixelHeight(17),fontWeight: FontWeight.w600),
                          ),
                        ],
                      )
                  ),
                ),
              ],
            ),
            SizedBox(height: FetchPixels.getPixelHeight(10),),
            Row(
              children: [
                Expanded(
                  child: Container(
                      alignment: Alignment.center,
                      height: FetchPixels.height / 13,
                      width: FetchPixels.width/2,
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Color(0xffFFA799),
                          borderRadius: BorderRadius.circular(7)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "This Month",
                            style: TextStyle(color: blackBrown,fontSize: FetchPixels.getPixelHeight(17),fontWeight: FontWeight.w600),
                          ),
                          loading == true ? SizedBox(height:(FetchPixels.getPixelHeight(20)),width: FetchPixels.getPixelWidth(20),child: Center(child: CircularProgressIndicator(color: blackBrown,),),)
                              : Text(
                            "${thisMonth}",
                            style: TextStyle(color: blackBrown,fontSize: FetchPixels.getPixelHeight(17),fontWeight: FontWeight.w600),
                          ),
                        ],
                      )
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    height: FetchPixels.height / 13,
                    width: FetchPixels.width/2,
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.pinkAccent.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(7)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "This Year",
                          style: TextStyle(color: blackBrown,fontSize: FetchPixels.getPixelHeight(17),fontWeight: FontWeight.w600),
                        ),
                        loading == true ? SizedBox(height:(FetchPixels.getPixelHeight(20)),width: FetchPixels.getPixelWidth(20),child: Center(child: CircularProgressIndicator(color: blackBrown,),),)
                            : Text(
                          "${thisYear}",
                          style: TextStyle(color: blackBrown,fontSize: FetchPixels.getPixelHeight(17),fontWeight: FontWeight.w600),
                        ),
                      ],
                    )
                  ),
                ),
              ],
            ),
            SizedBox(height: FetchPixels.getPixelHeight(20),),
           Row(
             children: [
               Container(
                 width: FetchPixels.width/2,
                 child: Padding(
                   padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
                   child: TextField(
                     readOnly: true,
                     enabled: true,
                     onTap: (){
                       showDatePicker(
                         context: context,
                         initialDate: now,
                         firstDate: DateTime(1950),
                         lastDate: DateTime(2050),
                       ).then((selectedDate) {
                         if(selectedDate != null){
                           String formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);
                           fromDateCtr.text = formattedDate;
                         }
                       });
                     },
                     decoration: InputDecoration(
                         hintText: "From Date",
                         suffixIcon: Icon(Icons.calendar_month)
                     ),
                     controller: fromDateCtr,
                   ),
                 ),
               ),
               Container(
                 width: FetchPixels.width/2,
                 child: Padding(
                   padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
                   child: TextField(
                     readOnly: true,
                     enabled: true,
                     onTap: (){
                       showDatePicker(
                         context: context,
                         initialDate: now,
                         firstDate: DateTime(1950),
                         lastDate: DateTime(2050),
                       ).then((selectedDate) {
                         if(selectedDate != null){
                           String formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);
                           toDateCtr.text = formattedDate;
                         }
                       });
                     },
                     decoration: InputDecoration(
                         hintText: "To Date",
                         suffixIcon: Icon(Icons.calendar_month)
                     ),
                     controller: toDateCtr,
                   ),),
               ),
             ],
           ),
            SizedBox(height: FetchPixels.getPixelHeight(20),),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(30)),
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                value: typeValue3,
                onChanged: (newValue) {

                  typeValue3 = newValue!;

                  if(typeValue3 == "Value"){
                    typeValue3value = 0;
                  }else if(typeValue3 == "Pcs"){
                    typeValue3value = 1;
                  }else{
                    typeValue3value = 2;
                  }

                  DateTime fromInputDate = DateFormat("dd-MM-yyyy").parse(fromDateCtr.text);
                  String s = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(fromInputDate);

                  DateTime eInputDate = DateFormat("dd-MM-yyyy").parse(toDateCtr.text);
                  String e = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(eInputDate);

                  Map<String,dynamic> saleByDay = {
                    "startDate": s,
                    "endDate": e,
                    "type": typeValue3value,
                    "distributors": distributionController.distributorIdList
                  };

                  UserController userCtr = Get.find<UserController>();

                  if(userCtr.isOnline.value == true){

                    getSaleDistributionByDate(saleByDay);

                  }else{
                    showToast(context, "");
                  }


                },
                items: typeDropDown3.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value ?? ""),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: FetchPixels.getPixelHeight(20),),
            Row(
              children: [
                InkWell(
                  onTap: (){
                    if(loading == true){
                    }else{
                    Get.to(DistributerWiseSale(distributorWiseList: distributorWiseList,year: typeValue1,value: typeValue3,top5: true));
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: FetchPixels.height / 13,
                    width: FetchPixels.width/2.4,
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Color(0xffB4F297),
                        borderRadius: BorderRadius.circular(7)),
                    child: Text(
                      "Top 5 Distributions",
                      style: TextStyle(color: blackBrown,fontSize: FetchPixels.getPixelHeight(15),fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    if(loading == true){

                    }else{
                    Get.to(CategoryWiseSale(categoryWiseList: categoryWiseList,year: typeValue1,value: typeValue3));
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: FetchPixels.height / 13,
                    width: FetchPixels.width/2.3,
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.redAccent.shade100,
                        borderRadius: BorderRadius.circular(7)),
                    child:  Text(
                      "Category Wise",
                      style: TextStyle(color: blackBrown,fontSize: FetchPixels.getPixelHeight(15),fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: (){
                      if(loading == true){
                      }else{
                      Get.to(RegionWiseSale(regionWiseList: regionWiseList,year: typeValue1,value: typeValue3));
                      }
                    },
                    child: Container(
                        alignment: Alignment.center,
                        height: FetchPixels.height / 13,
                        width: FetchPixels.width/2,
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.amber.shade200,
                            borderRadius: BorderRadius.circular(7)),
                        child: Text(
                          "Region Wise",
                          style: TextStyle(color: blackBrown,fontSize: FetchPixels.getPixelHeight(17),fontWeight: FontWeight.w600),
                        ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: ()async{
                      if(loading == true){

                      }else{
                      Get.to(BrandWiseSale(brandWiseList: brandWiseList,year: typeValue1,value: typeValue3));
                      }
                    },
                    child: Container(
                        alignment: Alignment.center,
                        height: FetchPixels.height / 13,
                        width: FetchPixels.width/2,
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.deepPurple.shade200,
                            borderRadius: BorderRadius.circular(7)),
                        child:  Text(
                          "Brand Wise",
                          style: TextStyle(color: blackBrown,fontSize: FetchPixels.getPixelHeight(17),fontWeight: FontWeight.w600),
                        ),
                    ),
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: ()async{
                if(loading == true){
                }else{
                  Get.to(DistributerWiseSale(distributorWiseList: distributorWiseList,year: typeValue1,value: typeValue3,top5: false));
                }
              },
              child: Container(
                alignment: Alignment.center,
                height: FetchPixels.height / 13,
                width: FetchPixels.width/2,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.tealAccent.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(7)),
                child:  Text(
                  "Distribution List",
                  style: TextStyle(color: blackBrown,fontSize: FetchPixels.getPixelHeight(17),fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void days(Map<String,dynamic> body)async{
    loading = true;
    setState(() {

    });
    DistributionController distributionController = Get.find<DistributionController>();
    DaysModel daysModel = await distributionController.saleReportApis(body);
    today = typeValue2 == "Tonnage" ? distributionController.formatNumberWithCommas(daysModel.today.toString()) : distributionController.formatNumberWithCommas(double.tryParse(daysModel.today.toString())!.toStringAsFixed(0));
    thisWeek = typeValue2 == "Tonnage" ? distributionController.formatNumberWithCommas(daysModel.thisWeek.toString()) : distributionController.formatNumberWithCommas(double.tryParse(daysModel.thisWeek.toString())!.toStringAsFixed(0));
    thisMonth = typeValue2 == "Tonnage" ? distributionController.formatNumberWithCommas(daysModel.thisMonth.toString()) : distributionController.formatNumberWithCommas(double.tryParse(daysModel.thisMonth.toString())!.toStringAsFixed(0));
    thisYear = typeValue2 == "Tonnage" ? distributionController.formatNumberWithCommas(daysModel.thisYear.toString()) : distributionController.formatNumberWithCommas(double.tryParse(daysModel.thisYear.toString())!.toStringAsFixed(0));
    setState(() {
      loading = false;
    });
  }


  void getSaleDistributionByDate(Map<String,dynamic> body)async{

    Get.dialog(Center(child: CircularProgressIndicator(color: themeColor,),));

    DistributionController distributionController = Get.find<DistributionController>();
    SaleDistributionModel saleDistribution = await distributionController.saleReportByDayApis(body);
    saleDistributionModel = saleDistribution;
    Get.back();

    brandWiseList.clear();
    distributorWiseList.clear();
    categoryWiseList.clear();
    regionWiseList.clear();
    brandWiseList.addAll(saleDistributionModel.brandSale ?? []);
    distributorWiseList.addAll(saleDistributionModel.distributors ?? []);
    categoryWiseList.addAll(saleDistributionModel.categorySale ?? []);
    regionWiseList.addAll(saleDistributionModel.regionSale ?? []);


  }




  void getAssignedUsersApi(String id,BuildContext context)async{
    Get.dialog(
        Center(child: CircularProgressIndicator(color: themeColor),)
    );

    UserController userController = Get.find<UserController>();

    try{
      var res = await http.get(
        Uri.parse("${BASE_URL}/UserAssigned/$id"),
      );

      log(">> assignUser ${res.statusCode} and ${res.body}");

      if(res.statusCode == 200){
        Get.back();
        List<dynamic> dataMap = jsonDecode(res.body);
        userController.userAssignList = dataMap.map((e) => UserAssignModel.fromJson(e)).toList();
      }else{
        Get.back();
        print(">> error ${res.body}");
      }
    }catch(exception){
      Get.back();
      print('>>> ${exception.toString()}');
    }

  }
  


}
