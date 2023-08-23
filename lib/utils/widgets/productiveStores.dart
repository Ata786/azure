import 'package:SalesUp/controllers/UserController.dart';
import 'package:SalesUp/controllers/syncNowController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../../controllers/shopServiceController.dart';
import '../../data/hiveDb.dart';
import '../../model/orderModel.dart';
import '../../model/productsModel.dart';
import '../../model/reasonName.dart';
import '../../model/reasonsModel.dart';
import '../../model/syncDownModel.dart';
import '../../res/base/fetch_pixels.dart';
import '../../res/colors.dart';
import '../../res/images.dart';
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
            itemCount: syncNowController.reasonModelList.length,
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
                                      textWidget(
                                        textColor: Colors.black,
                                        text: syncNowController
                                                .reasonModelList[index]
                                                .shopName ??
                                            "",
                                        fontSize:
                                            FetchPixels.getPixelHeight(17),
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textWidget(
                                        textColor: Colors.black,
                                        text: syncNowController
                                                .reasonModelList[index]
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
                              syncNowController.reasonModelList[index].reason ==
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
                                            .reasonModelList[index].reason !=
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
                                                                    .reasonModelList[
                                                                        index]
                                                                    .shopName,
                                                            "reasons": reasons,
                                                            "gprs": syncNowController
                                                                .reasonModelList[
                                                                    index]
                                                                .checkIn,
                                                            "shopId":
                                                                syncNowController
                                                                    .reasonModelList[
                                                                        index]
                                                                    .shopId,
                                                            "image":
                                                                syncNowController
                                                                    .reasonModelList[
                                                                        index]
                                                                    .image,
                                                            "isEdit": true,
                                                            "isReason":
                                                                syncNowController
                                                                    .reasonModelList[
                                                                        index]
                                                                    .reason,
                                                            "updateReason":
                                                                syncNowController
                                                                        .reasonModelList[
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

                                      ShopServiceController shopCtr =
                                          Get.find<ShopServiceController>();
                                      UserController userController =
                                          Get.find<UserController>();
                                      shopCtr.orderList = [];

                                      // String formattedDate =
                                      //     DateFormat('yyyy-MM-dd HH:mm:ss')
                                      //         .format(DateTime.now());

                                      List<OrderModel> orderList =
                                          await HiveDatabase.getOrderData(
                                              "orderBox", "order");

                                      HiveDatabase.getReasonData("reasonNo", "reason");

                                      ReasonModel reasonModel = syncNowController.reasonModelList.where((p0) => p0.shopId == syncNowController.reasonModelList[index].shopId).first;

                                      OrderModel orderModel = OrderModel(shopId: reasonModel.shopId,pjpNo: reasonModel.pjpnumber,bookerId: reasonModel.bookerId,image: reasonModel.image,
                                        invoiceStatus: "Pending",reason: "Pending",userId: userController.user!.value.id,replace: "0",checkIn: reasonModel.checkIn);

                                      shopCtr.orderList.add(orderModel);

                                      /////////////////////

                                      OrderModel order = orderList.where((element) => element.shopId.toString() == syncNowController.reasonModelList[index].shopId.toString()).first;

  var box = await Hive.openBox("productsBox");
  List<dynamic> data = box.get("products") ?? [];
  if (data.isNotEmpty) {
    List<ProductsModel> products = data.map((e) =>
        ProductsModel(
            sr: e.sr,
            pname: e.pname,
            wgm: e.wgm,
            brandName: e.brandName,
            tonnageperpcs: e.tonnageperpcs,
            netRate: e.netRate,
            quantity: e.quantity,
            subTotal: e.subTotal,
            retail: e.retail,
            weight: e.weight,
            tonnage: e.tonnage,
            fixedRate: e.fixedRate
        )).toList();


    int productIndex = products.indexWhere((element) =>
    element.sr == order.orderDataModel!.productId);


    if (productIndex != -1) {
      ProductsModel product = products[productIndex];
      product.quantity = order.orderDataModel!.quantity;
      product.netRate = order.orderDataModel!.netRate;
      product.fixedRate = order.orderDataModel!.fixedRate;
      product.subTotal = int.tryParse(order.orderDataModel!.quantity.toString())! * double.tryParse(product.fixedRate)!;

      products[productIndex] = product;

      await box.put('products',products);

      Get.back();
      Get.toNamed(STORE, arguments: {
        "shopName": syncNowController
            .reasonModelList[index].shopName,
        "sr": syncNowController
            .reasonModelList[index].shopId,
        "gprs": syncNowController
            .reasonModelList[index].checkIn,
        "phone": "",
        "isEdit": true,
      });

    }

  }

  ////////////////


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
                                                    String shopId =
                                                        syncNowController
                                                            .reasonModelList[
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
