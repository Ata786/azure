import 'package:azure/controllers/UserController.dart';
import 'package:azure/model/categoryName.dart';
import 'package:azure/model/monthPerformanceModel.dart';
import 'package:azure/model/orderModel.dart';
import 'package:azure/model/productsModel.dart';
import 'package:azure/model/syncDownModel.dart';
import 'package:azure/model/weekPerformanceModel.dart';
import 'package:azure/utils/routes/routePath.dart';
import 'package:azure/utils/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'model/reasonName.dart';
import 'model/reasonsModel.dart';
import 'model/reateDetailModel.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.blue));
  WidgetsFlutterBinding.ensureInitialized();
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
    ..registerAdapter(RateDetailAdapter())
    ..registerAdapter(OrderModelAdapter())
    ..registerAdapter(OrderDataModelAdapter());

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
        }),
        title: "KFarm",
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
