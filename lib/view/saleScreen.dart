import 'package:SalesUp/res/base/fetch_pixels.dart';
import 'package:flutter/material.dart';

class SaleScreen extends StatefulWidget {
   SaleScreen({super.key});

  @override
  State<SaleScreen> createState() => _SaleScreenState();
}

class _SaleScreenState extends State<SaleScreen> {

  List<String> typeDropDown = ["Value","Pcs","Tonnage"];
  String typeValue = "Value";

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return Scaffold(
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Today",
                            style: TextStyle(color: Colors.white,fontSize: FetchPixels.getPixelHeight(17),fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "0.0000",
                            style: TextStyle(color: Colors.white,fontSize: FetchPixels.getPixelHeight(17),fontWeight: FontWeight.w600),
                          ),
                        ],
                      )
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "This Week",
                            style: TextStyle(color: Colors.white,fontSize: FetchPixels.getPixelHeight(17),fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "0.0000",
                            style: TextStyle(color: Colors.white,fontSize: FetchPixels.getPixelHeight(17),fontWeight: FontWeight.w600),
                          ),
                        ],
                      )
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "This Month",
                            style: TextStyle(color: Colors.white,fontSize: FetchPixels.getPixelHeight(17),fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "0.0000",
                            style: TextStyle(color: Colors.white,fontSize: FetchPixels.getPixelHeight(17),fontWeight: FontWeight.w600),
                          ),
                        ],
                      )
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "This Year",
                          style: TextStyle(color: Colors.white,fontSize: FetchPixels.getPixelHeight(17),fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "0.0000",
                          style: TextStyle(color: Colors.white,fontSize: FetchPixels.getPixelHeight(17),fontWeight: FontWeight.w600),
                        ),
                      ],
                    )
                  ),
                ),
              ],
            ),
            Container(
                alignment: Alignment.center,
                height: FetchPixels.height / 13,
                width: FetchPixels.width/2,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Color(0xffB4F297),
                    borderRadius: BorderRadius.circular(7)),
                child: Text(
                  "Top 5 Distributions",
                  style: TextStyle(color: Colors.white,fontSize: FetchPixels.getPixelHeight(17),fontWeight: FontWeight.w600),
                ),
            )
          ],
        ),
      ),
    );
  }
}
