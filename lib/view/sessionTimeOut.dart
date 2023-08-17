import 'package:SalesUp/res/base/fetch_pixels.dart';
import 'package:flutter/material.dart';

import '../utils/widgets/appWidgets.dart';

class SessionTimeOut extends StatelessWidget {
  SessionTimeOut({super.key});

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: FetchPixels.height,
        width: FetchPixels.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            textWidget(text: "Session Timed Out",textColor: Colors.white, fontSize: FetchPixels.getPixelHeight(18), fontWeight:FontWeight.w600),
            SizedBox(height: FetchPixels.getPixelHeight(10),),
            textWidget(text: "To continue working please enter password again",textColor: Colors.white, fontSize: FetchPixels.getPixelHeight(16), fontWeight:FontWeight.w500),
            SizedBox(height: FetchPixels.getPixelHeight(20),),
            Container(height: FetchPixels.getPixelHeight(1),color: Colors.white,),
            SizedBox(height: FetchPixels.getPixelHeight(20),),
            button(height: FetchPixels.getPixelHeight(40),
                width: FetchPixels.getPixelWidth(100),
                color: Colors.grey, textColor: Colors.white,
                textSize: FetchPixels.getPixelHeight(15),
                borderRadius: FetchPixels.getPixelHeight(40),
                textWeight: FontWeight.w500, text: "Submit"),
            SizedBox(height: FetchPixels.getPixelHeight(20),),
            textWidget(text: "OR",textColor: Colors.white, fontSize: FetchPixels.getPixelHeight(16), fontWeight:FontWeight.w500),
            SizedBox(height: FetchPixels.getPixelHeight(20),),
            button(height: FetchPixels.getPixelHeight(40),
                width: FetchPixels.getPixelWidth(100),
                color: Colors.red, textColor: Colors.white,
                textSize: FetchPixels.getPixelHeight(15),
                borderRadius: FetchPixels.getPixelHeight(40),
                textWeight: FontWeight.w500, text: "Log out"),
          ],
        ),
      ),
    );
  }
}
