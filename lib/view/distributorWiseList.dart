import 'dart:developer';

import 'package:SalesUp/data/postApis.dart';
import 'package:SalesUp/model/daysModel.dart';
import 'package:SalesUp/model/receivableModel.dart';
import 'package:SalesUp/res/base/fetch_pixels.dart';
import 'package:SalesUp/res/colors.dart';
import 'package:SalesUp/utils/widgets/appWidgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DistributionWiseList extends StatefulWidget {
  List<Distributor>? distributor;
  String year = '';
  DistributionWiseList({super.key,required this.distributor,required this.year});

  @override
  State<DistributionWiseList> createState() => _DistributionWiseListState();
}

class _DistributionWiseListState extends State<DistributionWiseList> {

  TextEditingController searchCtr = TextEditingController();
  List<Distributor> _filteredData = [];
  String _searchQuery = '';

  bool show = false;

  @override
  void initState() {
    super.initState();
    _filteredData = widget.distributor ?? [];
  }

  void _onSearchQueryChanged(String value) {
    setState(() {
      _searchQuery = value;
      _filteredData = widget.distributor!.where((element) => element.distributorName!.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
        title: textWidget(text: "Receivable Balance", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w600,textColor: Colors.white),
      ),
      body: Container(
        height: FetchPixels.height,
        width: FetchPixels.width,
        child: Column(children: [
          SizedBox(height: FetchPixels.getPixelHeight(15),),
          textWidget(text: "Till  ${DateFormat('dd-MM-yyyy').format(DateTime.now())}", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w600,textColor: Colors.black),
          SizedBox(height: FetchPixels.getPixelHeight(10),),
          textWidget(text: "Distribution's Receivable Balance", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w600,textColor: Colors.black),
          SizedBox(height: FetchPixels.getPixelHeight(20),),
         Padding(
           padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
           child: Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               show == true ? Expanded(
                 child: Padding(
                   padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(10)),
                   child: textField(
                       onChange: _onSearchQueryChanged,
                       controller: searchCtr,
                       hintText: "Search..."),
                 ),
               ) : SizedBox(),
               InkWell(
                   onTap: (){
                     setState(() {
                       show = !show;
                       searchCtr.text = '';
                     });
                   },
                   child: Icon(show == true ? Icons.close : Icons.search)),
             ],
           ),
         ),
          SizedBox(height: FetchPixels.getPixelHeight(20),),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
            child: Row(
              children: [
                Expanded(child: textWidget(text: "Name", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w600,textColor: Colors.black)),
                Expanded(child: textWidget(text: "City", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w600,textColor: Colors.black)),
                Expanded(child: textWidget(text: "Balance", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w600,textColor: Colors.black))
              ],
            ),
          ),
          _filteredData.isEmpty ? Center(child: textWidget(maxLines: 2,text: "No Data Found", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w500,textColor: Colors.black))
          : Column(
            children: List.generate(_filteredData.length, (index) => Container(
              child: Column(
                children: [
                  SizedBox(height: FetchPixels.getPixelHeight(10),),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: textWidget(maxLines: 2,text: "${_filteredData[index].distributorName}", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w500,textColor: Colors.black)),
                        Expanded(child: textWidget(text: "City Name", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w500,textColor: Colors.black)),
                        Expanded(child: textWidget(text: "${formatNumberWithCommas(_filteredData[index].totalReciveable.toString())}", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w500,textColor: Colors.black))
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
