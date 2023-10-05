import 'dart:convert';
import 'dart:developer';
import 'package:SalesUp/controllers/distributionController.dart';
import 'package:SalesUp/data/getApis.dart';
import 'package:SalesUp/data/hiveDb.dart';
import 'package:SalesUp/data/sharedPreference.dart';
import 'package:SalesUp/model/attendenceModel.dart';
import 'package:SalesUp/model/financialYearModel.dart';
import 'package:SalesUp/res/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../controllers/UserController.dart';
import '../model/distributionModel.dart';
import '../model/userModel.dart';
import '../utils/routes/routePath.dart';
import '../utils/userCurrentLocation.dart';

void officeCodeApis(String data)async{
  Get.dialog(Center(child: CircularProgressIndicator(color: themeColor,),));
  try{
    var res = await http.post(
        Uri.parse("${BASE_URL}/Company"),
        body: {"CompanyCode": data}
    );

    if(res.statusCode == 200){
      Get.back();
      Map<String,dynamic> codeMap = jsonDecode(res.body);
      codeMap.putIfAbsent("isCode", () => true);
      setOfficeCode(jsonEncode(codeMap));
      Get.toNamed(SIGN_IN_SCREEN);
    }else{
      print(">> error ${res.body}");
    }
  }catch(exception){
    print('>>> ${exception.toString()}');
  }

}



// signin api
void signInApi(String email,String password,BuildContext context)async{
  Get.dialog(
    Center(child: CircularProgressIndicator(color: themeColor),)
  );
  UserController userController = Get.find<UserController>();
  try{
    var res = await http.post(
        Uri.parse("${BASE_URL}/User"),
        body: {"Email": email,"Password": password}
    );

    if(res.statusCode == 200){
      log(">> signin ${res.body}");
      Get.back();
      Map<String,dynamic> dataMap = jsonDecode(res.body);
      dataMap.putIfAbsent("isLogin", () => true);
      setUserDataSp(jsonEncode(dataMap));
      UserModel userModel = UserModel.fromJson(dataMap);
      userController.user = userModel.obs;
      Position? location = await getLocation(context);
      if(location != null){
        userController.latitude = location.latitude;
        userController.longitude = location.longitude;
      }
      await financialYearApi();
      await distributorList();

    }else{
      print(">> error ${res.body}");
    }
  }catch(exception){
    print('>>> ${exception.toString()}');
  }

}



Future<void> distributorList()async{

  UserController userController = Get.find<UserController>();

  try{
    log('>>> id ${userController.user!.value.id}');
    var res = await http.get(Uri.parse("$BASE_URL/AssignedDistributors/${userController.user!.value.id}"));

    log('>>>> response ${res.statusCode} and ${res.body}');

    if(res.statusCode == 200){

      Get.put(DistributionController());
      DistributionController distributionController = Get.find<DistributionController>();
      List<dynamic> map = jsonDecode(res.body);
      List<DistributionModel> distributionList = map.map((e) => DistributionModel.fromJson(e)).toList();
      HiveDatabase.setDistributionList("distribution", "distributionBox", distributionList);
      List<DistributionModel> list = await HiveDatabase.getDistributionList("distribution", "distributionBox");
      distributionController.distributionList.value = list;
    }else{
      log('>>>> error ${res.body}');
    }

    getAttendanceData(userController.user!.value.id!,DateFormat('dd MMM yyyy hh:mm a').format(DateTime.now()));

  }catch(e){
    log('Exception >>>> ${e.toString()}');
  }

}



Future<void> getAttendanceData(String userId,String dateTime) async {
  UserController userController = Get.find<UserController>();
  try{

    final url = Uri.parse('http://125.209.79.107:7700/api/Attendance/${userId}/${dateTime}');
    final response = await http.get(url);
    log('>>>> attendance ${response.statusCode} and ${response.body}');
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      log('>>>> date ${jsonData}');
      CheckIn checkInParse = CheckIn.fromJson(jsonData);
      CheckIn checkIn = CheckIn(latitude: double.parse(checkInParse.latitude.toString()),longitude: double.parse(checkInParse.longitude.toString()),attendanceDateTime: DateFormat('dd MMM yyyy hh:mm a').format(DateTime.parse(checkInParse.attendanceDateTime!)),id: checkInParse.id,userId: checkInParse.userId,outLongitude: double.parse(checkInParse.outLongitude.toString()),outLatitude: double.parse(checkInParse.outLatitude.toString()),outAttendanceDateTime: checkInParse.outAttendanceDateTime);
      log('>>>> checkIn ${checkIn.toJson()}');
      HiveDatabase.setCheckInAttendance("checkInAttendance", "checkIn", checkIn);
      CheckIn check = await HiveDatabase.getCheckInAttendance("checkInAttendance", "checkIn");
      userController.checkIn.value = check;

      CheckOut checkOut = CheckOut.fromJson(jsonData);
      CheckOut checkOutData = CheckOut(userId: "",outLatitude: checkOut.outLatitude,outLongitude: checkOut.outLongitude,outAttendanceDateTime:DateFormat('dd MMM yyyy hh:mm a').format(DateTime.parse(checkOut.outAttendanceDateTime!)));
      await HiveDatabase.setCheckOutAttendance("checkOutAttendance", "checkOut", checkOutData);
      CheckOut checkOutHive = await HiveDatabase.getCheckOutAttendance("checkOutAttendance", "checkOut");
      userController.checkOut.value = checkOutHive;

      log('>>>> checkIn ${userController.checkIn.value.toJson()}');
      Get.offAllNamed(HOME);
    }else if(response.statusCode == 204){
      Get.offAllNamed(HOME);
    } else if(response.statusCode == 404) {
      Get.offAllNamed(HOME);
    }else{
      log('>>>> error is ${response.statusCode} and ${response.body}');
    }

  }catch(e){
    throw Exception(
        'Failed to fetch attendance data. Error:${e.toString()}');
  }

}


Future<void> financialYearApi()async{

  try{

    final url = Uri.parse('http://125.209.79.107:7700/api/FinancialYear');
    final response = await http.get(url);
    log('>>>> Financial Year ${response.statusCode} and ${response.body}');
    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      List<FinancialYearModel> financialYearList = jsonData.map((e) => FinancialYearModel.fromJson(e)).toList();
      HiveDatabase.setFinancialYearList("financialYear", "financialYearBox", financialYearList);
    }else{
      log('>>>> error is ${response.statusCode} and ${response.body}');
    }

  }catch(e){
    throw Exception(
        'Failed to fetch attendance data. Error:${e.toString()}');
  }

}


String changeDateFormat(String date){
  DateTime dateTime = DateTime.parse(date);
  String formattedDate = DateFormat('dd MMM yyyy hh:mm a').format(dateTime);
  return formattedDate;
}