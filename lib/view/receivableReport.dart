import 'dart:developer';
import 'package:SalesUp/controllers/UserController.dart';
import 'package:SalesUp/controllers/distributionController.dart';
import 'package:SalesUp/model/receivableInvoicesModel.dart';
import 'package:SalesUp/model/receivableModel.dart';
import 'package:SalesUp/res/base/fetch_pixels.dart';
import 'package:SalesUp/res/colors.dart';
import 'package:SalesUp/utils/toast.dart';
import 'package:SalesUp/utils/widgets/appWidgets.dart';
import 'package:SalesUp/view/distributerScreen.dart';
import 'package:SalesUp/view/distributorWiseList.dart';
import 'package:SalesUp/view/receivableInvoicesScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../data/hiveDb.dart';
import '../model/financialYearModel.dart';

class ReceivableReport extends StatefulWidget {
  ReceivableReport({super.key});

  @override
  State<ReceivableReport> createState() => _ReceivableReportState();
}

class _ReceivableReportState extends State<ReceivableReport> {

  String typeValue1 = '';
  String typeValue2 = '';
  bool loading = false;
  String todayReceivable = "0.0000";
  String thisWeekReceivable = "0.0000";
  String thisMonthReceivable = "0.0000";
  String thisYearReceivable = "0.0000";
  String todayRecovery = "0.0000";
  String thisWeekRecovery = "0.0000";
  String thisMonthRecovery = "0.0000";
  String thisYearRecovery = "0.0000";

  List<String> dayList = ["Today","This Week","This Month","This Year"];
  String selectedDay = "Today";
  int dayNumber = 0;
  List<Distributor> distributors = [];

  ReceivableInvoicesModel receivableInvoicesModel = ReceivableInvoicesModel();

  TextEditingController fromDateCtr = TextEditingController();
  TextEditingController toDateCtr = TextEditingController();
  DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();

    DateTime currentDate = DateTime.now();
    int selectedYear = int.tryParse(typeValue2) ?? currentDate.year;
    DateTime customDate = DateTime(selectedYear, currentDate.month, currentDate.day, currentDate.hour, currentDate.minute, currentDate.second, currentDate.millisecond);
    String formattedDate = customDate.toUtc().toIso8601String();

    fromDateCtr.text = DateFormat("dd-MM-yyyy").format(currentDate);
    toDateCtr.text = DateFormat("dd-MM-yyyy").format(currentDate);

    UserController userController = Get.find<UserController>();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if(userController.isOnline.value == true){
        getReceivablePrice();
      }else{
        showToast(context, "");
      }
    });

  }

  @override
  Widget build(BuildContext context) {
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
        title:  textWidget(text: "Receivable Report", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w600,textColor: Colors.white),
      ),
      body: Container(
        height: FetchPixels.height,
        width: FetchPixels.width,
        child: Column(
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: FetchPixels.width/2,
                  alignment: Alignment.centerLeft,
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
                ),
                InkWell(
                  onTap: ()async{
                    UserController userController = Get.find<UserController>();
                    if(userController.isOnline.value == true){
                      getReceivablePrice();
                    }else{
                      showToast(context, "");
                    }
                  },
                  child: Container(
                      margin: EdgeInsets.only(right: FetchPixels.getPixelWidth(10)),
                      width: FetchPixels.getPixelWidth(80),height: FetchPixels.getPixelHeight(40),
                      decoration: BoxDecoration(
                        color: themeColor,
                      ),
                      child: Center(
                        child:    textWidget(text: "Update", fontSize: FetchPixels.getPixelHeight(11), fontWeight: FontWeight.w500,textColor: Colors.white),
                      )
                  ),
                ),
              ],
            ),
            SizedBox(height: FetchPixels.getPixelHeight(40),),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.center,
                    width: FetchPixels.width/2,
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Color(0xffFFA799),
                        borderRadius: BorderRadius.circular(7)),
                    child:  Column(
                      children: [
                        Text(
                          "Today",
                          style: TextStyle(color: blackBrown,fontSize: FetchPixels.getPixelHeight(17),fontWeight: FontWeight.w600),
                        ),
                        Row(
                          children: [Text(
                            "Receivable : ${todayReceivable}",
                            style: TextStyle(color: blackBrown,fontSize: FetchPixels.getPixelHeight(11),fontWeight: FontWeight.w600),
                          ),
                          ],
                        ),
                        Row(
                          children: [Text(
                            "Recovery    : ${todayRecovery}",
                            style: TextStyle(color: blackBrown,fontSize: FetchPixels.getPixelHeight(11),fontWeight: FontWeight.w600),
                          ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.center,
                    width: FetchPixels.width/2,
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(7)),
                    child:  Column(
                      children: [
                        Text(
                          "This Week",
                          style: TextStyle(color: blackBrown,fontSize: FetchPixels.getPixelHeight(17),fontWeight: FontWeight.w600),
                        ),
                        Row(
                          children: [Text(
                            "Receivable : ${thisWeekReceivable}",
                            style: TextStyle(color: blackBrown,fontSize: FetchPixels.getPixelHeight(11),fontWeight: FontWeight.w600),
                          ),
                          ],
                        ),
                        Row(
                          children: [Text(
                            "Recovery    : ${thisWeekRecovery}",
                            style: TextStyle(color: blackBrown,fontSize: FetchPixels.getPixelHeight(11),fontWeight: FontWeight.w600),
                          ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.center,
                    width: FetchPixels.width/2,
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(7)),
                    child:  Column(
                      children: [
                        Text(
                          "This Month",
                          style: TextStyle(color: blackBrown,fontSize: FetchPixels.getPixelHeight(17),fontWeight: FontWeight.w600),
                        ),
                        Row(
                          children: [Text(
                            "Receivable : ${thisMonthReceivable}",
                            style: TextStyle(color: blackBrown,fontSize: FetchPixels.getPixelHeight(11),fontWeight: FontWeight.w600),
                          ),
                          ],
                        ),
                        Row(
                          children: [Text(
                            "Recovery    : ${thisMonthRecovery}",
                            style: TextStyle(color: blackBrown,fontSize: FetchPixels.getPixelHeight(11),fontWeight: FontWeight.w600),
                          ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.center,
                    width: FetchPixels.width/2,
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.deepPurple.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(7)),
                    child:  Column(
                      children: [
                        Text(
                          "This Year",
                          style: TextStyle(color: blackBrown,fontSize: FetchPixels.getPixelHeight(17),fontWeight: FontWeight.w600),
                        ),
                        Row(
                          children: [Text(
                            "Receivable : ${thisYearReceivable}",
                            style: TextStyle(color: blackBrown,fontSize: FetchPixels.getPixelHeight(11),fontWeight: FontWeight.w600),
                          ),
                          ],
                        ),
                        Row(
                          children: [Text(
                            "Recovery    : ${thisYearRecovery}",
                            style: TextStyle(color: blackBrown,fontSize: FetchPixels.getPixelHeight(11),fontWeight: FontWeight.w600),
                          ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: FetchPixels.getPixelHeight(20),),
            InkWell(
              onTap: (){
                Get.to(DistributionWiseList(year: typeValue1, distributor: distributors,));
              },
              child: Container(
                height: FetchPixels.getPixelHeight(50),
                width: FetchPixels.width/1.7,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(5)
                ),
                child: Center(
                  child: Text(
                    "Receivable Balance",
                    style: TextStyle(color: blackBrown,fontSize: FetchPixels.getPixelHeight(17),fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            SizedBox(height: FetchPixels.getPixelHeight(30),),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: FetchPixels.getPixelWidth(20)),
                      child: Text(
                        "From Date",
                        style: TextStyle(color: blackBrown,fontSize: FetchPixels.getPixelHeight(14),fontWeight: FontWeight.w500),
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
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: FetchPixels.getPixelWidth(20)),
                      child: Text(
                        "To Date",
                        style: TextStyle(color: blackBrown,fontSize: FetchPixels.getPixelHeight(14),fontWeight: FontWeight.w500),
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
              ],
            ),
            SizedBox(height: FetchPixels.getPixelHeight(30),),
            InkWell(
              onTap: (){

                DistributionController distributionController = Get.find<DistributionController>();

                DateTime fromInputDate = DateFormat("dd-MM-yyyy").parse(fromDateCtr.text);
                String s = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(fromInputDate);

                DateTime eInputDate = DateFormat("dd-MM-yyyy").parse(toDateCtr.text);
                String e = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(eInputDate);


                Map<String,dynamic> data = {
                  "startDate": s,
                  "endDate": e,
                  "distributors": distributionController.distributorIdList
                };
                UserController userController = Get.find<UserController>();

                if(userController.isOnline.value == true){
                  getReceivableInvoices(data,0);
                }else{
                  showToast(context, "");
                }
               },
              child: Container(
                height: FetchPixels.getPixelHeight(50),
                width: FetchPixels.width/1.7,
                decoration: BoxDecoration(
                  color: Colors.brown.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(5)
                ),
                child: Center(
                  child: Text(
                    "Receivable Invoices",
                    style: TextStyle(color: blackBrown,fontSize: FetchPixels.getPixelHeight(17),fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            SizedBox(height: FetchPixels.getPixelHeight(20),),
            InkWell(
              onTap: (){
                DistributionController distributionController = Get.find<DistributionController>();

                DateTime fromInputDate = DateFormat("dd-MM-yyyy").parse(fromDateCtr.text);
                String s = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(fromInputDate);

                DateTime eInputDate = DateFormat("dd-MM-yyyy").parse(toDateCtr.text);
                String e = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(eInputDate);


                Map<String,dynamic> data = {
                  "startDate": s,
                  "endDate": e,
                  "distributors": distributionController.distributorIdList
                };

                UserController userController = Get.find<UserController>();

                if(userController.isOnline.value == true){

                  getReceivableInvoices(data,1);
                }
                else{
                  showToast(context, "");
                }
               },
              child: Container(
                height: FetchPixels.getPixelHeight(50),
                width: FetchPixels.width/1.7,
                decoration: BoxDecoration(
                  color: Colors.deepOrange.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(5)
                ),
                child: Center(
                  child: Text(
                    "Recovered Invoices",
                    style: TextStyle(color: blackBrown,fontSize: FetchPixels.getPixelHeight(17),fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getReceivablePrice()async{

    Get.dialog(Center(child: CircularProgressIndicator(color: themeColor,),));
    DistributionController distributionController = Get.find<DistributionController>();
    DateTime currentDate = DateTime.now();
    int selectedYear = int.tryParse(typeValue1) ?? currentDate.year;
    DateTime customDate = DateTime(selectedYear, currentDate.month, currentDate.day, currentDate.hour, currentDate.minute, currentDate.second, currentDate.millisecond);
    String formattedDate = customDate.toUtc().toIso8601String();

    Map<String,dynamic> data = {
      "date": formattedDate,
      "distributors": distributionController.distributorIdList
    };

    log('>>> ${data}');

    ReceivableModel receivableModel = await distributionController.receivableReportApis(data);
    todayReceivable = distributionController.formatNumberWithCommas(receivableModel.today!.reciveable.toString()) ?? "";
    todayRecovery = distributionController.formatNumberWithCommas(receivableModel.today!.recovery.toString()) ?? "";
    thisWeekReceivable = distributionController.formatNumberWithCommas(receivableModel.thisWeek!.reciveable.toString()) ?? "";
    thisWeekRecovery = distributionController.formatNumberWithCommas(receivableModel.thisWeek!.recovery.toString()) ?? "";
    thisMonthReceivable = distributionController.formatNumberWithCommas(receivableModel.thisMonth!.reciveable.toString()) ?? "";
    thisMonthRecovery = distributionController.formatNumberWithCommas(receivableModel.thisMonth!.recovery.toString()) ?? "";
    thisYearReceivable = distributionController.formatNumberWithCommas(receivableModel.thisYear!.reciveable.toString()) ?? "";
    thisYearRecovery = distributionController.formatNumberWithCommas(receivableModel.thisYear!.recovery.toString()) ?? "";
    distributors.clear();
    distributors.addAll(receivableModel.distributor!);
    
    Get.back();

    setState(() {

    });

  }




  void getReceivableInvoices(Map<String,dynamic> data,int value)async{
    Get.dialog(Center(child: CircularProgressIndicator(color: themeColor,),));
    DistributionController distributionController = Get.find<DistributionController>();
    ReceivableInvoicesModel receivableInvoicesModelData = await distributionController.receivableInvoicesApis(data);

    Get.back();
    Get.to(ReceivableInvoicesScreen(receivableInvoicesModel: receivableInvoicesModelData, from: fromDateCtr.text, to: toDateCtr.text,value: value));
  }


}
