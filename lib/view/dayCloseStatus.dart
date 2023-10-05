import 'package:SalesUp/res/base/fetch_pixels.dart';
import 'package:SalesUp/res/colors.dart';
import 'package:SalesUp/utils/widgets/appWidgets.dart';
import 'package:flutter/material.dart';

class DayCloseStatusScreen extends StatelessWidget {
   DayCloseStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return Scaffold(
      appBar: AppBar(
        title: textWidget(
          textColor: Colors.white,
          text: "Day Close Status",
          fontSize: FetchPixels.getPixelHeight(17),
          fontWeight: FontWeight.w600,
        ),
        actions: [
          InkWell(
              onTap: (){

              },
              child: Icon(Icons.filter_alt_sharp,color: Colors.white,)),
          SizedBox(width: FetchPixels.getPixelWidth(20),),
        ],
      ),
      body: Container(
        height: FetchPixels.height,
        width: FetchPixels.width,
        child: Column(
          children: [
            SizedBox(height: FetchPixels.getPixelHeight(50),),
            Container(
              height: FetchPixels.getPixelHeight(70),
              width: FetchPixels.width,
              color: Colors.deepOrange.withOpacity(0.5),
              margin: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(50)),
              child: Center(child: textWidget(
                textColor: blackBrown,
                text: "Today Not Close",
                fontSize: FetchPixels.getPixelHeight(17),
                fontWeight: FontWeight.w600,
              ),),
            ),
            SizedBox(height: FetchPixels.getPixelHeight(30),),
            Container(
              height: FetchPixels.getPixelHeight(70),
              width: FetchPixels.width,
              color: Colors.blue.withOpacity(0.5),
              margin: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(50)),
              child: Center(child: textWidget(
                textColor: blackBrown,
                text: "Distribution List",
                fontSize: FetchPixels.getPixelHeight(17),
                fontWeight: FontWeight.w600,
              ),),
            ),
          ],
        ),
      ),
    );
  }
}
