import 'dart:convert';
import 'dart:developer';
import 'package:SalesUp/data/getApis.dart';
import 'package:SalesUp/data/sharedPreference.dart';
import 'package:SalesUp/model/attendenceModel.dart';
import 'package:SalesUp/res/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../controllers/UserController.dart';
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
      log(">> error ${res.body}");
      Get.back();
      Map<String,dynamic> dataMap = jsonDecode(res.body);
      dataMap.putIfAbsent("isLogin", () => true);
      setUserDataSp(jsonEncode(dataMap));
      getLocation(context).then((value) async{
        userController.latitude = value!.latitude ?? 0.0;
        userController.longitude = value.longitude ?? 0.0;
        UserModel userModel = UserModel.fromJson(dataMap);
        userController.user = userModel.obs;
        var box = await Hive.openBox("attendance");
        box.put("markAttendance", userModel.attendance);
        Get.offAllNamed(HOME);
      });
    }else{
      print(">> error ${res.body}");
    }
  }catch(exception){
    print('>>> ${exception.toString()}');
  }

}


void setAttendence({required double latitude,required double longitude,required String userId})async{
  UserController userController = Get.find<UserController>();
  // try{
    var res = await http.post(Uri.parse("$BASE_URL/Attendance"),
        body: jsonEncode({"userId": userId,"latitude": latitude,"longitude": longitude})
    );
    //
    // if(res.statusCode == 200){
    //   print('>>> ${res.body}');
    //   // Map<String,dynamic> body = jsonDecode(res.body);
    //   // userController.attendanceModel = AttendenceModel.fromJson(body).obs;
    // }else{
    //   print('>>> error ${res.body}');
    // }
  // }catch(exception){
  //   print('>>> exception ${exception.toString()}');
  // }
}


String changeDateFormat(String date){
  DateTime dateTime = DateTime.parse(date);
  String formattedDate = DateFormat('dd MMM yyyy hh:mm a').format(dateTime);
  return formattedDate;
}