import 'package:SalesUp/model/daysModel.dart';
import 'package:SalesUp/model/saleDistributionModel.dart';
import 'package:SalesUp/res/base/fetch_pixels.dart';
import 'package:SalesUp/res/colors.dart';
import 'package:SalesUp/utils/widgets/appWidgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DistributerWiseSale extends StatefulWidget {
  List<Distributors> distributorWiseList = [];
  String year = '',value = '';
  bool top5;
  DistributerWiseSale({super.key,required this.distributorWiseList,required this.year,required this.value,required this.top5});

  @override
  State<DistributerWiseSale> createState() => _DistributerWiseSaleState();
}

class _DistributerWiseSaleState extends State<DistributerWiseSale> {
  List<Distributors> top5List = [];

  TextEditingController searchCtr = TextEditingController();
  List<Distributors> _filteredData = [];
  String _searchQuery = '';

  bool show = false;

  @override
  void initState() {
    super.initState();

    if(widget.top5 == true){
      widget.distributorWiseList.sort((a, b) => b.totalValue!.compareTo(a.totalValue!));
      top5List = widget.distributorWiseList.take(5).toList();
    }

    _filteredData = widget.distributorWiseList ?? [];
  }


  void _onSearchQueryChanged(String value) {
    setState(() {
      _searchQuery = value;
      _filteredData = widget.distributorWiseList.where((element) => element.distributorName!.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
        title: textWidget(text: widget.top5 == true ? "Top 5 Distributors" : "Distribution List", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w600,textColor: Colors.white),
      ),
      body: Container(
        height: FetchPixels.height,
        width: FetchPixels.width,
        child: SingleChildScrollView(
          child: Column(children: [
            SizedBox(height: FetchPixels.getPixelHeight(10),),
            widget.top5 == true ? SizedBox() : Padding(
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
                          _filteredData = widget.distributorWiseList ?? [];
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
                  Expanded(
                      child: Center(child: textWidget(text: "Distributor Name", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w600,textColor: Colors.black))),
                  Expanded(child: Center(child: textWidget(text: "${widget.value}", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w600,textColor: Colors.black))),
                  Expanded(child: Center(child: textWidget(text: "Town", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w600,textColor: Colors.black)))
                ],
              ),
            ),
             SizedBox(height: FetchPixels.getPixelHeight(10),),
            Column(
              children: List.generate(widget.top5 == true ? top5List.length : _filteredData.length, (index) => Container(
                child: Column(
                  children: [
                    SizedBox(height: FetchPixels.getPixelHeight(10),),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
                      child: widget.top5 == false ? Row(
                        children: [
                          Expanded(
                              child: textWidget(textAlign: TextAlign.start,maxLines: 2,text: "${_filteredData[index].distributorName}", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w500,textColor: Colors.black)),
                          Expanded(child: Center(child: textWidget(text: widget.value == "Tonnage" ? "${formatNumberWithCommas(_filteredData[index].totalValue.toString())}" : "${formatNumberWithCommas(_filteredData[index].totalValue!.toStringAsFixed(0))}", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w500,textColor: Colors.black))),
                          Expanded(child: Center(child: textWidget(text: _filteredData[index].townName ?? "", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w500,textColor: Colors.black)))
                        ],
                      )
                      : Row(
                        children: [
                          Expanded(
                              child: textWidget(textAlign: TextAlign.start,maxLines: 2,text: "${top5List[index].distributorName}", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w500,textColor: Colors.black)),
                          Expanded(child: Center(child: textWidget(text: widget.value == "Tonnage" ? "${formatNumberWithCommas(top5List[index].totalValue.toString())}" : "${formatNumberWithCommas(top5List[index].totalValue!.toStringAsFixed(0))}", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w500,textColor: Colors.black))),
                          Expanded(child: Center(child: textWidget(text: top5List[index].townName ?? "", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w500,textColor: Colors.black)))
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
