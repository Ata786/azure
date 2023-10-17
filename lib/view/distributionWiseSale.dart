import 'package:SalesUp/model/daysModel.dart';
import 'package:SalesUp/model/saleDistributionModel.dart';
import 'package:SalesUp/res/base/fetch_pixels.dart';
import 'package:SalesUp/res/colors.dart';
import 'package:SalesUp/utils/widgets/appWidgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DistributerWiseSale extends StatelessWidget {
  List<Distributors> distributorWiseList = [];
  String year = '',value = '';
  bool top5;
  DistributerWiseSale({super.key,required this.distributorWiseList,required this.year,required this.value,required this.top5});

  List<Distributors> top5List = [];

  @override
  Widget build(BuildContext context) {
    if(top5 == true){
      distributorWiseList.sort((a, b) => b.totalValue!.compareTo(a.totalValue!));
      top5List = distributorWiseList.take(5).toList();
    }
    FetchPixels(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
        title: textWidget(text: top5 == true ? "Top 5 Distributors" : "Distribution List", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w600,textColor: Colors.white),
      ),
      body: Container(
        height: FetchPixels.height,
        width: FetchPixels.width,
        child: SingleChildScrollView(
          child: Column(children: [
             SizedBox(height: FetchPixels.getPixelHeight(10),),
            textWidget(text: "${value} Wise", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w600,textColor: Colors.black),
            SizedBox(height: FetchPixels.getPixelHeight(10),),
            Column(
              children: List.generate(top5 == true ? top5List.length : distributorWiseList.length, (index) => Container(
                child: Column(
                  children: [
                    SizedBox(height: FetchPixels.getPixelHeight(10),),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          textWidget(text: "${distributorWiseList[index].distributorName}", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w500,textColor: Colors.black),
                          textWidget(text: "${formatNumberWithCommas(distributorWiseList[index].totalValue.toString())}", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w500,textColor: Colors.black),
                          textWidget(text: distributorWiseList[index].townName ?? "", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w500,textColor: Colors.black)
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
      ),
    );
  }
  String formatNumberWithCommas(String decimalString) {
    NumberFormat formatter = NumberFormat("#,###.####");
    return formatter.format(double.parse(decimalString));
  }
}
