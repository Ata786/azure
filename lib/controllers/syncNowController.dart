import 'package:SalesUp/model/orderCalculations.dart';
import 'package:SalesUp/model/reasonsModel.dart';
import 'package:get/get.dart';
import '../model/shopsTexModel.dart';
import '../model/syncDownModel.dart';

class SyncNowController extends GetxController{

  Rx<bool> check = false.obs;
  RxList<SyncDownModel> syncDownList = <SyncDownModel>[].obs;
  Rx<bool> searchCheck = false.obs;
  RxList<SyncDownModel> allList = <SyncDownModel>[].obs;
  RxList<SyncDownModel> searchList = <SyncDownModel>[].obs;
  RxList<ReasonModel> reasonModelList = <ReasonModel>[].obs;
  RxList<SyncDownModel> nonProductiveList = <SyncDownModel>[].obs;

  RxList<ShopsStatusModel> shopStatusList = <ShopsStatusModel>[].obs;
  RxList<ShopSectorModel> shopSectorList = <ShopSectorModel>[].obs;
  RxList<ShopTypeModel> shopTypeList = <ShopTypeModel>[].obs;

  Rx<OrderCalculationModel> orderCalculationModel = OrderCalculationModel().obs;


}