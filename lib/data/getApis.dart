import "dart:convert";
import "package:SalesUp/controllers/UserController.dart";
import "package:SalesUp/controllers/dashboardController.dart";
import "package:SalesUp/controllers/shopServiceController.dart";
import "package:SalesUp/controllers/syncNowController.dart";
import "package:SalesUp/data/hiveDb.dart";
import "package:SalesUp/model/categoryName.dart";
import "package:SalesUp/model/monthPerformanceModel.dart" as month;
import "package:SalesUp/model/reasonName.dart";
import "package:SalesUp/model/reateDetailModel.dart";
import "package:SalesUp/model/syncDownModel.dart";
import "package:SalesUp/model/weekPerformanceModel.dart" as week;
import "package:SalesUp/res/colors.dart";
import "package:flutter/material.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:get/get.dart";
import "package:http/http.dart" as http;
import "../model/creditModel.dart";
import "../model/historyModel.dart";
import "../model/monthPerformanceModel.dart";
import "../model/productsModel.dart";
import "../model/shopsTexModel.dart";

String BASE_URL = "http://125.209.79.107:7700/api";



void allApis()async{
  print('>>>> 1');
  UserController userController = Get.find<UserController>();
  SyncNowController syncNowController = Get.find<SyncNowController>();
  syncNowController.check.value = true;
  print('>>>> 2');
  var res = await http.get(Uri.parse("${BASE_URL}/SyncDown/${userController.user!.value.catagoryId}"));
  print('>>>> ${res.statusCode}');
  print('>>>> ${res.body}');
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
        catagoryId: e['shops']['catagoryId'],
        productive: false,
        myntn: e['shops']['myntn'],
        tax: e['shops']['tax'],
        cnic: e['shops']['cnic'],
        typeId: e['shops']['typeId'],
        sectorId: e['shops']['sectorId'],
        statusId: e['shops']['statusId'],
        isEdit: false,
        picture: e['shops']['picture']
    ))
        .toList();
    await HiveDatabase.setData("syncDownList", "syncDown", syncDownList);
    syncNowController.syncDownList.value = syncDownList;
    syncNowController.allList.value = syncNowController.syncDownList;
    syncNowController.searchList.value = syncNowController.allList;



    // week data

    DashBoardController dashBoardController = Get.find<DashBoardController>();

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



    // month data

    dynamic bookerPerformanceMonthly = parsedData['bookerPerformanceMonthly'];

    List<BrandTonageSale> brandTonageMonthSaleList = [];

    brandTonageMonthSaleList = (bookerPerformanceMonthly['brandTonageSale'] as List)
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
        brandTonageSale: brandTonageMonthSaleList
    );

    HiveDatabase.setMonthPerformanceData("monthPerformance", "month", monthPerformanceModel);

    dashBoardController.monthPerformanceModel = Rx<month.MonthPerformanceModel>(monthPerformanceModel);
    dashBoardController.monthPerformanceModel.value = monthPerformanceModel;
    dashBoardController.monthCheck.value = false;


    // get reason

    Map<String, dynamic> map = jsonDecode(res.body);
    List<dynamic> reason = map['reason'];
    List<ReasonsModel> reasons = reason.map((e) => ReasonsModel(sr: e['sr'],reasonName: e['reasonName'])).toList();
    HiveDatabase.setReasons("reasonsName", "reason", reasons);


    // get Products
    ShopServiceController shopServiceController = Get.find<ShopServiceController>();
    List<dynamic> products = parsedData['products'];
    List<ProductsModel> productList = products.map((e) => ProductsModel(brandName: e['brandName'],wgm: e['wgm'],sr: e['sr'],pname: e['pname'],tonagePerPcs: e['tonagePerPcs'])).toList();
    HiveDatabase.setProducts("productsBox", "products", productList);
    shopServiceController.checkProducts.value = true;
    shopServiceController.productsList.value = productList;



    // get Category Name

    Map<String,dynamic> map1 = jsonDecode(res.body);
    List<dynamic> list = map1['shopCatagory'];
    List<CategoryNameModel> c = list.map((e) => CategoryNameModel(sr: e['sr'],name: e['name'])).toList();
    HiveDatabase.saveCategoryName("category", "categoryName", c);


    // get Rate Details
    List<RateDetailModel> rateDetaillist = [];
    Map<String,dynamic> map2 = jsonDecode(res.body);
    List<dynamic> list1 = map2['rateDetail'];
    rateDetaillist = list1.map((e) => RateDetailModel.fromJson(e)).toList();
    HiveDatabase.setProductRateDetails("product", "productRate", rateDetaillist.map((e) => e.toJson()).toList());




    // get shop text data

    List<ShopsStatusModel> shopStatusList = [];
    List<ShopTypeModel> shopTypeList = [];
    List<ShopSectorModel> shopSectorList = [];

    Map<String,dynamic> map3 = jsonDecode(res.body);
    List<dynamic> shopTypeMaps = map3['shopTypes'];
    List<dynamic> sectorList = map3['sector'];
    List<dynamic> statusList = map3['status'];

    shopTypeList = shopTypeMaps.map((e) => ShopTypeModel(sr: e['sr'],name: e['name'])).toList();
    shopStatusList = statusList.map((e) => ShopsStatusModel(sr: e['sr'],name: e['name'])).toList();
    shopSectorList = sectorList.map((e) => ShopSectorModel(sr: e['sr'],name: e['name'],nname: e['nname'],distributerId: e['distributerId'])).toList();

    await HiveDatabase.setShopType("shopTypeBox", "shopType", shopTypeList);
    await HiveDatabase.setShopSector("shopSectorBox", "shopSector", shopSectorList);
    await HiveDatabase.setShopStatus('shopStatusBox', "shopStatus", shopStatusList);

    await HiveDatabase.getShopType("shopTypeBox", "shopType");
    await HiveDatabase.getShopSector("shopSectorBox", "shopSector");
    await HiveDatabase.getShopStatus('shopStatusBox', "shopStatus");


    // fetch orderMasterApp collection
    List<HistoryModel> historyList = [];
    Map<String,dynamic> orderMasterParse = jsonDecode(res.body);
    List<dynamic> orderMapList = orderMasterParse['orderMasterApp'];
    historyList = orderMapList.map((e) => HistoryModel.fromJson(e)).toList();
    HiveDatabase.setHistory("historyBox", "history", historyList);



    // fetch credits
    List<CreditModel> creditList = [];
    Map<String,dynamic> creditParse = jsonDecode(res.body);
    List<dynamic> creditListMap = creditParse['credits'];
    creditList = creditListMap.map((e) => CreditModel.fromJson(e)).toList();
    for(int i = 0; i < creditList.length; i++){
      creditList[i].recovery = 0.0;
    }
    HiveDatabase.setCreditList("creditBox", "credit", creditList);

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

  } else {
    ScaffoldMessenger.of(Get.context!)
        .showSnackBar(SnackBar(content: Text("Error:- ${res.body}")));
  }

}




