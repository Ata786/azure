import 'package:SalesUp/controllers/syncNowController.dart';
import 'package:SalesUp/data/hiveDb.dart';
import 'package:SalesUp/model/syncDownModel.dart';
import 'package:SalesUp/res/base/fetch_pixels.dart';
import 'package:SalesUp/res/colors.dart';
import 'package:SalesUp/utils/widgets/appWidgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../model/creditModel.dart';


class CreditList extends StatefulWidget {
  CreditList({super.key});

  @override
  State<CreditList> createState() => _CreditListState();
}

class _CreditListState extends State<CreditList> {


  List<CreditModel> creditList = [];
  List<SyncDownModel> shopList = [];
  String searchQuery = '';
  List<CreditModel> filteredCreditList = [];
  List<TextEditingController> recoveryControllers = [];

  @override
  void initState() {
    fetchCredits();
    super.initState();
  }

  void fetchCredits()async{
    SyncNowController syncNowController = Get.find<SyncNowController>();
    creditList = await HiveDatabase.getCreditList("creditBox", "credit");
    shopList = syncNowController.syncDownList;

    filteredCreditList = List.from(creditList);
    recoveryControllers = List.generate(filteredCreditList.length, (_) => TextEditingController());

    setState(() {
      
    });
  }

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
            ),
        onChanged: (v){
          setState(() {
            searchQuery = v;
            filteredCreditList = creditList.where((credit) {
              SyncDownModel shopModel =
              shopList.firstWhere((element) => element.sr == credit.shopId);
              return shopModel.shopname!.toLowerCase().contains(v.toLowerCase());
            }).toList();
          });
        },
      ),
              SizedBox(height: FetchPixels.getPixelHeight(20),),
              Expanded(
                  child: ListView.builder(
                    itemCount: filteredCreditList.length,
                  itemBuilder: (context,index){
                    double relisedAmount = double.tryParse(filteredCreditList[index].realisedAmount.toString()) ?? 0.0;
                    double billAmount = filteredCreditList[index].billAmount ?? 0.0;
                    SyncDownModel shopModel = shopList.where((element) => element.sr == filteredCreditList[index].shopId).first;
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
                              textWidget(text: "Invoice No: ${filteredCreditList[index].billNoId}",textColor: primaryColor, fontSize: FetchPixels.getPixelHeight(14), fontWeight:FontWeight.w600),
                              SizedBox(height: FetchPixels.getPixelHeight(10),),
                              Container(height: FetchPixels.getPixelHeight(1),color: Colors.black,),
                              SizedBox(height: FetchPixels.getPixelHeight(15),),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  textWidget(text: "Shop Name",textColor: themeColor, fontSize: FetchPixels.getPixelHeight(14), fontWeight:FontWeight.w600),
                                  textWidget(text: "${shopModel.shopname}",textColor: themeColor, fontSize: FetchPixels.getPixelHeight(14), fontWeight:FontWeight.w600),
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
                                        textWidget(text: filteredCreditList[index].recieveableDate == null || filteredCreditList[index].recieveableDate == "" ? "" : "${parseDate(filteredCreditList[index].recieveableDate!)}",textColor: primaryColor, fontSize: FetchPixels.getPixelHeight(13), fontWeight:FontWeight.w600),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        textWidget(text: "Amount",textColor: primaryColor, fontSize: FetchPixels.getPixelHeight(13), fontWeight:FontWeight.w600),
                                        textWidget(text: "${filteredCreditList[index].billAmount}",textColor: primaryColor, fontSize: FetchPixels.getPixelHeight(13), fontWeight:FontWeight.w600),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        textWidget(text: "Realized Amount",textColor: primaryColor, fontSize: FetchPixels.getPixelHeight(13), fontWeight:FontWeight.w600),
                                        textWidget(text: filteredCreditList[index].realisedAmount == null ? "0" : "${filteredCreditList[index].realisedAmount}",textColor: primaryColor, fontSize: FetchPixels.getPixelHeight(13), fontWeight:FontWeight.w600),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        textWidget(text: "Rest Amount",textColor: primaryColor, fontSize: FetchPixels.getPixelHeight(13), fontWeight:FontWeight.w600),
                                        textWidget(text: "${billAmount - relisedAmount}",textColor: primaryColor, fontSize: FetchPixels.getPixelHeight(13), fontWeight:FontWeight.w600),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: FetchPixels.getPixelHeight(15),),
                              TextFormField(
                                maxLines: 2,
                                  keyboardType: TextInputType.number,
                                  controller: recoveryControllers[index],
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
                                  ),
                              ),
                              SizedBox(height: FetchPixels.getPixelHeight(15),),
                              Align(
                                alignment: Alignment.center,
                                child: InkWell(
                                  onTap: (){
                                    double restAmount = billAmount - relisedAmount;
                                    double recoveryAmount = double.tryParse(recoveryControllers[index].text) ?? 0.0;

                                    if(recoveryAmount > restAmount){
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(behavior: SnackBarBehavior.floating,content: textWidget(text: "Recover Amount should be not increase from Rest Amount",textColor: Colors.white, fontSize: FetchPixels.getPixelHeight(14), fontWeight:FontWeight.w600),));
                                    }else{
                                      int creditIndex = creditList.indexWhere((element) => element.shopId == filteredCreditList[index].shopId);
                                      if(creditIndex != -1){
                                        creditList[creditIndex].recovery = recoveryAmount;
                                        HiveDatabase.setCreditList("creditBox", "credit", creditList);
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(behavior: SnackBarBehavior.floating,content:   textWidget(text: "Recovery successfully save",textColor: Colors.white, fontSize: FetchPixels.getPixelHeight(14), fontWeight:FontWeight.w600),));
                                       setState(() {
                                         tappedIndex = -1;
                                       });
                                      }
                                    }

                                  },
                                  child: button(height: FetchPixels.getPixelHeight(35),
                                      width: FetchPixels.getPixelWidth(150), color: themeColor, textColor: Colors.white, textSize: FetchPixels.getPixelHeight(20), borderRadius: FetchPixels.getPixelHeight(8), textWeight: FontWeight.w500, text: "Save"),
                                ),
                              )
                            ],
                          )
                          : Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              textWidget(text: "Invoice No: ${filteredCreditList[index].billNoId}",textColor: primaryColor, fontSize: FetchPixels.getPixelHeight(14), fontWeight:FontWeight.w600),
                             Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  textWidget(text: "Shop Name",textColor: primaryColor, fontSize: FetchPixels.getPixelHeight(14), fontWeight:FontWeight.w600),
                                  textWidget(text: "${shopModel.shopname}",textColor: primaryColor, fontSize: FetchPixels.getPixelHeight(14), fontWeight:FontWeight.w600),
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

  String parseDate(String inputDate){
    DateTime dateTime = DateTime.parse(inputDate);

    String formattedDate = DateFormat("MM/dd/yyyy").format(dateTime);
    return formattedDate;
  }


}
