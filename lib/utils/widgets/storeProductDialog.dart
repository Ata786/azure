import 'package:azure/controllers/shopServiceController.dart';
import 'package:azure/res/base/fetch_pixels.dart';
import 'package:azure/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../../data/hiveDb.dart';
import '../../model/orderModel.dart';
import '../../model/productsModel.dart';
import '../../model/reateDetailModel.dart';
import '../../res/images.dart';
import 'appWidgets.dart';

void showStoreProductDialog({required OrderModel order,required ShopServiceController shopServiceController,required sr,required productName,required List<RateDetailModel> rateDetail}){
  List<RateDetail> rates1 = rateDetail[0].rateDetail!.where((element) => element.productId == sr).toList();
  Get.dialog(
    AlertDialog(
      content: StoreProductDialogContent(order: order,rates1: rates1,shopServiceController: shopServiceController, sr: sr, productName: productName, rateDetail: rateDetail,),
    )
  );

}


class StoreProductDialogContent extends StatefulWidget {
  final List<RateDetail> rates1;
  final ShopServiceController shopServiceController;
  final dynamic sr;
  final dynamic productName;
  final List<RateDetailModel> rateDetail;
  final OrderModel order;

  StoreProductDialogContent({super.key,required this.order,required this.rates1, required this.shopServiceController, this.sr, this.productName, required this.rateDetail});

  @override
  State<StoreProductDialogContent> createState() => _StoreProductDialogContentState();
}

class _StoreProductDialogContentState extends State<StoreProductDialogContent> {

  late TextEditingController qtyController;

  @override
  void initState() {
    super.initState();
    qtyController = TextEditingController(text: "0");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: FetchPixels.height/2,
      width: FetchPixels.width,
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(height: FetchPixels.getPixelHeight(10),),
          Image.asset(basket,height: FetchPixels.getPixelHeight(30),width: FetchPixels.getPixelWidth(30),),
          SizedBox(height: FetchPixels.getPixelHeight(20),),
          textWidget(text: widget.productName, fontSize: FetchPixels.getPixelHeight(16), fontWeight: FontWeight.w600,textColor: Colors.blue),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Obx(() => Radio(
                activeColor: themeColor,
                  value: widget.shopServiceController.radio.value == 1 ? true : false,
                  groupValue: true,
                  onChanged: (v){
                    widget.shopServiceController.radio.value = 1;
                    widget.shopServiceController.netRate.value = widget.rates1[0].netRate.toStringAsFixed(6);
                  })),
              textWidget(text: widget.rateDetail[0].ratename ?? "", fontSize: FetchPixels.getPixelHeight(13), fontWeight: FontWeight.w600,textColor: primaryColor),
              Spacer(),
              Spacer(),
              textWidget(text: "${widget.rates1[0].netRate.toStringAsFixed(6)}", fontSize: FetchPixels.getPixelHeight(13), fontWeight: FontWeight.w600,textColor: primaryColor),
              Spacer(),
              Spacer(),
              Spacer(),
              Spacer(),
              textWidget(text: "${widget.rates1[0].stock}", fontSize: FetchPixels.getPixelHeight(13), fontWeight: FontWeight.w600,textColor: Colors.green),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Obx(() => Radio(
                  activeColor: themeColor,
                  value: widget.shopServiceController.radio.value == 2 ? true : false,
                  groupValue: true,
                  onChanged: (v){
                    widget.shopServiceController.radio.value = 2;
                    widget.shopServiceController.netRate.value = widget.rates1[0].netRate.toStringAsFixed(6);
                  })),
              textWidget(text: widget.rateDetail[1].ratename ?? "", fontSize: FetchPixels.getPixelHeight(13), fontWeight: FontWeight.w600,textColor: primaryColor),
              Spacer(),
              Spacer(),
              textWidget(text: "${widget.rates1[0].netRate.toStringAsFixed(6)}", fontSize: FetchPixels.getPixelHeight(13), fontWeight: FontWeight.w600,textColor: primaryColor),
              Spacer(),
              Spacer(),
              Spacer(),
              Spacer(),
              textWidget(text: "${widget.rates1[0].stock}", fontSize: FetchPixels.getPixelHeight(13), fontWeight: FontWeight.w600,textColor: Colors.green),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Obx(() => Radio(
                  activeColor: themeColor,
                  value: widget.shopServiceController.radio.value == 3 ? true : false,
                  groupValue: true,
                  onChanged: (v){
                    widget.shopServiceController.radio.value = 3;
                    widget.shopServiceController.netRate.value = widget.rates1[0].netRate.toStringAsFixed(6);
                  })),
              textWidget(text: widget.rateDetail[2].ratename ?? "", fontSize: FetchPixels.getPixelHeight(13), fontWeight: FontWeight.w600,textColor: primaryColor),
              Spacer(),
              Spacer(),
              textWidget(text: "${widget.rates1[0].netRate.toStringAsFixed(6)}", fontSize: FetchPixels.getPixelHeight(13), fontWeight: FontWeight.w600,textColor: primaryColor),
              Spacer(),
              Spacer(),
              Spacer(),
              Spacer(),
              textWidget(text: "${widget.rates1[0].stock}", fontSize: FetchPixels.getPixelHeight(13), fontWeight: FontWeight.w600,textColor: Colors.green),
            ],
          ),
          SizedBox(height: FetchPixels.getPixelHeight(10),),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              textWidget(text: "Price:-", fontSize: FetchPixels.getPixelHeight(13), fontWeight: FontWeight.w600,textColor: primaryColor),
              Container(
                  child: Row(
                    children: [
                      Expanded(flex: 2,child: Obx(() => Padding(
                        padding: EdgeInsets.only(left: FetchPixels.getPixelWidth(10)),
                        child: textWidget(text: widget.shopServiceController.netRate.value, fontSize: FetchPixels.getPixelHeight(13), fontWeight: FontWeight.w600,textColor: primaryColor),
                      ))),
                      Expanded(flex: 1,child: Container(
                        child: Row(
                          children: [
                            InkWell(
                                onTap: (){
                                  double? rate = double.tryParse(widget.shopServiceController.netRate.value);
                                  if(widget.shopServiceController.netRate.value == widget.rates1[0].netRate.toStringAsFixed(6)){
                                  }else if (rate != null){
                                    rate++;
                                    widget.shopServiceController.netRate.value = rate.toString();
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
              SizedBox(
                width: FetchPixels.getPixelWidth(100),
                child: Center(child: Obx(() => Text("${widget.shopServiceController.quantity.value}"))),
              ),
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
                  if(widget.shopServiceController.quantity.value == 0){
                    Get.back();
                  }else{
                    List<OrderModel> orderList = await HiveDatabase.getOrderData("orderBox", "order");
                    widget.order.orderDataModel =  OrderDataModel(fixedRate: widget.rates1[0].netRate.toStringAsFixed(6),productId: widget.sr,netRate: widget.shopServiceController.netRate.value,rateId: widget.rates1[0].rateId,quantity: widget.shopServiceController.quantity.value.toString());
                    orderList.add(widget.order);
                    HiveDatabase.setOrderData("orderBox", "order", orderList);
                    ShopServiceController shopServiceCtr = Get.find<ShopServiceController>();
                    var box = await Hive.openBox("productsBox");
                    List<dynamic> data = box.get("products") ?? [];
                    if(data.isNotEmpty){
                      List<ProductsModel> products = data.map((e) => ProductsModel(sr: e.sr,pname: e.pname,wgm: e.wgm,brandName: e.brandName)).toList();
                      int indexToUpdate = products.indexWhere((element) => element.sr == widget.sr);

                      if (indexToUpdate != -1) {
                        ProductsModel pModel = products[indexToUpdate];
                        pModel.retail = widget.rates1[0].consumerPrice;
                        pModel.netRate = widget.rates1[0].netRate;
                        pModel.quantity = widget.shopServiceController.quantity.value;
                        pModel.subTotal = widget.rates1[0].netRate * widget.shopServiceController.quantity.value;

                        products[indexToUpdate] = pModel;

                        await box.put("products", products);
                        List<dynamic> dataList = box.get("products") ?? [];
                        if(dataList.isNotEmpty){
                          shopServiceCtr.productsList.value = dataList.map((e) => ProductsModel(sr: e.sr,pname: e.pname,wgm: e.wgm,brandName: e.brandName,
                              netRate: e.netRate,quantity: e.quantity,subTotal: e.subTotal,retail: e.retail)).toList();
                          Get.back();
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
    );
  }
}
