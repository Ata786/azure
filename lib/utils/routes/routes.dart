import 'package:SalesUp/utils/routes/routePath.dart';
import 'package:SalesUp/view/NewShops.dart';
import 'package:SalesUp/view/Splash.dart';
import 'package:SalesUp/view/attendance.dart';
import 'package:SalesUp/view/dashboard/home.dart';
import 'package:SalesUp/view/history.dart';
import 'package:SalesUp/view/officeCode.dart';
import 'package:SalesUp/view/orderDetail.dart';
import 'package:SalesUp/view/saleScreen.dart';
import 'package:SalesUp/view/shopService.dart';
import 'package:SalesUp/view/signin.dart';
import 'package:SalesUp/view/store.dart';
import 'package:get/get.dart';

import '../../view/creditList.dart';
import '../../view/todayNewShops.dart';

class Routes{

  static List<GetPage> routesLIst = [
    GetPage(name: SPLASH, page: ()=> Splash()),
    GetPage(name: OFFICE_CODE_SCREEN, page: ()=> OfficeCode()),
    GetPage(name: SIGN_IN_SCREEN, page: ()=> SignIn()),
    GetPage(name: HOME, page: ()=> Home()),
    GetPage(name: SHOP_SERVICE, page: ()=> ShopService()),
    GetPage(name: STORE, page: ()=> StoreScreen()),
    GetPage(name: SHOP_HISTORY, page: ()=> ShopHistory()),
    GetPage(name: NEW_SHOPS, page: ()=> NewShops()),
    GetPage(name: ORDER_DETAIL, page: ()=> OrderDetail()),
    GetPage(name: CREDIT_LIST, page: ()=> CreditList()),
    GetPage(name: TODAY_NEW_SHOP, page: ()=> TodayNewShops()),
    GetPage(name: ATTENDANCE, page: ()=> AttendanceScreen()),
    GetPage(name: SALE, page: ()=> SaleScreen()),
  ];

}