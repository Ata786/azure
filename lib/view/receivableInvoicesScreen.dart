import 'dart:developer';

import 'package:SalesUp/model/receivableInvoicesModel.dart';
import 'package:SalesUp/res/base/fetch_pixels.dart';
import 'package:SalesUp/res/colors.dart';
import 'package:SalesUp/utils/widgets/appWidgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReceivableInvoicesScreen extends StatefulWidget {
  late ReceivableInvoicesModel receivableInvoicesModel;
  String from = '',to = '';
  int value;
  ReceivableInvoicesScreen({super.key,required this.receivableInvoicesModel,required this.from,required this.to,required this.value});

  @override
  State<ReceivableInvoicesScreen> createState() => _ReceivableInvoicesScreenState();
}

class _ReceivableInvoicesScreenState extends State<ReceivableInvoicesScreen> {


  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
        title: textWidget(text: widget.value == 0 ? "Receivable Invoices" : "Recovered Invoices", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w600,textColor: Colors.white),
      ),
      body: Container(
        height: FetchPixels.height,
        width: FetchPixels.width,
        padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(10)),
        child: widget.value == 0 ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: FetchPixels.getPixelHeight(20),),
         Row(
           children: [
             textWidget(text: "From - To:-   ", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w600,textColor: Colors.black),
             textWidget(text: "${widget.from} - ${widget.to}", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w500,textColor: Colors.black),
           ],
         ),
           SizedBox(height: FetchPixels.getPixelHeight(10),),
           Expanded(child: widget.receivableInvoicesModel.reciveableInvoices!.isEmpty
                ? Center(child:  textWidget(text: "No Record Found", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w600,textColor: Colors.black))
            : CustomScrollView(
              slivers: [
                SliverList(delegate: SliverChildBuilderDelegate(
                  childCount: widget.receivableInvoicesModel.reciveableInvoices!.length,
                    (context,i){
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: FetchPixels.getPixelHeight(10),),
                          Row(
                            children: [
                              textWidget(text: "Distributor Name:-  ", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w600,textColor: Colors.black),
                              textWidget(text: "${widget.receivableInvoicesModel.reciveableInvoices![i].distributorName}", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w400,textColor: Colors.black),
                            ],
                          ),
                          SizedBox(height: FetchPixels.getPixelHeight(20),),
                          Row(
                            children: [
                              Expanded(
                                  flex: 2,
                                  child: textWidget(text: "Shop", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w600,textColor: Colors.black)),
                              Expanded( flex: 3,child: textWidget(text: "Date", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w600,textColor: Colors.black)),
                              Expanded( flex: 3,child: textWidget(text: "Amount", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w600,textColor: Colors.black)),
                              Expanded( flex: 2,child: textWidget(text: "Recovery", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w600,textColor: Colors.black)),
                              Expanded( flex: 2,child: Center(child: textWidget(text: "BillNo", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w600,textColor: Colors.black)))
                            ],
                          ),
                          for(int index = 0; index<widget.receivableInvoicesModel.reciveableInvoices![i].invoices.length; index++)
                       Column(
                      children: [
                      SizedBox(height: FetchPixels.getPixelHeight(10),),
                      Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      Expanded(flex: 2,child: textWidget(maxLines: 3,text: "${widget.receivableInvoicesModel.reciveableInvoices![i].invoices[index].shopName}", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w400,textColor: Colors.black)),
                      Expanded( flex: 3,child: textWidget(maxLines: 2,text: "${DateFormat("d MMM yyyy").format(DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(widget.receivableInvoicesModel.reciveableInvoices![i].invoices[index].reciveableDate!))}", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w400,textColor: Colors.black)),
                      Expanded( flex: 3,child: textWidget(text: "${widget.receivableInvoicesModel.reciveableInvoices![i].invoices[index].reciveableAmount!.toInt()}", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w400,textColor: Colors.black)),
                      Expanded(flex: 2,child: textWidget(text: "${widget.receivableInvoicesModel.reciveableInvoices![i].invoices[index].recoverAmount.toInt()}", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w400,textColor: Colors.black)),
                      Expanded(flex: 2,child: Center(child: textWidget(text: "${widget.receivableInvoicesModel.reciveableInvoices![i].invoices[index].billNoId.toString()}", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w400,textColor: Colors.black)))
                      ],
                      ),
                      ],
                      ),
                          Divider(),
                        ],
                      );
                    }
                ))
              ],
            )),
        ],)
        : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: FetchPixels.getPixelHeight(15),),
            Row(
              children: [
                textWidget(text: "From - To:-   ", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w600,textColor: Colors.black),
                textWidget(text: "${widget.from} - ${widget.to}", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w500,textColor: Colors.black),
              ],
            ),
            SizedBox(height: FetchPixels.getPixelHeight(10),),
            Expanded(child: widget.receivableInvoicesModel.recoveryInvoices!.isEmpty
                ? Center(child:  textWidget(text: "No Record Found", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w600,textColor: Colors.black))
                : CustomScrollView(
              slivers: [
                SliverList(delegate: SliverChildBuilderDelegate(
                    childCount: widget.receivableInvoicesModel.recoveryInvoices!.length,
                        (context,i){
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: FetchPixels.getPixelHeight(10),),
                          Row(
                            children: [
                              textWidget(text: "Distributor Name:-  ", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w600,textColor: Colors.black),
                              textWidget(text: "${widget.receivableInvoicesModel.recoveryInvoices![i].distributorName}", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w400,textColor: Colors.black),
                            ],
                          ),
                          SizedBox(height: FetchPixels.getPixelHeight(20),),
                          Row(
                            children: [
                              Expanded(
                                  flex: 2,
                                  child: textWidget(text: "Shop", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w600,textColor: Colors.black)),
                              Expanded( flex: 3,child: textWidget(text: "Date", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w600,textColor: Colors.black)),
                              Expanded( flex: 3,child: textWidget(text: "Amount", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w600,textColor: Colors.black)),
                              Expanded( flex: 2,child: textWidget(text: "Recovery", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w600,textColor: Colors.black)),
                              Expanded( flex: 2,child: Center(child: textWidget(text: "BillNo", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w600,textColor: Colors.black)))
                            ],
                          ),
                          for(int index = 0; index<widget.receivableInvoicesModel.recoveryInvoices![i].invoices.length; index++)
                            Column(
                              children: [
                                SizedBox(height: FetchPixels.getPixelHeight(10),),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(flex: 2,child: textWidget(maxLines: 3,text: "${widget.receivableInvoicesModel.recoveryInvoices![i].invoices[index].shopName}", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w400,textColor: Colors.black)),
                                    Expanded( flex: 3,child: textWidget(maxLines: 2,text: "${DateFormat("d MMM yyyy").format(DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(widget.receivableInvoicesModel.recoveryInvoices![i].invoices[index].reciveableDate!))}", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w400,textColor: Colors.black)),
                                    Expanded( flex: 3,child: textWidget(text: "${widget.receivableInvoicesModel.recoveryInvoices![i].invoices[index].reciveableAmount!.toInt()}", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w400,textColor: Colors.black)),
                                    Expanded(flex: 2,child: textWidget(text: "${widget.receivableInvoicesModel.recoveryInvoices![i].invoices[index].recoverAmount.toInt()}", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w400,textColor: Colors.black)),
                                    Expanded(flex: 2,child: Center(child: textWidget(text: "${widget.receivableInvoicesModel.recoveryInvoices![i].invoices[index].billNoId.toString()}", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w400,textColor: Colors.black)))
                                  ],
                                ),
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
