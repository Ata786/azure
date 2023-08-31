import 'package:SalesUp/data/getApis.dart';
import 'package:SalesUp/data/hiveDb.dart';
import 'package:SalesUp/model/historyModel.dart';
import 'package:SalesUp/res/base/fetch_pixels.dart';
import 'package:SalesUp/res/colors.dart';
import 'package:SalesUp/utils/widgets/appWidgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ShopHistory extends StatefulWidget {
  ShopHistory({super.key});

  @override
  State<ShopHistory> createState() => _ShopHistoryState();
}

class _ShopHistoryState extends State<ShopHistory> {

  List<HistoryModel> history = [];

  @override
  void initState() {
    getHistory();
    super.initState();
  }

  void getHistory()async{
    Map<String,dynamic> argument = Get.arguments as Map<String,dynamic>;
    int sr = int.tryParse(argument['sr'].toString())!;
    List<HistoryModel> historyList = await HiveDatabase.getHistory("historyBox", "history");
    history = historyList.where((element) => element.shopId == sr).toList();
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String,dynamic> argument = Get.arguments as Map<String,dynamic>;
    history.sort((a, b) => b.createdOn!.compareTo(a.createdOn!));
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
            Container(
              padding: EdgeInsets.only(left: FetchPixels.getPixelWidth(15)),
              alignment: Alignment.centerLeft,
              height: FetchPixels.getPixelHeight(50),
              width: FetchPixels.width,
              color: themeColor,
              child: textWidget(text: "${argument['shopName']}", fontSize: FetchPixels.getPixelHeight(16), fontWeight: FontWeight.w600,textColor: Colors.white),
            ),
            Container(
              height: FetchPixels.height/2,
              width: FetchPixels.width,
              padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20),vertical: FetchPixels.getPixelHeight(20)),
              child: Card(
                child: Padding(
                  padding:  EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          textWidget(text: "Date", fontSize: FetchPixels.getPixelHeight(16), fontWeight: FontWeight.w600,textColor: Colors.black),
                          textWidget(text: "Visit Status", fontSize: FetchPixels.getPixelHeight(16), fontWeight: FontWeight.w600,textColor: Colors.black),
                        ],
                      ),
                      Column(
                        children: List.generate(history.length, (index) =>  Padding(
                          padding: EdgeInsets.only(top: FetchPixels.getPixelHeight(15)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              textWidget(text: history[index].createdOn == null || history[index].createdOn == "" ? "" : parseDate(history[index].createdOn!), fontSize: FetchPixels.getPixelHeight(16), fontWeight: FontWeight.w400,textColor: primaryColor),
                              textWidget(text: "${history[index].reason!.trim()}", fontSize: FetchPixels.getPixelHeight(16), fontWeight: FontWeight.w400,textColor: primaryColor),
                            ],
                          ),
                        ),),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  String parseDate(String inputDate){
    DateTime dateTime = DateTime.parse(inputDate);

    String formattedDate = DateFormat("MM/dd/yyyy").format(dateTime);
  return formattedDate;
  }

}
