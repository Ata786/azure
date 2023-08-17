import 'package:SalesUp/res/base/fetch_pixels.dart';
import 'package:SalesUp/res/colors.dart';
import 'package:flutter/material.dart';

// app text widget
Widget textWidget(
    {required String text,
    required double fontSize,
    required fontWeight,
      textAlign,
    maxLines,
    textColor,
    underline}) {
  return Text(
    text,
    maxLines: maxLines,
    textAlign: textAlign,
    style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        overflow: TextOverflow.ellipsis,
        color: textColor ?? primaryColor,
        decoration: underline ?? TextDecoration.none),
  );
}

// app text field
Widget textField(
    {required controller, required hintText, keyboardType, helperText,suffix,validator}) {
  return TextFormField(
    validator: validator,
      controller: controller,
      keyboardType: keyboardType,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        isDense: true,
        hintText: hintText,
        helperText: helperText,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(8)),
            borderSide: BorderSide(color: Colors.black, width: 1)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(8)),
            borderSide: BorderSide(color: Colors.black, width: 1)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(8)),
            borderSide: BorderSide(color: Colors.red, width: 1)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(8)),
            borderSide: BorderSide(color: Colors.red, width: 1)),
        suffixIcon: suffix == true ? Icon(Icons.visibility_off,color: Colors.black,) : SizedBox()
      )
  );
}




// app text field
Widget searchTextField(
    {required controller, required hintText, keyboardType, helperText,suffix,validator}) {
  return TextFormField(
      validator: validator,
      controller: controller,
      keyboardType: keyboardType,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
          isDense: true,
          fillColor: Colors.white,
          filled: true,
          hintText: hintText,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(8)),
              borderSide: BorderSide(color: Colors.black, width: 1)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(8)),
              borderSide: BorderSide(color: Colors.black, width: 1)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(8)),
              borderSide: BorderSide(color: Colors.red, width: 1)),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(8)),
              borderSide: BorderSide(color: Colors.red, width: 1)),
          suffixIcon: suffix
      )
  );
}

// app button
Widget button(
    {required height,
    required width,
    required color,
    required textColor,
    required textSize,
    required double borderRadius,
    required textWeight,
    required text}) {
  return Container(
    height: height,
    width: width,
    decoration: BoxDecoration(
        color: color, borderRadius: BorderRadius.circular(borderRadius)),
    child: Center(
      child: textWidget(text: text, fontSize: textSize, fontWeight: textWeight,textColor: textColor),
    ),
  );
}



// app button  with icon
Widget buttonWithIcon(
    {
      required color,
      required textColor,
      required textSize,
      required double borderRadius,
      required textWeight,
      required text}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 3),
    decoration: BoxDecoration(
        color: color, borderRadius: BorderRadius.circular(borderRadius)),
    child: Row(
      children: [
        Icon(Icons.add,color: Colors.white,),
        textWidget(text: text, fontSize: textSize, fontWeight: textWeight,textColor: textColor),
      ],
    ),
  );
}



// performance Widget
Widget performanceTextWidget({required text}){
  return Padding(
    padding: EdgeInsets.symmetric(
        vertical:
        FetchPixels.getPixelHeight(
            5),
        horizontal:
        FetchPixels.getPixelWidth(5)),
    child: textWidget(
        text: text,
        fontSize:
        FetchPixels.getPixelHeight(
            15),
        fontWeight: FontWeight.w500,
        textColor: primaryColor),
  );
}
