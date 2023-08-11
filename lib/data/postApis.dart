import 'dart:convert';
import 'package:azure/data/getApis.dart';
import 'package:azure/data/sharedPreference.dart';
import 'package:azure/model/attendenceModel.dart';
import 'package:azure/res/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

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
      Get.back();
      Map<String,dynamic> dataMap = jsonDecode(res.body);
      dataMap.putIfAbsent("isLogin", () => true);
      setUserDataSp(jsonEncode(dataMap));
      getLocation(context).then((value) {
        userController.latitude = value!.latitude ?? 0.0;
        userController.longitude = value.longitude ?? 0.0;
        UserModel userModel = UserModel.fromJson(dataMap);
        userController.user = userModel.obs;
        Get.toNamed(HOME);
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
  try{
    var res = await http.post(Uri.parse("$BASE_URL/Attendance"),
        body: jsonEncode({"userId": userId,"latitude": latitude,"longitude": longitude})
    );

    if(res.statusCode == 200){
      print('>>> ${res.body}');
      // Map<String,dynamic> body = jsonDecode(res.body);
      // userController.attendanceModel = AttendenceModel.fromJson(body).obs;
    }else{
      print('>>> error ${res.body}');
    }
  }catch(exception){
    print('>>> exception ${exception.toString()}');
  }
}