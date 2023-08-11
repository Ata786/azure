import 'dart:async';
import 'dart:convert';

import 'package:azure/controllers/UserController.dart';
import 'package:azure/data/postApis.dart';
import 'package:azure/data/sharedPreference.dart';
import 'package:azure/model/officeCodeModel.dart';
import 'package:azure/model/userModel.dart';
import 'package:azure/res/base/fetch_pixels.dart';
import 'package:azure/utils/routes/routePath.dart';
import 'package:azure/utils/userCurrentLocation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      checkUser();
    });
  }

  void checkUser()async{

    UserController userController = Get.find<UserController>();

    String? officeCode = await getOfficeCode("officeCode");

    if(officeCode != null){
      Map<String,dynamic> officeData = jsonDecode(officeCode);
     OfficeCodeModel officeCodeModel = OfficeCodeModel.fromJson(officeData);
     userController.officeCode = officeCodeModel.obs;
     if(officeCodeModel.isCode == false){
       Get.toNamed(OFFICE_CODE_SCREEN);
     }else{
       String? user = await getUserDataSp('user');
       if(user != null){
         getLocation(context).then((value) {
           userController.latitude = value!.latitude;
           userController.longitude = value.longitude;

           Map<String,dynamic> userMap = jsonDecode(user);
           UserModel userModel = UserModel.fromJson(userMap);
           userController.user = userModel.obs;
           if(userModel.isLogin == true){
             Get.toNamed(HOME);
           }else{
             Get.toNamed(SIGN_IN_SCREEN);
           }

         });
       }else{
         Get.toNamed(SIGN_IN_SCREEN);
       }
      }

    }else{
      Get.toNamed(OFFICE_CODE_SCREEN);
    }

  }

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return Scaffold(
      body: Container(height: FetchPixels.height,width: FetchPixels.width,child: Center(child: Text("SUFI",style: TextStyle(fontWeight: FontWeight.bold,fontSize: FetchPixels.getPixelHeight(50),color: Colors.red),)),),
    );
  }
}
