import 'dart:developer';

import 'package:SalesUp/res/base/fetch_pixels.dart';
import 'package:SalesUp/res/colors.dart';
import 'package:SalesUp/utils/widgets/appWidgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AttendanceReportScreen extends StatefulWidget {
  AttendanceReportScreen({super.key});

  @override
  State<AttendanceReportScreen> createState() => _AttendanceReportScreenState();
}

class _AttendanceReportScreenState extends State<AttendanceReportScreen> {
  List<String> typeDropDown = ["Select Person"];

  String typeValue = "Select Person";
  TextEditingController fromDateCtr = TextEditingController();
  TextEditingController toDateCtr = TextEditingController();
  DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
        title:  textWidget(text: "Attendance Report", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w600,textColor: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
        child: Column(
          children: [
            SizedBox(height: FetchPixels.getPixelHeight(20),),
            TextField(
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
            SizedBox(height: FetchPixels.getPixelHeight(20),),
            TextField(
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
            ),
            SizedBox(height: FetchPixels.getPixelHeight(20),),
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
                    child: Text(
                      "Late Arrival",
                      style: TextStyle(color: blackBrown,fontSize: FetchPixels.getPixelHeight(17),fontWeight: FontWeight.w600),
                    ),
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
                    child: Text(
                      "List",
                      style: TextStyle(color: blackBrown,fontSize: FetchPixels.getPixelHeight(17),fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: FetchPixels.getPixelHeight(10),),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(10)),
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                value: typeValue,
                onChanged: (newValue) {
                  setState(() {
                    typeValue = newValue!;
                  });
                },
                items: typeDropDown.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value ?? ""),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: FetchPixels.getPixelHeight(20),),
            Container(
              alignment: Alignment.center,
              height: FetchPixels.height / 13,
              width: FetchPixels.width/2,
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Color(0xfff7d8ba),
                  borderRadius: BorderRadius.circular(7)),
              child: Text(
                "Detail",
                style: TextStyle(color: blackBrown,fontSize: FetchPixels.getPixelHeight(17),fontWeight: FontWeight.w600),
              ),
            )
          ],
        ),
      ),
    );
  }
}
