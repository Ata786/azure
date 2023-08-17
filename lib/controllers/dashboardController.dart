import 'package:SalesUp/model/monthPerformanceModel.dart';
import 'package:get/get.dart';

import '../model/weekPerformanceModel.dart';

class DashBoardController extends GetxController{

  Rx<int> performanceDay = 0.obs;

  Rx<WeekPerformanceModel> weekPerformanceModel = WeekPerformanceModel(brandTonageSale: []).obs;
  Rx<bool> weekCheck = false.obs;
  Rx<MonthPerformanceModel> monthPerformanceModel = MonthPerformanceModel(brandTonageSale: []).obs;
  Rx<bool> monthCheck = false.obs;

}