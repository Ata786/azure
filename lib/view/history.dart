import 'package:SalesUp/data/getApis.dart';
import 'package:SalesUp/model/historyModel.dart';
import 'package:SalesUp/res/base/fetch_pixels.dart';
import 'package:SalesUp/res/colors.dart';
import 'package:SalesUp/utils/widgets/appWidgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShopHistory extends StatefulWidget {
  ShopHistory({super.key});

  @override
  State<ShopHistory> createState() => _ShopHistoryState();
}

class _ShopHistoryState extends State<ShopHistory> {

  @override
  Widget build(BuildContext context) {
    Map<String,dynamic> argument = Get.arguments as Map<String,dynamic>;
    int sr = argument['sr'];
    FetchPixels(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: textWidget(text: "Shop History Detail", fontSize: FetchPixels.getPixelHeight(16), fontWeight: FontWeight.w600,textColor: Colors.white),
      ),
      body: Container(
        height: FetchPixels.height,
        width: FetchPixels.width,
        child: Column(
          children: [
            // Container(
            //   height: FetchPixels.getPixelHeight(50),
            //   width: FetchPixels.width,
            //   color: themeColor,
            //   padding: EdgeInsets.only(left: FetchPixels.getPixelWidth(30)),
            //   child: Align(
            //       alignment: Alignment.centerLeft,
            //       child: textWidget(text: argument['shopName'] ?? '', fontSize: FetchPixels.getPixelHeight(16), fontWeight: FontWeight.w600,textColor: Colors.white)),
            // ),
            Expanded(
                child: ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context,index){
                      return Container(
                        height: FetchPixels.getPixelHeight(250),
                        width: FetchPixels.width,
                        padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        textWidget(text: "Date", fontSize: FetchPixels.getPixelHeight(16), fontWeight: FontWeight.w600,textColor: Colors.black),
                                        SizedBox(height: FetchPixels.getPixelHeight(10),),
                                        textWidget(text: "01/01/2023", fontSize: FetchPixels.getPixelHeight(16), fontWeight: FontWeight.w400,textColor: Colors.black),
                                        SizedBox(height: FetchPixels.getPixelHeight(10),),
                                        textWidget(text: "01/01/2023", fontSize: FetchPixels.getPixelHeight(16), fontWeight: FontWeight.w400,textColor: Colors.black),
                                        SizedBox(height: FetchPixels.getPixelHeight(20),),
                                        textWidget(text: "01/01/2023", fontSize: FetchPixels.getPixelHeight(16), fontWeight: FontWeight.w400,textColor: Colors.black),
                                        SizedBox(height: FetchPixels.getPixelHeight(20),),
                                        textWidget(text: "01/01/2023", fontSize: FetchPixels.getPixelHeight(16), fontWeight: FontWeight.w400,textColor: Colors.black),
                                        SizedBox(height: FetchPixels.getPixelHeight(10),),
                                        textWidget(text: "01/01/2023", fontSize: FetchPixels.getPixelHeight(16), fontWeight: FontWeight.w400,textColor: Colors.black),
                                        SizedBox(height: FetchPixels.getPixelHeight(10),),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        textWidget(text: "Visit Status", fontSize: FetchPixels.getPixelHeight(16), fontWeight: FontWeight.w600,textColor: Colors.black),
                                        SizedBox(height: FetchPixels.getPixelHeight(10),),
                                        textWidget(text: "Net Visit", fontSize: FetchPixels.getPixelHeight(16), fontWeight: FontWeight.w400,textColor: Colors.black),
                                        SizedBox(height: FetchPixels.getPixelHeight(10),),
                                        textWidget(text: "Stock Available", fontSize: FetchPixels.getPixelHeight(16), fontWeight: FontWeight.w400,textColor: Colors.black),
                                        SizedBox(height: FetchPixels.getPixelHeight(20),),
                                        textWidget(text: "Invoice", fontSize: FetchPixels.getPixelHeight(16), fontWeight: FontWeight.w400,textColor: Colors.black),
                                        SizedBox(height: FetchPixels.getPixelHeight(20),),
                                        textWidget(text: "Net Visit", fontSize: FetchPixels.getPixelHeight(16), fontWeight: FontWeight.w400,textColor: Colors.black),
                                        SizedBox(height: FetchPixels.getPixelHeight(10),),
                                        textWidget(text: "Stock Available", fontSize: FetchPixels.getPixelHeight(16), fontWeight: FontWeight.w400,textColor: Colors.black),
                                        SizedBox(height: FetchPixels.getPixelHeight(10),),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    })
            )
          ],
        ),
      ),
    );
  }

}
