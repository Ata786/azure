import 'package:SalesUp/controllers/UserController.dart';
import 'package:SalesUp/data/postApis.dart';
import 'package:SalesUp/res/base/fetch_pixels.dart';
import 'package:SalesUp/res/fieldvalidation.dart';
import 'package:SalesUp/utils/routes/routePath.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../res/colors.dart';
import '../utils/widgets/appWidgets.dart';

class SignIn extends StatelessWidget {
  SignIn({super.key});

  TextEditingController nameCtr = TextEditingController();
  TextEditingController passCtr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    UserController userController = Get.find<UserController>();
    FetchPixels(context);
    return SafeArea(
      child: Scaffold(
          body: Container(
              height: FetchPixels.height,
              width: FetchPixels.width,
              color: themeColor,
              child: Container(
                height: FetchPixels.height,
                width: FetchPixels.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(FetchPixels.getPixelHeight(10))),
                padding: EdgeInsets.symmetric(
                    horizontal: FetchPixels.getPixelWidth(20),
                    vertical: FetchPixels.getPixelHeight(20)),
                margin: EdgeInsets.symmetric(
                    horizontal: FetchPixels.getPixelWidth(30),
                    vertical: FetchPixels.getPixelHeight(40)),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: FetchPixels.getPixelHeight(50),),
                      textWidget(
                        textColor: Colors.red,
                        text: "SUFI",
                        fontSize: FetchPixels.getPixelHeight(30),
                        fontWeight: FontWeight.bold,),
                      // Obx(() => userController.officeCode != null ? Image.network("http://125.209.79.107:7700/api${userController.officeCode!.value.image}") : textWidget(
                      //   textColor: Colors.red,
                      //   text: "SUFI",
                      //   fontSize: FetchPixels.getPixelHeight(35),
                      //   fontWeight: FontWeight.bold,),),
                      SizedBox(height: FetchPixels.getPixelHeight(50),),
                      textWidget(
                        textColor: primaryColor,
                        text: "Welcome back!",
                        fontSize: FetchPixels.getPixelHeight(15),
                        fontWeight: FontWeight.w600,),
                      textWidget(
                        textColor: primaryColor,
                        text: "Sign in to your account",
                        fontSize: FetchPixels.getPixelHeight(15),
                        fontWeight: FontWeight.w400,),
                      SizedBox(height: FetchPixels.getPixelHeight(20),),
                      textField(
                        validator: (value)=> FieldValidator.validateEmail(value!),
                          controller: nameCtr,
                          hintText: "User Name"),
                      SizedBox(height: FetchPixels.getPixelHeight(7),),
                      textField(
                        validator: (value)=> FieldValidator.validateEmpty(value!),
                          controller: passCtr,
                          helperText: '',
                          suffix: true,
                          hintText: "Password"),
                      InkWell(
                        onTap: ()async{
                          var box1 = await Hive.openBox("syncDownList");
                          var box2 = await Hive.openBox("weekPerformance");
                          var box3 = await Hive.openBox("monthPerformance");
                          var box4 = await Hive.openBox("reasonNo");
                          var box5 = await Hive.openBox("productsBox");
                          var box6 = await Hive.openBox("reasonsName");
                          var box7 = await Hive.openBox("category");
                          var box8 = await Hive.openBox("product");
                          var box9 = await Hive.openBox("orderBox");
                          var box10 = await Hive.openBox("attendance");
                          box1.delete("syncDown");
                          box2.delete("week");
                          box3.delete("month");
                          box4.delete("reason");
                          box5.delete("products");
                          box6.delete("reason");
                          box7.delete("categoryName");
                          box8.delete("productRate");
                          box9.delete("order");
                          box10.delete("markAttendance");
                          signInApi(nameCtr.text, passCtr.text,context);
                        },
                        child: button(
                            height: FetchPixels.getPixelHeight(35), width: FetchPixels.width/4.5, color: themeColor,
                            textColor: Colors.white, textSize: FetchPixels.getPixelHeight(15),
                            borderRadius: 100,
                            textWeight: FontWeight.w600,
                            text: "Sign In"),
                      ),
                      SizedBox(height: FetchPixels.getPixelHeight(40),),
                      textWidget(
                          text: "Privacy",
                          underline: TextDecoration.underline,
                          fontSize: FetchPixels.getPixelHeight(15),
                          fontWeight: FontWeight.bold,
                          textColor: Colors.black),
                      SizedBox(height: FetchPixels.getPixelHeight(200),),
                      textWidget(
                        textColor: themeColor,
                        text: "SalesUp",
                        fontSize: FetchPixels.getPixelHeight(15),
                        fontWeight: FontWeight.bold,),
                    ],
                  ),
                ),
              ))),
    );
  }
}
