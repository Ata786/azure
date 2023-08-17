import 'package:SalesUp/res/base/fetch_pixels.dart';
import 'package:SalesUp/res/colors.dart';
import 'package:SalesUp/res/images.dart';
import 'package:SalesUp/utils/widgets/appWidgets.dart';
import 'package:flutter/material.dart';
import '../data/postApis.dart';

class OfficeCode extends StatelessWidget {
  OfficeCode({super.key});

  TextEditingController officeCodeCtr = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: FetchPixels.getPixelHeight(20),
                  ),
                  Center(
                      child: Image.asset(
                    logo,
                    height: FetchPixels.getPixelHeight(100),
                    width: FetchPixels.getPixelWidth(100),
                  )),
                  SizedBox(
                    height: FetchPixels.getPixelHeight(10),
                  ),
                  textWidget(
                      text: "Hi there",
                      fontSize: FetchPixels.getPixelHeight(20),
                      fontWeight: FontWeight.w600),
                  SizedBox(
                    height: FetchPixels.getPixelHeight(10),
                  ),
                  textWidget(
                      text: "Welcome to salesup.",
                      fontSize: FetchPixels.getPixelHeight(15),
                      fontWeight: FontWeight.w400),
                  textWidget(
                      text:
                          "Please provide the company code provided by your administrator.",
                      fontSize: FetchPixels.getPixelHeight(15),
                      fontWeight: FontWeight.w400),
                  SizedBox(
                    height: FetchPixels.getPixelHeight(20),
                  ),
                  textField(
                      controller: officeCodeCtr,
                      helperText: '',
                      hintText: "Enter Code"),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: (){
                        officeCodeApis(officeCodeCtr.text);
                      },
                      child: textWidget(
                          text: "Next",
                          underline: TextDecoration.underline,
                          fontSize: FetchPixels.getPixelHeight(15),
                          fontWeight: FontWeight.bold,
                          textColor: themeColor),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
