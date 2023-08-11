import 'package:azure/controllers/UserController.dart';
import 'package:azure/data/postApis.dart';
import 'package:azure/res/base/fetch_pixels.dart';
import 'package:azure/res/fieldvalidation.dart';
import 'package:azure/utils/routes/routePath.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
                        fontSize: FetchPixels.getPixelHeight(35),
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
                        onTap: (){
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
