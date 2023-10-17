import 'dart:developer';

import 'package:SalesUp/model/lppcModel.dart';
import 'package:SalesUp/res/base/fetch_pixels.dart';
import 'package:SalesUp/res/colors.dart';
import 'package:SalesUp/utils/widgets/appWidgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LppcListScreen extends StatefulWidget {
  late List<BookerList> bookerList;
  String year = '',value = '';
  LppcListScreen({super.key,required this.bookerList,required this.year,required this.value});

  @override
  State<LppcListScreen> createState() => _LppcListScreenState();
}

class _LppcListScreenState extends State<LppcListScreen> {

  TextEditingController searchCtr = TextEditingController();



  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
        title: textWidget(text: "Distributors List", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w600,textColor: Colors.white),
      ),
      body: Container(
        height: FetchPixels.height,
        width: FetchPixels.width,
        padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: FetchPixels.getPixelHeight(15),),
            textWidget(text: "${widget.value} Wise", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w600,textColor: Colors.black),
            SizedBox(height: FetchPixels.getPixelHeight(15),),
            textWidget(text: "${widget.year}", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w600,textColor: Colors.black),
            SizedBox(height: FetchPixels.getPixelHeight(15),),
            Row(
              children: [
                Expanded( flex: 2,child: textWidget(text: "Distributor Name:", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w600,textColor: Colors.black)),
                Expanded( flex: 2,child: textWidget(text: "${widget.bookerList[0].distributorName}", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w500,textColor: Colors.black)),
                Expanded(child: SizedBox()),
              ],
            ),
            SizedBox(height: FetchPixels.getPixelHeight(20),),
            Row(
              children: [
                Expanded(
                    flex: 3,
                    child: textWidget(text: "Booker Name", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w600,textColor: Colors.black)),
                Expanded( flex: 2,child: textWidget(text: "LPPC", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w600,textColor: Colors.black)),
              ],
            ),
            SizedBox(height: FetchPixels.getPixelHeight(10),),
            Expanded(child: CustomScrollView(
              slivers: [
                SliverList(delegate: SliverChildBuilderDelegate(
                    childCount: widget.bookerList.length,
                        (context,index){
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: FetchPixels.getPixelHeight(20),),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(flex: 3,child: textWidget(maxLines: 3,text:"${widget.bookerList[index].bookerName}", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w400,textColor: Colors.black)),
                              Expanded( flex: 2,child: textWidget(maxLines: 2,text: "${widget.bookerList[index].lppc.toStringAsFixed(3)}", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w400,textColor: Colors.black)),
                            ],
                          ),
                          Divider(),
                        ],
                      );
                    }
                ))
              ],
            )),
          ],),
      ),
    );
  }

  String formatNumberWithCommas(String decimalString) {
    NumberFormat formatter = NumberFormat("#,###.####");
    return formatter.format(double.parse(decimalString));
  }
}
