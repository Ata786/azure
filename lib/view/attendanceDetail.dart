import 'dart:developer';

import 'package:SalesUp/model/attendanceDetailModel.dart';
import 'package:SalesUp/model/attendanceLocation.dart';
import 'package:SalesUp/res/base/fetch_pixels.dart';
import 'package:SalesUp/res/colors.dart';
import 'package:SalesUp/utils/widgets/appWidgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AttendanceDetail extends StatelessWidget {
  String personName = '';
  bool late;
  List<AttendanceDetailsModel> attendanceDetailList = [];
   AttendanceDetail(this.attendanceDetailList,this.personName, {required this.late,super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
        title: textWidget(text: "Attendance Detail", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w600,textColor: Colors.white),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(10)),
        height: FetchPixels.height,
        width: FetchPixels.width,
        child: Column(
          children: [
            SizedBox(height: FetchPixels.getPixelHeight(20),),
            Expanded(
              child: ListView.builder(
                  itemCount: attendanceDetailList.length,
                  itemBuilder: (context,index){
                return Column(
                  children: [
                    Row(
                      children: [
                        textWidget(text: "Person Name:- ", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w600,textColor: Colors.black),
                        textWidget(text: "${attendanceDetailList[index].fullName}", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w500,textColor: Colors.black)
                      ],
                    ),
                    SizedBox(height: FetchPixels.getPixelHeight(20),),
                    Row(
                      children: [
                        Expanded(flex: 2,child: Center(child: textWidget(text: "Date", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w600,textColor: Colors.black))),
                        Expanded(flex: 2,child: Center(child: textWidget(text: "In-Time", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w600,textColor: Colors.black))),
                        Expanded(flex: 2,child: Center(child: textWidget(text: "Out-Time", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w600,textColor: Colors.black))),
                        Expanded(flex: 1,child: Center(child: textWidget(maxLines: 2,text: "Distance", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w600,textColor: Colors.black))),
                        Expanded(flex: 2,child: Center(child: textWidget(text: "Status", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w600,textColor: Colors.black))),
                      ],
                    ),
                    SizedBox(height: FetchPixels.getPixelHeight(10),),
                    Column(
                      children: List.generate(attendanceDetailList[index].attendance!.length, (i) =>
                      Padding(
                        padding: EdgeInsets.only(top: FetchPixels.getPixelHeight(10)),
                        child: Row(
                          children: [
                            Expanded(flex: 2,child: Center(child: InkWell(
                                onTap: (){
                                },
                                child: textWidget(textAlign: TextAlign.center,maxLines: 2,text: attendanceDetailList[index].attendance![i].checkInTime != null ? "${DateFormat('dd-MM-yyyy').format(DateTime.parse(attendanceDetailList[index].attendance![i].checkInTime.toString()))}" : "", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w500,textColor: Colors.black)))),
                            Expanded(flex: 2,child: Center(child: InkWell(
                                onTap: (){
                                  Get.to(AttendanceLocation(double.tryParse(attendanceDetailList[index].attendance![i].checkInLatitude.toString()) ?? 0.0, double.tryParse(attendanceDetailList[index].attendance![i].checkOutLongitude.toString()) ?? 0.0));
                                },
                                child: textWidget(textAlign: TextAlign.center,maxLines: 2,text: attendanceDetailList[index].attendance![i].checkInTime != null ? "${DateFormat('HH:mm').format(DateTime.parse(attendanceDetailList[index].attendance![i].checkInTime.toString()))}" : "", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w500,textColor: Colors.black)))),
                            Expanded(flex: 2,child: Center(child: InkWell(
                                onTap: (){
                                  Get.to(AttendanceLocation(double.tryParse(attendanceDetailList[index].attendance![i].checkOutLatitude.toString()) ?? 0.0, double.tryParse(attendanceDetailList[index].attendance![i].checkOutLongitude.toString()) ?? 0.0));
                                },
                                child: textWidget(textAlign: TextAlign.center,maxLines: 2,text: attendanceDetailList[index].attendance![i].checkOutTime != null ? "${DateFormat('HH:mm').format(DateTime.parse(attendanceDetailList[index].attendance![i].checkOutTime.toString()))}" : "", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w500,textColor: Colors.black)))),
                            Expanded(flex: 1,child: Center(child: textWidget(text: "${attendanceDetailList[index].attendance![i].checkIn.toString()}", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w500,textColor: Colors.black))),
                            Expanded(flex: 2,child: Center(child: textWidget(textAlign: TextAlign.center,maxLines: 2,text: isLate(attendanceDetailList[index].attendance![i]) == true ? "On-Time" : "Late", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w500,textColor: isLate(attendanceDetailList[index].attendance![i]) == true ? Colors.green : Colors.red))),
                          ],
                        ),
                      )),
                    ),
                    SizedBox(height: FetchPixels.getPixelHeight(10),),
                    Container(
                      height: 1,
                      width: FetchPixels.width,
                      color: Colors.black,
                    ),
                    SizedBox(height: FetchPixels.getPixelHeight(20),),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  bool isLate(Attendance attendanceDetail) {
    DateTime checkInTime = DateTime.parse(attendanceDetail.checkInTime!);
    DateTime lateTime = DateTime.parse(attendanceDetail.late ?? "0000-00-00T00:00:00");

    if (lateTime.isBefore(checkInTime)) {
      log('>>>> 0');
      return true;
    } else if (lateTime.isAfter(checkInTime)) {
      log('>>>> 1');
      return false;
    }  else if(lateTime.isAtSameMomentAs(checkInTime)){
      log('>>>> 2');
      return true;
    } else {
      log('>>>> 3');
      return true;
    }
  }

}


class AttendanceLate extends StatelessWidget {
  const AttendanceLate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
        title: textWidget(text: "Late Arrival", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w600,textColor: Colors.white),
      ),
    );
  }
}
