import 'dart:developer';

import 'package:SalesUp/controllers/syncNowController.dart';
import 'package:SalesUp/data/hiveDb.dart';
import 'package:SalesUp/model/invoiceModel.dart';
import 'package:SalesUp/model/syncDownModel.dart';
import 'package:SalesUp/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../model/orderModel.dart';
import '../model/productsModel.dart';
import '../res/base/fetch_pixels.dart';
import '../utils/widgets/appWidgets.dart';

class InvoiceScreen extends StatefulWidget {
  String shopId;
  InvoiceScreen({super.key,required this.shopId});

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {

  OrderModel? order;
  SyncDownModel? syncDownModel;
  List<InvoiceModel> invoiceList = [];

  @override
  void initState() {
    getOrder();
    super.initState();
  }

  void getOrder()async{

    SyncNowController syncNowController = Get.find<SyncNowController>();

    List<OrderModel> list =
    await HiveDatabase.getOrderData(
        "orderBox", "order");

    for(int or=0; or<list.length; or++){
      if(list[or].shopId.toString() == widget.shopId.toString()){

        String netRate = list[or].orderDataModel!.netRate;
        int quantity = list[or].orderDataModel!.quantity;
        double weight = list[or].weight;

        var box = await Hive.openBox("productsBox");
        List<dynamic> data = box.get("products") ?? [];
        List<ProductsModel> productsList = data.map((e) => ProductsModel(sr: e.sr,pname: e.pname,wgm: e.wgm,brandName: e.brandName,
            netRate: e.netRate,rateId: e.rateId,quantity: e.quantity,subTotal: e.subTotal,retail: e.retail,weight: e.weight,tonnage: e.tonnage,fixedRate: e.fixedRate,tonagePerPcs: e.tonagePerPcs)).toList();

        for(int i=0; i<productsList.length; i++){
          if(productsList[i].sr.toString() == list[or].orderDataModel!.productId.toString()){
            String pName = productsList[i].pname ?? "";
            invoiceList.add(InvoiceModel(skuName: pName,skuPrice: netRate,weight: weight,qty: quantity));
          }
        }

      }
    }

    order = list.where((element) => element.shopId.toString() == widget.shopId.toString()).first;
    syncDownModel = syncNowController.syncDownList.where((p0) => p0.sr.toString() == order!.shopId.toString()).first;


    setState(() {

    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
        title:  textWidget(text: "Invoice", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w600,textColor: Colors.white),
      ),
      body: Container(
        height: FetchPixels.height,
        width: FetchPixels.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: FetchPixels.getPixelHeight(10),),
            Padding(
              padding: EdgeInsets.only(left: FetchPixels.getPixelWidth(15)),
              child: textWidget(text: "Shop Name :- ${syncDownModel == null ? "" : syncDownModel!.shopname}", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w500,textColor: Colors.black),
            ),
            Padding(
              padding: EdgeInsets.only(left: FetchPixels.getPixelWidth(15)),
              child: textWidget(text: "Order/Invoice No. :- ${order == null ? "" : order!.orderNumber}", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w500,textColor: Colors.black),
            ),
            Padding(
              padding: EdgeInsets.only(left: FetchPixels.getPixelWidth(15)),
              child: textWidget(text: "Date :- ${order == null ? "" : order!.pjpDate}", fontSize: FetchPixels.getPixelHeight(15), fontWeight: FontWeight.w500,textColor: Colors.black),
            ),
            SizedBox(height: FetchPixels.getPixelHeight(10),),
            Container(
              height: FetchPixels.getPixelHeight(70),
              width: FetchPixels.width,
              color: Color(0xff616161),
              child: Row(
                children: [
                  Expanded(
                      flex: 2,
                      child: Center(child: textWidget(text: "SKU Name", fontSize: FetchPixels.getPixelHeight(13), fontWeight: FontWeight.w600,textColor: Colors.white))),
                  Expanded( flex: 2,child: Center(child: textWidget(text: "SKU Price", fontSize: FetchPixels.getPixelHeight(13), fontWeight: FontWeight.w600,textColor: Colors.white))),
                  Expanded( flex: 1,
                      child: Center(child: textWidget(text: "Qty", fontSize: FetchPixels.getPixelHeight(13), fontWeight: FontWeight.w600,textColor: Colors.white))),
                  Expanded( flex: 2,child: Center(child: textWidget(text: "Weight", fontSize: FetchPixels.getPixelHeight(13), fontWeight: FontWeight.w600,textColor: Colors.white))),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: invoiceList.length,
                  itemBuilder: (context,index){
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                        flex: 2,
                        child: Center(child: Padding(
                          padding: EdgeInsets.all(3.0),
                          child: textWidget(textAlign: TextAlign.center,maxLines: 2,text: "${invoiceList[index].skuName}", fontSize: FetchPixels.getPixelHeight(13), fontWeight: FontWeight.w500,textColor: primaryColor),
                        ))),
                    Expanded(
                        flex: 2,
                        child: Center(child: textWidget(text: "${invoiceList[index].skuPrice}", fontSize: FetchPixels.getPixelHeight(13), fontWeight: FontWeight.w500,textColor: primaryColor))),
                    Expanded(flex: 1,child: Center(child: textWidget(text: "${invoiceList[index].qty}", fontSize: FetchPixels.getPixelHeight(13), fontWeight: FontWeight.w500,textColor: primaryColor))),
                    Expanded(flex: 2,child: Center(child: textWidget(text: "${invoiceList[index].weight}", fontSize: FetchPixels.getPixelHeight(13), fontWeight: FontWeight.w500,textColor: primaryColor))),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
