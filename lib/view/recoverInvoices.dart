import 'package:SalesUp/model/receivableInvoicesModel.dart';
import 'package:SalesUp/res/base/fetch_pixels.dart';
import 'package:SalesUp/res/colors.dart';
import 'package:SalesUp/utils/widgets/appWidgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RecoverInvoicesScreen extends StatelessWidget {
  late ReceivableInvoicesModel receivableInvoicesModel;
  String year = '',value = '';
  RecoverInvoicesScreen({super.key,required this.receivableInvoicesModel,required this.year,required this.value});

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
        title: textWidget(text: "Recovered Invoices", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w600,textColor: Colors.white),
      ),
      body: Container(
        height: FetchPixels.height,
        width: FetchPixels.width,
        padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: FetchPixels.getPixelHeight(15),),
            textWidget(text: "${value} Wise", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w600,textColor: Colors.black),
            SizedBox(height: FetchPixels.getPixelHeight(10),),
            Expanded(child: CustomScrollView(
              slivers: [
                SliverList(delegate: SliverChildBuilderDelegate(
                    childCount: receivableInvoicesModel.recoveryInvoices!.length,
                        (context,i){
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: FetchPixels.getPixelHeight(10),),
                          Row(
                            children: [
                              textWidget(text: "Distributor Name:-  ", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w600,textColor: Colors.black),
                              textWidget(text: "${receivableInvoicesModel.recoveryInvoices![i].distributorName}", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w400,textColor: Colors.black),
                            ],
                          ),
                          SizedBox(height: FetchPixels.getPixelHeight(20),),
                          Row(
                            children: [
                              Expanded(
                                  flex: 2,
                                  child: textWidget(text: "Shop", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w600,textColor: Colors.black)),
                              Expanded( flex: 3,child: textWidget(text: "Date", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w600,textColor: Colors.black)),
                              Expanded( flex: 2,child: textWidget(text: "Recovery", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w600,textColor: Colors.black)),
                              Expanded( flex: 2,child: Center(child: textWidget(text: "BillNo", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w600,textColor: Colors.black)))
                            ],
                          ),
                          for(int index = 0; index<receivableInvoicesModel.recoveryInvoices![i].invoices.length; index++)
                            Column(
                              children: [
                                SizedBox(height: FetchPixels.getPixelHeight(10),),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(flex: 2,child: textWidget(maxLines: 3,text: "${receivableInvoicesModel.recoveryInvoices![i].invoices[index].shopName}", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w400,textColor: Colors.black)),
                                    Expanded( flex: 3,child: textWidget(maxLines: 2,text: "${DateFormat("d MMM yyyy").format(DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(receivableInvoicesModel.recoveryInvoices![i].invoices[index].recoveryDate!))}", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w400,textColor: Colors.black)),
                                    Expanded(flex: 2,child: textWidget(text: "${receivableInvoicesModel.recoveryInvoices![i].invoices[index].recoveredAmount!.toInt()}", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w400,textColor: Colors.black)),
                                    Expanded(flex: 2,child: Center(child: textWidget(text: "${receivableInvoicesModel.recoveryInvoices![i].invoices[index].billNoId.toString()}", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w400,textColor: Colors.black)))
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
