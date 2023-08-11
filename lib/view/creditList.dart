import 'package:azure/res/base/fetch_pixels.dart';
import 'package:azure/res/colors.dart';
import 'package:azure/utils/widgets/appWidgets.dart';
import 'package:flutter/material.dart';

class CreditList extends StatefulWidget {
  CreditList({super.key});

  @override
  State<CreditList> createState() => _CreditListState();
}

class _CreditListState extends State<CreditList> {

  TextEditingController searchCtr = TextEditingController();
  int tappedIndex = -1;

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return Scaffold(
      appBar: AppBar(title: textWidget(text: "Credit List",textColor: Colors.white, fontSize: FetchPixels.getPixelHeight(16), fontWeight:FontWeight.w600),),
      body: Container(
        height: FetchPixels.height,
        width: FetchPixels.width,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
          child: Column(
            children: [
              SizedBox(height: FetchPixels.getPixelHeight(20),),
      TextFormField(
            controller: searchCtr,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
                isDense: true,
                fillColor: Colors.white,
                filled: true,
                hintText: "Search....",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(30)),
                    borderSide: BorderSide(color: Colors.black, width: 1)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(30)),
                    borderSide: BorderSide(color: Colors.black, width: 1)),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(30)),
                    borderSide: BorderSide(color: Colors.red, width: 1)),
                focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(30)),
                    borderSide: BorderSide(color: Colors.red, width: 1)),
                suffixIcon: Icon(Icons.search)
            )
      ),
              SizedBox(height: FetchPixels.getPixelHeight(20),),
              Expanded(
                  child: ListView.builder(
                    itemCount: 5,
                  itemBuilder: (context,index){
                    return InkWell(
                      onTap: (){
                        setState(() {
                          tappedIndex = index;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: FetchPixels.getPixelHeight(10)),
                        height: index == tappedIndex ? FetchPixels.getPixelHeight(300) : FetchPixels.getPixelHeight(100),
                        width: FetchPixels.width,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 3),
                              color: Colors.grey.withOpacity(0.2)
                            )
                          ],
                          color: Colors.white
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20),vertical: FetchPixels.getPixelHeight(10)),
                          child: tappedIndex == index
                              ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              textWidget(text: "Invoice No: 12345",textColor: primaryColor, fontSize: FetchPixels.getPixelHeight(14), fontWeight:FontWeight.w600),
                              SizedBox(height: FetchPixels.getPixelHeight(10),),
                              Container(height: FetchPixels.getPixelHeight(1),color: Colors.black,),
                              SizedBox(height: FetchPixels.getPixelHeight(15),),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  textWidget(text: "Store Name",textColor: themeColor, fontSize: FetchPixels.getPixelHeight(14), fontWeight:FontWeight.w600),
                                  textWidget(text: "Johar Town",textColor: themeColor, fontSize: FetchPixels.getPixelHeight(14), fontWeight:FontWeight.w600),
                                ],
                              ),
                              SizedBox(height: FetchPixels.getPixelHeight(20),),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        textWidget(text: "Date",textColor: primaryColor, fontSize: FetchPixels.getPixelHeight(13), fontWeight:FontWeight.w600),
                                        textWidget(text: "8/6/2023",textColor: primaryColor, fontSize: FetchPixels.getPixelHeight(13), fontWeight:FontWeight.w600),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        textWidget(text: "Amount",textColor: primaryColor, fontSize: FetchPixels.getPixelHeight(13), fontWeight:FontWeight.w600),
                                        textWidget(text: "100.0000",textColor: primaryColor, fontSize: FetchPixels.getPixelHeight(13), fontWeight:FontWeight.w600),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        textWidget(text: "Realized Amount",textColor: primaryColor, fontSize: FetchPixels.getPixelHeight(13), fontWeight:FontWeight.w600),
                                        textWidget(text: "100.0000",textColor: primaryColor, fontSize: FetchPixels.getPixelHeight(13), fontWeight:FontWeight.w600),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        textWidget(text: "Rest Amount",textColor: primaryColor, fontSize: FetchPixels.getPixelHeight(13), fontWeight:FontWeight.w600),
                                        textWidget(text: "100.0000",textColor: primaryColor, fontSize: FetchPixels.getPixelHeight(13), fontWeight:FontWeight.w600),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: FetchPixels.getPixelHeight(15),),
                              TextFormField(
                                maxLines: 2,
                                  controller: searchCtr,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  decoration: InputDecoration(
                                      isDense: true,
                                      fillColor: Colors.white,
                                      filled: true,
                                      hintText: "Recovery Amount",
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(10)),
                                          borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1)),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(10)),
                                          borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1)),
                                      errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(10)),
                                          borderSide: BorderSide(color: Colors.red, width: 1)),
                                      focusedErrorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(10)),
                                          borderSide: BorderSide(color: Colors.red, width: 1)),
                                  )
                              ),
                              SizedBox(height: FetchPixels.getPixelHeight(15),),
                              Align(
                                alignment: Alignment.center,
                                child: button(height: FetchPixels.getPixelHeight(35),
                                    width: FetchPixels.getPixelWidth(150), color: themeColor, textColor: Colors.white, textSize: FetchPixels.getPixelHeight(20), borderRadius: FetchPixels.getPixelHeight(8), textWeight: FontWeight.w500, text: "Save"),
                              )
                            ],
                          )
                          : Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              textWidget(text: "Invoice No: 12345",textColor: primaryColor, fontSize: FetchPixels.getPixelHeight(14), fontWeight:FontWeight.w600),
                             Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  textWidget(text: "Store Name",textColor: primaryColor, fontSize: FetchPixels.getPixelHeight(14), fontWeight:FontWeight.w600),
                                  textWidget(text: "Johar Town",textColor: primaryColor, fontSize: FetchPixels.getPixelHeight(14), fontWeight:FontWeight.w600),
                                ],
                              )
                            ],),
                        ),
                      ),
                    );
                  })),
              SizedBox(height: FetchPixels.getPixelHeight(20),)
            ],
          ),
        ),
      ),
    );
  }
}
