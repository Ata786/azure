import 'dart:developer';

import 'package:SalesUp/controllers/UserController.dart';
import 'package:SalesUp/controllers/syncNowController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../../controllers/shopServiceController.dart';
import '../../data/hiveDb.dart';
import '../../model/orderCalculations.dart';
import '../../model/orderModel.dart';
import '../../model/productsModel.dart';
import '../../model/reasonName.dart';
import '../../model/reasonsModel.dart';
import '../../model/syncDownModel.dart';
import '../../res/base/fetch_pixels.dart';
import '../../res/colors.dart';
import '../../res/images.dart';
import '../../view/invoiceScreen.dart';
import '../routes/routePath.dart';
import 'appWidgets.dart';

Widget productiveStore({required SyncNowController syncNowController}) {
  return Obx(
    () => syncNowController.check.value == true
        ? Center(
            child: CircularProgressIndicator(
              color: themeColor,
            ),
          )
        : ListView.builder(
            itemCount: syncNowController.filteredReasonList.length,
            itemBuilder: (context, index) {
              return Container(
                  height: FetchPixels.getPixelHeight(50),
                  width: FetchPixels.width,
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: FetchPixels.width / 1.8,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        onTap:syncNowController.filteredReasonList[index].reason ==
                                            "Invoice" ? (){

                                          Get.dialog(AlertDialog(
                                            content: Container(
                                              height:
                                              FetchPixels.getPixelHeight(100),
                                              width: FetchPixels.width,
                                              child: Column(
                                                children: [
                                                  textWidget(
                                                    textColor: Colors.black,
                                                    text:
                                                    "Do you want to preview this order?",
                                                    fontSize:
                                                    FetchPixels.getPixelHeight(
                                                        16),
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  SizedBox(
                                                    height:
                                                    FetchPixels.getPixelHeight(
                                                        20),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          Get.back();
                                                        },
                                                        child: Card(
                                                          child: Padding(
                                                            padding:
                                                            EdgeInsets.all(5.0),
                                                            child: textWidget(
                                                                text: "No",
                                                                fontSize: FetchPixels
                                                                    .getPixelHeight(
                                                                    15),
                                                                fontWeight:
                                                                FontWeight.w600,
                                                                textColor:
                                                                Colors.red),
                                                          ),
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () async {
                                                          Get.back();
                                                         Get.to(InvoiceScreen(shopId: syncNowController.filteredReasonList[index].shopId!));
                                                        },
                                                        child: Card(
                                                          child: Padding(
                                                            padding:
                                                            EdgeInsets.all(5.0),
                                                            child: textWidget(
                                                                text: "Yes",
                                                                fontSize: FetchPixels
                                                                    .getPixelHeight(
                                                                    15),
                                                                fontWeight:
                                                                FontWeight.w600,
                                                                textColor:
                                                                Colors.green),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ));

                                        } : (){},
                                        child: textWidget(
                                          textColor: Colors.black,
                                          text: syncNowController
                                                  .filteredReasonList[index]
                                                  .shopName ??
                                              "",
                                          fontSize:
                                              FetchPixels.getPixelHeight(17),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      textWidget(
                                        textColor: Colors.black,
                                        text: syncNowController
                                                .filteredReasonList[index]
                                                .reason ??
                                            "",
                                        fontSize:
                                            FetchPixels.getPixelHeight(12),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              syncNowController.filteredReasonList[index].reason ==
                                      "Invoice"
                                  ? Image.asset(
                                      checked,
                                      height: FetchPixels.getPixelHeight(20),
                                      width: FetchPixels.getPixelWidth(20),
                                    )
                                  : Image.asset(
                                      remove,
                                      height: FetchPixels.getPixelHeight(20),
                                      width: FetchPixels.getPixelWidth(20),
                                    ),
                              SizedBox(
                                width: FetchPixels.getPixelWidth(25),
                              ),
                              InkWell(
                                  onTap: () async {
                                    if (syncNowController
                                            .filteredReasonList[index].reason !=
                                        "Invoice") {
                                      Get.dialog(AlertDialog(
                                        content: Container(
                                          height:
                                              FetchPixels.getPixelHeight(100),
                                          width: FetchPixels.width,
                                          child: Column(
                                            children: [
                                              textWidget(
                                                textColor: Colors.black,
                                                text:
                                                    "Do you want to edit this record?",
                                                fontSize:
                                                    FetchPixels.getPixelHeight(
                                                        16),
                                                fontWeight: FontWeight.w600,
                                              ),
                                              SizedBox(
                                                height:
                                                    FetchPixels.getPixelHeight(
                                                        20),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      Get.back();
                                                    },
                                                    child: Card(
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.all(5.0),
                                                        child: textWidget(
                                                            text: "No",
                                                            fontSize: FetchPixels
                                                                .getPixelHeight(
                                                                    15),
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            textColor:
                                                                Colors.red),
                                                      ),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () async {
                                                      Get.back();
                                                      List<ReasonsModel>
                                                          reasons =
                                                          await HiveDatabase
                                                              .getReasons(
                                                                  "reasonsName",
                                                                  "reason");
                                                      Get.toNamed(SHOP_SERVICE,
                                                          arguments: {
                                                            "shopName":
                                                                syncNowController
                                                                    .filteredReasonList[
                                                                        index]
                                                                    .shopName,
                                                            "reasons": reasons,
                                                            "gprs": syncNowController
                                                                .filteredReasonList[
                                                                    index]
                                                                .checkIn,
                                                            "shopId":
                                                                syncNowController
                                                                    .filteredReasonList[
                                                                        index]
                                                                    .shopId,
                                                            "image":
                                                                syncNowController
                                                                    .filteredReasonList[
                                                                        index]
                                                                    .image,
                                                            "isEdit": true,
                                                            "isReason":
                                                                syncNowController
                                                                    .filteredReasonList[
                                                                        index]
                                                                    .reason,
                                                            "updateReason":
                                                                syncNowController
                                                                        .filteredReasonList[
                                                                    index]
                                                          });
                                                    },
                                                    child: Card(
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.all(5.0),
                                                        child: textWidget(
                                                            text: "Yes",
                                                            fontSize: FetchPixels
                                                                .getPixelHeight(
                                                                    15),
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            textColor:
                                                                Colors.green),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ));
                                    } else {

                                      Get.dialog(AlertDialog(
                                        content: Container(
                                          height:
                                          FetchPixels.getPixelHeight(100),
                                          width: FetchPixels.width,
                                          child: Column(
                                            children: [
                                              textWidget(
                                                textColor: Colors.black,
                                                text:
                                                "Do you want to edit this record?",
                                                fontSize:
                                                FetchPixels.getPixelHeight(
                                                    16),
                                                fontWeight: FontWeight.w600,
                                              ),
                                              SizedBox(
                                                height:
                                                FetchPixels.getPixelHeight(
                                                    20),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceEvenly,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      Get.back();
                                                    },
                                                    child: Card(
                                                      child: Padding(
                                                        padding:
                                                        EdgeInsets.all(5.0),
                                                        child: textWidget(
                                                            text: "No",
                                                            fontSize: FetchPixels
                                                                .getPixelHeight(
                                                                15),
                                                            fontWeight:
                                                            FontWeight.w600,
                                                            textColor:
                                                            Colors.red),
                                                      ),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () async {
                                                      Get.back();

                                                      ShopServiceController shopCtr =
                                                      Get.find<ShopServiceController>();

                                                      var box2 = await Hive.openBox("productsBox");
                                                      List<dynamic> data1 = box2.get("products") ?? [];
                                                      if (data1.isNotEmpty) {
                                                        List<
                                                            ProductsModel> products = data1
                                                            .map((e) =>
                                                            ProductsModel(
                                                              sr: e.sr,
                                                              rateId: e.rateId,
                                                              pname: e.pname,
                                                              wgm: e.wgm,
                                                              brandName: e
                                                                  .brandName,
                                                              tonagePerPcs: e
                                                                  .tonagePerPcs,
                                                              weight: e.weight,
                                                              tonnage: e.tonnage,
                                                              fixedRate: e.fixedRate,
                                                              netRate: null,
                                                              quantity: null,
                                                              subTotal: null,
                                                              retail: null,
                                                            ))
                                                            .toList();
                                                        shopCtr.productsList
                                                            .value = products;
                                                        box2.put("products",
                                                            products);
                                                      }


                                                      UserController userController =
                                                      Get.find<UserController>();
                                                      shopCtr.orderList = [];

                                                      List<OrderModel> orderList =
                                                      await HiveDatabase.getOrderData(
                                                          "orderBox", "order");

                                                      log('>>>> order ${orderList.length}');

                                                      for(int i=0; i<orderList.length; i++){
                                                        log('>>>> order ${orderList[i].toJson()}');
                                                      }

                                                      HiveDatabase.getReasonData("reasonNo", "reason");

                                                      ReasonModel reasonModel = syncNowController.filteredReasonList.where((p0) => p0.shopId == syncNowController.filteredReasonList[index].shopId).first;

                                                      OrderModel orderModel = OrderModel(shopId: reasonModel.shopId,pjpNo: reasonModel.pjpnumber,bookerId: reasonModel.bookerId,image: reasonModel.image,
                                                          invoiceStatus: "Pending",reason: "Pending",userId: userController.user!.value.id,replace: "0",checkIn: reasonModel.checkIn,orderDataModel: OrderDataModel());

                                                      shopCtr.orderList.add(orderModel);

                                                      /////////////////////

                                                      //print('>>> ${syncNowController.filteredReasonList[index].shopId}');

                                                      List<OrderModel> order = orderList.where((element) => element.shopId.toString() == syncNowController.filteredReasonList[index].shopId.toString()).toList();

                                                      // print('>>> ${order.shopId}');

                                                      var box = await Hive.openBox("productsBox");
                                                      List<dynamic> data = box.get("products") ?? [];
                                                      if (data.isNotEmpty) {
                                                        List<ProductsModel> products = data.map((e) =>
                                                            ProductsModel(
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
                                                                fixedRate: e.fixedRate,
                                                              rateId: e.rateId
                                                            )).toList();

                                                        for (int i = 0; i < products.length; i++) {
                                                          for (int j = 0; j < order.length; j++) {
                                                            if (products[i].sr == order[j].orderDataModel!.productId) {
                                                              ProductsModel product = products[i];
                                                              product.quantity = order[j].orderDataModel!.quantity;
                                                              product.netRate = order[j].orderDataModel!.netRate;
                                                              product.fixedRate = order[j].orderDataModel!.fixedRate;
                                                              product.subTotal = int.tryParse(order[j].orderDataModel!.quantity.toString())! * double.tryParse(product.fixedRate)!;
                                                              products[i] = product;
                                                              break; // No need to continue searching for this product
                                                            }
                                                          }

                                                          await box.put('products', products);
                                                          HiveDatabase.getProducts("productsBox", "products");

                                                            Get.back();
                                                            Get.toNamed(STORE, arguments: {
                                                              "shopName": syncNowController
                                                                  .filteredReasonList[index].shopName,
                                                              "sr": syncNowController
                                                                  .filteredReasonList[index].shopId,
                                                              "gprs": syncNowController
                                                                  .filteredReasonList[index].checkIn,
                                                              "phone": "",
                                                              "isEdit": true,
                                                              "image": order[0].image,
                                                              "checkIn": double.tryParse(orderModel.checkIn)
                                                            });


                                                          }

                                                        }

                                                    },
                                                    child: Card(
                                                      child: Padding(
                                                        padding:
                                                        EdgeInsets.all(5.0),
                                                        child: textWidget(
                                                            text: "Yes",
                                                            fontSize: FetchPixels
                                                                .getPixelHeight(
                                                                15),
                                                            fontWeight:
                                                            FontWeight.w600,
                                                            textColor:
                                                            Colors.green),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ));

                                    }
                                  },
                                  child: Image.asset(
                                    editing,
                                    height: FetchPixels.getPixelHeight(20),
                                    width: FetchPixels.getPixelWidth(20),
                                  )),
                              SizedBox(
                                width: FetchPixels.getPixelWidth(25),
                              ),
                              InkWell(
                                  onTap: () {
                                    Get.dialog(AlertDialog(
                                      content: Container(
                                        height: FetchPixels.getPixelHeight(100),
                                        width: FetchPixels.width,
                                        child: Column(
                                          children: [
                                            textWidget(
                                              textColor: Colors.black,
                                              text:
                                                  "Do you want to delete this record?",
                                              fontSize:
                                                  FetchPixels.getPixelHeight(
                                                      16),
                                              fontWeight: FontWeight.w600,
                                            ),
                                            SizedBox(
                                              height:
                                                  FetchPixels.getPixelHeight(
                                                      20),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    Get.back();
                                                  },
                                                  child: Card(
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(5.0),
                                                      child: textWidget(
                                                          text: "No",
                                                          fontSize: FetchPixels
                                                              .getPixelHeight(
                                                                  15),
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          textColor:
                                                              Colors.red),
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () async {

                                                    OrderCalculationModel getOrderCalculate = await HiveDatabase.getOrderCalculation("orderCalculateBox", "orderCalculate");
                                                    List<OrderModel> list =
                                                    await HiveDatabase.getOrderData(
                                                        "orderBox", "order");
                                                    OrderModel order = list.where((element) => element.shopId.toString() == syncNowController.filteredReasonList[index].shopId.toString()).first;
                                                    double qty = getOrderCalculate.qty! - double.tryParse(order.orderDataModel!.quantity.toString())!;
                                                    double weight = getOrderCalculate.weight! - double.tryParse(order.weight.toString())!;
                                                    double tonnage = getOrderCalculate.tonnage! - double.tryParse(order.tonnage.toString())!;
                                                    getOrderCalculate.weight = weight;
                                                    getOrderCalculate.qty = qty;
                                                    getOrderCalculate.tonnage = tonnage;

                                                    await HiveDatabase.setOrderCalculation("orderCalculateBox", "orderCalculate", getOrderCalculate);
                                                    OrderCalculationModel orderCalculated = await HiveDatabase.getOrderCalculation("orderCalculateBox", "orderCalculate");
                                                    syncNowController.orderCalculationModel.value = orderCalculated;

                                                    String shopId =
                                                        syncNowController
                                                            .filteredReasonList[
                                                                index]
                                                            .shopId!;
                                                    var syncDownBox =
                                                        await Hive.openBox(
                                                            "syncDownList");
                                                    List<dynamic> data =
                                                        syncDownBox.get(
                                                                'syncDown') ??
                                                            [];
                                                    if (data.isNotEmpty) {
                                                      List<SyncDownModel> modelList = data
                                                          .map((e) => SyncDownModel(
                                                              shopname:
                                                                  e.shopname,
                                                              address:
                                                                  e.address,
                                                              salesInvoiceDate: e
                                                                  .salesInvoiceDate,
                                                              gprs: e.gprs,
                                                              shopCode:
                                                                  e.shopCode,
                                                              sr: e.sr,
                                                              phone: e.phone,
                                                              owner: e.owner,
                                                              catagoryId:
                                                                  e.catagoryId,
                                                              productive:
                                                                  e.productive))
                                                          .toList();
                                                      int updateIndex =
                                                          modelList.indexWhere(
                                                              (element) =>
                                                                  element.sr ==
                                                                  int.tryParse(
                                                                      shopId));
                                                      if (updateIndex != -1) {
                                                        modelList[updateIndex]
                                                            .productive = false;
                                                        await syncDownBox.put(
                                                            'syncDown',
                                                            modelList);
                                                        List<dynamic> data2 =
                                                            syncDownBox.get(
                                                                    'syncDown') ??
                                                                [];
                                                        syncNowController.syncDownList.value = data2
                                                            .map((e) => SyncDownModel(
                                                                shopname:
                                                                    e.shopname,
                                                                address:
                                                                    e.address,
                                                                salesInvoiceDate: e
                                                                    .salesInvoiceDate,
                                                                gprs: e.gprs,
                                                                shopCode:
                                                                    e.shopCode,
                                                                sr: e.sr,
                                                                phone: e.phone,
                                                                owner: e.owner,
                                                                catagoryId: e
                                                                    .catagoryId,
                                                                productive: e
                                                                    .productive))
                                                            .toList();
                                                        syncNowController
                                                                .allList.value =
                                                            syncNowController
                                                                .syncDownList;
                                                        syncNowController
                                                                .searchList
                                                                .value =
                                                            syncNowController
                                                                .allList;
                                                      }
                                                    }
                                                    var box =
                                                        await Hive.openBox(
                                                            "reasonNo");
                                                    syncNowController
                                                        .reasonModelList
                                                        .removeAt(index);
                                                    box.put(
                                                        "reason",
                                                        syncNowController
                                                            .reasonModelList);
                                                    HiveDatabase.getReasonData(
                                                        "reasonNo", "reason");

                                                    Get.back();
                                                  },
                                                  child: Card(
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(5.0),
                                                      child: textWidget(
                                                          text: "Yes",
                                                          fontSize: FetchPixels
                                                              .getPixelHeight(
                                                                  15),
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          textColor:
                                                              Colors.green),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ));
                                  },
                                  child: Image.asset(
                                    bin,
                                    height: FetchPixels.getPixelHeight(20),
                                    width: FetchPixels.getPixelWidth(20),
                                  )),
                            ],
                          )
                        ],
                      ),
                      Spacer(),
                      Container(
                        height: FetchPixels.getPixelHeight(1),
                        color: Colors.black,
                      ),
                      SizedBox(
                        height: FetchPixels.getPixelHeight(5),
                      )
                    ],
                  ));
            }),
  );
}
