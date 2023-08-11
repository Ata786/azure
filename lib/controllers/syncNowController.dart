import 'package:azure/model/reasonsModel.dart';
import 'package:get/get.dart';
import '../model/syncDownModel.dart';

class SyncNowController extends GetxController{

  Rx<bool> check = false.obs;
  RxList<SyncDownModel> syncDownList = <SyncDownModel>[].obs;
  Rx<bool> searchCheck = false.obs;
  RxList<SyncDownModel> allList = <SyncDownModel>[].obs;
  RxList<SyncDownModel> searchList = <SyncDownModel>[].obs;
  RxList<ReasonModel> reasonModelList = <ReasonModel>[].obs;


}