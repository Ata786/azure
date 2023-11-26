import 'package:SalesUp/model/bookerWiseTargetModel.dart';
import 'package:SalesUp/res/base/fetch_pixels.dart';
import 'package:SalesUp/res/colors.dart';
import 'package:SalesUp/utils/widgets/appWidgets.dart';
import 'package:flutter/material.dart';

class ShopWiseTarget extends StatefulWidget {
  List<ShopWiseTargetModel> list = [];
  String month;
  int year;
  String selectedDistribution;
  ShopWiseTarget(this.list,this.month,this.year, this.selectedDistribution,{super.key});

  @override
  State<ShopWiseTarget> createState() => _ShopWiseTargetState();
}

class _ShopWiseTargetState extends State<ShopWiseTarget> {

  List<ShopWiseTargetModel> _filteredData = [];

  String _searchQuery = '';

  bool show = false;

  TextEditingController searchCtr = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _filteredData = widget.list ?? [];
  }

  void _onSearchQueryChanged(String value) {
    setState(() {
      _searchQuery = value;
      _filteredData = widget.list.where((element) => element.distributorName!.toLowerCase().contains(_searchQuery.toLowerCase()) || element.shopName!.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    _filteredData.sort((a, b) => a.distributorName!.compareTo(b.distributorName ?? ""));
    FetchPixels(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
        title:  textWidget(text: "Shop Wise Target", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w600,textColor: Colors.white),
      ),
      body: Container(
        height: FetchPixels.height,
        width: FetchPixels.width,
        child: Column(
          children: [
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
                          _filteredData = widget.list;
                        });
                      },
                      child: Icon(show == true ? Icons.close : Icons.search)),
                ],
              ),
            ),
            SizedBox(height: FetchPixels.getPixelHeight(20),),
            Container(
                padding: EdgeInsets.only(left: FetchPixels.getPixelWidth(20)),
                width: FetchPixels.width,
                child: textWidget(text: "${widget.month} - ${widget.year}  ${widget.selectedDistribution}", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w500,textColor: Colors.black)),
            SizedBox(height: FetchPixels.getPixelHeight(20),),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(10)),
              child: Row(
                children: [
                  Expanded(child: Center(child: textWidget(textAlign: TextAlign.center,maxLines: 2,text: "Distributor", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w600,textColor: Colors.black)),),
                  Expanded(child: Center(child: textWidget(textAlign: TextAlign.center,maxLines: 2,text: "Shop", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w600,textColor: Colors.black)),),
                  Expanded(child: Center(child: textWidget(text: "Target", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w600,textColor: Colors.black)),),
                  Expanded(child: Center(child: textWidget(textAlign: TextAlign.center,maxLines: 2,text: "Ach", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w600,textColor: Colors.black)),),
                  Expanded(child: Center(child: textWidget(text: "%", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w600,textColor: Colors.black)),),
                ],
              ),
            ),
            SizedBox(height: FetchPixels.getPixelHeight(10),),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: FetchPixels.getPixelWidth(10),right: FetchPixels.getPixelWidth(10)),
                child: ListView.builder(
                    itemCount: _filteredData.length,
                    itemBuilder: (context,index){
                      return Padding(
                        padding: EdgeInsets.only(top: FetchPixels.getPixelHeight(10)),
                        child: Row(
                          children: [
                            Expanded(child: Center(child: textWidget(textAlign: TextAlign.center,maxLines: 2,text: "${_filteredData[index].distributorName}", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w500,textColor: Colors.black)),),
                            Expanded(child: Center(child: textWidget(textAlign: TextAlign.center,maxLines: 2,text: "${_filteredData[index].shopName}", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w500,textColor: Colors.black)),),
                            Expanded(child: Center(child: textWidget(text: widget.selectedDistribution == "Pcs" ? "${_filteredData[index].targetPcs}" : "${_filteredData[index].targetTonnage}", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w500,textColor: Colors.black)),),
                            Expanded(child: Center(child: textWidget(text: widget.selectedDistribution == "Pcs" ? "${double.tryParse(_filteredData[index].achPcs.toString())!.toStringAsFixed(4)}" : "${double.tryParse(_filteredData[index].achTonnage.toString())!.toStringAsFixed(4)}", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w500,textColor: Colors.black)),),
                            Expanded(child: Center(child: textWidget(text: widget.selectedDistribution == "Pcs" ? "${calculatePercentage(double.tryParse(_filteredData[index].achPcs.toString()) ?? 0.0, double.tryParse(_filteredData[index].targetPcs.toString()) ?? 0.0).toStringAsFixed(2)}" : "${calculatePercentage(double.tryParse(_filteredData[index].achTonnage.toString()) ?? 0.0, double.tryParse(_filteredData[index].targetTonnage.toString()) ?? 0.0).toStringAsFixed(2)}", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w500,textColor: Colors.black)),),
                          ],
                        ),
                      );
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }

  double calculatePercentage(double current, double target) {
    if (target == 0) {
      return 0.0; // To avoid division by zero
    }
    return ((target / current) * 100).toDouble();
  }
}
