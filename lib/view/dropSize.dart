import 'package:SalesUp/res/base/fetch_pixels.dart';
import 'package:SalesUp/res/colors.dart';
import 'package:SalesUp/utils/widgets/appWidgets.dart';
import 'package:SalesUp/view/distributerScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DropSizeScreen extends StatefulWidget {
  DropSizeScreen({super.key});

  @override
  State<DropSizeScreen> createState() => _DropSizeScreenState();
}

class _DropSizeScreenState extends State<DropSizeScreen> {

  List<String> typeDropDown = ["Value","Pcs","Tonnage"];
  String typeValue = "Value";

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          InkWell(
              onTap: (){
                Get.to(DistributerScreen());
              },
              child: Icon(Icons.filter_list_outlined,color: Colors.white,)),
          SizedBox(width: FetchPixels.getPixelWidth(20),),
        ],
        backgroundColor: themeColor,
        title:  textWidget(text: "Drop Size", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w600,textColor: Colors.white),
      ),
      body: Container(
        height: FetchPixels.height,
        width: FetchPixels.width,
        child: Column(
          children: [
            SizedBox(height: FetchPixels.getPixelHeight(30),),
            Row(
              children: [
                Expanded(child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(10)),
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                    value: typeValue,
                    onChanged: (newValue) {
                      setState(() {
                        typeValue = newValue!;
                      });
                    },
                    items: typeDropDown.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value ?? ""),
                      );
                    }).toList(),
                  ),
                ),),
                Expanded(child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(10)),
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                    value: typeValue,
                    onChanged: (newValue) {
                      setState(() {
                        typeValue = newValue!;
                      });
                    },
                    items: typeDropDown.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value ?? ""),
                      );
                    }).toList(),
                  ),
                ),),
              ],
            ),
            SizedBox(height: FetchPixels.getPixelHeight(30),),
            Row(
              children: [
                Expanded(
                  child: Container(
                      alignment: Alignment.center,
                      height: FetchPixels.height / 13,
                      width: FetchPixels.width/2,
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Color(0xffADD8E6),
                          borderRadius: BorderRadius.circular(7)),
                      child: Text(
                        "Top 5 Distributions",
                        style: TextStyle(color: Colors.white,fontSize: FetchPixels.getPixelHeight(17),fontWeight: FontWeight.w600),
                      ),
                  ),
                ),
                Expanded(
                  child: Container(
                      alignment: Alignment.center,
                      height: FetchPixels.height / 13,
                      width: FetchPixels.width/2,
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Color(0xfff7d8ba),
                          borderRadius: BorderRadius.circular(7)),
                      child: Text(
                        "Top 5 Booker",
                        style: TextStyle(color: Colors.white,fontSize: FetchPixels.getPixelHeight(17),fontWeight: FontWeight.w600),
                      ),
                  ),
                ),
              ],
            ),
            SizedBox(height: FetchPixels.getPixelHeight(10),),
            Row(
              children: [
                Expanded(
                  child: Container(
                      alignment: Alignment.center,
                      height: FetchPixels.height / 13,
                      width: FetchPixels.width/2,
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Color(0xffFFA799),
                          borderRadius: BorderRadius.circular(7)),
                      child:  Text(
                        "Distribution List",
                        style: TextStyle(color: Colors.white,fontSize: FetchPixels.getPixelHeight(17),fontWeight: FontWeight.w600),
                      ),
                  ),
                ),
                Expanded(
                  child: Container(
                      alignment: Alignment.center,
                      height: FetchPixels.height / 13,
                      width: FetchPixels.width/2,
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Color(0xffB7ACA5),
                          borderRadius: BorderRadius.circular(7)),
                      child:   Text(
                        "Booker List",
                        style: TextStyle(color: Colors.white,fontSize: FetchPixels.getPixelHeight(17),fontWeight: FontWeight.w600),
                      ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
