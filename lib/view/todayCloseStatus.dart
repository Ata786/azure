import 'package:SalesUp/model/dayCloseModel.dart';
import 'package:SalesUp/res/base/fetch_pixels.dart';
import 'package:SalesUp/utils/widgets/appWidgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TodayNotCloseScreen extends StatefulWidget {
  int value;
  List<DayCloseModel> list = [];
  TodayNotCloseScreen({super.key,required this.value,required this.list});

  @override
  State<TodayNotCloseScreen> createState() => _TodayNotCloseScreenState();
}

class _TodayNotCloseScreenState extends State<TodayNotCloseScreen> {

  bool i = false;



  List<DayCloseModel> originalList = [];

  onSearchQueryChanged(query){
    setState(() {
      if (query.isEmpty) {
        // If the query is empty, show the original unfiltered data
        originalList = List.from(widget.list);
      } else {
        // Filter the original data based on the search query
        originalList = widget.list
            .where((item) =>
            item.distributorName!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();
    originalList = List.from(widget.list);
  }

  TextEditingController searchCtr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return Scaffold(
      appBar: AppBar(
        title: textWidget(
          textColor: Colors.white,
          text: widget.value == 0 ? "Distribution Day Close Status" : "Not Day Close Distribution List",
          fontSize: FetchPixels.getPixelHeight(17),
          fontWeight: FontWeight.w600,
        ),
        actions: [
          InkWell(
              onTap: (){

              },
              child: Icon(Icons.filter_alt_sharp,color: Colors.white,)),
          SizedBox(width: FetchPixels.getPixelWidth(20),),
        ],
      ),
      body: Container(
        height: FetchPixels.height,
        width: FetchPixels.width,
        child: Column(
          children: [
            SizedBox(height: FetchPixels.getPixelHeight(15),),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(15)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  i == true ? Expanded(
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
                          i = !i;
                          searchCtr.text = '';
                        });
                      },
                      child: Icon(i == true ? Icons.close : Icons.search)),
                ],
              ),
            ),
            SizedBox(height: FetchPixels.getPixelHeight(20),),
           Padding(
             padding: EdgeInsets.only(left: 8),
             child: Row(
               children: [
                 Expanded(
                   child: textWidget(
                     textColor: Colors.black,
                     text: "Name",
                     fontSize: FetchPixels.getPixelHeight(17),
                     fontWeight: FontWeight.w600,
                   ),
                 ),
                 Expanded(
                   child: textWidget(
                     textColor: Colors.black,
                     text: "Day Close Date",
                     fontSize: FetchPixels.getPixelHeight(17),
                     fontWeight: FontWeight.w600,
                   ),
                 ),
                 Expanded(
                   child: textWidget(
                     textColor: Colors.black,
                     text: "City",
                     fontSize: FetchPixels.getPixelHeight(17),
                     fontWeight: FontWeight.w600,
                   ),
                 ),
               ],
             ),
           ),
            SizedBox(height: FetchPixels.getPixelHeight(20),),
            Expanded(
              child: ListView.builder(
                  itemCount: originalList.length,
                  itemBuilder: (context,index){
                    originalList.sort((a, b) => a.tname!.compareTo(b.tname!));
                return   Padding(
                  padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(8),vertical: FetchPixels.getPixelHeight(10)),
                  child: Row(
                    children: [
                      Expanded(
                        child: textWidget(
                          maxLines: 2,
                          textColor: Colors.black,
                          text: "${originalList[index].distributorName}",
                          fontSize: FetchPixels.getPixelHeight(15),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Expanded(
                        child: textWidget(
                          textColor: Colors.black,
                          text: "${date(originalList[index].dcdate!)}",
                          fontSize: FetchPixels.getPixelHeight(15),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Expanded(child: textWidget(
                        textColor: Colors.black,
                        text: "${originalList[index].tname}",
                        fontSize: FetchPixels.getPixelHeight(15),
                        fontWeight: FontWeight.w500,
                      ),),
                    ],
                  ),
                );
              }),
            )
          ],
        ),
      ),
    );
  }

  String date(String d){
    DateTime inputDate = DateTime.parse(d);

    String formattedDate = DateFormat("dd MMM yyyy").format(inputDate);
  return formattedDate;
  }
}
