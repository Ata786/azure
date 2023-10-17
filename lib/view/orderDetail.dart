import 'dart:developer';

import 'package:SalesUp/controllers/UserController.dart';
import 'package:SalesUp/controllers/shopServiceController.dart';
import 'package:SalesUp/controllers/syncNowController.dart';
import 'package:SalesUp/model/orderCalculations.dart';
import 'package:SalesUp/res/base/fetch_pixels.dart';
import 'package:SalesUp/res/colors.dart';
import 'package:SalesUp/utils/widgets/appWidgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../data/hiveDb.dart';
import '../model/orderModel.dart';
import '../model/productsModel.dart';
import '../model/reasonsModel.dart';
import '../model/syncDownModel.dart';

class OrderDetail extends StatefulWidget {
  OrderDetail({super.key});

  @override
  State<OrderDetail> createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {

  bool loading = true;
  List<ProductsModel> productsList = [];
  double totalWeight = 0.0;
  double totalAmount = 0.0;
  int totalQuantity = 0;

  int radio = 1;

  void getSelectedProducts()async{
    var box = await Hive.openBox("productsBox");
    List<dynamic> data = box.get("products") ?? [];
    List<dynamic> list = data.where((element) => element.subTotal != null).toList();
    productsList = list.map((e) => ProductsModel(sr: e.sr,pname: e.pname,wgm: e.wgm,brandName: e.brandName,
        netRate: e.netRate,rateId: e.rateId,quantity: e.quantity,subTotal: e.subTotal,retail: e.retail,weight: e.weight,tonnage: e.tonnage,fixedRate: e.fixedRate,tonagePerPcs: e.tonagePerPcs)).toList();

    for(int i=0; i<productsList.length; i++){
      totalWeight += double.tryParse(productsList[i].wgm.toString())!;
      totalAmount += double.tryParse(productsList[i].subTotal.toString())!;
      totalQuantity += int.tryParse(productsList[i].quantity.toString())!;
    }
    loading = false;
    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();
    getSelectedProducts();
  }

  @override
  Widget build(BuildContext context) {
    FetchPixels(context);
    return Scaffold(
      appBar: AppBar(
        title: textWidget(text: "Order Detail", fontSize: FetchPixels.getPixelHeight(16),textColor: Colors.white, fontWeight: FontWeight.w600),automaticallyImplyLeading: false,
      ),
      body: Container(
        height: FetchPixels.height,
        width: FetchPixels.width,
        child: Column(
          children: [
            SizedBox(height: FetchPixels.getPixelHeight(20),),
            Container(
              height: FetchPixels.getPixelHeight(100),
              width: FetchPixels.width,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Container(
                    height: FetchPixels.getPixelHeight(70),
                    width: FetchPixels.getPixelWidth(200),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(7))
                    ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(7))
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(10),vertical: FetchPixels.getPixelHeight(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            textWidget(text: "Sort By", fontSize: FetchPixels.getPixelHeight(14),textColor: primaryColor, fontWeight: FontWeight.w500),
                            Row(
                              children: [
                                Radio(value: true, groupValue: true, onChanged: (v){},activeColor: Colors.pinkAccent,),
                                textWidget(text: "Details", fontSize: FetchPixels.getPixelHeight(14),textColor: primaryColor, fontWeight: FontWeight.w500),
                                Radio(value: false, groupValue: true, onChanged: (v){},activeColor: Colors.pinkAccent,),
                                textWidget(text: "SKU", fontSize: FetchPixels.getPixelHeight(14),textColor: primaryColor, fontWeight: FontWeight.w500),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: FetchPixels.getPixelHeight(70),
                    width: FetchPixels.getPixelWidth(300),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(7))
                    ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(FetchPixels.getPixelHeight(7))
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(10),vertical: FetchPixels.getPixelHeight(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            textWidget(text: "Payment Method", fontSize: FetchPixels.getPixelHeight(14),textColor: primaryColor, fontWeight: FontWeight.w500),
                            Row(
                              children: [
                                Radio(value: radio == 0 ? true : false, groupValue: true, onChanged: (v){
                                  setState(() {
                                    radio = 0;
                                  });
                                },activeColor: Colors.pinkAccent,),
                                textWidget(text: "Credit", fontSize: FetchPixels.getPixelHeight(14),textColor: primaryColor, fontWeight: FontWeight.w500),
                                Radio(value: radio == 1 ? true : false, groupValue: true, onChanged: (v){
                                 setState(() {
                                   radio = 1;
                                 });
                                },activeColor: Colors.pinkAccent,),
                                textWidget(text: "Cash", fontSize: FetchPixels.getPixelHeight(14),textColor: primaryColor, fontWeight: FontWeight.w500),
                               ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: FetchPixels.getPixelHeight(10),),
            Container(height: FetchPixels.getPixelHeight(1),color: Colors.black,),
            SizedBox(height: FetchPixels.getPixelHeight(10),),
            Expanded(
                child: loading == true ? Center(child: CircularProgressIndicator(color: themeColor,),)
                :  ListView.builder(
                  itemCount: productsList.length,
                    itemBuilder: (context,index) {
              return InkWell(
                onTap: ()async{

                },
                child: Container(
                    margin: EdgeInsets.only(top: FetchPixels.getPixelHeight(10),left: FetchPixels.getPixelWidth(20),right: FetchPixels.getPixelWidth(20)),
                    width: FetchPixels.width,
                    height: FetchPixels.getPixelHeight(120),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                textWidget(text: productsList[index].pname ?? "", fontSize: FetchPixels.getPixelHeight(16), fontWeight: FontWeight.w600,textColor: primaryColor),
                                SizedBox(height: FetchPixels.getPixelHeight(7),),
                                textWidget(text: "Quantity: ${productsList[index].quantity}", fontSize: FetchPixels.getPixelHeight(13), fontWeight: FontWeight.w500,textColor: primaryColor),
                                SizedBox(height: FetchPixels.getPixelHeight(7),),
                                textWidget(text: 'Total Weight: ${double.tryParse(productsList[index].quantity.toString())! * double.tryParse(productsList[index].wgm.toString())!}', fontSize: FetchPixels.getPixelHeight(13), fontWeight: FontWeight.w500,textColor: primaryColor),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(height: FetchPixels.getPixelHeight(30),),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    textWidget(text: "Weight:", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w500,textColor: primaryColor),
                                    SizedBox(width: FetchPixels.getPixelWidth(10),),
                                    textWidget(text: "${productsList[index].wgm}", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w500,textColor: primaryColor),
                                  ],
                                ),
                                SizedBox(height: FetchPixels.getPixelHeight(7),),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    textWidget(text: "Rate:", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w500,textColor: primaryColor),
                                    SizedBox(width: FetchPixels.getPixelWidth(10),),
                                    textWidget(text: "${productsList[index].netRate}", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w500,textColor: primaryColor),
                                  ],
                                ),
                                SizedBox(height: FetchPixels.getPixelHeight(7),),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    textWidget(text: "SubTotal:", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w500,textColor: primaryColor),
                                    SizedBox(width: FetchPixels.getPixelWidth(10),),
                                    textWidget(text: "${productsList[index].subTotal.toStringAsFixed(6)}", fontSize: FetchPixels.getPixelHeight(14), fontWeight: FontWeight.w500,textColor: primaryColor),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                        Container(
                          height: FetchPixels.getPixelHeight(0.5),
                          color: Colors.black.withOpacity(0.5),
                          width: FetchPixels.width,
                        )
                      ],
                    )
                ),
              );
            })),
            SizedBox(height: FetchPixels.getPixelHeight(10),),
            Container(
              margin: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(20)),
              height: FetchPixels.getPixelHeight(100),
              width: FetchPixels.width,
              child: Card(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: FetchPixels.getPixelWidth(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          textWidget(text: "Total Quantity", fontSize: FetchPixels.getPixelHeight(13),textColor: primaryColor, fontWeight: FontWeight.w500),
                          textWidget(text: "Total Weight", fontSize: FetchPixels.getPixelHeight(13),textColor: primaryColor, fontWeight: FontWeight.w500),
                          textWidget(text: "Total Amount", fontSize: FetchPixels.getPixelHeight(13),textColor: primaryColor, fontWeight: FontWeight.w500),
                         ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          textWidget(text: "$totalQuantity", fontSize: FetchPixels.getPixelHeight(13),textColor: primaryColor, fontWeight: FontWeight.w500),
                          textWidget(text: "$totalWeight", fontSize: FetchPixels.getPixelHeight(13),textColor: primaryColor, fontWeight: FontWeight.w500),
                          textWidget(text: "${totalAmount.toStringAsFixed(6)}", fontSize: FetchPixels.getPixelHeight(13),textColor: primaryColor, fontWeight: FontWeight.w500),
                        ],
                      ),
                    ],
                  ),
                )
              ),
            ),
            SizedBox(height: FetchPixels.getPixelHeight(20),),
            Padding(
              padding: EdgeInsets.only(right: FetchPixels.getPixelWidth(25)),
              child: Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: ()async{
                    Get.put(ShopServiceController());
                    Get.put(SyncNowController());
                    ShopServiceController shopServiceController = Get.find<ShopServiceController>();
                    SyncNowController syncNowController = Get.find<SyncNowController>();

                    dynamic shId = shopServiceController.orderList[0].shopId;

                    List<OrderModel> list = await HiveDatabase.getOrderData("orderBox", "order");
                    var box0 = await Hive.openBox("reasonNo");
                    List<dynamic> data1 = box0.get("reason") ?? [];
                      syncNowController.reasonModelList.value = data1.map((e) =>
                          ReasonModel(shopName: e.shopName,
                              shopId: e.shopId,
                              bookerId: e.bookerId,
                              checkIn: e.checkIn,
                              createdOn: e.createdOn,
                              reason: e.reason,
                              image: e.image,
                              payment: e.payment,
                              pjpnumber: e.pjpnumber,
                          )).toList();

                    // print('>>> 1st ${list.length} and ${syncNowController.reasonModelList.length}');

                    int orderIndex = list.indexWhere((element) => element.shopId.toString() == shId.toString());
                    int reasonIndex = syncNowController.reasonModelList.indexWhere((element) => element.shopId.toString() == shId.toString());

                    if (orderIndex != -1) {
                      // print('.>>> yes');
                      list.removeAt(orderIndex);
                      HiveDatabase.setOrderData("orderBox", "order", list);
                    }

                    if (reasonIndex != -1) {
                      // print('.>>> yes');
                      syncNowController.reasonModelList.removeAt(reasonIndex);
                      HiveDatabase.setReasonData("reasonNo", "reason", syncNowController.reasonModelList);
                    }

                    // print('>>> 2nd ${list.length} and ${syncNowController.reasonModelList.length}');

                    List<OrderModel> list2 = await HiveDatabase.getOrderData("orderBox", "order");
                    var box01 = await Hive.openBox("reasonNo");
                    List<dynamic> data2 = box01.get("reason") ?? [];
                    syncNowController.reasonModelList.value = data2.map((e) =>
                        ReasonModel(shopName: e.shopName,
                            shopId: e.shopId,
                            bookerId: e.bookerId,
                            checkIn: e.checkIn,
                            createdOn: e.createdOn,
                            reason: e.reason,
                            image: e.image,
                            payment: e.payment,
                            pjpnumber: e.pjpnumber)).toList();

                    List<OrderModel> ordersList = await HiveDatabase.getOrderData("orderBox", "order");
                    int orderListIndex = ordersList.indexWhere((element) => element.shopId.toString() == shId.toString());

                    int nextOrderNumber = 0;
                    int maxOrderNumber = ordersList.fold(0, (max, order) {
                      if (order.orderNumber > max) {
                        return order.orderNumber;
                      }
                      return max;
                    });

                    if(orderListIndex != -1){
                      nextOrderNumber = maxOrderNumber;
                    }else{
                      nextOrderNumber = maxOrderNumber + 1;
                    }

                    OrderModel orderModel = shopServiceController.orderList[0];

                    int initialLength = ordersList.length;

                    for(int i=0; i<productsList.length; i++){
                     OrderModel order = OrderModel(image: orderModel.image,shopId: orderModel.shopId,pjpNo: orderModel.pjpNo,pjpDate: orderModel.pjpDate,
                         invoiceStatus: orderModel.invoiceStatus,userId: orderModel.userId,reason: "Invoice",replace: orderModel.replace,
                         tonnage: productsList[i].tonnage,weight: productsList[i].weight,orderNumber: nextOrderNumber,orderDataModel: OrderDataModel(fixedRate: productsList[i].fixedRate,productId: productsList[i].sr,netRate: productsList[i].netRate,rateId: productsList[i].rateId,quantity: productsList[i].quantity));
                     ordersList.add(order);
                    }

                    int finalLength = ordersList.length;

                    if(finalLength > initialLength){
                      HiveDatabase.setOrderData("orderBox", "order", ordersList);
                    }

                    List<OrderModel> orderList = await HiveDatabase.getOrderData("orderBox", "order");


                    OrderCalculationModel orderCalculate = await HiveDatabase.getOrderCalculation("orderCalculateBox", "orderCalculate");
                    double bookingValue = orderCalculate.bookingValue ?? 0.0;
                    // double llpc = orderCalculate.llpc ?? 0.0;
                   double llpc = 0.0;
                    double qty = orderCalculate.qty ?? 0.0;
                    double weight = orderCalculate.weight ?? 0.0;
                    double tonnage = orderCalculate.tonnage ?? 0.0;

                    double sum = 0.0;
                    double quantitySum = 0.0;
                    double weightSum = 0.0;
                    double tonnageSum = 0.0;

                    for (int i = 0; i < orderList.length; i++) {
                      sum += double.tryParse(orderList[i].orderDataModel!.netRate)! * double.tryParse(orderList[i].orderDataModel!.quantity.toString())!;
                      quantitySum += double.tryParse(orderList[i].orderDataModel!.quantity.toString())!;
                      weightSum += double.tryParse(orderList[i].weight.toString())!;
                      tonnageSum += double.tryParse(orderList[i].tonnage.toString())!;
                    }

                    orderCalculate.bookingValue = sum;
                    orderCalculate.qty = quantitySum;
                    orderCalculate.weight = weightSum;
                    orderCalculate.tonnage = tonnageSum;
                    orderCalculate.shopId = int.tryParse(orderModel.shopId.toString());
                    var box = await Hive.openBox("orderBox");
                    box.put("order", orderList);

                    UserController userController = Get.find<UserController>();

                    List<OrderModel> orders = shopServiceController.orderList;
                    dynamic shopId = orders[0].shopId;
                    String checkIn = orders[0].checkIn.toString();
                    String image = orders[0].image;

                    var box2 = await Hive.openBox("syncDownList");
                    List<dynamic> syncDownData = box2.get("syncDown") ?? [];

                    List<SyncDownModel> syncDownList = syncDownData.map((e) => SyncDownModel(shopname: e.shopname,address: e.address,salesInvoiceDate: e.salesInvoiceDate,gprs: e.gprs,shopCode: e.shopCode,sr: e.sr,phone: e.phone,owner: e.owner,catagoryId: e.catagoryId,productive: e.productive,distributerId: e.distributerId,sectorId: e.sectorId,typeId: e.typeId,statusId: e.statusId,salesTax: e.salesTax,tax: e.tax,shopType: e.shopType,picture: e.picture,sector: e.sector,cnic: e.cnic,myntn: e.myntn,isEdit: e.isEdit)).toList();
                    SyncDownModel syncDownModel = syncDownList.firstWhere((element) => element.sr.toString() == shopId.toString());
                    int index = syncDownList.indexWhere((element) => element.sr.toString() == shopId.toString());

                    syncDownList[index].productive = true;

                    await box2.put("syncDown",syncDownList);

                    List<dynamic> syncDownUpdatedList = box2.get("syncDown") ?? [];
                    syncNowController.syncDownList.value = syncDownUpdatedList.map((e) => SyncDownModel(shopname: e.shopname,address: e.address,salesInvoiceDate: e.salesInvoiceDate,gprs: e.gprs,shopCode: e.shopCode,sr: e.sr,phone: e.phone,owner: e.owner,catagoryId: e.catagoryId,productive: e.productive,distributerId: e.distributerId,sectorId: e.sectorId,typeId: e.typeId,statusId: e.statusId,salesTax: e.salesTax,tax: e.tax,shopType: e.shopType,picture: e.picture,sector: e.sector,cnic: e.cnic,myntn: e.myntn,isEdit: e.isEdit)).toList();
                    syncNowController.allList.value = syncNowController.syncDownList;
                    syncNowController.searchList.value = syncNowController.allList;

                    String formattedDateTime = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());
                    ReasonModel reasonModel = ReasonModel(shopName: syncDownModel.shopname,shopId: syncDownModel.sr.toString(),bookerId: userController.user!.value.catagoryId,checkIn: checkIn.toString(),createdOn: formattedDateTime,image: image,payment: radio == 0 ? "Credit" : radio == 1 ? "Cash" : "Check" ,reason: "Invoice" ?? '',pjpnumber: "0");
                    var box3 = await Hive.openBox("reasonNo");
                    List<dynamic> data = box3.get("reason") ?? [];
                    List<ReasonModel> reasonModelList = data.map((e) => ReasonModel(shopName: e.shopName,shopId: e.shopId,bookerId: e.bookerId,
                        checkIn: e.checkIn,createdOn: e.createdOn,reason: e.reason,image: e.image,payment: radio == 0 ? "Credit" : radio == 1 ? "Cash" : "Check" ,pjpnumber: e.pjpnumber)).toList();
                    reasonModelList.add(reasonModel);
                    HiveDatabase.setReasonData("reasonNo", "reason", reasonModelList);
                    HiveDatabase.getReasonData("reasonNo", "reason");

                    // int orderListLength = shopServiceController.orderList.length;
                    List<OrderModel> orderList5 = await HiveDatabase.getOrderData("orderBox", "order");
                    int reasonLength = syncNowController.reasonModelList.where((p0) => p0.reason == "Invoice").length;
                    double llpLength = 0.0;

                    if (reasonLength != 0) {
                      llpLength = orderList5.length / reasonLength;
                    } else {
                      llpLength = 0.0;
                    }

                    orderCalculate.llpc = llpLength;

                    HiveDatabase.setOrderCalculation("orderCalculateBox", "orderCalculate", orderCalculate);
                    OrderCalculationModel getOrderCalculate = await HiveDatabase.getOrderCalculation("orderCalculateBox", "orderCalculate");

                    syncNowController.orderCalculationModel.value = getOrderCalculate;

                    Get.back();
                    Get.back();
                  },
                  child: button(height: FetchPixels.getPixelHeight(30),
                      width: FetchPixels.getPixelWidth(130),
                      color: themeColor,
                      textColor: Colors.white,
                      textSize: FetchPixels.getPixelHeight(10),
                      borderRadius: FetchPixels.getPixelHeight(8), textWeight: FontWeight.w500, text: "CHECK OUT"),
                ),
              ),
            ),
            SizedBox(height: FetchPixels.getPixelHeight(30),),
          ],
        ),
      ),
    );
  }
}
