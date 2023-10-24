import 'dart:convert';
import 'dart:developer';
import 'package:SalesUp/controllers/UserController.dart';
import 'package:SalesUp/controllers/syncNowController.dart';
import 'package:SalesUp/data/getApis.dart';
import 'package:SalesUp/data/hiveDb.dart';
import 'package:SalesUp/model/creditModel.dart';
import 'package:SalesUp/model/orderModel.dart';
import 'package:SalesUp/model/reasonsModel.dart';
import 'package:SalesUp/model/reateDetailModel.dart';
import 'package:SalesUp/model/syncDownModel.dart';
import 'package:SalesUp/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

void mobileRecovery(Map<String,dynamic> data)async{

  SyncNowController syncNowController = Get.find<SyncNowController>();
  syncNowController.checkSyncUp.value = true;
  try{
    var res = await http.post(Uri.parse("$BASE_URL/MobileRecovery"), headers: {'Content-Type': 'application/json'},body: jsonEncode(data));

    log('>>> mobile recovery ${res.statusCode}');
    if(res.statusCode == 200){
      syncNowController.checkSyncUp.value = false;
    }else{
      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(SnackBar(content: Text("Error:- ${res.body}")));
    }
    
  }catch(e){
    ScaffoldMessenger.of(Get.context!)
        .showSnackBar(SnackBar(content: Text("Exception:- ${e.toString()}")));
  }
  
}


void addNewShop(Map<String,dynamic> data)async{

  try{

    SyncNowController syncNowController = Get.find<SyncNowController>();
    syncNowController.checkSyncUp.value = true;

    var uri = Uri.parse("$BASE_URL/Shops"); // Replace with your API endpoint
    var request = http.MultipartRequest('POST', uri);
    // Add fields (optional)
    request.fields['ShopName'] = data['ShopName'];
    request.fields['ShopAddress'] = data['ShopAddress'];
    request.fields['OwnerPhone'] = data['OwnerPhone'];
    request.fields['OwnerName'] = data['OwnerName'];
    request.fields['OwnerCnic'] = data['OwnerCnic'];
    request.fields['Strm'] = data['Strm'];
    request.fields['Myntn'] = data['Myntn'];
    request.fields['Sector'] = data['Sector'].toString();
    request.fields['SaleTax'] = data['SaleTax'].toString();
    request.fields['ShopeType'] = data['ShopeType'].toString();
    request.fields['Gprs'] = data['Gprs'];
    request.fields['DistributerId'] = data['DistributerId'].toString();
    request.fields['UserId'] = data['UserId'];

    // Add the file
    var file = await http.MultipartFile.fromPath(
      'Image',
      data['Image'],
    );


    request.files.add(file);

    // Send the request
    var response = await request.send();
    log('>>> new shop ${response.statusCode}');
    if(response.statusCode == 200){
      syncNowController.checkSyncUp.value = false;
    }

  }catch(e){
    ScaffoldMessenger.of(Get.context!)
        .showSnackBar(SnackBar(content: Text("Exception:- ${e.toString()}")));
  }

}



void editShopApi(Map<String,dynamic> data)async{

  try{
    SyncNowController syncNowController = Get.find<SyncNowController>();
    syncNowController.checkSyncUp.value = true;

    var uri = Uri.parse("$BASE_URL/Shops");
    var request = http.MultipartRequest('PUT', uri);


    request.fields['Sr'] = data['Sr'].toString();
    request.fields['Shopname'] = data['Shopname'];
    request.fields['Shopcode'] = data['Shopcode'].toString();
    request.fields['Address'] = data['Address'];
    request.fields['Phone'] = data['Phone'];
    request.fields['Owner'] = data['Owner'];
    request.fields['Cnic'] = data['Cnic'];
    request.fields['Tax'] = data['Tax'];
    request.fields['Myntn'] = data['Myntn'];
    request.fields['SectorId'] = data['SectorId'].toString();
    request.fields['StatusId'] = data['StatusId'].toString();
    request.fields['TypeId'] = data['TypeId'].toString();
    request.fields['Gprs'] = data['Gprs'];
    request.fields['Image'] = data['Image'];

    var file = await http.MultipartFile.fromPath(
      'Image',
      data['Image'],
    );


    request.files.add(file);

    // Send the request
    var response = await request.send();
    log('>>> edit shop ${response.statusCode}');
    syncNowController.checkSyncUp.value = false;
    if(response.statusCode == 200){
      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(SnackBar(content: Text("Successfully Submit")));
    }else{
      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(SnackBar(content: Text("Error:- ${response.statusCode}")));
    }

  }catch(e){
    ScaffoldMessenger.of(Get.context!)
        .showSnackBar(SnackBar(content: Text("Exception:- ${e.toString()}")));
  }

}



void deleteMobileMasterData(Map<String,dynamic> deletedData,ReasonModel reasonModel)async{

  try{

    SyncNowController syncNowController = Get.find<SyncNowController>();
    syncNowController.checkSyncUp.value = true;
    UserController userController = Get.find<UserController>();

    var res = await http.delete(Uri.parse("$BASE_URL/MobileMasterData"),body: deletedData);

    log('>>>> yes 1 ${res.statusCode}');
    syncNowController.checkSyncUp.value = false;

    HiveDatabase.getReasonData("reasonNo", "reason");

    List<ReasonModel> reasonList = syncNowController.reasonModelList;

    for(int i=0; i<reasonList.length; i++){
      Map<String,dynamic> data = {
        "ShopId": int.tryParse(reasonList[i].shopId!),
        "BookerId": userController.user!.value.id,
        "CheckIn": double.tryParse(reasonList[i].checkIn!),
        "CreatedOn": formatDateAndTime(reasonList[i].createdOn!),
        "Payment": reasonList[i].payment,
        "Reason": reasonList[i].reason,
        "Picture": reasonList[i].image
      };
      insertMobileMasterData(data);
    }

    if(res.statusCode == 200){

    }else{

    }

    List<SyncDownModel> list = syncNowController.syncDownList.where((p0) => p0.productive != true).toList();

    for(int i=0; i< list.length; i++){
      Map<String,dynamic> data = list[i].toJson();
      data.putIfAbsent("reason", () => "Not Visit");

      DateTime currentDateTime = DateTime.now();

      // Set the time portion to "00:00:00.000"
      DateTime modifiedDateTime = DateTime(
        currentDateTime.year,
        currentDateTime.month,
        currentDateTime.day,
        0,  // Hour
        0,  // Minute
        0,  // Second
        0,  // Millisecond
      );

      Map<String,dynamic> insert = {
        "ShopId": int.tryParse(data['sr'].toString()),
        "BookerId": userController.user!.value.id,
        "CheckIn": 0.0,
        "CreatedOn": DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(modifiedDateTime),
        "Payment": "None",
        "Reason": data['reason'],
        "Picture": reasonList[0].image
      };

      insertMobileMasterData(insert);
    }

  }catch(e){
    ScaffoldMessenger.of(Get.context!)
        .showSnackBar(SnackBar(content: Text("Exception:- ${e.toString()}")));
  }

}


void insertMobileMasterData(Map<String,dynamic> data)async{

  SyncNowController syncNowController = Get.find<SyncNowController>();
  syncNowController.checkSyncUp.value = true;
  try{

    var uri = Uri.parse("$BASE_URL/MobileMasterData");
    var request = http.MultipartRequest('POST', uri);

    log('>>>> yes 2 ');
    request.fields['ShopId'] = data['ShopId'].toString();
    request.fields['BookerId'] = data['BookerId'].toString();
    request.fields['CheckIn'] = data['CheckIn'].toString();
    request.fields['CreatedOn'] = data['CreatedOn'].toString();
    request.fields['Payment'] = data['Payment'].toString();
    request.fields['Reason'] = data['Reason'].toString();

    if (data.containsKey('Picture') && data['Picture'] != null) {
      var file = await http.MultipartFile.fromPath(
        'Picture',
        data['Picture'],
      );
      request.files.add(file);
    }

    // Send the request
    var response = await request.send();
    log('>>>> insert shop ${response.statusCode} ');
    if(response.statusCode == 200){
      syncNowController.checkSyncUp.value = false;
    }else{
      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(SnackBar(content: Text("Error:- ${response.statusCode}")));
    }

  }catch(e){
    ScaffoldMessenger.of(Get.context!)
        .showSnackBar(SnackBar(content: Text("Exception:- ${e.toString()}")));
  }

}


void deleteMobileDetail(Map<String,dynamic> deletedData,int bookerId)async{
  SyncNowController syncNowController = Get.find<SyncNowController>();
  syncNowController.checkSyncUp.value = true;
  UserController userController = Get.find<UserController>();
  try{
    var res = await http.delete(Uri.parse("$BASE_URL/MobileDetail"),body: deletedData);
    syncNowController.checkSyncUp.value = false;
    log('>>> deleted ${res.statusCode}');

    List<OrderModel> orderList = await HiveDatabase.getOrderData("orderBox", "order");

    for(int i = 0; i<orderList.length; i++){
      Map<String,dynamic> data1 = {
        "Sr": int.tryParse(1.toString()),
        "ShopId": int.tryParse(orderList[i].shopId.toString()),
        "ProductId": int.tryParse(orderList[i].orderDataModel!.productId.toString()),
        "RateId": int.tryParse(orderList[i].orderDataModel!.rateId.toString()),
        "FixedRate": double.tryParse(orderList[i].orderDataModel!.fixedRate.toString()),
        "NetRate": double.tryParse(orderList[i].orderDataModel!.netRate.toString()),
        "Quantity": int.tryParse(orderList[i].orderDataModel!.quantity.toString()),
        "PjpNoId": int.tryParse(userController.user!.value.pjpId.toString()),
        "PjpDate": formatDateAndTime(orderList[i].pjpDate),
        "BookerId": bookerId,
        "InvoiceStatus": orderList[i].invoiceStatus.toString(),
        "OrderNo": int.tryParse(orderList[i].orderNumber.toString()),
        "UserId": userController.user!.value.id,
        "Replace": int.tryParse(orderList[i].replace.toString()),
      };

      sendMobileDetailsData(data1,orderList,i);
    }

    if(res.statusCode == 200){

    }

  }catch(e){
    ScaffoldMessenger.of(Get.context!)
        .showSnackBar(SnackBar(content: Text("Exception:- ${e.toString()}")));
  }

}


void sendMobileDetailsData(Map<String,dynamic> insertData,List<OrderModel> orderList,int i)async{

  SyncNowController syncNowController = Get.find<SyncNowController>();
  syncNowController.checkSyncUp.value = true;
  try{
  var request = http.MultipartRequest('POST', Uri.parse("$BASE_URL/MobileDetail"));
  request.fields['Sr'] = insertData['Sr'].toString();
  request.fields['ShopId'] = insertData['ShopId'].toString();
  request.fields['ProductId'] = insertData['ProductId'].toString();
  request.fields['RateId'] = insertData['RateId'].toString();
  request.fields['FixedRate'] = insertData['FixedRate'].toString();
  request.fields['NetRate'] = insertData['NetRate'].toString();
  request.fields['Quantity'] = insertData['Quantity'].toString();
  request.fields['PjpNoId'] = insertData['PjpNoId'].toString();
  request.fields['PjpDate'] = insertData['PjpDate'].toString();
  request.fields['BookerId'] = insertData['BookerId'].toString();
  request.fields['InvoiceStatus'] = insertData['InvoiceStatus'].toString();
  request.fields['OrderNo'] = insertData['OrderNo'].toString();
  request.fields['UserId'] = insertData['UserId'].toString();
  request.fields['Replace'] = insertData['Replace'].toString();

  var response = await request.send();

  log('>>> inserted ${response.statusCode}');
  syncNowController.checkSyncUp.value = false;
  if(response.statusCode == 200){

  }else{
    ScaffoldMessenger.of(Get.context!)
        .showSnackBar(SnackBar(content: Text("Error:- ${response.statusCode}")));
  }

  if(i == orderList.length-1){
    Fluttertoast.showToast(
        msg: "SyncUp is Completed",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: themeColor,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  }catch(e){
    ScaffoldMessenger.of(Get.context!)
        .showSnackBar(SnackBar(content: Text("Exception:- ${e.toString()}")));
  }

}








// mobile sync delete
void mobileSyncDeleteApi(Map<String,dynamic> deleteData)async{

  try{


    SyncNowController syncNowController = Get.find<SyncNowController>();
    UserController userController = Get.find<UserController>();
    syncNowController.checkSyncUp.value = true;

    var res = await http.delete(Uri.parse("$BASE_URL/MobileSyncUp"),body: deleteData);

    syncNowController.checkSyncUp.value = false;

    Map<String,dynamic> data = {
      "PjpDate": DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(DateTime.now()),
      "UserId": userController.user!.value.id,
    };

    mobileDetailDeleteApi(data);


  }
  catch(e){
    ScaffoldMessenger.of(Get.context!)
        .showSnackBar(SnackBar(content: Text("Exception:- ${e.toString()}")));
  }

}


// mobile sync delete
void mobileDetailDeleteApi(Map<String,dynamic> deleteData)async {
  SyncNowController syncNowController = Get.find<SyncNowController>();
  UserController userController = Get.find<UserController>();

  try {
    syncNowController.checkSyncUp.value = true;

    var res = await http.delete(
        Uri.parse("$BASE_URL/MobileSyncUp/DeleteMobileDetail"),
        body: deleteData);

    log('>>>> delete ${res.statusCode}');


    HiveDatabase.getReasonData("reasonNo", "reason");

    List<ReasonModel> reasonList = syncNowController.reasonModelList;

    List<SyncDownModel> list = syncNowController.syncDownList.where((p0) =>
    p0.productive != true).toList();

    List<Map<String, dynamic>> combinedList = [];

    for (int i = 0; i < reasonList.length; i++) {
      Map<String, dynamic> data = {
        "shopId": int.tryParse(reasonList[i].shopId!),
        "bookerId": userController.user!.value.id,
        "checkIn": double.tryParse(reasonList[i].checkIn!),
        "createdOn": formatDateAndTime(reasonList[i].createdOn!),
        "payment": reasonList[i].payment,
        "reason": reasonList[i].reason,
        "picture": reasonList[i].image
      };
      combinedList.add(data);
    }

    for (int i = 0; i < list.length; i++) {
      DateTime currentDateTime = DateTime.now();

      // Set the time portion to "00:00:00.000"
      DateTime modifiedDateTime = DateTime(
        currentDateTime.year,
        currentDateTime.month,
        currentDateTime.day,
        0,
        // Hour
        0,
        // Minute
        0,
        // Second
        0, // Millisecond
      );

      Map<String, dynamic> data = {
        "shopId": int.tryParse(list[i].sr.toString()),
        "bookerId": userController.user!.value.id,
        "checkIn": 0,
        "createdOn": DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(
            modifiedDateTime),
        "payment": "None",
        "reason": "Not Visit",
        "picture": reasonList.isNotEmpty ? reasonList[0].image : ""
      };
      combinedList.add(data);
    }

    List<OrderModel> orderList = await HiveDatabase.getOrderData(
        "orderBox", "order");

    List<Map<String, dynamic>> order = [];


    for (int i = 0; i < orderList.length; i++) {
      List<RateDetailModel> rateDetails = await HiveDatabase
          .getProductRateDetails("product", "productRate");

      List<RateDetailModel> rateDetailModel = rateDetails.where((element) =>
      element.productId.toString() ==
          orderList[i].orderDataModel!.productId.toString()).toList();

      String fixedRate = double.tryParse(
          orderList[i].orderDataModel!.fixedRate.toString())!.toStringAsFixed(
          1);

      RateDetailModel rateDetail = rateDetailModel.firstWhere((element) {
        String netRateAsString = element.netRate!.toStringAsFixed(1);
        return netRateAsString == fixedRate;
      });

      Map<String, dynamic> data1 = {
        "shopId": int.tryParse(orderList[i].shopId.toString()),
        "productId": int.tryParse(
            orderList[i].orderDataModel!.productId.toString()),
        "rateId": orderList[i].orderDataModel == null ||
            orderList[i].orderDataModel!.rateId == null ? int.tryParse(
            rateDetail.rateId.toString()) : int.tryParse(
            orderList[i].orderDataModel!.rateId.toString()),
        "fixedRate": double.tryParse(
            orderList[i].orderDataModel!.fixedRate.toString()),
        "netRate": double.tryParse(
            orderList[i].orderDataModel!.netRate.toString()),
        "quantity": int.tryParse(
            orderList[i].orderDataModel!.quantity.toString()),
        "pjpNoId": int.tryParse(userController.user!.value.pjpId.toString()),
        "pjpDate": DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(
            DateTime.now()),
        "bookerId": reasonList[0].bookerId,
        "invoiceStatus": orderList[i].invoiceStatus.toString(),
        "orderNo": int.tryParse(orderList[i].orderNumber.toString()),
        "userId": userController.user!.value.id,
        "replace": int.tryParse(orderList[i].replace.toString()),
      };


      order.add(data1);
    }

    Map<String, dynamic> uploadData = {
      "masterM": combinedList,
      "masterD": order,
    };

    syncNowController.checkSyncUp.value = false;

    mobileSyncUpApi(uploadData);
  }

  catch (e) {
    syncNowController.checkSyncUp.value = false;
    ScaffoldMessenger.of(Get.context!)
        .showSnackBar(SnackBar(content: Text("Exception:- ${e.toString()}")));
  }
}



void mobileSyncUpApi(Map<String,dynamic> data)async{

  SyncNowController syncNowController = Get.find<SyncNowController>();
  syncNowController.checkSyncUp.value = true;
  try{

   log('>>>> ${data}');

    var res = await http.post(Uri.parse("$BASE_URL/MobileSyncUp"), headers: {
    'Content-Type': 'application/json',
    },body: jsonEncode(data));

    log('>>>> syncUp is ${res.statusCode} and ${res.body}');

   syncNowController.checkSyncUp.value = false;

    if(res.statusCode == 200){

      Fluttertoast.showToast(
          msg: "SyncUp is Completed",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: themeColor,
          textColor: Colors.white,
          fontSize: 16.0
      );

    }else if(res.statusCode == 404){

    } else{
      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(SnackBar(content: Text("Error:- ${res.body}")));
    }

  }catch(e){
    ScaffoldMessenger.of(Get.context!)
        .showSnackBar(SnackBar(content: Text("Exception:- ${e.toString()}")));
  }


}




String formatDateAndTime(String dateAndTime) {
  DateTime dateTime = DateTime.parse(dateAndTime);
  String formattedTime = dateTime.toUtc().toIso8601String();
  return formattedTime;
}