import 'package:SalesUp/controllers/UserController.dart';
import 'package:SalesUp/model/NewShopModel.dart';
import 'package:SalesUp/model/attendenceModel.dart';
import 'package:SalesUp/model/categoryName.dart';
import 'package:SalesUp/model/distributionModel.dart';
import 'package:SalesUp/model/financialYearModel.dart';
import 'package:SalesUp/model/historyModel.dart';
import 'package:SalesUp/model/monthPerformanceModel.dart';
import 'package:SalesUp/model/orderCalculations.dart';
import 'package:SalesUp/model/orderModel.dart';
import 'package:SalesUp/model/productsModel.dart';
import 'package:SalesUp/model/shopsTexModel.dart';
import 'package:SalesUp/model/syncDownModel.dart';
import 'package:SalesUp/model/weekPerformanceModel.dart';
import 'package:SalesUp/utils/routes/routePath.dart';
import 'package:SalesUp/utils/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'controllers/distributionController.dart';
import 'controllers/syncNowController.dart';
import 'model/creditModel.dart';
import 'model/reasonName.dart';
import 'model/reasonsModel.dart';
import 'model/reateDetailModel.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.blue));
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.deleteFromDisk();
  var directory = await getApplicationDocumentsDirectory();
  Hive
    ..init(directory.path)
    ..registerAdapter(SyncDownModelAdapter())
    ..registerAdapter(WeekPerformanceModelAdapter())
    ..registerAdapter(MonthPerformanceModelAdapter())
    ..registerAdapter(BrandTonageSaleAdapter())
    ..registerAdapter(ReasonModelAdapter())
    ..registerAdapter(ProductsModelAdapter())
    ..registerAdapter(ReasonsModelAdapter())
    ..registerAdapter(CategoryNameModelAdapter())
    ..registerAdapter(RateDetailModelAdapter())
    ..registerAdapter(OrderModelAdapter())
    ..registerAdapter(OrderDataModelAdapter())
    ..registerAdapter(ShopsStatusModelAdapter())
    ..registerAdapter(ShopTypeModelAdapter())
    ..registerAdapter(ShopSectorModelAdapter())
    ..registerAdapter(NewShopModelHiveAdapter())
    ..registerAdapter(OrderCalculationModelAdapter())
    ..registerAdapter(HistoryModelHiveAdapter())
    ..registerAdapter(CreditModelAdapter())
    ..registerAdapter(CheckInAdapter())
    ..registerAdapter(CheckOutAdapter())
    ..registerAdapter(DistributionModelAdapter())
    ..registerAdapter(FinancialYearAdapter());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: GetMaterialApp(
        initialBinding: BindingsBuilder(() {
          Get.put(UserController());
          Get.put(DistributionController());
        }),
        title: "SalesUp",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: MaterialColor(0xff01579B, {
            50: Color(0xffE1F5FE),
            100: Color(0xffB3E5FC),
            200: Color(0xff81D4FA),
            300: Color(0xff4FC3F7),
            400: Color(0xff29B6F6),
            500: Color(0xff01579B),
            600: Color(0xff039BE5),
            700: Color(0xff0288D1),
            800: Color(0xff0277BD),
            900: Color(0xff01579B),
          }),
        ),
        getPages: Routes.routesLIst,
        initialRoute: SPLASH,
      ),
    );
  }
}
