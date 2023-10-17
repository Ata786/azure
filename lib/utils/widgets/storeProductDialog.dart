import 'dart:developer';

import 'package:SalesUp/controllers/shopServiceController.dart';
import 'package:SalesUp/res/base/fetch_pixels.dart';
import 'package:SalesUp/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../../model/orderModel.dart';
import '../../model/productsModel.dart';
import '../../model/reateDetailModel.dart';
import '../../res/images.dart';
import 'appWidgets.dart';

void showStoreProductDialog({required int argumentSr,required ShopServiceController shopServiceController,required sr,required productName,required List<RateDetailModel> rateDetail,required Function(dynamic value) onDialogClosed}){
  List<RateDetailModel> rates1 = rateDetail.where((element) => element.productId == sr).toList();
  shopServiceController.netRate.value = rates1[0].netRate!.toStringAsFixed(6);
  Get.dialog(
      AlertDialog(
        content: Container(
            height: FetchPixels.height/1.8,
            child: StoreProductDialogContent(argumentSr: argumentSr,rates1: rates1,shopServiceController: shopServiceController, sr: sr, productName: productName, rateDetail: rateDetail,)),
      )
  ).then(onDialogClosed);

}


class StoreProductDialogContent extends StatefulWidget {
  final List<RateDetailModel> rates1;
  final ShopServiceController shopServiceController;
  final dynamic sr;
  final dynamic productName;
  final List<RateDetailModel> rateDetail;
  final int argumentSr;

  StoreProductDialogContent({super.key,required this.argumentSr,required this.rates1, required this.shopServiceController, this.sr, this.productName, required this.rateDetail});

  @override
  State<StoreProductDialogContent> createState() => _StoreProductDialogContentState();
}

class _StoreProductDialogContentState extends State<StoreProductDialogContent> {

  late TextEditingController qtyController;
  late TextEditingController priceController;

  @override
  void initState() {
    super.initState();
    priceController = TextEditingController(text: "${widget.shopServiceController.netRate.value.toString()}");
    qtyController = TextEditingController(text: "0");
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      height: FetchPixels.height/2,
      width: FetchPixels.width,
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: FetchPixels.getPixelHeight(10),),
            Image.asset(basket,height: FetchPixels.getPixelHeight(30),width: FetchPixels.getPixelWidth(30),),
            SizedBox(height: FetchPixels.getPixelHeight(20),),
            textWidget(text: widget.productName, fontSize: FetchPixels.getPixelHeight(16), fontWeight: FontWeight.w600,textColor: Colors.blue),
            Column(
              children: List.generate(widget.rates1.length, (index) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Obx(() => Radio(
                      activeColor: themeColor,
                      value: index,
                      groupValue: widget.shopServiceController.radio.value,
                      onChanged: (v){
                        widget.shopServiceController.radio.value = v!;
                        widget.shopServiceController.netRate.value = widget.rates1[v].netRate!.toStringAsFixed(6);
                      })),
                  textWidget(text: widget.rates1[index].rateName ?? "", fontSize: FetchPixels.getPixelHeight(13), fontWeight: FontWeight.w600,textColor: primaryColor),
                  Spacer(),
                  Spacer(),
                  textWidget(text: "${widget.rates1[index].netRate!.toStringAsFixed(6)}", fontSize: FetchPixels.getPixelHeight(13), fontWeight: FontWeight.w600,textColor: primaryColor),
                  Spacer(),
                  Spacer(),
                  Spacer(),
                  Spacer(),
                  textWidget(text: "${widget.rates1[index].stock}", fontSize: FetchPixels.getPixelHeight(13), fontWeight: FontWeight.w600,textColor: Colors.green),
                ],
              ),),
            ),
            SizedBox(height: FetchPixels.getPixelHeight(10),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                textWidget(text: "Price:-", fontSize: FetchPixels.getPixelHeight(13), fontWeight: FontWeight.w600,textColor: primaryColor),
                Container(
                    child: Row(
                      children: [
                        Expanded(flex: 2,child: Padding(
                          padding: EdgeInsets.only(left: FetchPixels.getPixelWidth(10)),
                          // child: textWidget(text: widget.shopServiceController.netRate.value, fontSize: FetchPixels.getPixelHeight(13), fontWeight: FontWeight.w600,textColor: primaryColor),
                          child: TextFormField(
                            controller: priceController,
                            onChanged: (v){
                              widget.shopServiceController.netRate.value = v.toString();
                            },
                          ),
                        )),
                        Expanded(flex: 1,child: Container(
                          child: Row(
                            children: [
                              InkWell(
                                  onTap: (){
                                    double? rate = double.tryParse(widget.shopServiceController.netRate.value);
                                    if(widget.shopServiceController.netRate.value == widget.rates1[0].netRate!.toStringAsFixed(6)){
                                    }else if (rate != null){
                                      rate++;
                                      widget.shopServiceController.netRate.value = rate.toString();
                                      priceController.text = rate.toString();
                                    }

                                  },
                                  child: Icon(Icons.arrow_upward)),
                              Spacer(),
                              InkWell(
                                  onTap: (){
                                    double? rate = double.tryParse(widget.shopServiceController.netRate.value);
                                    if(rate != null){
                                      rate--;
                                      widget.shopServiceController.netRate.value = rate.toString();
                                      priceController.text = rate.toString();
                                    }
                                  },
                                  child: Icon(Icons.arrow_downward)),
                              Spacer(),
                            ],
                          ),
                        ))
                      ],
                    ),
                    height: FetchPixels.getPixelHeight(50),
                    width: FetchPixels.getPixelWidth(180),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black)
                    )
                ),
              ],
            ),
            SizedBox(height: FetchPixels.getPixelHeight(10),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                textWidget(text: "Qty:-", fontSize: FetchPixels.getPixelHeight(13), fontWeight: FontWeight.w600,textColor: primaryColor),
                InkWell(
                  onTap: (){
                    if(widget.shopServiceController.quantity.value != 0){
                      widget.shopServiceController.quantity.value--;
                      qtyController.text = widget.shopServiceController.quantity.value.toString();
                    }
                  },
                  child: Container(
                    height: FetchPixels.getPixelHeight(25),
                    width: FetchPixels.getPixelWidth(25),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Center(child: Icon(Icons.remove),),
                  ),
                ),
                Container(
                  width: FetchPixels.getPixelWidth(100),
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    controller: qtyController,
                  ),
                ),
                // SizedBox(
                //   width: FetchPixels.getPixelWidth(100),
                //   child: Center(child: Obx(() => Text("${widget.shopServiceController.quantity.value}"))),
                // ),
                InkWell(
                  onTap: (){
                    widget.shopServiceController.quantity.value++;
                    qtyController.text = widget.shopServiceController.quantity.value.toString();
                  },
                  child: Container(
                    height: FetchPixels.getPixelHeight(25),
                    width: FetchPixels.getPixelWidth(25),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: Center(child: Icon(Icons.add),),
                  ),
                ),
              ],
            ),
            SizedBox(height: FetchPixels.getPixelHeight(15),),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  child: Text('Cancel',style: TextStyle(color: Colors.red,fontWeight: FontWeight.w600),),
                  onPressed: () {
                    Get.back();
                  },
                ),
                SizedBox(width: FetchPixels.getPixelWidth(15),),
                TextButton(
                  child: Text('Ok',style: TextStyle(color: Colors.green,fontWeight: FontWeight.w600),),
                  onPressed: () async{
                    if(int.tryParse(qtyController.text)! <= 0){
                      Get.back();
                    }else{

                      int index = widget.shopServiceController.orderList.indexWhere((element) => element.shopId.toString() == widget.argumentSr.toString());
                      if (index != -1) {

                        OrderModel updatedOrder = widget.shopServiceController.orderList[index];
                        updatedOrder.orderDataModel!.fixedRate = widget.rates1[widget.shopServiceController.radio.value].netRate!.toStringAsFixed(6);
                        updatedOrder.orderDataModel!.productId = widget.sr;
                        updatedOrder.orderDataModel!.netRate = widget.shopServiceController.netRate.value;
                        updatedOrder.orderDataModel!.rateId = widget.rates1[widget.shopServiceController.radio.value].rateId;
                        updatedOrder.orderDataModel!.quantity = int.tryParse(qtyController.text)!.toString();

                        // Replace the existing OrderModel with the updated one
                        widget.shopServiceController.orderList[index] = updatedOrder;

                        var box = await Hive.openBox("productsBox");
                        List<dynamic> data = box.get("products") ?? [];
                        if (data.isNotEmpty) {
                          List<ProductsModel> products = data.map((e) => ProductsModel(
                              sr: e.sr,
                              pname: e.pname,
                              wgm: e.wgm,
                              brandName: e.brandName,
                              tonagePerPcs: e.tonagePerPcs,
                              netRate: e.netRate,
                              quantity: e.quantity,
                              subTotal: e.subTotal,
                              retail: e.retail,
                              weight: e.weight,
                              tonnage: e.tonnage,
                              rateId: e.rateId,
                            fixedRate: e.fixedRate,
                          )).toList();



                          int productIndex = products.indexWhere((element) => element.sr == widget.sr);
                          if (productIndex != -1) {
                            ProductsModel product = products[productIndex];
                            product.retail = widget.rates1[widget.shopServiceController.radio.value].consumerPrice;
                            product.netRate = widget.shopServiceController.netRate.value;
                            product.quantity = int.tryParse(qtyController.text)!;
                            product.rateId = widget.rates1[widget.shopServiceController.radio.value].rateId;
                            product.subTotal = double.tryParse(widget.shopServiceController.netRate.value)! * int.tryParse(qtyController.text)!;
                            product.fixedRate = widget.rates1[widget.shopServiceController.radio.value].netRate!.toStringAsFixed(6);
                            product.weight = double.tryParse(product.wgm.toString())! * int.tryParse(qtyController.text)!;
                            product.tonnage = product.tonagePerPcs ?? 0.0 * int.tryParse(qtyController.text)!;

                            products[productIndex] = product;
                            // Update the productsList in the shopServiceController
                            widget.shopServiceController.productsList.value = products;

                            //Update the specific product in the Hive box
                            box.put("products", widget.shopServiceController.productsList);
                            List<dynamic> data = box.get("products") ?? [];
                            if(data.isNotEmpty){
                              widget.shopServiceController.productsList.value = data.map((e) => ProductsModel(sr: e.sr,pname: e.pname,wgm: e.wgm,brandName: e.brandName,tonagePerPcs: e.tonagePerPcs,retail: e.retail,netRate: e.netRate,subTotal: e.subTotal,quantity: e.quantity,weight: e.weight,tonnage: e.tonnage,fixedRate: e.fixedRate,rateId: e.rateId)).toList();
                              widget.shopServiceController.filteredProductsList.value = widget.shopServiceController.productsList;

                              Get.back();

                            }
                          }else{

                          }
                        }

                      }
                    }
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
