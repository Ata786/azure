import 'package:SalesUp/model/daysModel.dart';
import 'package:SalesUp/model/saleDistributionModel.dart';
import 'package:SalesUp/res/base/fetch_pixels.dart';
import 'package:SalesUp/res/colors.dart';
import 'package:SalesUp/utils/widgets/appWidgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BrandWiseSale extends StatelessWidget {
  List<BrandSale> brandWiseList = [];
  String year = '',value = '';
  BrandWiseSale({super.key,required this.brandWiseList,required this.year,required this.value});

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
        title: textWidget(text: "Brand Wise Sale", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w600,textColor: Colors.white),
      ),
      body: Container(
        height: FetchPixels.height,
        width: FetchPixels.width,
        child: Column(children: [
          SizedBox(height: FetchPixels.getPixelHeight(10),),
          textWidget(text: "${value} Wise", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w600,textColor: Colors.black),
          SizedBox(height: FetchPixels.getPixelHeight(10),),
          Column(
            children: List.generate(brandWiseList.length, (index) => Container(
              child: Column(
                children: [
                  SizedBox(height: FetchPixels.getPixelHeight(10),),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        textWidget(text: "${brandWiseList[index].brandName}", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w600,textColor: Colors.black),
                        textWidget(text: "${formatNumberWithCommas(brandWiseList[index].totalTonage.toString())}", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w600,textColor: Colors.black)
                      ],
                    ),
                  ),
                  SizedBox(height: FetchPixels.getPixelHeight(10),),
                  Divider(),
                ],
              ),
            )),
          )
        ],),
      ),
    );
  }
  String formatNumberWithCommas(String decimalString) {
    NumberFormat formatter = NumberFormat("#,###.####");
    return formatter.format(double.parse(decimalString));
  }
}
