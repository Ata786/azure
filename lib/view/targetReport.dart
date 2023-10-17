import 'package:SalesUp/res/base/fetch_pixels.dart';
import 'package:SalesUp/res/colors.dart';
import 'package:SalesUp/utils/widgets/appWidgets.dart';
import 'package:SalesUp/view/distributerScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  String selectedMonth = "January";

  int selectedYear = DateTime.now().year;

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
            SizedBox(height: 50),
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
            SizedBox(height: FetchPixels.getPixelHeight(40),),
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
                      child:  Text(
                        "Target Achivement",
                        style: TextStyle(color: blackBrown,fontSize: FetchPixels.getPixelHeight(17),fontWeight: FontWeight.w600),
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
}
