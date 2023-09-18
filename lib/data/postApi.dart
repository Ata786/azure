import 'dart:convert';
import 'dart:developer';
import 'package:SalesUp/controllers/UserController.dart';
import 'package:SalesUp/controllers/syncNowController.dart';
import 'package:SalesUp/data/getApis.dart';
import 'package:SalesUp/data/hiveDb.dart';
import 'package:SalesUp/model/creditModel.dart';
import 'package:SalesUp/model/orderModel.dart';
import 'package:SalesUp/model/reasonsModel.dart';
import 'package:flutter/material.dart';
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
    if(response.statusCode == 200){
      syncNowController.checkSyncUp.value = false;
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

    var res = await http.delete(Uri.parse("$BASE_URL/MobileMasterData"),body: deletedData);

    Map<String,dynamic> data = {
      "ShopId": int.tryParse(reasonModel.shopId!),
      "BookerId": deletedData['BookerId'],
      "CheckIn": double.tryParse(reasonModel.checkIn!),
      "CreatedOn": deletedData['CreatedOn'],
      "Payment": reasonModel.payment,
      "Reason": reasonModel.reason,
      "Picture": reasonModel.image
    };
    insertMobileMasterData(data,reasonModel.bookerId!);
    if(res.statusCode == 200){
      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(SnackBar(content: Text("Data Deleted Successfully")));
    }else{
    }

  }catch(e){
    ScaffoldMessenger.of(Get.context!)
        .showSnackBar(SnackBar(content: Text("Exception:- ${e.toString()}")));
  }

}


void insertMobileMasterData(Map<String,dynamic> data,int bookerId)async{

  UserController userController = Get.find<UserController>();
  try{

    var uri = Uri.parse("$BASE_URL/MobileMasterData");
    var request = http.MultipartRequest('POST', uri);

    request.fields['ShopId'] = data['ShopId'].toString();
    request.fields['BookerId'] = data['BookerId'].toString();
    request.fields['CheckIn'] = data['CheckIn'].toString();
    request.fields['CreatedOn'] = data['CreatedOn'].toString();
    request.fields['Payment'] = data['Payment'].toString();
    request.fields['Reason'] = data['Reason'].toString();

    var file = await http.MultipartFile.fromPath(
      'Picture',
      data['Picture'],
    );


    request.files.add(file);

    // Send the request
    var response = await request.send();

    if(response.statusCode == 200){
      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(SnackBar(content: Text("Data insert successfully")));
      List<OrderModel> orderList = await HiveDatabase.getOrderData("orderBox", "order");
      for(int i=0; i<orderList.length; i++){
        Map<String,dynamic> deletedData = {
          "PjpDate": formatDateAndTime(orderList[i].pjpDate),
          "UserId": userController.user!.value.id,
        };
        Map<String,dynamic> data1 = {
          "Sr": int.tryParse(1.toString()),
          "ShopId": int.tryParse(orderList[i].shopId.toString()),
          "ProductId": int.tryParse(orderList[i].orderDataModel!.productId.toString()),
          "RateId": int.tryParse(orderList[i].orderDataModel!.rateId.toString()),
          "FixedRate": double.tryParse(orderList[i].orderDataModel!.fixedRate.toString()),
          "NetRate": double.tryParse(orderList[i].orderDataModel!.netRate.toString()),
          "Quantity": int.tryParse(orderList[i].orderDataModel!.quantity.toString()),
          "PjpNoId": int.tryParse(orderList[i].pjpNo.toString()),
          "PjpDate": formatDateAndTime(orderList[i].pjpDate),
          "BookerId": int.tryParse(bookerId.toString()),
          "InvoiceStatus": orderList[i].invoiceStatus.toString(),
          "OrderNo": int.tryParse(orderList[i].orderNumber.toString()),
          "UserId": userController.user!.value.id,
          "Replace": int.tryParse(orderList[i].replace.toString()),
        };
        deleteMobileDetail(deletedData,data1);
      }
    }else{
      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(SnackBar(content: Text("Error:- ${response.statusCode}")));
    }

  }catch(e){
    ScaffoldMessenger.of(Get.context!)
        .showSnackBar(SnackBar(content: Text("Exception:- ${e.toString()}")));
  }

}


void deleteMobileDetail(Map<String,dynamic> deletedData,Map<String,dynamic> data)async{

  try{
    var res = await http.delete(Uri.parse("$BASE_URL/MobileDetail"),body: deletedData);
    sendMobileDetailsData(data);
    if(res.statusCode == 200){
      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(SnackBar(content: Text("Successfully Delete")));
    }

  }catch(e){
    ScaffoldMessenger.of(Get.context!)
        .showSnackBar(SnackBar(content: Text("Exception:- ${e.toString()}")));
  }

}


void sendMobileDetailsData(Map<String,dynamic> insertData)async{

  log('>>> data is ${insertData}');
  // try{
    var res = await http.post(Uri.parse("$BASE_URL/MobileDetail"),body: insertData);
    log('>>> insert status ${res.statusCode} and ${res.body}');
    if(res.statusCode == 200){

    }else{

    }

  //
  // }catch(e){
  //   ScaffoldMessenger.of(Get.context!)
  //       .showSnackBar(SnackBar(content: Text("Exception:- ${e.toString()}")));
  // }

}




String formatDateAndTime(String dateAndTime) {
  DateTime dateTime = DateTime.parse(dateAndTime);
  String formattedTime = dateTime.toUtc().toIso8601String();
  return formattedTime;
}