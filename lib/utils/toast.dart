import 'package:SalesUp/res/base/fetch_pixels.dart';
import 'package:flutter/material.dart';

void showToast(BuildContext context, String message) {
  FetchPixels(context);
  final snackBar = SnackBar(
    margin: EdgeInsets.only(bottom: FetchPixels.getPixelHeight(330),left: FetchPixels.getPixelWidth(50),right: FetchPixels.getPixelWidth(50)),
    backgroundColor: Color(0xff616161),
    content: Center(child: Text("Check internet service and try it again",textAlign: TextAlign.center,)),
    behavior: SnackBarBehavior.floating, // This prevents rounded corners
    duration: Duration(seconds: 2),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

