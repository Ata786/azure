import 'dart:convert';
import 'dart:developer';
import 'dart:ui';
import 'package:SalesUp/controllers/UserController.dart';
import 'package:flutter_foreground_service/flutter_foreground_service.dart';
import 'package:http/http.dart' as http;
import 'package:SalesUp/data/hiveDb.dart';
import 'package:SalesUp/data/sharedPreference.dart';
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
import 'package:SalesUp/model/userLiveModel.dart';
import 'package:SalesUp/model/userModel.dart';
import 'package:SalesUp/model/weekPerformanceModel.dart';
import 'package:SalesUp/utils/localNotification.dart';
import 'package:SalesUp/utils/routes/routePath.dart';
import 'package:SalesUp/utils/routes/routes.dart';
import 'package:SalesUp/utils/userCurrentLocation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:workmanager/workmanager.dart';
import 'controllers/distributionController.dart';
import 'model/creditModel.dart';
import 'model/reasonName.dart';
import 'model/reasonsModel.dart';
import 'model/reateDetailModel.dart';


const fetchBackground = "fetchBackground";
const fetchBackground2 = "fetchBackground2";


@pragma('vm:entry-point')
void printHello() async {
  Workmanager().executeTask((task, inputData) async {

    switch(task){
      case fetchBackground:
        await handleTask1();
        break;
      case fetchBackground2:
        await handleTask2();
        break;
    }

    return Future.value(true);
  });


}



Future<void> handleTask1()async{

  if(Hive.isAdapterRegistered(25)){

    log('>>>> register is true');

    String? user = await getUserDataSp("user");

    if(user != null) {

      log('>>>> user not null');

      Map<String,dynamic> data = jsonDecode(user);
      UserModel userModel = UserModel.fromJson(data);

      Position? location = await getCurrentLocation();

      if(location != null){

        log('>>>> location not null');

        List<UserLiveModel> liveList = await HiveDatabase.getUserLive("live", "liveBox");

        UserLiveModel userLiveModel = UserLiveModel(email: userModel.email,dateTime: DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(DateTime.now()),latitude: location.latitude,longitude: location.longitude);

        liveList.add(userLiveModel);

        await HiveDatabase.setUserLive("live", "liveBox", liveList);

        List<UserLiveModel> live = await HiveDatabase.getUserLive("live", "liveBox");

        for(int i=0; i<live.length; i++){
          log('>>>> live Data ${live[i].toJson()}');
        }

      }

    }

  }else{
    var directory = await getApplicationDocumentsDirectory();
    Hive
      ..init(directory.path);
    Hive.registerAdapter(UserLiveModelAdapter());

    String? user = await getUserDataSp("user");

    if(user != null) {

      Map<String,dynamic> data = jsonDecode(user);
      UserModel userModel = UserModel.fromJson(data);

      Position? location = await getCurrentLocation();

      if(location != null){

        List<UserLiveModel> liveList = await HiveDatabase.getUserLive("live", "liveBox");

        UserLiveModel userLiveModel = UserLiveModel(email: userModel.email,dateTime: DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(DateTime.now()),latitude: location.latitude,longitude: location.longitude);

        liveList.add(userLiveModel);

        await HiveDatabase.setUserLive("live", "liveBox", liveList);

        List<UserLiveModel> live = await HiveDatabase.getUserLive("live", "liveBox");

        for(int i=0; i<live.length; i++){
          log('>>>> live Data ${live[i].toJson()}');
        }
      }

    }

  }

}





Future<void> handleTask2()async{

  log('>>>> second task');

  String? user = await getUserDataSp("user");

  log('>>>> second user ${user}');

  Map<String,dynamic> data = jsonDecode(user!);
  UserModel userModel = UserModel.fromJson(data);

  log('>>>> user model is ${userModel.toJson()}');

  List<UserLiveModel> live = [];

    var directory = await getApplicationDocumentsDirectory();
    Hive
      ..init(directory.path);
    Hive.registerAdapter(UserLiveModelAdapter());
    Hive.registerAdapter(CheckInAdapter());
    live = await HiveDatabase.getUserLive("live", "liveBox");

    log('>>> live lenght is ${live.length}');

  CheckIn checkIn = await HiveDatabase.getCheckInAttendance("checkInAttendance", "checkIn");

  log('>>>> checkIn ${checkIn.toJson()}');

  DateFormat inputFormat = DateFormat("dd MMM y hh:mm a");
  DateTime checkInDateTime = inputFormat.parse(checkIn.attendanceDateTime!);
  String checkInFormattedDateTime = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(checkInDateTime);

  Map<String,dynamic> map = {
    "email": userModel.email,
    "date": checkInFormattedDateTime,
    "userLocation": live.map((user) {
      return {
        "longitude": user.longitude,
        "latitude": user.latitude,
        "datetime": user.dateTime,
      };
    }).toList(),
  };

  log('>>>>> map is ${map}');

  final response = await http.post(
    Uri.parse('http://125.209.79.107:7700/api/UserLive'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(map),
  );

  ForegroundService().stop();
  await Workmanager().cancelAll();

  log('>>>> userLive response on time under ${response.statusCode} and ${response.body}');

}



void main() async {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.blue));
  WidgetsFlutterBinding.ensureInitialized();

  await LocalNotification.initializeLocalNotification();

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
    ..registerAdapter(FinancialYearAdapter())
    ..registerAdapter(RemarksModelAdapter())
    ..registerAdapter(UserLiveModelAdapter());
  
  Workmanager().initialize(printHello);


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
