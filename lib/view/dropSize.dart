import 'dart:developer';
import 'package:SalesUp/controllers/distributionController.dart';
import 'package:SalesUp/model/distributionModel.dart';
import 'package:SalesUp/model/llpcDistibutors.dart';
import 'package:SalesUp/model/lppcModel.dart';
import 'package:SalesUp/res/base/fetch_pixels.dart';
import 'package:SalesUp/res/colors.dart';
import 'package:SalesUp/utils/widgets/appWidgets.dart';
import 'package:SalesUp/view/distributerScreen.dart';
import 'package:SalesUp/view/llpcBookerList.dart';
import 'package:SalesUp/view/lppcListScree.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../data/hiveDb.dart';
import '../model/financialYearModel.dart';

class DropSizeScreen extends StatefulWidget {
  DropSizeScreen({super.key});

  @override
  State<DropSizeScreen> createState() => _DropSizeScreenState();
}

class _DropSizeScreenState extends State<DropSizeScreen> {

  List<String> typeDropDown1 = ["Financial Year","Value","Pcs","Tonnage"];
  String typeValue1 = "Financial Year";

  List<String> dayList1 = ["Today","This Week","This Month","This Year"];
  String selectedDay1 = "Today";

  List<String> dayList2 = ["Today","This Week","This Month","This Year"];
  String selectedDay2 = "Today";

  int dayNumber1 = 0;
  String typeValue2 = "";
  int dayNumber2 = 0;

  late String selectedValue;
  LppcModel lppcModel = LppcModel();
  List<BookerList> bookerList = [];

  TextEditingController fromDateCtr = TextEditingController();
  TextEditingController toDateCtr = TextEditingController();
  DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();
    DistributionController distributionController = Get.find<DistributionController>();
    selectedValue = distributionController.distributionList[0].distributorName ?? "";

    DateTime currentDate = DateTime.now();
    int selectedYear = int.tryParse(typeValue1) ?? currentDate.year;
    DateTime customDate = DateTime(selectedYear, currentDate.month, currentDate.day, currentDate.hour, currentDate.minute, currentDate.second, currentDate.millisecond);
    String formattedDate = customDate.toUtc().toIso8601String();

    Map<String,dynamic> data = {
      "date": formattedDate,
      "type": dayNumber1,
      "distributors": distributionController.distributorIdList
    };

    Map<String,dynamic> bookers = {
      "date": formattedDate,
      "type": dayNumber1,
      "distributor": distributionController.distributorIdList[0]
    };

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getDistributorsList(data);
      getLppcList(bookers);
    });

  }


  @override
  Widget build(BuildContext context) {
    DistributionController distributionController = Get.find<DistributionController>();
    FetchPixels(context);
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
        title:  textWidget(text: "LPPC Report", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w600,textColor: Colors.white),
      ),
      body: Container(
        height: FetchPixels.height,
        width: FetchPixels.width,
        child: Column(
          children: [
            SizedBox(height: FetchPixels.getPixelHeight(30),),
            Row(
              children: [
                Expanded(
                  child: FutureBuilder(
                    future: HiveDatabase.getFinancialYearList("financialYear", "financialYearBox"),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<FinancialYearModel> financialList = snapshot.data ?? [];
                        typeValue1 = financialList[0].value.toString();
                        return Padding(padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),child: DropdownButtonFormField<String>(
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
                        ),);
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      } else {
                        return SizedBox();
                      }
                    },
                  ),
                ),
               Expanded(
                 child:  Padding(
                   padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
                   child: DropdownButtonFormField<String>(
                     items: dayList1.map<DropdownMenuItem<String>>((String value) {
                       return DropdownMenuItem<String>(
                         value: value,
                         child: Text(value),
                       );
                     }).toList(),
                     value: selectedDay1,
                     onChanged: (String? value) {
                       selectedDay1 = value ?? "";
                       if(selectedDay1 == "Today"){
                         dayNumber1 = 0;
                       }else if(selectedDay1 == "This Week"){
                         dayNumber1 = 1;
                       }else if(selectedDay1 == "This Month"){
                         dayNumber1 = 2;
                       }else{
                         dayNumber1 = 3;
                       }

                       DateTime currentDate = DateTime.now();
                       int selectedYear = int.tryParse(typeValue1) ?? currentDate.year;
                       DateTime customDate = DateTime(selectedYear, currentDate.month, currentDate.day, currentDate.hour, currentDate.minute, currentDate.second, currentDate.millisecond);
                       String formattedDate = customDate.toUtc().toIso8601String();

                       Map<String,dynamic> data = {
                         "date": formattedDate,
                         "type": dayNumber1,
                         "distributors": distributionController.distributorIdList
                       };

                       getDistributorsList(data);

                     },
                   ),
                 ),
               ),
              ],
            ),
            SizedBox(height: FetchPixels.getPixelHeight(20),),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: (){
                   Get.to(LlpcDistributorsScreen(lppcModel: lppcModel, year: typeValue1, value: selectedDay1,top5: true));
                     },
                    child: Container(
                        alignment: Alignment.center,
                        height: FetchPixels.height / 13,
                        width: FetchPixels.width/2,
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Color(0xffADD8E6),
                            borderRadius: BorderRadius.circular(7)),
                        child: Text(
                          "Top 5 Distributions",
                          style: TextStyle(color: blackBrown,fontSize: FetchPixels.getPixelHeight(17),fontWeight: FontWeight.w600),
                        ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: (){
                      Get.to(LlpcBookerListScreen(lppcModel: lppcModel, year: typeValue1, value: selectedDay1,top5: true));
                    },
                    child: Container(
                        alignment: Alignment.center,
                        height: FetchPixels.height / 13,
                        width: FetchPixels.width/2,
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Color(0xfff7d8ba),
                            borderRadius: BorderRadius.circular(7)),
                        child: Text(
                          "Top 5 Booker",
                          style: TextStyle(color: blackBrown,fontSize: FetchPixels.getPixelHeight(17),fontWeight: FontWeight.w600),
                        ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: FetchPixels.getPixelHeight(10),),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: (){
                      Get.to(LlpcDistributorsScreen(lppcModel: lppcModel, year: typeValue1, value: selectedDay1,top5: false));
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
                          "Distribution List",
                          style: TextStyle(color: blackBrown,fontSize: FetchPixels.getPixelHeight(17),fontWeight: FontWeight.w600),
                        ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: (){
                      Get.to(LlpcBookerListScreen(lppcModel: lppcModel, year: typeValue1, value: selectedDay1,top5: false));
                    },
                    child: Container(
                        alignment: Alignment.center,
                        height: FetchPixels.height / 13,
                        width: FetchPixels.width/2,
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Color(0xffB7ACA5),
                            borderRadius: BorderRadius.circular(7)),
                        child:   Text(
                          "Booker List",
                          style: TextStyle(color: blackBrown,fontSize: FetchPixels.getPixelHeight(17),fontWeight: FontWeight.w600),
                        ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: FetchPixels.getPixelHeight(20),),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
              child: DropdownSearch<String>(
                compareFn: (a,b) => a == b,
                popupProps: PopupProps.menu(
                  showSearchBox: true,
                  showSelectedItems: true,
                ),
                items: distributionController.distributionList.map((element) => element.distributorName ?? "").toList(),
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: "",
                    hintText: "",
                  ),
                ),
                onChanged: (value){
                  setState(() {
                    selectedValue = value!;
                  });
                },
                selectedItem: selectedValue, // This will show the first item in the list.
              ),
            ),
            SizedBox(height: FetchPixels.getPixelHeight(20),),
            // Row(
            //   children: [
            //     Expanded(flex: 1,child: FutureBuilder(
            //       future: HiveDatabase.getFinancialYearList("financialYear", "financialYearBox"),
            //       builder: (context, snapshot) {
            //         if (snapshot.hasData) {
            //           List<FinancialYearModel> financialList = snapshot.data ?? [];
            //           typeValue2 = financialList[0].value.toString();
            //           return Padding(padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),child: DropdownButtonFormField<String>(
            //             items: financialList.map<DropdownMenuItem<String>>((FinancialYearModel value) {
            //               return DropdownMenuItem<String>(
            //                 value: value.value.toString(),
            //                 child: Text(value.value.toString() ?? ""),
            //               );
            //             }).toList(),
            //             value: typeValue2,
            //             onChanged: (String? value) {
            //               typeValue2 = value ?? "";
            //
            //             },
            //           ),);
            //         } else if (snapshot.hasError) {
            //           return Text("${snapshot.error}");
            //         } else {
            //           return SizedBox();
            //         }
            //       },
            //     )),
            //     Expanded(
            //       flex: 1,
            //       child: Padding(
            //         padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(5)),
            //         child: DropdownButtonFormField<String>(
            //           items: dayList2.map<DropdownMenuItem<String>>((String value) {
            //             return DropdownMenuItem<String>(
            //               value: value,
            //               child: Text(value),
            //             );
            //           }).toList(),
            //           value: selectedDay2,
            //           onChanged: (String? value) {
            //             selectedDay2 = value ?? "";
            //
            //             if(selectedDay2 == "Today"){
            //               dayNumber2 = 0;
            //             }else if(selectedDay2 == "This Week"){
            //               dayNumber2 = 1;
            //             }else if(selectedDay2 == "This Month"){
            //               dayNumber2 = 2;
            //             }else{
            //               dayNumber2 = 3;
            //             }
            //
            //             DateTime currentDate = DateTime.now();
            //             int selectedYear = int.tryParse(typeValue1) ?? currentDate.year;
            //             DateTime customDate = DateTime(selectedYear, currentDate.month, currentDate.day, currentDate.hour, currentDate.minute, currentDate.second, currentDate.millisecond);
            //             String formattedDate = customDate.toUtc().toIso8601String();
            //
            //             DistributionModel d = distributionController.distributionList.where((p0) => p0.distributorName.toString() == selectedValue.toString()).first;
            //
            //             Map<String,dynamic> bookers = {
            //               "date": formattedDate,
            //               "type": dayNumber1,
            //               "distributor": d.distributorId
            //             };
            //             getLppcList(bookers);
            //           },
            //         ),
            //       ),
            //     )
            //   ],
            // ),
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
            InkWell(
              onTap: (){
                Get.to(LppcListScreen(bookerList: bookerList, year: typeValue2, value: selectedDay2,));
              },
              child: Container(
                alignment: Alignment.center,
                height: FetchPixels.height / 14,
                width: FetchPixels.width/3,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.deepPurple.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(7)),
                child: Text(
                  "List",
                  style: TextStyle(color: blackBrown,fontSize: FetchPixels.getPixelHeight(17),fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getDistributorsList(Map<String,dynamic> data)async{
    Get.dialog(Center(child: CircularProgressIndicator(color: themeColor,),));
    DistributionController distributionController = Get.find<DistributionController>();
    LppcModel l = await distributionController.lppcListApi(data);
    lppcModel = l;
    Get.back();
  }


  void getLppcList(Map<String,dynamic> data)async{
    log('>>> ${data}');
    Get.dialog(Center(child: CircularProgressIndicator(color: themeColor,),));
    DistributionController distributionController = Get.find<DistributionController>();
    List<BookerList> l = await distributionController.lppcApi(data);
    bookerList.clear();
    bookerList.addAll(l);
    Get.back();
  }


}
