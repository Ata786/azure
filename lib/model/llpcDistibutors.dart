import 'dart:developer';

import 'package:SalesUp/model/lppcModel.dart';
import 'package:SalesUp/res/base/fetch_pixels.dart';
import 'package:SalesUp/res/colors.dart';
import 'package:SalesUp/utils/widgets/appWidgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LlpcDistributorsScreen extends StatefulWidget {
  late LppcModel lppcModel;
  String year = '',value = '';
  bool? top5;
  LlpcDistributorsScreen({super.key,required this.lppcModel,required this.year,required this.value,required this.top5});

  @override
  State<LlpcDistributorsScreen> createState() => _LlpcDistributorsScreenState();
}

class _LlpcDistributorsScreenState extends State<LlpcDistributorsScreen> {

  List<DistributionList> originalList = [];

  onSearchQueryChanged(query){
    setState(() {
      if (query.isEmpty) {
        // If the query is empty, show the original unfiltered data
        originalList = List.from(widget.lppcModel.distributionList!);
      } else {
        // Filter the original data based on the search query
        originalList = widget.lppcModel.distributionList!
            .where((item) =>
            item.distributorName!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  TextEditingController searchCtr = TextEditingController();

  bool show = false;

  @override
  void initState() {
    super.initState();
    if (widget.top5 == true) {
      originalList = List.from(widget.lppcModel.distributionList!);
      originalList.sort((a, b) => b.lppc.compareTo(a.lppc));
      originalList = originalList.take(5).toList();
    } else {
      originalList = List.from(widget.lppcModel.distributionList!);
    }
  }

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
        title: textWidget(text: widget.top5 == true ? "Top 5 Distributors" : "Distributors", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w600,textColor: Colors.white),
      ),
      body: Container(
        height: FetchPixels.height,
        width: FetchPixels.width,
        padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: FetchPixels.getPixelHeight(15),),
            widget.top5 == false ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                show == true ? Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(10)),
                    child: textField(
                        onChange: onSearchQueryChanged,
                        controller: searchCtr,
                        hintText: "Search..."),
                  ),
                ) : SizedBox(),
                InkWell(
                    onTap: (){
                      setState(() {
                        show = !show;
                        searchCtr.text = '';
                        originalList = List.from(widget.lppcModel.distributionList!);
                      });
                    },
                    child: Icon(show == true ? Icons.close : Icons.search)),
              ],
            ) : SizedBox(),
            SizedBox(height: FetchPixels.getPixelHeight(10),),
            textWidget(text: "${widget.value} Wise", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w600,textColor: Colors.black),
            SizedBox(height: FetchPixels.getPixelHeight(20),),
            Row(
              children: [
                Expanded(
                    flex: 3,
                    child: textWidget(text: "Distributor Name", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w600,textColor: Colors.black)),
                Expanded( flex: 2,child: textWidget(text: "LPPC", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w600,textColor: Colors.black)),
                Expanded( flex: 2,child: textWidget(text: "Town", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w600,textColor: Colors.black)),
              ],
            ),
            SizedBox(height: FetchPixels.getPixelHeight(10),),
            Expanded(child: CustomScrollView(
              slivers: [
                SliverList(delegate: SliverChildBuilderDelegate(
                    childCount: originalList.length,
                        (context,index){
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: FetchPixels.getPixelHeight(20),),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(flex: 3,child: textWidget(maxLines: 3,text:"${originalList[index].distributorName}", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w400,textColor: Colors.black)),
                              Expanded( flex: 2,child: textWidget(maxLines: 2,text: "${originalList[index].lppc.toStringAsFixed(3)}", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w400,textColor: Colors.black)),
                              Expanded( flex: 2,child: textWidget(maxLines: 2,text: "${originalList[index].townName}", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w400,textColor: Colors.black)),
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
