import 'package:SalesUp/model/daysModel.dart';
import 'package:SalesUp/model/saleDistributionModel.dart';
import 'package:SalesUp/res/base/fetch_pixels.dart';
import 'package:SalesUp/res/colors.dart';
import 'package:SalesUp/utils/widgets/appWidgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RegionWiseSale extends StatelessWidget {
  List<RegionSale> regionWiseList = [];
  String year = '',value = '';
  RegionWiseSale({super.key,required this.regionWiseList,required this.year,required this.value});

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
        title: textWidget(text: "Region Wise Sale", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w600,textColor: Colors.white),
      ),
      body: Container(
        height: FetchPixels.height,
        width: FetchPixels.width,
        child: Column(children: [
          SizedBox(height: FetchPixels.getPixelHeight(10),),
          textWidget(text: "${value} Wise", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w600,textColor: Colors.black),
          SizedBox(height: FetchPixels.getPixelHeight(10),),
          Column(
            children: List.generate(regionWiseList.length, (index) => Container(
              child: Column(
                children: [
                  SizedBox(height: FetchPixels.getPixelHeight(10),),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        textWidget(text: "${regionWiseList[index].regionName}", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w600,textColor: Colors.black),
                        textWidget(text: "${formatNumberWithCommas(regionWiseList[index].totalValue.toString())}", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w600,textColor: Colors.black)
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
