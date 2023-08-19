import 'package:SalesUp/controllers/dashboardController.dart';
import 'package:SalesUp/model/NewShopModel.dart';
import 'package:SalesUp/model/categoryName.dart';
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
import '../model/orderModel.dart';
import '../model/reasonName.dart';

class HiveDatabase {
  static Future setData(String boxName, String key, var data) async {
    var box = await Hive.openBox(boxName);
    await box.put(key, data);
  }

  static void getData(String boxName, String key) async {
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
              sectorId: e.sectorId)).toList();
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
              payment: e.image,
              pjpnumber: e.pjpnumber)).toList();
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
              sr: e.sr, pname: e.pname, wgm: e.wgm, brandName: e.brandName))
          .toList();
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
          OrderModel(shopId: e.shopId,
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
              replace: e.replace)).toList();
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
              shopType: e.shopType)).toList();
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
      orderCalculationModel = OrderCalculationModel(bookingValue: data.bookingValue,llpc: data.llpc,qty: data.qty);
    }

    return orderCalculationModel;
  }



}
