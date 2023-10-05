import 'dart:developer';

import 'package:SalesUp/controllers/dashboardController.dart';
import 'package:SalesUp/model/NewShopModel.dart';
import 'package:SalesUp/model/SetUserLocationModel.dart';
import 'package:SalesUp/model/attendenceModel.dart';
import 'package:SalesUp/model/categoryName.dart';
import 'package:SalesUp/model/creditModel.dart';
import 'package:SalesUp/model/distributionModel.dart';
import 'package:SalesUp/model/historyModel.dart';
import 'package:SalesUp/model/monthPerformanceModel.dart';
import 'package:SalesUp/model/orderCalculations.dart';
import 'package:SalesUp/model/productsModel.dart';
import 'package:SalesUp/model/reasonsModel.dart';
import 'package:SalesUp/model/reateDetailModel.dart';
import 'package:SalesUp/model/shopsTexModel.dart';
import 'package:SalesUp/model/syncDownModel.dart';
import 'package:SalesUp/model/weekPerformanceModel.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../controllers/shopServiceController.dart';
import '../controllers/syncNowController.dart';
import '../model/financialYearModel.dart';
import '../model/orderModel.dart';
import '../model/reasonName.dart';

class HiveDatabase {
  static Future setData(String boxName, String key, var data) async {
    var box = await Hive.openBox(boxName);
    await box.put(key, data);
  }

  static Future getData(String boxName, String key) async {
    SyncNowController syncNowController = Get.find<SyncNowController>();
    syncNowController.check.value = true;
    var box = await Hive.openBox(boxName);
    List<dynamic> data = box.get(key) ?? [];
    if (data.isNotEmpty) {
      syncNowController.syncDownList.value = data.map((e) =>
          SyncDownModel(
              shopname: e.shopname,
              address: e.address,
              salesInvoiceDate: e.salesInvoiceDate,
              gprs: e.gprs,
              shopCode: e.shopCode,
              sr: e.sr,
              phone: e.phone,
              owner: e.owner,
              catagoryId: e.catagoryId,
              productive: e.productive,
              isEdit: e.isEdit,
              cnic: e.cnic,
              tax: e.tax,
              myntn: e.myntn,
              typeId: e.typeId,
              statusId: e.statusId,
              sectorId: e.sectorId,
            distributerId: e.distributerId,
            picture: e.picture,
            sector: e.sector,
            salesTax: e.salesTax,
            shopType: e.shopType
          )).toList();
      syncNowController.allList.value = syncNowController.syncDownList;
      syncNowController.searchList.value = syncNowController.allList;
    }
    syncNowController.check.value = false;
  }


  // set week Performance data
  static void setWeekPerformanceData(String boxName, String key,
      WeekPerformanceModel data) async {
    var box = await Hive.openBox(boxName);
    await box.put(key, data.toJson());
  }


  static void getWeekPerformanceData(String boxName, String key) async {
    DashBoardController dashBoardController = Get.find<DashBoardController>();
    dashBoardController.weekCheck.value == true;
    var box = await Hive.openBox(boxName);
    var data = box.get(key);
    if (data != null) {
      WeekPerformanceModel weekPerformanceModel = WeekPerformanceModel.fromJson(
          data);
      dashBoardController.weekPerformanceModel.value = weekPerformanceModel;
      dashBoardController.weekCheck.value == false;
    } else {
      dashBoardController.weekCheck.value == true;
    }
  }


  // set month Performance data
  static void setMonthPerformanceData(String boxName, String key,
      MonthPerformanceModel data) async {
    var box = await Hive.openBox(boxName);
    await box.put(key, data.toJson());
  }


  static void getMonthPerformanceData(String boxName, String key) async {
    DashBoardController dashBoardController = Get.find<DashBoardController>();
    dashBoardController.monthCheck.value == true;
    var box = await Hive.openBox(boxName);
    var data = box.get(key);
    if (data != null) {
      MonthPerformanceModel monthPerformanceModel = MonthPerformanceModel
          .fromJson(data);
      dashBoardController.monthPerformanceModel.value = monthPerformanceModel;
      dashBoardController.monthCheck.value == false;
    } else {
      dashBoardController.monthCheck.value == true;
    }
  }


  // save shop reasons in hive
  static void setReasonData(String boxName, String key, var data) async {
    var box = await Hive.openBox(boxName);
    await box.put(key, data);
  }

  // get shop reason data
  static void getReasonData(String boxName, String key) async {
    SyncNowController syncNowController = Get.find<SyncNowController>();
    var box = await Hive.openBox(boxName);
    List<dynamic> data = box.get(key) ?? [];
    if (data.isNotEmpty) {
      syncNowController.reasonModelList.value = data.map((e) =>
          ReasonModel(shopName: e.shopName,
              shopId: e.shopId,
              bookerId: e.bookerId,
              checkIn: e.checkIn,
              createdOn: e.createdOn,
              reason: e.reason,
              image: e.image,
              payment: e.payment,
              pjpnumber: e.pjpnumber)).toList();
      syncNowController.filteredReasonList.value = syncNowController.reasonModelList;
    }
  }


  // set Products data
  static void setProducts(String boxName, String key, var data) async {
    var box = await Hive.openBox(boxName);
    await box.put(key, data);
  }

  // get products data
  static void getProducts(String boxName, String key) async {
    ShopServiceController shopServiceController = Get.find<
        ShopServiceController>();
    var box = await Hive.openBox(boxName);
    List<dynamic> data = box.get(key) ?? [];
    if (data.isNotEmpty) {
      shopServiceController.productsList.value = data.map((e) =>
          ProductsModel(
              sr: e.sr, pname: e.pname, wgm: e.wgm, brandName: e.brandName,rateId: e.rateId,tonagePerPcs: e.tonagePerPcs,retail: e.retail,
          netRate: e.netRate,quantity: e.quantity,subTotal: e.subTotal,weight: e.weight,fixedRate: e.fixedRate,tonnage: e.tonnage))
          .toList();
      shopServiceController.filteredProductsList.value = shopServiceController.productsList;
      shopServiceController.checkProducts.value = true;
    }
  }


  // save reasons
  static Future setReasons(String boxName, String key, var data) async {
    var box = await Hive.openBox(boxName);
    await box.put(key, data);
  }

  // get reasons
  static Future<List<ReasonsModel>> getReasons(String boxName,
      String key) async {
    List<ReasonsModel> reasonsModel = [];
    var box = await Hive.openBox(boxName);
    List<dynamic> data = box.get(key) ?? [];
    if (data.isNotEmpty) {
      reasonsModel =
          data.map((e) => ReasonsModel(sr: e.sr, reasonName: e.reasonName))
              .toList();
    }
    return reasonsModel;
  }

  // save category name
  static void saveCategoryName(String boxName, String key, var data) async {
    var box = await Hive.openBox(boxName);
    await box.put(key, data);
  }

  // get category names
  static Future<List<CategoryNameModel>> getCategoryName(String boxName,
      String key) async {
    List<CategoryNameModel> categoryName = [];
    var box = await Hive.openBox(boxName);
    List<dynamic> data = box.get(key) ?? [];
    if (data.isNotEmpty) {
      categoryName =
          data.map((e) => CategoryNameModel(sr: e.sr, name: e.name)).toList();
    }
    return categoryName;
  }


  // set product rateDetails
  static void setProductRateDetails(String boxName, String key,
      var data) async {
    var box = await Hive.openBox(boxName);
    await box.put(key, data);
  }


  // get product rate details
  static Future<List<RateDetailModel>> getProductRateDetails(String boxName,
      String key) async {
    var box = await Hive.openBox(boxName);
    var data = box.get(key);
    List<RateDetailModel> rateDetailList = [];
    if (data != null) {
      List<dynamic> list = data;
      rateDetailList = list.map((e) => RateDetailModel.fromJson(e)).toList();
    }
    return rateDetailList;
  }


  // set order
  static void setOrderData(String boxName, String key, var data) async {
    var box = await Hive.openBox(boxName);
    await box.put(key, data);
  }

  static Future<List<OrderModel>> getOrderData(String boxName,
      String key) async {
    var box = await Hive.openBox(boxName);
    var data = box.get(key);
    List<OrderModel> orderModel = [];
    if (data != null) {
      List<dynamic> list = data;
      List<OrderModel> order = list.map((e) =>
          OrderModel(
            shopId: e.shopId,
              pjpDate: e.pjpDate,
              pjpNo: e.pjpNo,
              bookerId: e.bookerId,
              reason: e.reason,
              userId: e.userId,
              image: e.image,
              checkIn: e.checkIn,
              invoiceStatus: e.invoiceStatus,
              orderDataModel: e.orderDataModel,
              orderNumber: e.orderNumber,
              weight: e.weight,
              tonnage: e.tonnage,
              replace: e.replace,
          )).toList();
      orderModel = order;
    }
    return orderModel;
  }


  static Future setShopType(String boxName, String key, var data) async {
    var box = await Hive.openBox(boxName);
    await box.put(key, data);
  }

  static Future setShopSector(String boxName, String key, var data) async {
    var box = await Hive.openBox(boxName);
    await box.put(key, data);
  }

  static Future setShopStatus(String boxName, String key, var data) async {
    var box = await Hive.openBox(boxName);
    await box.put(key, data);
  }


  static Future getShopType(String boxName, String key) async {
    SyncNowController syncNowController = Get.find<SyncNowController>();
    var box = await Hive.openBox(boxName);
    var data = box.get(key);
    if (data != null) {
      List<dynamic> list = data;
      List<ShopTypeModel> typeList = list.map((e) =>
          ShopTypeModel(sr: e.sr, name: e.name)).toList();
      syncNowController.shopTypeList.value = typeList;
    }
  }


  static Future getShopStatus(String boxName, String key) async {
    SyncNowController syncNowController = Get.find<SyncNowController>();
    var box = await Hive.openBox(boxName);
    var data = box.get(key);
    if (data != null) {
      List<dynamic> list = data;
      List<ShopsStatusModel> statusList = list.map((e) =>
          ShopsStatusModel(sr: e.sr, name: e.name)).toList();
      syncNowController.shopStatusList.value = statusList;
    }
  }


  static Future getShopSector(String boxName, String key) async {
    SyncNowController syncNowController = Get.find<SyncNowController>();
    var box = await Hive.openBox(boxName);
    var data = box.get(key);
    if (data != null) {
      List<dynamic> list = data;
      List<ShopSectorModel> sectorList = list.map((e) =>
          ShopSectorModel(sr: e.sr,
              name: e.name,
              nname: e.nname,
              distributerId: e.distributerId)).toList();
      syncNowController.shopSectorList.value = sectorList;
    }
  }


  static Future setNewShop(String boxName, String key, var data) async {
    var box = await Hive.openBox(boxName);
    await box.put(key, data);
  }

  static Future<List<NewShopModel>> getNewShops(String boxName,
      String key) async {
    var box = await Hive.openBox(boxName);
    var data = box.get(key);
    List<NewShopModel> newShops = [];
    if (data != null) {
      List<dynamic> list = data;
      newShops = list.map((e) =>
          NewShopModel(sr: e.sr,
              shopCode: e.shopCode,
              shopName: e.shopName,
              shopAddress: e.shopAddress,
              ownerPhone: e.ownerPhone,
              ownerName: e.ownerName,
              ownerCnic: e.ownerCnic,
              gprs: e.gprs,
              picture: e.picture,
              myntn: e.myntn,
              strn: e.strn,
              salesTax: e.salesTax,
              sector: e.sector,
              shopType: e.shopType,
            salesTaxSr: e.salesTaxSr,
            sectorSr: e.sectorSr,
            shopTypeSr: e.shopTypeSr
          )).toList();
    }
    return newShops;
  }


  static Future setOrderCalculation(String boxName, String key, var data) async {
    var box = await Hive.openBox(boxName);
    await box.put(key, data);
  }



  static Future<OrderCalculationModel> getOrderCalculation(String boxName, String key) async {
    var box = await Hive.openBox(boxName);
    var data = box.get(key);
    OrderCalculationModel orderCalculationModel = OrderCalculationModel();
    if(data != null){
      orderCalculationModel = OrderCalculationModel(bookingValue: data.bookingValue,llpc: data.llpc,qty: data.qty,weight: data.weight,tonnage: data.tonnage);
    }

    return orderCalculationModel;
  }



  // set history
  static Future setHistory(String boxName, String key, var data) async {
    var box = await Hive.openBox(boxName);
    await box.put(key, data);
  }



  static Future<List<HistoryModel>> getHistory(String boxName,
      String key) async {
    var box = await Hive.openBox(boxName);
    var data = box.get(key);
    List<HistoryModel> historyList = [];
    if (data != null) {
      List<dynamic> list = data;
      historyList = list.map((e) =>
          HistoryModel(sr: e.sr,shopId: e.shopId,createdOn: e.createdOn,reason: e.reason)).toList();
    }
    return historyList;
  }



  // set credits list
  static Future setCreditList(String boxName, String key, var data) async {
    var box = await Hive.openBox(boxName);
    await box.put(key, data);
  }


  // get credit list
  static Future<List<CreditModel>> getCreditList(String boxName,
      String key) async {
    var box = await Hive.openBox(boxName);
    var data = box.get(key);
    List<CreditModel> creditModelList = [];
    if (data != null) {
      List<dynamic> list = data;
      creditModelList = list.map((e) =>
          CreditModel(sr: e.sr,shopId: e.shopId,realisedAmount: e.realisedAmount,recieveableDate: e.recieveableDate,isRecovered: e.isRecovered,
          pjpNoId: e.pjpNoId,vanId: e.vanId,bookerId: e.bookerId,bankId: e.bankId,billAmount: e.billAmount,billNoId: e.billNoId,
              bouncedDate: e.bouncedDate,chequeDate: e.chequeDate,chequeNo: e.chequeNo,companyId: e.companyId,currentDistId: e.currentDistId,
          type: e.type,isBounced: e.isBounced,recovery: e.recovery)).toList();
    }
    return creditModelList;
  }


  static Future<void> setCheckInAttendance(String boxName, String key,
      var data) async {
    var box = await Hive.openBox(boxName);
    await box.put(key, data);
  }

  static Future<CheckIn> getCheckInAttendance(String boxName,
      String key) async {
    var box = await Hive.openBox(boxName);
    var data = box.get(key);
    CheckIn checkIn = CheckIn();
    if (data != null) {
      checkIn = CheckIn(userId: data.userId,latitude: data.latitude,longitude: data.longitude,attendanceDateTime: data.attendanceDateTime,id: data.id);
    }
    return checkIn;
  }


  static Future<void> setCheckOutAttendance(String boxName, String key,
      var data) async {
    var box = await Hive.openBox(boxName);
    await box.put(key, data);
  }

  static Future<CheckOut> getCheckOutAttendance(String boxName,
      String key) async {
    var box = await Hive.openBox(boxName);
    var data = box.get(key);
    CheckOut checkOut = CheckOut();
    if (data != null) {
      checkOut = CheckOut(userId: data.userId,outLatitude: data.outLatitude,outLongitude: data.outLongitude,outAttendanceDateTime: data.outAttendanceDateTime);
    }
    return checkOut;
  }


  ///////////////////////////////////////




  static Future<void> setDistributionList(String boxName, String key,
      var data) async {
    var box = await Hive.openBox(boxName);
    await box.put(key, data);
  }


  static Future<List<DistributionModel>> getDistributionList(String boxName,
      String key) async {
    var box = await Hive.openBox(boxName);
    var data = box.get(key);
    List<DistributionModel> distributionList = [];
    if (data != null) {
      List<dynamic> list = data;
      distributionList = list.map((e) => DistributionModel(distributorId: e.distributorId,distributorName: e.distributorName,assignedId: e.assignedId)).toList();
    }
    return distributionList;
  }


  static Future<void> setFinancialYearList(String boxName, String key,
      var data) async {
    var box = await Hive.openBox(boxName);
    await box.put(key, data);
  }


  static Future<List<FinancialYearModel>> getFinancialYearList(String boxName,
      String key) async {
    var box = await Hive.openBox(boxName);
    var data = box.get(key);
    List<FinancialYearModel> financialYearList = [];
    if (data != null) {
      List<dynamic> list = data;
      financialYearList = list.map((e) => FinancialYearModel(id: e.id,value: e.value)).toList();
    }
    return financialYearList;
  }



  static Future<void> setUserLocation(String boxName, String key,
      var data) async {
    var box = await Hive.openBox(boxName);
    await box.put(key, data);
  }

  static Future<SetUserLocationModel> getUserLocation(String boxName, String key,
      var data) async {

    var box = await Hive.openBox(boxName);
    var data = box.get(key);

    SetUserLocationModel setUserLocationModel = SetUserLocationModel();
    if(data != null){
      setUserLocationModel = SetUserLocationModel(name: data.name,latitude: data.latitude,longitude: data.longitude,location: data.location);
    }
    return setUserLocationModel;
  }


}
