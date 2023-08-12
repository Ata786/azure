import "dart:async";
import "dart:convert";
import "package:azure/controllers/UserController.dart";
import "package:azure/controllers/dashboardController.dart";
import "package:azure/controllers/shopServiceController.dart";
import "package:azure/controllers/syncNowController.dart";
import "package:azure/data/hiveDb.dart";
import "package:azure/model/categoryName.dart";
import "package:azure/model/monthPerformanceModel.dart" as month;
import "package:azure/model/reasonName.dart";
import "package:azure/model/reateDetailModel.dart";
import "package:azure/model/syncDownModel.dart";
import "package:azure/model/weekPerformanceModel.dart" as week;
import "package:azure/res/colors.dart";
import "package:flutter/material.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:get/get.dart";
import "package:http/http.dart" as http;
import "../model/historyModel.dart";
import "../model/monthPerformanceModel.dart";
import "../model/productsModel.dart";

String BASE_URL = "http://125.209.79.107:7700/api";



// get shops
void syncDownApi(BuildContext context) async {
  UserController userController = Get.find<UserController>();
  SyncNowController syncNowController = Get.find<SyncNowController>();
  syncNowController.check.value = true;
  var res = await http.get(Uri.parse("${BASE_URL}/SyncDown/${userController.user!.value.catagoryId}"));
  if (res.statusCode == 200) {
    Map<String, dynamic> parsedData = jsonDecode(res.body);
    List<dynamic> pjpDetails = parsedData['pjpDetail'];
    List<SyncDownModel> syncDownList = pjpDetails
        .map((e) => SyncDownModel(
            sr: e['shops']['sr'],
            shopname: e['shops']['shopname'],
            address: e['shops']['address'],
            salesInvoiceDate: e['shops']['salesInvoiceDate'],
            gprs: e['shops']['gprs'],
            shopCode: e['shops']['shopcode'],
            phone: e['shops']['phone'],
            owner: e['shops']['owner'],
            catagoryId: e['shops']['catagoryId']
    ))
        .toList();
    await HiveDatabase.setData("syncDownList", "syncDown", syncDownList);
    syncNowController.syncDownList.value = syncDownList;
    syncNowController.allList.value = syncNowController.syncDownList;
    syncNowController.searchList.value = syncNowController.allList;
  } else {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Error:- ${res.body}")));
  }
}



// get Week Performance Data
Future<void> getWeekPerformance(
    {required BuildContext context}) async {
  UserController userController = Get.find<UserController>();
  DashBoardController dashBoardController = Get.find<DashBoardController>();
  dashBoardController.weekCheck.value = true;
  try {
    var res = await http.get(Uri.parse(
        "${BASE_URL}/SyncDown/${userController.user!.value.catagoryId}"));
    if (res.statusCode == 200) {
      Map<String, dynamic> parsedData = jsonDecode(res.body);
     dynamic bookerPerformanceWeekly = parsedData['bookerPerformanceWeekly'];

      List<week.BrandTonageSale> brandTonageSaleList = [];
      brandTonageSaleList = (bookerPerformanceWeekly['brandTonageSale'] as List)
          .map((item) => week.BrandTonageSale.fromJson(item))
          .toList();

      week.WeekPerformanceModel weekPerformanceModel = week.WeekPerformanceModel(
        currentPjPShops: bookerPerformanceWeekly['currentPjPShops'],
        pjPShops: bookerPerformanceWeekly['pjPShops'],
        visitedShops: bookerPerformanceWeekly['visitedShops'],
        productiveShops: bookerPerformanceWeekly['productiveShops'],
        uniqueProductivety: bookerPerformanceWeekly['uniqueProductivety'],
        noOfInvoices: bookerPerformanceWeekly['noOfInvoices'],
        averageDropSize: bookerPerformanceWeekly['averageDropSize'],
        averageSale: bookerPerformanceWeekly['averageSale'],
        frequency: bookerPerformanceWeekly['frequency'],
        lppc: bookerPerformanceWeekly['lppc'],
        totalTonage: bookerPerformanceWeekly['totalTonage'],
        brandTonageSale: brandTonageSaleList
      );

      HiveDatabase.setWeekPerformanceData("weekPerformance", "week", weekPerformanceModel);

      dashBoardController.weekPerformanceModel = Rx<week.WeekPerformanceModel>(weekPerformanceModel);
      dashBoardController.weekPerformanceModel.value = weekPerformanceModel;
      dashBoardController.weekCheck.value = false;
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error:- ${res.body}")));
    }
  } catch (exception) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Exceptionr:- ${exception}")));
  }
}



// get Month Performance Data
Future<void> getMonthlyPerformance(
    {required BuildContext context}) async {
  UserController userController = Get.find<UserController>();
  DashBoardController dashBoardController = Get.find<DashBoardController>();
  try {
    var res = await http.get(Uri.parse(
        "${BASE_URL}/SyncDown/${userController.user!.value.catagoryId}"));
    if (res.statusCode == 200) {
      Map<String, dynamic> parsedData = jsonDecode(res.body);
      dynamic bookerPerformanceMonthly = parsedData['bookerPerformanceMonthly'];

      List<BrandTonageSale> brandTonageSaleList = [];
      brandTonageSaleList = (bookerPerformanceMonthly['brandTonageSale'] as List)
          .map((item) => BrandTonageSale.fromJson(item))
          .toList();

      month.MonthPerformanceModel monthPerformanceModel = month.MonthPerformanceModel(
          currentPjPShops: bookerPerformanceMonthly['currentPjPShops'],
          pjPShops: bookerPerformanceMonthly['pjPShops'],
          visitedShops: bookerPerformanceMonthly['visitedShops'],
          productiveShops: bookerPerformanceMonthly['productiveShops'],
          uniqueProductivety: bookerPerformanceMonthly['uniqueProductivety'],
          noOfInvoices: bookerPerformanceMonthly['noOfInvoices'],
          averageDropSize: bookerPerformanceMonthly['averageDropSize'],
          averageSale: bookerPerformanceMonthly['averageSale'],
          frequency: bookerPerformanceMonthly['frequency'],
          lppc: bookerPerformanceMonthly['lppc'],
          totalTonage: bookerPerformanceMonthly['totalTonage'],
          brandTonageSale: brandTonageSaleList
      );

      HiveDatabase.setMonthPerformanceData("monthPerformance", "month", monthPerformanceModel);

      dashBoardController.monthPerformanceModel = Rx<month.MonthPerformanceModel>(monthPerformanceModel);
      dashBoardController.monthPerformanceModel.value = monthPerformanceModel;
      dashBoardController.monthCheck.value = false;

    } else {
      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(SnackBar(content: Text("Error:- ${res.body}")));
    }
  } catch (exception) {
    ScaffoldMessenger.of(Get.context!)
        .showSnackBar(SnackBar(content: Text("Exceptionr:- ${exception}")));
  }

}



// get reasons
Future<void> getReasons(BuildContext context) async {
  UserController userController = Get.find<UserController>();

  var res = await http.get(Uri.parse(
      "${BASE_URL}/SyncDown/${userController.user!.value.catagoryId}"));
  if (res.statusCode == 200) {
    Map<String, dynamic> map = jsonDecode(res.body);
    List<dynamic> reason = map['reason'];
    List<ReasonsModel> reasons = reason.map((e) => ReasonsModel(sr: e['sr'],reasonName: e['reasonName'])).toList();
    HiveDatabase.setReasons("reasonsName", "reason", reasons);
  } else {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Error:- ${res.body}")));
  }
}


// get Products table data
Future<void> getProducts({required BuildContext context}) async {
  UserController userController = Get.find<UserController>();
  ShopServiceController shopServiceController = Get.find<ShopServiceController>();
    try {
    var res = await http.get(Uri.parse(
        "${BASE_URL}/SyncDown/${userController.user!.value.catagoryId}"));
    if (res.statusCode == 200) {
      Map<String, dynamic> parsedData = jsonDecode(res.body);
      List<dynamic> products = parsedData['products'];
      List<ProductsModel> productList = products.map((e) => ProductsModel(brandName: e['brandName'],wgm: e['wgm'],sr: e['sr'],pname: e['pname'])).toList();
      HiveDatabase.setProducts("productsBox", "products", productList);
      shopServiceController.checkProducts.value = true;
      shopServiceController.productsList.value = productList;
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error:- ${res.body}")));
    }
  } catch (exception) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Exceptionr:- ${exception}")));
  }
}



// get orderMasterApp table data for product history
Future<List<HistoryModel>> getHistory({required BuildContext context}) async {
  UserController userController = Get.find<UserController>();
  List<HistoryModel> historyModel = [];
  try {
    var res = await http.get(Uri.parse(
        "${BASE_URL}/SyncDown/${userController.user!.value.catagoryId}"));

    if(res.statusCode == 200){
      Map<String,dynamic> map = jsonDecode(res.body);
      List<dynamic> list = map['orderMasterApp'];
      historyModel = list.map((e) => HistoryModel.fromJson(e)).toList();
    }else{
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error:- ${res.body}")));
    }

  } catch (exception) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Exceptionr:- ${exception}")));
  }
  return historyModel;
}



// get shopCategory table for his sr
Future<void> getCategoryName(BuildContext context)async{
  UserController userController = Get.find<UserController>();
  SyncNowController syncNowController = Get.find<SyncNowController>();
  try {
    var res = await http.get(Uri.parse(
        "${BASE_URL}/SyncDown/${userController.user!.value.catagoryId}"));

    if(res.statusCode == 200){
      Map<String,dynamic> map = jsonDecode(res.body);
      List<dynamic> list = map['shopCatagory'];
      List<CategoryNameModel> c = list.map((e) => CategoryNameModel(sr: e['sr'],name: e['name'])).toList();
      HiveDatabase.saveCategoryName("category", "categoryName", c);
    }else{
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error:- ${res.body}")));
    }

  } catch (exception) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Exceptionr:- ${exception}")));
  }
}



// get retail details table data
Future<List<RateDetailModel>> getRateDetails(BuildContext context)async{
  UserController userController = Get.find<UserController>();
  SyncNowController syncNowController = Get.find<SyncNowController>();
  List<RateDetailModel> rateDetaillist = [];
  try {
    var res = await http.get(Uri.parse(
        "${BASE_URL}/SyncDown/${userController.user!.value.catagoryId}"));

    if(res.statusCode == 200){
      Map<String,dynamic> map = jsonDecode(res.body);
      List<dynamic> list = map['rate'];
      rateDetaillist = list.map((e) => RateDetailModel.fromJson(e)).toList();
      syncNowController.check.value = false;
      Fluttertoast.showToast(
          msg: "Sync Down is Completed",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: themeColor,
          textColor: Colors.white,
          fontSize: 16.0
      );
      HiveDatabase.setProductRateDetails("product", "productRate", rateDetaillist.map((e) => e.toJson()).toList());
    }else{
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error:- ${res.body}")));
    }

  } catch (exception) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Exceptionr:- ${exception}")));
  }
return rateDetaillist;
}





